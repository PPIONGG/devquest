'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Menu, Database, Code2, BookOpen, FileText, LayoutDashboard, Settings } from 'lucide-react'
import { useState } from 'react'
import { cn } from '@/lib/utils'
import { Button } from '@/components/ui/button'
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet'

const navItems = [
  { href: '/dashboard', label: 'Dashboard', icon: LayoutDashboard },
  { href: '/sql/challenges', label: 'Challenges', icon: Code2 },
  { href: '/sql/learn', label: 'Academy', icon: BookOpen },
  { href: '/sql/cheat-sheet', label: 'Cheat Sheet', icon: FileText },
  { href: '/settings', label: 'Settings', icon: Settings },
]

export function MobileHeader() {
  const pathname = usePathname()
  const [open, setOpen] = useState(false)

  return (
    <header className="md:hidden flex h-14 items-center gap-4 border-b px-4 bg-background">
      <Sheet open={open} onOpenChange={setOpen}>
        <SheetTrigger asChild>
          <Button variant="ghost" size="icon">
            <Menu className="size-5" />
          </Button>
        </SheetTrigger>
        <SheetContent side="left" className="w-56 p-0">
          <div className="flex items-center gap-2 px-4 py-4 border-b">
            <Database className="size-5 text-primary" />
            <span className="font-bold text-lg">DevQuest</span>
          </div>
          <nav className="px-2 py-3 space-y-0.5">
            {navItems.map((item) => {
              const active = pathname === item.href || pathname.startsWith(item.href + '/')
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  onClick={() => setOpen(false)}
                  className={cn(
                    'flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors',
                    active
                      ? 'bg-primary/10 text-primary'
                      : 'text-muted-foreground hover:bg-muted hover:text-foreground'
                  )}
                >
                  <item.icon className="size-4 shrink-0" />
                  {item.label}
                </Link>
              )
            })}
          </nav>
        </SheetContent>
      </Sheet>
      <div className="flex items-center gap-2">
        <Database className="size-4 text-primary" />
        <span className="font-bold">DevQuest</span>
      </div>
    </header>
  )
}
