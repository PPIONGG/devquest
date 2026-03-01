import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { executeAndJudge } from '@/lib/sandbox/executor'

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { session } } = await supabase.auth.getSession()
    if (!session) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const { challenge_id, query } = body

    if (!challenge_id || !query?.trim()) {
      return NextResponse.json({ error: 'challenge_id and query are required' }, { status: 400 })
    }

    const { data: challenge, error } = await supabase
      .from('sql_challenges')
      .select('*')
      .eq('id', challenge_id)
      .single()

    if (error || !challenge) {
      return NextResponse.json({ error: 'Challenge not found' }, { status: 404 })
    }

    const result = await executeAndJudge({
      tableSchema: challenge.table_schema,
      seedData: challenge.seed_data,
      userQuery: query,
      solutionSQL: challenge.solution_sql,
      orderSensitive: challenge.order_sensitive,
    })

    // Save submission
    const { error: subError } = await supabase.from('sql_submissions').insert({
      user_id: session.user.id,
      challenge_id,
      query,
      status: result.status,
      execution_time_ms: result.execution_time_ms,
      error_message: result.error_message,
      query_plan: result.query_plan,
    })

    if (subError) {
      console.error('[submit] save submission error:', subError)
    }

    // Update progress
    const isCorrect = result.status === 'correct'
    const { data: existing } = await supabase
      .from('sql_challenge_progress')
      .select('*')
      .eq('user_id', session.user.id)
      .eq('challenge_id', challenge_id)
      .maybeSingle()

    const now = new Date().toISOString()
    const upsertData: Record<string, unknown> = {
      user_id: session.user.id,
      challenge_id,
      attempts: (existing?.attempts ?? 0) + 1,
      last_attempted_at: now,
    }

    if (isCorrect) {
      upsertData.is_solved = true
      if (!existing?.first_solved_at) {
        upsertData.first_solved_at = now
      }
      const newTime = result.execution_time_ms
      if (!existing?.best_time_ms || newTime < existing.best_time_ms) {
        upsertData.best_time_ms = newTime
      }
    } else if (existing?.is_solved) {
      // Keep solved status if already solved
      upsertData.is_solved = true
      upsertData.first_solved_at = existing.first_solved_at
      upsertData.best_time_ms = existing.best_time_ms
    }

    await supabase.from('sql_challenge_progress').upsert(upsertData)

    return NextResponse.json(result)
  } catch (err) {
    console.error('[/api/sql/submit]', err)
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 })
  }
}
