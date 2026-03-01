CREATE TABLE IF NOT EXISTS sql_challenges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
  category TEXT NOT NULL CHECK (category IN ('select','filtering','joins','aggregate','subquery','window','cte','analytics')),
  description TEXT NOT NULL,
  table_schema TEXT NOT NULL,
  seed_data TEXT NOT NULL,
  solution_sql TEXT NOT NULL,
  hint TEXT DEFAULT '',
  order_sensitive BOOLEAN DEFAULT false,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_sql_challenges_slug ON sql_challenges(slug);
CREATE INDEX IF NOT EXISTS idx_sql_challenges_sort ON sql_challenges(sort_order);
