CREATE TABLE IF NOT EXISTS sql_challenge_progress (
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  challenge_id UUID REFERENCES sql_challenges(id) ON DELETE CASCADE NOT NULL,
  is_solved BOOLEAN DEFAULT false,
  best_time_ms INT,
  attempts INT DEFAULT 0,
  first_solved_at TIMESTAMPTZ,
  last_attempted_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (user_id, challenge_id)
);

CREATE INDEX IF NOT EXISTS idx_sql_progress_user ON sql_challenge_progress(user_id);
