'use client'

import { useState, useEffect, useCallback, useRef } from 'react'
import { toast } from 'sonner'
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
import {
  fetchChallenges,
  fetchChallengeBySlug,
  fetchStats,
  fetchTopSolutions,
  runQuery,
  submitQuery,
  explainQuery,
  previewTableData,
  fetchAcademyModules,
  fetchLesson,
  markLessonComplete,
} from '@/lib/services/sql'

// ─── Challenge List ────────────────────────────────────────────

export function useSqlChallenges() {
  const [challenges, setChallenges] = useState<SqlChallengeWithProgress[]>([])
  const [stats, setStats] = useState<SqlPracticeStats | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [search, setSearch] = useState('')
  const [difficultyFilter, setDifficultyFilter] = useState('all')
  const [categoryFilter, setCategoryFilter] = useState('all')
  const [statusFilter, setStatusFilter] = useState('all')
  const mountedRef = useRef(true)

  useEffect(() => {
    mountedRef.current = true
    return () => { mountedRef.current = false }
  }, [])

  const load = useCallback(async () => {
    setLoading(true)
    setError(null)
    try {
      const [ch, st] = await Promise.all([fetchChallenges(), fetchStats()])
      if (mountedRef.current) {
        setChallenges(ch)
        setStats(st)
      }
    } catch (err: any) {
      if (mountedRef.current) setError(err.message ?? 'Failed to load challenges')
    } finally {
      if (mountedRef.current) setLoading(false)
    }
  }, [])

  useEffect(() => { load() }, [load])

  const filtered = challenges.filter((c) => {
    if (difficultyFilter !== 'all' && c.difficulty !== difficultyFilter) return false
    if (categoryFilter !== 'all' && c.category !== categoryFilter) return false
    if (statusFilter === 'solved' && !c.progress?.is_solved) return false
    if (statusFilter === 'unsolved' && c.progress?.is_solved) return false
    if (search.trim()) {
      const q = search.toLowerCase()
      return c.title.toLowerCase().includes(q) || c.category.includes(q)
    }
    return true
  })

  return {
    challenges: filtered,
    stats,
    loading,
    error,
    search,
    setSearch,
    difficultyFilter,
    setDifficultyFilter,
    categoryFilter,
    setCategoryFilter,
    statusFilter,
    setStatusFilter,
    refetch: load,
  }
}

// ─── Challenge Detail ──────────────────────────────────────────

export function useSqlChallenge(slug: string) {
  const [detail, setDetail] = useState<SqlChallengeDetail | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [running, setRunning] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [result, setResult] = useState<SqlSubmitResult | null>(null)
  const [resultIsPreview, setResultIsPreview] = useState(false)
  const mountedRef = useRef(true)

  useEffect(() => {
    mountedRef.current = true
    return () => { mountedRef.current = false }
  }, [])

  const load = useCallback(async () => {
    if (!slug) return
    setLoading(true)
    setError(null)
    try {
      const d = await fetchChallengeBySlug(slug)
      if (mountedRef.current) setDetail(d)
    } catch (err: any) {
      if (mountedRef.current) setError(err.message ?? 'Failed to load challenge')
    } finally {
      if (mountedRef.current) setLoading(false)
    }
  }, [slug])

  useEffect(() => { load() }, [load])

  const run = useCallback(async (query: string) => {
    if (!detail) return
    setRunning(true)
    try {
      const res = await runQuery(detail.challenge.id, query)
      if (mountedRef.current) {
        setResult(res)
        setResultIsPreview(true)
        if (res.status === 'error') {
          toast.error(res.error_message || 'Query error')
        } else {
          toast.success(`Query ran in ${res.execution_time_ms}ms`)
        }
      }
    } catch (err: any) {
      toast.error(err.message ?? 'Run failed')
    } finally {
      if (mountedRef.current) setRunning(false)
    }
  }, [detail])

  const submit = useCallback(async (query: string) => {
    if (!detail) return null
    setSubmitting(true)
    try {
      const res = await submitQuery(detail.challenge.id, query)
      if (mountedRef.current) {
        setResult(res)
        setResultIsPreview(false)
        if (res.status === 'correct') {
          toast.success('Correct! Great job!')
          // Refresh to update progress
          load()
        } else if (res.status === 'wrong') {
          toast.error('Wrong answer. Check the expected output.')
        } else {
          toast.error(res.error_message || 'Query error')
        }
      }
      return res
    } catch (err: any) {
      toast.error(err.message ?? 'Submit failed')
      return null
    } finally {
      if (mountedRef.current) setSubmitting(false)
    }
  }, [detail, load])

  const explain = useCallback(async (query: string) => {
    if (!detail) return null
    try {
      return await explainQuery(detail.challenge.id, query)
    } catch (err: any) {
      toast.error(err.message ?? 'Explain failed')
      return null
    }
  }, [detail])

  const previewTable = useCallback(async (tableName: string): Promise<QueryResult> => {
    if (!detail) throw new Error('No challenge loaded')
    return previewTableData(detail.challenge.id, tableName)
  }, [detail])

  const refreshTopSolutions = useCallback(async (): Promise<SqlTopSolution[]> => {
    if (!detail) return []
    const solutions = await fetchTopSolutions(detail.challenge.id)
    if (mountedRef.current) setDetail((prev) => prev ? { ...prev, top_solutions: solutions } : prev)
    return solutions
  }, [detail])

  return {
    challenge: detail?.challenge ?? null,
    submissions: detail?.submissions ?? [],
    progress: detail?.progress ?? null,
    prevSlug: detail?.prev_slug ?? '',
    nextSlug: detail?.next_slug ?? '',
    solutionSql: detail?.solution_sql ?? null,
    topSolutions: detail?.top_solutions ?? [],
    loading,
    error,
    running,
    submitting,
    result,
    resultIsPreview,
    run,
    submit,
    explain,
    previewTable,
    refreshTopSolutions,
    refetch: load,
  }
}

// ─── Academy ──────────────────────────────────────────────────

export function useSqlAcademy() {
  const [modules, setModules] = useState<SqlModuleWithLessons[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const mountedRef = useRef(true)

  useEffect(() => {
    mountedRef.current = true
    return () => { mountedRef.current = false }
  }, [])

  useEffect(() => {
    setLoading(true)
    fetchAcademyModules()
      .then((data) => { if (mountedRef.current) setModules(data) })
      .catch((err) => { if (mountedRef.current) setError(err.message) })
      .finally(() => { if (mountedRef.current) setLoading(false) })
  }, [])

  return { modules, loading, error }
}

export function useSqlLesson(lessonId: string) {
  const [lesson, setLesson] = useState<SqlLesson | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const mountedRef = useRef(true)

  useEffect(() => {
    mountedRef.current = true
    return () => { mountedRef.current = false }
  }, [])

  const load = useCallback(async () => {
    if (!lessonId) return
    setLoading(true)
    try {
      const l = await fetchLesson(lessonId)
      if (mountedRef.current) setLesson(l)
    } catch (err: any) {
      if (mountedRef.current) setError(err.message)
    } finally {
      if (mountedRef.current) setLoading(false)
    }
  }, [lessonId])

  useEffect(() => { load() }, [load])

  const complete = useCallback(async () => {
    if (!lesson) return
    try {
      await markLessonComplete(lesson.id)
      if (mountedRef.current) setLesson((prev) => prev ? { ...prev, is_completed: true } : prev)
      toast.success('Lesson marked as complete!')
    } catch (err: any) {
      toast.error(err.message ?? 'Failed to mark complete')
    }
  }, [lesson])

  return { lesson, loading, error, refetch: load, complete }
}
