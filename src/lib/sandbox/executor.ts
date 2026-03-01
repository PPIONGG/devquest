import { Pool, PoolClient } from 'pg'
import type { QueryResult } from '@/lib/utils/compare-results'
import { compareResults } from '@/lib/utils/compare-results'

let _pool: Pool | null = null

function getPool(): Pool {
  if (!_pool) {
    _pool = new Pool({
      connectionString: process.env.SUPABASE_DB_DIRECT_URL,
      max: 5,
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: 10000,
      ssl: { rejectUnauthorized: false },
    })
  }
  return _pool
}

export interface ExecuteResult {
  status: 'correct' | 'wrong' | 'error'
  user_result?: QueryResult
  expected_result?: QueryResult
  execution_time_ms: number
  error_message: string
  query_plan?: string
}

function sanitizeError(err: unknown): string {
  let msg = err instanceof Error ? err.message : String(err)
  msg = msg.replace(/^ERROR:\s*/i, '')
  const sqlstateIdx = msg.lastIndexOf('(SQLSTATE')
  if (sqlstateIdx !== -1) msg = msg.slice(0, sqlstateIdx).trim()
  if (msg.length > 300) msg = msg.slice(0, 300) + '...'
  return msg
}

function validateQuery(query: string): string | null {
  const trimmed = query.trim().toUpperCase()
  const allowed = ['SELECT', 'WITH', 'INSERT', 'UPDATE', 'DELETE']
  const valid = allowed.some((p) => trimmed.startsWith(p))
  if (!valid) return 'Only SELECT, WITH, INSERT, UPDATE, and DELETE queries are allowed'
  if (containsMultipleStatements(query)) return 'Only single statements are allowed'
  return null
}

function containsMultipleStatements(query: string): boolean {
  const stripped = stripSqlLiteralsAndComments(query)
  const trimmed = stripped.trimEnd().replace(/;+$/, '')
  return trimmed.includes(';')
}

function stripSqlLiteralsAndComments(s: string): string {
  let result = ''
  let i = 0
  while (i < s.length) {
    // Single-line comment
    if (s[i] === '-' && s[i + 1] === '-') {
      while (i < s.length && s[i] !== '\n') i++
      continue
    }
    // Block comment
    if (s[i] === '/' && s[i + 1] === '*') {
      i += 2
      while (i + 1 < s.length && !(s[i] === '*' && s[i + 1] === '/')) i++
      if (i + 1 < s.length) i += 2
      continue
    }
    // String literal
    if (s[i] === "'") {
      i++
      while (i < s.length) {
        if (s[i] === "'") {
          i++
          if (i < s.length && s[i] === "'") { i++; continue }
          break
        }
        i++
      }
      continue
    }
    result += s[i]
    i++
  }
  return result
}

async function runQueryInClient(
  client: PoolClient,
  query: string
): Promise<QueryResult> {
  const res = await client.query(query)
  const columns = res.fields.map((f) => f.name)
  const rows = res.rows.map((row) =>
    columns.map((col) => {
      const val = row[col]
      if (val === null || val === undefined) return null
      if (val instanceof Date) return val.toISOString()
      if (typeof val === 'object') return JSON.stringify(val)
      return val
    })
  )
  return { columns, rows, row_count: rows.length }
}

export async function executeAndJudge({
  tableSchema,
  seedData,
  userQuery,
  solutionSQL,
  orderSensitive,
}: {
  tableSchema: string
  seedData: string
  userQuery: string
  solutionSQL: string
  orderSensitive: boolean
}): Promise<ExecuteResult> {
  const validationError = validateQuery(userQuery)
  if (validationError) {
    return { status: 'error', error_message: validationError, execution_time_ms: 0 }
  }

  const pool = getPool()
  const client = await pool.connect()

  try {
    await client.query('BEGIN')
    await client.query("SET LOCAL statement_timeout = '5000'")
    await client.query("SET LOCAL timezone = 'UTC'")

    try {
      await client.query(tableSchema)
    } catch (err) {
      await client.query('ROLLBACK')
      return { status: 'error', error_message: `Schema error: ${sanitizeError(err)}`, execution_time_ms: 0 }
    }

    try {
      await client.query(seedData)
    } catch (err) {
      await client.query('ROLLBACK')
      return { status: 'error', error_message: `Seed error: ${sanitizeError(err)}`, execution_time_ms: 0 }
    }

    const start = Date.now()
    let userResult: QueryResult
    try {
      userResult = await runQueryInClient(client, userQuery)
    } catch (err) {
      await client.query('ROLLBACK')
      return {
        status: 'error',
        error_message: sanitizeError(err),
        execution_time_ms: Date.now() - start,
      }
    }
    const elapsed = Date.now() - start

    let expectedResult: QueryResult
    try {
      expectedResult = await runQueryInClient(client, solutionSQL)
    } catch {
      await client.query('ROLLBACK')
      return { status: 'error', error_message: 'Internal error running reference solution', execution_time_ms: elapsed }
    }

    // Get explain plan
    let plan = ''
    try {
      const planRes = await client.query(`EXPLAIN (FORMAT TEXT) ${userQuery}`)
      plan = planRes.rows.map((r: Record<string, unknown>) => Object.values(r)[0]).join('\n')
    } catch { /* ignore */ }

    const isCorrect = compareResults(userResult, expectedResult, orderSensitive)

    return {
      status: isCorrect ? 'correct' : 'wrong',
      user_result: userResult,
      expected_result: expectedResult,
      execution_time_ms: elapsed,
      error_message: '',
      query_plan: plan,
    }
  } finally {
    await client.query('ROLLBACK').catch(() => {})
    client.release()
  }
}

export async function runExplainAnalyze({
  tableSchema,
  seedData,
  userQuery,
}: {
  tableSchema: string
  seedData: string
  userQuery: string
}): Promise<string> {
  const validationError = validateQuery(userQuery)
  if (validationError) throw new Error(validationError)

  const pool = getPool()
  const client = await pool.connect()

  try {
    await client.query('BEGIN')
    await client.query("SET LOCAL statement_timeout = '5000'")
    await client.query(tableSchema)
    await client.query(seedData)

    const res = await client.query(`EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) ${userQuery}`)
    const plan = res.rows.map((r: Record<string, unknown>) => Object.values(r)[0]).join('\n')
    return plan
  } finally {
    await client.query('ROLLBACK').catch(() => {})
    client.release()
  }
}

export async function previewTable({
  tableSchema,
  seedData,
  tableName,
}: {
  tableSchema: string
  seedData: string
  tableName: string
}): Promise<QueryResult> {
  const pool = getPool()
  const client = await pool.connect()

  try {
    await client.query('BEGIN')
    await client.query("SET LOCAL statement_timeout = '5000'")
    await client.query(tableSchema)
    await client.query(seedData)

    // Only allow alphanumeric table names to prevent injection
    if (!/^[a-zA-Z_][a-zA-Z0-9_]*$/.test(tableName)) {
      throw new Error('Invalid table name')
    }

    const result = await runQueryInClient(client, `SELECT * FROM ${tableName} LIMIT 50`)
    return result
  } finally {
    await client.query('ROLLBACK').catch(() => {})
    client.release()
  }
}
