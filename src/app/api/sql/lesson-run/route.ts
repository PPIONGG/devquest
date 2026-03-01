import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { Pool, PoolClient } from 'pg'

let _pool: Pool | null = null
function getPool(): Pool {
  if (!_pool) {
    _pool = new Pool({
      connectionString: process.env.SUPABASE_DB_DIRECT_URL,
      max: 5,
    })
  }
  return _pool
}

async function runQueryInClient(client: PoolClient, query: string) {
  const res = await client.query(query)
  const columns = res.fields.map((f) => f.name)
  const rows = res.rows.map((row) =>
    columns.map((col) => {
      const val = row[col]
      if (val === null || val === undefined) return null
      if (val instanceof Date) return val.toISOString()
      return val
    })
  )
  return { columns, rows, row_count: rows.length }
}

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { session } } = await supabase.auth.getSession()
    if (!session) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const { lesson_id, query } = body

    if (!lesson_id || !query?.trim()) {
      return NextResponse.json({ error: 'lesson_id and query are required' }, { status: 400 })
    }

    const { data: lesson, error } = await supabase
      .from('sql_lessons')
      .select('table_schema, seed_data, practice_query')
      .eq('id', lesson_id)
      .single()

    if (error || !lesson) {
      return NextResponse.json({ error: 'Lesson not found' }, { status: 404 })
    }

    if (!lesson.table_schema) {
      return NextResponse.json({ error: 'This lesson has no practice schema' }, { status: 400 })
    }

    const pool = getPool()
    const client = await pool.connect()

    try {
      await client.query('BEGIN')
      await client.query("SET statement_timeout = '5000'")
      await client.query(lesson.table_schema)
      if (lesson.seed_data) await client.query(lesson.seed_data)

      const start = Date.now()
      let userResult
      try {
        userResult = await runQueryInClient(client, query)
      } catch (err: any) {
        return NextResponse.json({
          status: 'error',
          user_result: null,
          expected_result: null,
          execution_time_ms: 0,
          error_message: err.message?.replace(/^ERROR:\s*/i, '').slice(0, 300) ?? 'Query error',
        })
      }
      const elapsed = Date.now() - start

      let expectedResult = null
      if (lesson.practice_query) {
        try {
          expectedResult = await runQueryInClient(client, lesson.practice_query)
        } catch { /* ignore */ }
      }

      return NextResponse.json({
        status: 'correct',
        user_result: userResult,
        expected_result: expectedResult,
        execution_time_ms: elapsed,
        error_message: '',
      })
    } finally {
      await client.query('ROLLBACK').catch(() => {})
      client.release()
    }
  } catch (err) {
    console.error('[/api/sql/lesson-run]', err)
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 })
  }
}
