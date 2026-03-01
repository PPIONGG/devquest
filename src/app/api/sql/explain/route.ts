import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { runExplainAnalyze } from '@/lib/sandbox/executor'

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
      .select('table_schema, seed_data')
      .eq('id', challenge_id)
      .single()

    if (error || !challenge) {
      return NextResponse.json({ error: 'Challenge not found' }, { status: 404 })
    }

    const plan = await runExplainAnalyze({
      tableSchema: challenge.table_schema,
      seedData: challenge.seed_data,
      userQuery: query,
    })

    return NextResponse.json({ plan })
  } catch (err: any) {
    console.error('[/api/sql/explain]', err)
    return NextResponse.json({ error: err.message ?? 'Internal server error' }, { status: 500 })
  }
}
