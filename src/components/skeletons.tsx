import { Skeleton } from '@/components/ui/skeleton'
import { Card, CardHeader } from '@/components/ui/card'

export function ChallengeCardSkeleton() {
  return (
    <Card className="gap-0 py-0">
      <CardHeader className="flex-row items-center gap-3 px-4 py-3">
        <Skeleton className="size-5 shrink-0 rounded-full" />
        <div className="flex-1 space-y-2">
          <Skeleton className="h-4 w-3/4" />
          <div className="flex gap-2">
            <Skeleton className="h-3 w-12 rounded" />
            <Skeleton className="h-3 w-20 rounded" />
          </div>
        </div>
      </CardHeader>
    </Card>
  )
}

export function LessonCardSkeleton() {
  return (
    <div className="flex items-center gap-3 rounded-lg border p-3">
      <Skeleton className="size-5 shrink-0 rounded-full" />
      <div className="flex-1 space-y-1.5">
        <Skeleton className="h-4 w-2/3" />
        <Skeleton className="h-3 w-full" />
      </div>
    </div>
  )
}

export function PageSkeleton() {
  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <Skeleton className="h-8 w-48" />
        <Skeleton className="h-4 w-72" />
      </div>
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {Array.from({ length: 6 }).map((_, i) => (
          <ChallengeCardSkeleton key={i} />
        ))}
      </div>
    </div>
  )
}
