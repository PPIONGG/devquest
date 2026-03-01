CREATE TABLE IF NOT EXISTS sql_lessons (
  id TEXT PRIMARY KEY,
  module_id TEXT NOT NULL,
  module_title TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  content TEXT NOT NULL,
  practice_query TEXT NOT NULL,
  expected_output_json TEXT,
  table_schema TEXT NOT NULL DEFAULT '',
  seed_data TEXT NOT NULL DEFAULT '',
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS sql_lesson_progress (
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  lesson_id TEXT REFERENCES sql_lessons(id) ON DELETE CASCADE NOT NULL,
  is_completed BOOLEAN NOT NULL DEFAULT false,
  completed_at TIMESTAMPTZ,
  last_accessed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, lesson_id)
);

CREATE INDEX IF NOT EXISTS idx_sql_lesson_progress_user ON sql_lesson_progress(user_id);
