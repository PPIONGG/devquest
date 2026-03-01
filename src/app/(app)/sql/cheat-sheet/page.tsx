'use client'

import { useRouter } from 'next/navigation'
import {
  ArrowLeft,
  Search,
  Copy,
  Filter,
  Database,
  Link as LinkIcon,
  Zap,
  Edit3,
  Settings,
  ShieldCheck,
  Type,
} from 'lucide-react'
import { useState } from 'react'
import { toast } from 'sonner'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Badge } from '@/components/ui/badge'

interface CheatItem {
  title: string
  syntax: string
  description: string
  example: string
}

interface CheatCategory {
  category: string
  icon: React.ComponentType<{ className?: string }>
  items: CheatItem[]
}

const cheatSheetData: CheatCategory[] = [
  {
    category: 'Basics & Selection',
    icon: Database,
    items: [
      {
        title: 'SELECT ALL',
        syntax: 'SELECT * FROM table_name;',
        description: 'Retrieve all columns from a table.',
        example: 'SELECT * FROM employees;',
      },
      {
        title: 'SELECT COLUMNS',
        syntax: 'SELECT col1, col2 FROM table;',
        description: 'Select only specific columns.',
        example: 'SELECT name, salary FROM employees;',
      },
      {
        title: 'SELECT DISTINCT',
        syntax: 'SELECT DISTINCT column FROM table;',
        description: 'Return only unique values.',
        example: 'SELECT DISTINCT department FROM employees;',
      },
      {
        title: 'ORDER BY',
        syntax: 'SELECT * FROM table ORDER BY col ASC|DESC;',
        description: 'Sort results ascending or descending.',
        example: 'SELECT * FROM users ORDER BY created_at DESC;',
      },
      {
        title: 'LIMIT & OFFSET',
        syntax: 'SELECT * FROM table LIMIT 10 OFFSET 5;',
        description: 'Limit rows and skip initial rows.',
        example: 'SELECT * FROM products LIMIT 5 OFFSET 10;',
      },
    ],
  },
  {
    category: 'Filtering (WHERE)',
    icon: Filter,
    items: [
      {
        title: 'WHERE CLAUSE',
        syntax: 'SELECT * FROM table WHERE condition;',
        description: 'Filter rows based on a condition.',
        example: 'SELECT * FROM users WHERE age >= 18;',
      },
      {
        title: 'LIKE & Wildcards',
        syntax: "WHERE column LIKE 'A%';",
        description: '% matches multiple chars, _ matches one.',
        example: "SELECT * FROM users WHERE name LIKE 'John%';",
      },
      {
        title: 'IN / BETWEEN',
        syntax: 'WHERE col IN (v1, v2) / BETWEEN v1 AND v2;',
        description: 'Match a value from a list or within a range.',
        example: 'SELECT * FROM sales WHERE amount BETWEEN 100 AND 500;',
      },
      {
        title: 'CASE WHEN',
        syntax: 'CASE WHEN cond THEN res ELSE res END;',
        description: 'Conditional logic (if-else) in SQL.',
        example: "SELECT name, CASE WHEN score >= 50 THEN 'Pass' ELSE 'Fail' END FROM results;",
      },
    ],
  },
  {
    category: 'Joins (Table Relations)',
    icon: LinkIcon,
    items: [
      {
        title: 'INNER JOIN',
        syntax: 'SELECT * FROM T1 JOIN T2 ON T1.id = T2.id;',
        description: 'Return only rows with matches in both tables.',
        example: 'SELECT e.name, d.name FROM employees e JOIN depts d ON e.dept_id = d.id;',
      },
      {
        title: 'LEFT JOIN',
        syntax: 'SELECT * FROM T1 LEFT JOIN T2 ON T1.id = T2.id;',
        description: 'All rows from left, matching from right (NULL if no match).',
        example: 'SELECT * FROM users u LEFT JOIN orders o ON u.id = o.user_id;',
      },
      {
        title: 'FULL OUTER JOIN',
        syntax: 'SELECT * FROM T1 FULL JOIN T2 ON T1.id = T2.id;',
        description: 'All rows from both tables.',
        example: 'SELECT * FROM t1 FULL JOIN t2 ON t1.id = t2.id;',
      },
    ],
  },
  {
    category: 'Aggregation',
    icon: Zap,
    items: [
      {
        title: 'COUNT / SUM / AVG',
        syntax: 'SELECT COUNT(*), SUM(col), AVG(col) FROM table;',
        description: 'Aggregate functions for counting and math.',
        example: 'SELECT COUNT(*), AVG(salary) FROM employees;',
      },
      {
        title: 'GROUP BY',
        syntax: 'SELECT col, COUNT(*) FROM table GROUP BY col;',
        description: 'Group rows for aggregate calculations.',
        example: 'SELECT dept, COUNT(*) FROM employees GROUP BY dept;',
      },
      {
        title: 'HAVING',
        syntax: 'SELECT col, COUNT(*) FROM table GROUP BY col HAVING COUNT(*) > 5;',
        description: 'Filter grouped results (like WHERE but for groups).',
        example: 'SELECT dept, COUNT(*) FROM employees GROUP BY dept HAVING COUNT(*) > 3;',
      },
    ],
  },
  {
    category: 'Data Modification (DML)',
    icon: Edit3,
    items: [
      {
        title: 'INSERT INTO',
        syntax: 'INSERT INTO table (col1, col2) VALUES (v1, v2);',
        description: 'Add new rows to a table.',
        example: "INSERT INTO users (name, email) VALUES ('Alice', 'alice@dev.com');",
      },
      {
        title: 'UPDATE',
        syntax: 'UPDATE table SET col = val WHERE condition;',
        description: 'Modify existing rows. Always use WHERE!',
        example: 'UPDATE employees SET salary = salary * 1.1 WHERE id = 101;',
      },
      {
        title: 'DELETE',
        syntax: 'DELETE FROM table WHERE condition;',
        description: 'Remove rows from a table. Always use WHERE!',
        example: "DELETE FROM tasks WHERE status = 'completed';",
      },
    ],
  },
  {
    category: 'Schema & Tables (DDL)',
    icon: Settings,
    items: [
      {
        title: 'CREATE TABLE',
        syntax: 'CREATE TABLE table (col type constraints);',
        description: 'Create a new table with column definitions.',
        example: 'CREATE TABLE posts (id SERIAL PRIMARY KEY, title TEXT NOT NULL);',
      },
      {
        title: 'ALTER TABLE',
        syntax: 'ALTER TABLE table ADD/DROP/RENAME COLUMN col;',
        description: 'Modify an existing table structure.',
        example: 'ALTER TABLE users ADD COLUMN phone_number VARCHAR(15);',
      },
    ],
  },
  {
    category: 'Constraints',
    icon: ShieldCheck,
    items: [
      {
        title: 'PRIMARY KEY',
        syntax: 'ID INT PRIMARY KEY;',
        description: 'Unique identifier for each row.',
        example: 'user_id UUID PRIMARY KEY DEFAULT gen_random_uuid();',
      },
      {
        title: 'FOREIGN KEY',
        syntax: 'FOREIGN KEY (col) REFERENCES other_table(id);',
        description: 'Link to another table.',
        example: 'dept_id INT REFERENCES departments(id) ON DELETE CASCADE;',
      },
    ],
  },
  {
    category: 'Advanced: CTEs & Window Functions',
    icon: Zap,
    items: [
      {
        title: 'WITH (CTE)',
        syntax: 'WITH name AS (SELECT ...) SELECT * FROM name;',
        description: 'Named temporary result set for readable queries.',
        example: 'WITH high_sal AS (SELECT * FROM emp WHERE sal > 5000) SELECT * FROM high_sal;',
      },
      {
        title: 'Window Functions',
        syntax: 'FUNC() OVER (PARTITION BY col ORDER BY col);',
        description: 'RANK, ROW_NUMBER, LAG, LEAD without collapsing rows.',
        example: 'SELECT name, RANK() OVER (ORDER BY salary DESC) FROM emp;',
      },
      {
        title: 'String Functions',
        syntax: 'CONCAT(), UPPER(), LOWER(), TRIM(), LENGTH();',
        description: 'Common string manipulation functions.',
        example: "SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM emp;",
      },
      {
        title: 'COALESCE',
        syntax: 'COALESCE(val, fallback);',
        description: 'Return the first non-NULL value.',
        example: "SELECT COALESCE(avatar_url, 'default.png') FROM profiles;",
      },
    ],
  },
]

export default function SqlCheatSheetPage() {
  const router = useRouter()
  const [search, setSearch] = useState('')

  const filteredData = cheatSheetData
    .map((cat) => ({
      ...cat,
      items: cat.items.filter(
        (item) =>
          item.title.toLowerCase().includes(search.toLowerCase()) ||
          item.description.toLowerCase().includes(search.toLowerCase()) ||
          item.syntax.toLowerCase().includes(search.toLowerCase())
      ),
    }))
    .filter((cat) => cat.items.length > 0)

  const copyToClipboard = (text: string) => {
    navigator.clipboard.writeText(text)
    toast.success('Copied to clipboard!')
  }

  return (
    <div className="mx-auto max-w-6xl space-y-8">
      <div className="flex flex-col gap-6 sm:flex-row sm:items-center sm:justify-between">
        <div className="space-y-1">
          <div className="flex items-center gap-2">
            <Button
              variant="ghost"
              size="sm"
              onClick={() => router.push('/sql/learn')}
              className="-ml-2 h-8"
            >
              <ArrowLeft className="mr-1 size-4" /> Academy
            </Button>
          </div>
          <h2 className="text-3xl font-bold tracking-tight">SQL Cheat Sheet</h2>
          <p className="text-muted-foreground">Quick reference for common SQL commands and patterns.</p>
        </div>
        <div className="relative w-full sm:w-80">
          <Search className="absolute left-3 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" />
          <Input
            placeholder="Search commands..."
            className="h-11 pl-9"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      </div>

      <div className="grid gap-8 lg:grid-cols-2">
        {filteredData.map((cat) => (
          <div key={cat.category} className="space-y-4">
            <div className="flex items-center gap-2 px-1">
              <div className="flex size-8 items-center justify-center rounded-lg bg-primary/10 text-primary">
                <cat.icon className="size-4" />
              </div>
              <h3 className="text-xl font-bold">{cat.category}</h3>
              <Badge variant="secondary" className="ml-auto">
                {cat.items.length} items
              </Badge>
            </div>
            <div className="grid gap-4">
              {cat.items.map((item) => (
                <Card
                  key={item.title}
                  className="group overflow-hidden transition-all hover:border-primary/50"
                >
                  <CardHeader className="bg-muted/30 p-4 pb-2">
                    <CardTitle className="flex items-center justify-between text-sm font-bold">
                      <span className="transition-colors group-hover:text-primary">{item.title}</span>
                      <Button
                        variant="ghost"
                        size="icon"
                        className="size-7 hover:bg-background"
                        onClick={() => copyToClipboard(item.syntax)}
                      >
                        <Copy className="size-3.5" />
                      </Button>
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-3 p-4 pt-3">
                    <p className="text-xs leading-relaxed text-muted-foreground">
                      {item.description}
                    </p>
                    <div className="rounded-lg border border-zinc-800 bg-zinc-950 p-3 font-mono text-[11px] text-zinc-300">
                      <span className="text-blue-400">{item.syntax.split(' ')[0]}</span>
                      {item.syntax.substring(item.syntax.indexOf(' '))}
                    </div>
                    <div className="flex items-start gap-2 rounded-md bg-primary/5 p-2 text-[10px]">
                      <span className="shrink-0 font-bold text-primary">EX:</span>
                      <code className="italic leading-normal text-muted-foreground">{item.example}</code>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>
        ))}
      </div>

      {filteredData.length === 0 && (
        <div className="flex flex-col items-center justify-center py-20 text-center">
          <Search className="mb-4 size-12 text-muted-foreground/20" />
          <h3 className="text-lg font-medium">No results found</h3>
          <p className="text-sm text-muted-foreground">Try a different search term.</p>
        </div>
      )}
    </div>
  )
}
