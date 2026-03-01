export interface QueryResult {
  columns: string[]
  rows: unknown[][]
  row_count: number
}

function rowToString(row: unknown[]): string {
  return JSON.stringify(row)
}

export function compareResults(
  user: QueryResult,
  expected: QueryResult,
  orderSensitive: boolean
): boolean {
  if (user.columns.length !== expected.columns.length) return false

  for (let i = 0; i < user.columns.length; i++) {
    if (user.columns[i].toLowerCase() !== expected.columns[i].toLowerCase()) return false
  }

  if (user.rows.length !== expected.rows.length) return false

  const userRows = user.rows.map(rowToString)
  const expectedRows = expected.rows.map(rowToString)

  if (!orderSensitive) {
    userRows.sort()
    expectedRows.sort()
  }

  for (let i = 0; i < userRows.length; i++) {
    if (userRows[i] !== expectedRows[i]) return false
  }

  return true
}
