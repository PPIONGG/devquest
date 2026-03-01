import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { previewTable } from '@/lib/sandbox/executor'

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { session } } = await supabase.auth.getSession()
    if (!session) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const { challenge_id, table_name } = body

    if (!challenge_id || !table_name) {
      return NextResponse.json({ error: 'challenge_id and table_name are required' }, { status: 400 })
    }

    const { data: challenge, error } = await supabase
      .from('sql_challenges')
      .select('table_schema, seed_data')
      .eq('id', challenge_id)
      .single()

    if (error || !challenge) {
      return NextResponse.json({ error: 'Challenge not found' }, { status: 404 })
    }

    const result = await previewTable({
      tableSchema: challenge.table_schema,
      seedData: challenge.seed_data,
      tableName: table_name,
    })

    return NextResponse.json(result)
  } catch (err: any) {
    console.error('[/api/sql/preview]', err)
    return NextResponse.json({ error: err.message ?? 'Internal server error' }, { status: 500 })
  }
}
