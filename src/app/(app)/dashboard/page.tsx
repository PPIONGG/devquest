'use client'

import { useRouter } from 'next/navigation'
import {
  Code2,
  BookOpen,
  Trophy,
  ArrowRight,
  Zap,
  Target,
  Flame,
  GraduationCap,
} from 'lucide-react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Progress } from '@/components/ui/progress'
import { Skeleton } from '@/components/ui/skeleton'
import { useSqlChallenges } from '@/hooks/use-sql'
import { useAuth } from '@/providers/auth-provider'
import { getDifficultyConfig } from '@/config/sql'

export default function DashboardPage() {
  const router = useRouter()
  const { user } = useAuth()
  const { stats, loading } = useSqlChallenges()

  const totalPercent =
    stats && stats.total_challenges > 0
      ? Math.round((stats.solved / stats.total_challenges) * 100)
      : 0

  return (
    <div className="space-y-8">
      {/* Welcome */}
      <div>
        <h2 className="text-2xl font-bold tracking-tight">
          Welcome back, {user?.email?.split('@')[0] ?? 'there'}!
        </h2>
        <p className="mt-1 text-muted-foreground">
          Ready to level up your SQL skills today?
        </p>
      </div>

      {/* Stats grid */}
      {loading ? (
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {Array.from({ length: 4 }).map((_, i) => (
            <Skeleton key={i} className="h-28 rounded-lg" />
          ))}
        </div>
      ) : stats ? (
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          <Card className="gap-0 py-0">
            <CardHeader className="flex-row items-center justify-between px-4 py-3">
              <CardTitle className="text-xs font-medium text-muted-foreground">Total Solved</CardTitle>
              <Trophy className="size-4 text-muted-foreground" />
            </CardHeader>
            <CardContent className="space-y-1.5 px-4 pb-3 pt-0">
              <div className="flex items-baseline gap-1">
                <span className="text-2xl font-bold">{stats.solved}</span>
                <span className="text-xs text-muted-foreground">/ {stats.total_challenges}</span>
              </div>
              <Progress value={totalPercent} className="h-1.5" />
            </CardContent>
          </Card>

          <Card className="gap-0 py-0">
            <CardHeader className="flex-row items-center justify-between px-4 py-3">
              <CardTitle className="text-xs font-medium text-muted-foreground">Easy</CardTitle>
              <Zap className="size-4 text-green-500" />
            </CardHeader>
            <CardContent className="space-y-1.5 px-4 pb-3 pt-0">
              <div className="flex items-baseline gap-1">
                <span className="text-2xl font-bold">{stats.easy_solved}</span>
                <span className="text-xs text-muted-foreground">/ {stats.easy_total}</span>
              </div>
              <div className="h-1.5 w-full overflow-hidden rounded-full bg-muted">
                <div
                  className="h-full rounded-full bg-green-500 transition-all"
                  style={{
                    width: `${stats.easy_total > 0 ? Math.round((stats.easy_solved / stats.easy_total) * 100) : 0}%`,
                  }}
                />
              </div>
            </CardContent>
          </Card>

          <Card className="gap-0 py-0">
            <CardHeader className="flex-row items-center justify-between px-4 py-3">
              <CardTitle className="text-xs font-medium text-muted-foreground">Medium</CardTitle>
              <Target className="size-4 text-yellow-500" />
            </CardHeader>
            <CardContent className="space-y-1.5 px-4 pb-3 pt-0">
              <div className="flex items-baseline gap-1">
                <span className="text-2xl font-bold">{stats.medium_solved}</span>
                <span className="text-xs text-muted-foreground">/ {stats.medium_total}</span>
              </div>
              <div className="h-1.5 w-full overflow-hidden rounded-full bg-muted">
                <div
                  className="h-full rounded-full bg-yellow-500 transition-all"
                  style={{
                    width: `${stats.medium_total > 0 ? Math.round((stats.medium_solved / stats.medium_total) * 100) : 0}%`,
                  }}
                />
              </div>
            </CardContent>
          </Card>

          <Card className="gap-0 py-0">
            <CardHeader className="flex-row items-center justify-between px-4 py-3">
              <CardTitle className="text-xs font-medium text-muted-foreground">Hard</CardTitle>
              <Flame className="size-4 text-red-500" />
            </CardHeader>
            <CardContent className="space-y-1.5 px-4 pb-3 pt-0">
              <div className="flex items-baseline gap-1">
                <span className="text-2xl font-bold">{stats.hard_solved}</span>
                <span className="text-xs text-muted-foreground">/ {stats.hard_total}</span>
              </div>
              <div className="h-1.5 w-full overflow-hidden rounded-full bg-muted">
                <div
                  className="h-full rounded-full bg-red-500 transition-all"
                  style={{
                    width: `${stats.hard_total > 0 ? Math.round((stats.hard_solved / stats.hard_total) * 100) : 0}%`,
                  }}
                />
              </div>
            </CardContent>
          </Card>
        </div>
      ) : null}

      <div className="grid gap-6 lg:grid-cols-2">
        {/* Daily Challenge */}
        {stats?.daily_challenge && (
          <Card>
            <CardHeader className="pb-3">
              <div className="flex items-center justify-between">
                <CardTitle className="flex items-center gap-2 text-sm">
                  <Zap className="size-4 text-yellow-500" />
                  Daily Challenge
                </CardTitle>
                <Badge variant="secondary" className="text-[10px]">
                  {new Date().toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}
                </Badge>
              </div>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <div className="flex items-center gap-2">
                  <h3 className="font-semibold">{stats.daily_challenge.title}</h3>
                  <Badge
                    variant="outline"
                    className={`text-[10px] ${getDifficultyConfig(stats.daily_challenge.difficulty).textColor}`}
                  >
                    {getDifficultyConfig(stats.daily_challenge.difficulty).label}
                  </Badge>
                </div>
                <p className="mt-1 text-sm text-muted-foreground line-clamp-2">
                  {stats.daily_challenge.description}
                </p>
              </div>
              <Button
                onClick={() => router.push(`/sql/challenges/${stats.daily_challenge!.slug}`)}
                className="w-full gap-2"
              >
                <Code2 className="size-4" />
                Solve Challenge
                <ArrowRight className="ml-auto size-4" />
              </Button>
            </CardContent>
          </Card>
        )}

        {/* Quick actions */}
        <div className="space-y-3">
          <h3 className="text-sm font-semibold text-muted-foreground">Quick Actions</h3>
          <div className="grid gap-3">
            <Card
              className="cursor-pointer gap-0 py-0 transition-colors hover:bg-muted/50"
              onClick={() => router.push('/sql/challenges')}
            >
              <CardContent className="flex items-center gap-3 px-4 py-4">
                <div className="flex size-9 shrink-0 items-center justify-center rounded-lg bg-primary/10">
                  <Code2 className="size-5 text-primary" />
                </div>
                <div className="flex-1">
                  <p className="text-sm font-medium">Practice Challenges</p>
                  <p className="text-xs text-muted-foreground">
                    {stats ? `${stats.total_challenges - stats.solved} unsolved` : 'Browse all challenges'}
                  </p>
                </div>
                <ArrowRight className="size-4 text-muted-foreground" />
              </CardContent>
            </Card>

            <Card
              className="cursor-pointer gap-0 py-0 transition-colors hover:bg-muted/50"
              onClick={() => router.push('/sql/learn')}
            >
              <CardContent className="flex items-center gap-3 px-4 py-4">
                <div className="flex size-9 shrink-0 items-center justify-center rounded-lg bg-blue-500/10">
                  <BookOpen className="size-5 text-blue-500" />
                </div>
                <div className="flex-1">
                  <p className="text-sm font-medium">SQL Academy</p>
                  <p className="text-xs text-muted-foreground">Structured learning path</p>
                </div>
                <ArrowRight className="size-4 text-muted-foreground" />
              </CardContent>
            </Card>

            <Card
              className="cursor-pointer gap-0 py-0 transition-colors hover:bg-muted/50"
              onClick={() => router.push('/sql/cheat-sheet')}
            >
              <CardContent className="flex items-center gap-3 px-4 py-4">
                <div className="flex size-9 shrink-0 items-center justify-center rounded-lg bg-green-500/10">
                  <GraduationCap className="size-5 text-green-500" />
                </div>
                <div className="flex-1">
                  <p className="text-sm font-medium">SQL Cheat Sheet</p>
                  <p className="text-xs text-muted-foreground">Quick reference guide</p>
                </div>
                <ArrowRight className="size-4 text-muted-foreground" />
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  )
}
