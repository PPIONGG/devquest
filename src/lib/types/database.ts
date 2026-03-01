export interface Profile {
  id: string
  username: string | null
  display_name: string | null
  avatar_url: string | null
  role: 'user' | 'admin'
  preferred_language: string
  created_at: string
}

// --- SQL Practice ---

export interface ColumnMetadata {
  name: string
  type: string
}

export interface TableMetadata {
  name: string
  columns: ColumnMetadata[]
}

export interface ChallengeMetadata {
  tables: TableMetadata[]
}

export interface SqlChallenge {
  id: string
  slug: string
  title: string
  difficulty: 'easy' | 'medium' | 'hard'
  category: 'select' | 'filtering' | 'joins' | 'aggregate' | 'subquery' | 'window' | 'cte' | 'analytics' | 'string' | 'datetime' | 'nulls' | 'case' | 'set_ops'
  description: string
  description_th: string
  table_schema: string
  seed_data: string
  hint: string
  hint_th: string
  order_sensitive: boolean
  sort_order: number
  created_at: string
  metadata?: ChallengeMetadata
}

export interface SqlChallengeProgress {
  user_id: string
  challenge_id: string
  is_solved: boolean
  best_time_ms: number | null
  attempts: number
  first_solved_at: string | null
  last_attempted_at: string
}

export interface SqlChallengeWithProgress extends SqlChallenge {
  progress: SqlChallengeProgress | null
}

export interface SqlSubmission {
  id: string
  user_id: string
  challenge_id: string
  query: string
  status: 'correct' | 'wrong' | 'error'
  execution_time_ms: number | null
  error_message: string
  submitted_at: string
}

export interface QueryResult {
  columns: string[]
  rows: unknown[][]
  row_count: number
}

export interface SqlSubmitResult {
  status: 'correct' | 'wrong' | 'error'
  user_result: QueryResult | null
  expected_result: QueryResult | null
  execution_time_ms: number
  error_message: string
  query_plan?: string
}

export interface SqlTopSolution {
  id: string
  user_id: string
  display_name: string
  avatar_url: string | null
  query: string
  execution_time_ms: number
  query_length: number
  submitted_at: string
}

export interface SqlPracticeCategoryStats {
  category: string
  total: number
  solved: number
}

export interface SqlPracticeStats {
  total_challenges: number
  solved: number
  easy_total: number
  easy_solved: number
  medium_total: number
  medium_solved: number
  hard_total: number
  hard_solved: number
  categories: SqlPracticeCategoryStats[]
  practice_streak: number
  total_submissions: number
  daily_challenge?: SqlChallenge
}

export interface SqlChallengeDetail {
  challenge: SqlChallenge
  submissions: SqlSubmission[]
  progress: SqlChallengeProgress | null
  prev_slug: string
  next_slug: string
  solution_sql: string | null
  top_solutions: SqlTopSolution[]
}

// --- SQL Academy ---

export interface SqlLesson {
  id: string
  module_id: string
  module_title: string
  title: string
  description: string
  content: string
  practice_query: string
  expected_output_json: string | null
  table_schema: string
  seed_data: string
  sort_order: number
  created_at: string
  is_completed: boolean
}

export interface SqlModuleWithLessons {
  id: string
  title: string
  lessons: SqlLesson[]
}
