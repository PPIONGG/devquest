'use client'

import { useRouter } from 'next/navigation'
import { BookOpen, CheckCircle2, Circle, ChevronRight, ArrowRight } from 'lucide-react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Skeleton } from '@/components/ui/skeleton'
import { useSqlAcademy } from '@/hooks/use-sql'

export default function SqlAcademyPage() {
  const router = useRouter()
  const { modules, loading, error } = useSqlAcademy()

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="space-y-2">
          <Skeleton className="h-8 w-48" />
          <Skeleton className="h-4 w-72" />
        </div>
        {Array.from({ length: 3 }).map((_, i) => (
          <div key={i} className="space-y-3">
            <Skeleton className="h-6 w-40" />
            {Array.from({ length: 3 }).map((_, j) => (
              <Skeleton key={j} className="h-16 w-full rounded-lg" />
            ))}
          </div>
        ))}
      </div>
    )
  }

  if (error) {
    return (
      <div className="rounded-md border border-destructive/50 bg-destructive/10 px-4 py-3 text-sm text-destructive">
        {error}
      </div>
    )
  }

  const totalLessons = modules.reduce((sum, m) => sum + m.lessons.length, 0)
  const completedLessons = modules.reduce(
    (sum, m) => sum + m.lessons.filter((l) => l.is_completed).length,
    0
  )

  return (
    <div className="mx-auto max-w-4xl space-y-8">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h2 className="text-2xl font-bold tracking-tight">SQL Academy</h2>
          <p className="mt-1 text-muted-foreground">
            Structured learning path from basics to advanced SQL.
          </p>
        </div>
        <div className="flex items-center gap-3">
          <div className="text-sm text-muted-foreground">
            {completedLessons}/{totalLessons} lessons completed
          </div>
          <Button variant="outline" size="sm" onClick={() => router.push('/sql/cheat-sheet')}>
            Cheat Sheet
          </Button>
          <Button size="sm" onClick={() => router.push('/sql/challenges')}>
            Challenges <ArrowRight className="ml-1 size-4" />
          </Button>
        </div>
      </div>

      {modules.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-20 text-center">
          <BookOpen className="mb-4 size-12 text-muted-foreground/20" />
          <h3 className="text-lg font-medium">No lessons yet</h3>
          <p className="text-sm text-muted-foreground">Check back soon for new content.</p>
        </div>
      ) : (
        <div className="space-y-8">
          {modules.map((module) => {
            const completedInModule = module.lessons.filter((l) => l.is_completed).length
            const allDone = completedInModule === module.lessons.length

            return (
              <div key={module.id} className="space-y-3">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <h3 className="font-semibold">{module.title}</h3>
                    {allDone && (
                      <Badge
                        variant="secondary"
                        className="bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400"
                      >
                        Completed
                      </Badge>
                    )}
                  </div>
                  <span className="text-xs text-muted-foreground">
                    {completedInModule}/{module.lessons.length}
                  </span>
                </div>

                <div className="space-y-2">
                  {module.lessons.map((lesson) => (
                    <Card
                      key={lesson.id}
                      className="cursor-pointer gap-0 py-0 transition-colors hover:bg-muted/50"
                      onClick={() => router.push(`/sql/learn/${lesson.id}`)}
                    >
                      <CardHeader className="flex-row items-center gap-3 px-4 py-3">
                        <div className="shrink-0">
                          {lesson.is_completed ? (
                            <CheckCircle2 className="size-5 text-green-500" />
                          ) : (
                            <Circle className="size-5 text-muted-foreground/40" />
                          )}
                        </div>
                        <div className="min-w-0 flex-1">
                          <CardTitle className="text-sm">{lesson.title}</CardTitle>
                          <p className="mt-0.5 truncate text-xs text-muted-foreground">
                            {lesson.description}
                          </p>
                        </div>
                        <ChevronRight className="size-4 shrink-0 text-muted-foreground" />
                      </CardHeader>
                    </Card>
                  ))}
                </div>
              </div>
            )
          })}
        </div>
      )}
    </div>
  )
}
