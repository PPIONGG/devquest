import type {
  SqlChallengeWithProgress,
  SqlChallengeDetail,
  SqlSubmitResult,
  SqlPracticeStats,
  SqlTopSolution,
  SqlModuleWithLessons,
  SqlLesson,
  QueryResult,
} from '@/lib/types/database'
import { createClient } from '@/lib/supabase/client'

const supabase = createClient()

// ─── Challenges ──────────────────────────────────────────────

export async function fetchChallenges(): Promise<SqlChallengeWithProgress[]> {
  const { data: { session } } = await supabase.auth.getSession()
  const userId = session?.user?.id

  const { data: challenges, error } = await supabase
    .from('sql_challenges')
    .select('*')
    .order('sort_order', { ascending: true })

  if (error) throw error

  if (!userId) {
    return (challenges ?? []).map((c) => ({ ...c, progress: null }))
  }

  const { data: progressRows } = await supabase
    .from('sql_challenge_progress')
    .select('*')
    .eq('user_id', userId)

  const progressMap = new Map((progressRows ?? []).map((p) => [p.challenge_id, p]))

  return (challenges ?? []).map((c) => ({
    ...c,
    progress: progressMap.get(c.id) ?? null,
  }))
}

export async function fetchChallengeBySlug(slug: string): Promise<SqlChallengeDetail> {
  const { data: { session } } = await supabase.auth.getSession()
  const userId = session?.user?.id

  const { data: challenge, error } = await supabase
    .from('sql_challenges')
    .select('*')
    .eq('slug', slug)
    .single()

  if (error || !challenge) throw new Error('Challenge not found')

  const metadata = parseSchema(challenge.table_schema)

  // Run all remaining queries in parallel (not sequential)
  const [prevResult, nextResult, subsResult, progResult, topResult] = await Promise.all([
    supabase
      .from('sql_challenges')
      .select('slug')
      .lt('sort_order', challenge.sort_order)
      .order('sort_order', { ascending: false })
      .limit(1)
      .maybeSingle(),
    supabase
      .from('sql_challenges')
      .select('slug')
      .gt('sort_order', challenge.sort_order)
      .order('sort_order', { ascending: true })
      .limit(1)
      .maybeSingle(),
    userId
      ? supabase
          .from('sql_submissions')
          .select('*')
          .eq('user_id', userId)
          .eq('challenge_id', challenge.id)
          .order('submitted_at', { ascending: false })
          .limit(20)
      : Promise.resolve({ data: [] }),
    userId
      ? supabase
          .from('sql_challenge_progress')
          .select('*')
          .eq('user_id', userId)
          .eq('challenge_id', challenge.id)
          .maybeSingle()
      : Promise.resolve({ data: null }),
    supabase
      .from('sql_submissions')
      .select('id, user_id, query, execution_time_ms, submitted_at, profiles(display_name, avatar_url)')
      .eq('challenge_id', challenge.id)
      .eq('status', 'correct')
      .order('execution_time_ms', { ascending: true })
      .limit(10),
  ])

  const submissions = subsResult.data ?? []
  const progress = progResult.data ?? null
  const isSolved = progress?.is_solved ?? false

  const topSolutions = (topResult.data ?? []).map((s: any) => ({
    id: s.id,
    user_id: s.user_id,
    display_name: s.profiles?.display_name ?? 'Anonymous',
    avatar_url: s.profiles?.avatar_url ?? null,
    query: s.query,
    execution_time_ms: s.execution_time_ms ?? 0,
    query_length: s.query.length,
    submitted_at: s.submitted_at,
  }))

  return {
    challenge: { ...challenge, metadata },
    submissions,
    progress,
    prev_slug: prevResult.data?.slug ?? '',
    next_slug: nextResult.data?.slug ?? '',
    solution_sql: isSolved ? challenge.solution_sql : null,
    top_solutions: topSolutions,
  }
}

export async function fetchStats(): Promise<SqlPracticeStats> {
  const { data: { session } } = await supabase.auth.getSession()
  const userId = session?.user?.id

  const { data: challenges } = await supabase
    .from('sql_challenges')
    .select('id, difficulty, category')

  const all = challenges ?? []
  const total = all.length
  const easyTotal = all.filter((c) => c.difficulty === 'easy').length
  const medTotal = all.filter((c) => c.difficulty === 'medium').length
  const hardTotal = all.filter((c) => c.difficulty === 'hard').length

  if (!userId) {
    return {
      total_challenges: total,
      solved: 0,
      easy_total: easyTotal,
      easy_solved: 0,
      medium_total: medTotal,
      medium_solved: 0,
      hard_total: hardTotal,
      hard_solved: 0,
      categories: [],
      practice_streak: 0,
      total_submissions: 0,
    }
  }

  const { data: progress } = await supabase
    .from('sql_challenge_progress')
    .select('*')
    .eq('user_id', userId)

  const solved = (progress ?? []).filter((p) => p.is_solved)
  const { count: totalSubs } = await supabase
    .from('sql_submissions')
    .select('id', { count: 'exact', head: true })
    .eq('user_id', userId)

  // Category stats
  const solvedSet = new Set(solved.map((p) => p.challenge_id))
  const catMap: Record<string, { total: number; solved: number }> = {}
  all.forEach((c) => {
    if (!catMap[c.category]) catMap[c.category] = { total: 0, solved: 0 }
    catMap[c.category].total++
    if (solvedSet.has(c.id)) catMap[c.category].solved++
  })

  // Pick daily challenge (deterministic by date)
  const todayIdx = Math.floor(Date.now() / 86400000) % all.length
  const { data: daily } = await supabase
    .from('sql_challenges')
    .select('*')
    .order('sort_order', { ascending: true })
    .range(todayIdx, todayIdx)
    .maybeSingle()

  return {
    total_challenges: total,
    solved: solved.length,
    easy_total: easyTotal,
    easy_solved: solved.filter((p) => all.find((c) => c.id === p.challenge_id)?.difficulty === 'easy').length,
    medium_total: medTotal,
    medium_solved: solved.filter((p) => all.find((c) => c.id === p.challenge_id)?.difficulty === 'medium').length,
    hard_total: hardTotal,
    hard_solved: solved.filter((p) => all.find((c) => c.id === p.challenge_id)?.difficulty === 'hard').length,
    categories: Object.entries(catMap).map(([category, v]) => ({ category, ...v })),
    practice_streak: 0, // simplified
    total_submissions: totalSubs ?? 0,
    daily_challenge: daily ?? undefined,
  }
}

export async function fetchTopSolutions(challengeId: string): Promise<SqlTopSolution[]> {
  const { data } = await supabase
    .from('sql_submissions')
    .select('id, user_id, query, execution_time_ms, submitted_at, profiles(display_name, avatar_url)')
    .eq('challenge_id', challengeId)
    .eq('status', 'correct')
    .order('execution_time_ms', { ascending: true })
    .limit(10)

  return (data ?? []).map((s: any) => ({
    id: s.id,
    user_id: s.user_id,
    display_name: s.profiles?.display_name ?? 'Anonymous',
    avatar_url: s.profiles?.avatar_url ?? null,
    query: s.query,
    execution_time_ms: s.execution_time_ms ?? 0,
    query_length: s.query.length,
    submitted_at: s.submitted_at,
  }))
}

// ─── SQL Sandbox API calls ────────────────────────────────────

async function callSqlApi(endpoint: string, body: unknown) {
  const res = await fetch(`/api/sql/${endpoint}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })
  if (!res.ok) {
    const err = await res.json().catch(() => ({ error: 'Request failed' }))
    throw new Error(err.error ?? 'Request failed')
  }
  return res.json()
}

export async function runQuery(challengeId: string, query: string): Promise<SqlSubmitResult> {
  return callSqlApi('run', { challenge_id: challengeId, query })
}

export async function submitQuery(challengeId: string, query: string): Promise<SqlSubmitResult> {
  return callSqlApi('submit', { challenge_id: challengeId, query })
}

export async function explainQuery(challengeId: string, query: string): Promise<string> {
  const { plan } = await callSqlApi('explain', { challenge_id: challengeId, query })
  return plan
}

export async function previewTableData(challengeId: string, tableName: string): Promise<QueryResult> {
  return callSqlApi('preview', { challenge_id: challengeId, table_name: tableName })
}

// ─── Academy ─────────────────────────────────────────────────

export async function fetchAcademyModules(): Promise<SqlModuleWithLessons[]> {
  const { data: { session } } = await supabase.auth.getSession()
  const userId = session?.user?.id

  const { data: lessons, error } = await supabase
    .from('sql_lessons')
    .select('*')
    .order('sort_order', { ascending: true })

  if (error) throw error

  let completedSet = new Set<string>()
  if (userId) {
    const { data: progress } = await supabase
      .from('sql_lesson_progress')
      .select('lesson_id')
      .eq('user_id', userId)
      .eq('is_completed', true)

    completedSet = new Set((progress ?? []).map((p) => p.lesson_id))
  }

  const modulesMap = new Map<string, SqlModuleWithLessons>()
  const moduleOrder: string[] = []

  for (const lesson of lessons ?? []) {
    if (!modulesMap.has(lesson.module_id)) {
      modulesMap.set(lesson.module_id, {
        id: lesson.module_id,
        title: lesson.module_title,
        lessons: [],
      })
      moduleOrder.push(lesson.module_id)
    }
    modulesMap.get(lesson.module_id)!.lessons.push({
      ...lesson,
      is_completed: completedSet.has(lesson.id),
    })
  }

  return moduleOrder.map((id) => modulesMap.get(id)!)
}

export async function fetchLesson(lessonId: string): Promise<SqlLesson> {
  const { data: { session } } = await supabase.auth.getSession()
  const userId = session?.user?.id

  const { data: lesson, error } = await supabase
    .from('sql_lessons')
    .select('*')
    .eq('id', lessonId)
    .single()

  if (error || !lesson) throw new Error('Lesson not found')

  let isCompleted = false
  if (userId) {
    const { data: prog } = await supabase
      .from('sql_lesson_progress')
      .select('is_completed')
      .eq('user_id', userId)
      .eq('lesson_id', lessonId)
      .maybeSingle()
    isCompleted = prog?.is_completed ?? false
  }

  return { ...lesson, is_completed: isCompleted }
}

export async function markLessonComplete(lessonId: string): Promise<void> {
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) throw new Error('Not authenticated')

  await supabase.from('sql_lesson_progress').upsert({
    user_id: session.user.id,
    lesson_id: lessonId,
    is_completed: true,
    completed_at: new Date().toISOString(),
    last_accessed_at: new Date().toISOString(),
  })
}

export async function runLessonQuery(lessonId: string, query: string): Promise<SqlSubmitResult> {
  const res = await fetch('/api/sql/run', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ lesson_id: lessonId, query }),
  })
  if (!res.ok) {
    const err = await res.json().catch(() => ({ error: 'Request failed' }))
    throw new Error(err.error ?? 'Request failed')
  }
  return res.json()
}

// ─── Helpers ──────────────────────────────────────────────────

function parseSchema(schema: string) {
  const tables: Array<{ name: string; columns: Array<{ name: string; type: string }> }> = []
  const tableRegex = /CREATE\s+(?:TEMP\s+)?TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(\w+)\s*\(([\s\S]+?)\);/gi
  const colRegex = /^\s*(\w+)\s+([\w(,.)]+)/i

  let match
  while ((match = tableRegex.exec(schema)) !== null) {
    const tableName = match[1]
    const colsStr = match[2]
    const columns: Array<{ name: string; type: string }> = []

    const lines = colsStr.split(',')
    for (const line of lines) {
      const trimmed = line.trim()
      if (!trimmed) continue
      const upper = trimmed.toUpperCase()
      if (upper.startsWith('PRIMARY KEY') || upper.startsWith('FOREIGN KEY') ||
          upper.startsWith('CONSTRAINT') || upper.startsWith('UNIQUE') || upper.startsWith('CHECK')) {
        continue
      }
      const colMatch = colRegex.exec(trimmed)
      if (colMatch) {
        columns.push({ name: colMatch[1], type: colMatch[2] })
      }
    }

    tables.push({ name: tableName, columns })
  }

  return { tables }
}
