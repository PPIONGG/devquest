CREATE TABLE IF NOT EXISTS sql_submissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  challenge_id UUID REFERENCES sql_challenges(id) ON DELETE CASCADE NOT NULL,
  query TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('correct','wrong','error')),
  execution_time_ms INT,
  error_message TEXT DEFAULT '',
  query_plan TEXT,
  submitted_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_sql_submissions_user ON sql_submissions(user_id);
CREATE INDEX IF NOT EXISTS idx_sql_submissions_challenge ON sql_submissions(challenge_id);
CREATE INDEX IF NOT EXISTS idx_sql_submissions_user_challenge ON sql_submissions(user_id, challenge_id);
