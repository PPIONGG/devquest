-- Profiles
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "profiles_own" ON profiles FOR ALL TO authenticated USING (id = auth.uid());
CREATE POLICY "profiles_public_read" ON profiles FOR SELECT TO authenticated USING (true);

-- SQL Challenges (public read)
ALTER TABLE sql_challenges ENABLE ROW LEVEL SECURITY;
CREATE POLICY "challenges_public_read" ON sql_challenges FOR SELECT TO anon, authenticated USING (true);

-- SQL Submissions (own data only)
ALTER TABLE sql_submissions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "submissions_own" ON sql_submissions FOR ALL TO authenticated USING (user_id = auth.uid());

-- SQL Challenge Progress (own data only)
ALTER TABLE sql_challenge_progress ENABLE ROW LEVEL SECURITY;
CREATE POLICY "progress_own" ON sql_challenge_progress FOR ALL TO authenticated USING (user_id = auth.uid());

-- SQL Lessons (public read)
ALTER TABLE sql_lessons ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lessons_public_read" ON sql_lessons FOR SELECT TO anon, authenticated USING (true);

-- SQL Lesson Progress (own data only)
ALTER TABLE sql_lesson_progress ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lesson_progress_own" ON sql_lesson_progress FOR ALL TO authenticated USING (user_id = auth.uid());
