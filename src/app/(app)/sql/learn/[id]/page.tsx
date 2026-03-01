'use client'

import { useState, useCallback, use } from 'react'
import { useRouter } from 'next/navigation'
import { ArrowLeft, CheckCircle2, Loader2, BookOpen } from 'lucide-react'
import { toast } from 'sonner'
import { Button } from '@/components/ui/button'
import { Card, CardContent } from '@/components/ui/card'
import { Skeleton } from '@/components/ui/skeleton'
import { ChallengeEditor } from '@/components/sql/challenge-editor'
import { ChallengeResult } from '@/components/sql/challenge-result'
import { useSqlLesson } from '@/hooks/use-sql'
import type { SqlSubmitResult } from '@/lib/types/database'

export default function LessonDetailPage({
  params,
}: {
  params: Promise<{ id: string }>
}) {
  const { id } = use(params)
  const router = useRouter()
  const { lesson, loading, error, refetch, complete } = useSqlLesson(id)

  const [query, setQuery] = useState('')
  const [running, setRunning] = useState(false)
  const [result, setResult] = useState<SqlSubmitResult | null>(null)

  const handleRun = useCallback(async () => {
    if (!lesson || !query.trim()) return
    setRunning(true)
    try {
      const res = await fetch('/api/sql/lesson-run', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ lesson_id: lesson.id, query }),
      })
      if (!res.ok) {
        const err = await res.json().catch(() => ({ error: 'Run failed' }))
        setResult({
          status: 'error',
          user_result: null,
          expected_result: null,
          execution_time_ms: 0,
          error_message: err.error || 'Run failed',
        })
        return
      }
      const data = await res.json()
      setResult(data)
    } catch (err: any) {
      toast.error(err.message ?? 'Run failed')
    } finally {
      setRunning(false)
    }
  }, [lesson, query])

  const handleSubmit = useCallback(async () => {
    await handleRun()
  }, [handleRun])

  // Set default query from lesson's practice_query
  const handleReset = useCallback(() => {
    if (lesson?.practice_query) setQuery(lesson.practice_query)
  }, [lesson])

  if (loading) {
    return (
      <div className="mx-auto max-w-4xl space-y-6">
        <Skeleton className="h-9 w-24" />
        <Skeleton className="h-8 w-64" />
        <Skeleton className="h-64 w-full rounded-lg" />
        <Skeleton className="h-48 w-full rounded-lg" />
      </div>
    )
  }

  if (error || !lesson) {
    return (
      <div className="space-y-4">
        <Button variant="ghost" size="sm" onClick={() => router.push('/sql/learn')}>
          <ArrowLeft className="mr-2 size-4" /> Back
        </Button>
        <div className="rounded-md border border-destructive/50 bg-destructive/10 px-4 py-3 text-sm text-destructive">
          {error || 'Lesson not found'}
        </div>
      </div>
    )
  }

  return (
    <div className="mx-auto max-w-4xl space-y-6">
      <div className="flex items-center justify-between">
        <Button variant="ghost" size="sm" onClick={() => router.push('/sql/learn')}>
          <ArrowLeft className="mr-1 size-4" /> Academy
        </Button>
        {lesson.is_completed ? (
          <div className="flex items-center gap-1.5 text-sm text-green-600 dark:text-green-400">
            <CheckCircle2 className="size-4" />
            Completed
          </div>
        ) : (
          <Button size="sm" onClick={complete} className="gap-2">
            <CheckCircle2 className="size-4" />
            Mark Complete
          </Button>
        )}
      </div>

      <div>
        <p className="text-sm text-muted-foreground">{lesson.module_title}</p>
        <h2 className="mt-0.5 text-2xl font-bold">{lesson.title}</h2>
        <p className="mt-1 text-muted-foreground">{lesson.description}</p>
      </div>

      {/* Lesson content (markdown-like) */}
      <Card>
        <CardContent className="px-6 py-5">
          <div className="prose prose-sm dark:prose-invert max-w-none">
            {lesson.content.split('\n').map((line, i) => {
              if (line.startsWith('**') && line.endsWith('**')) {
                return <p key={i} className="font-bold">{line.slice(2, -2)}</p>
              }
              if (line.startsWith('```')) return null
              if (line.match(/^`[^`]+`$/)) {
                return (
                  <p key={i}>
                    <code className="rounded bg-muted px-1.5 py-0.5 font-mono text-sm">
                      {line.slice(1, -1)}
                    </code>
                  </p>
                )
              }
              if (!line.trim()) return <br key={i} />
              // Inline code
              const parts = line.split(/(`[^`]+`)/)
              return (
                <p key={i} className="leading-relaxed">
                  {parts.map((part, j) => {
                    if (part.startsWith('`') && part.endsWith('`')) {
                      return (
                        <code key={j} className="rounded bg-muted px-1 py-0.5 font-mono text-sm">
                          {part.slice(1, -1)}
                        </code>
                      )
                    }
                    // Handle **bold**
                    const boldParts = part.split(/(\*\*[^*]+\*\*)/)
                    return boldParts.map((bp, k) => {
                      if (bp.startsWith('**') && bp.endsWith('**')) {
                        return <strong key={k}>{bp.slice(2, -2)}</strong>
                      }
                      return bp
                    })
                  })}
                </p>
              )
            })}
          </div>
        </CardContent>
      </Card>

      {/* Practice editor */}
      {lesson.table_schema && (
        <div className="space-y-3">
          <div className="flex items-center gap-2">
            <BookOpen className="size-4 text-primary" />
            <h3 className="font-semibold">Practice</h3>
          </div>
          <p className="text-sm text-muted-foreground">
            Try it yourself. Click &quot;Run&quot; to see the results.
          </p>

          <ChallengeEditor
            value={query || lesson.practice_query}
            onChange={setQuery}
            onRun={handleRun}
            onSubmit={handleSubmit}
            onReset={handleReset}
            running={running}
            submitting={false}
          />

          {result && <ChallengeResult result={result} isPreview />}
        </div>
      )}
    </div>
  )
}
