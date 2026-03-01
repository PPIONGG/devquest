import { TooltipProvider } from '@/components/ui/tooltip'
import { AppSidebar } from '@/components/layout/app-sidebar'
import { MobileHeader } from '@/components/layout/header'
import { AuthGuard } from '@/components/layout/auth-guard'

export const dynamic = 'force-dynamic'

export default function AppLayout({ children }: { children: React.ReactNode }) {
  return (
    <TooltipProvider>
      <div className="flex h-screen overflow-hidden">
        <AppSidebar />
        <div className="flex flex-1 flex-col overflow-hidden">
          <MobileHeader />
          <main className="flex-1 overflow-auto p-4 md:p-6">
            <AuthGuard>{children}</AuthGuard>
          </main>
        </div>
      </div>
    </TooltipProvider>
  )
}
