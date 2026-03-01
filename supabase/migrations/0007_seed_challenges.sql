-- ============================================================
-- SEED: SQL Challenges (ported from DevPulse)
-- ============================================================

INSERT INTO sql_challenges (slug, title, difficulty, category, description, table_schema, seed_data, solution_sql, hint, order_sensitive, sort_order)
VALUES (
    'select-all-employees',
    'Select All Employees',
    'easy',
    'select',
    'Write a query to retrieve all columns and all rows from the `employees` table.',
    'CREATE TEMP TABLE employees (
    id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL,
    department_id INT,
    salary NUMERIC(10,2) NOT NULL,
    hire_date DATE NOT NULL,
    manager_id INT
);',
    'INSERT INTO employees VALUES
(1, ''Alice'', ''Johnson'', ''alice@company.com'', 1, 85000, ''2020-03-15'', NULL),
(2, ''Bob'', ''Smith'', ''bob@company.com'', 1, 72000, ''2021-06-01'', 1),
(3, ''Carol'', ''Williams'', ''carol@company.com'', 2, 92000, ''2019-01-10'', NULL),
(4, ''David'', ''Brown'', ''david@company.com'', 2, 68000, ''2022-02-20'', 3),
(5, ''Eve'', ''Davis'', ''eve@company.com'', 3, 78000, ''2021-09-05'', NULL),
(6, ''Frank'', ''Miller'', ''frank@company.com'', 3, 65000, ''2023-01-15'', 5),
(7, ''Grace'', ''Wilson'', ''grace@company.com'', 1, 95000, ''2018-07-22'', NULL),
(8, ''Henry'', ''Moore'', ''henry@company.com'', 2, 71000, ''2022-11-30'', 3);',
    'SELECT * FROM employees;',
    'Use SELECT * to get all columns.',
    false,
    1
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug, title, difficulty, category, description, table_schema, seed_data, solution_sql, hint, order_sensitive, sort_order)
VALUES (
    'employee-names-and-salaries',
    'Employee Names & Salaries',
    'easy',
    'select',
    'Write a query to retrieve only the `first_name`, `last_name`, and `salary` columns from the `employees` table.',
    'CREATE TEMP TABLE employees (
    id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL,
    department_id INT,
    salary NUMERIC(10,2) NOT NULL,
    hire_date DATE NOT NULL,
    manager_id INT
);',
    'INSERT INTO employees VALUES
(1, ''Alice'', ''Johnson'', ''alice@company.com'', 1, 85000, ''2020-03-15'', NULL),
(2, ''Bob'', ''Smith'', ''bob@company.com'', 1, 72000, ''2021-06-01'', 1),
(3, ''Carol'', ''Williams'', ''carol@company.com'', 2, 92000, ''2019-01-10'', NULL),
(4, ''David'', ''Brown'', ''david@company.com'', 2, 68000, ''2022-02-20'', 3),
(5, ''Eve'', ''Davis'', ''eve@company.com'', 3, 78000, ''2021-09-05'', NULL);',
    'SELECT first_name, last_name, salary FROM employees;',
    'List the column names you want separated by commas.',
    false,
    2
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug, title, difficulty, category, description, table_schema, seed_data, solution_sql, hint, order_sensitive, sort_order)
VALUES (
    'unique-departments',
    'Unique Departments',
    'easy',
    'select',
    'Write a query to get all unique (distinct) `department_id` values from the `employees` table. Return a single column named `department_id`.',
    'CREATE TEMP TABLE employees (
    id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL,
    department_id INT,
    salary NUMERIC(10,2) NOT NULL,
    hire_date DATE NOT NULL,
    manager_id INT
);',
    'INSERT INTO employees VALUES
(1, ''Alice'', ''Johnson'', ''alice@company.com'', 1, 85000, ''2020-03-15'', NULL),
(2, ''Bob'', ''Smith'', ''bob@company.com'', 1, 72000, ''2021-06-01'', 1),
(3, ''Carol'', ''Williams'', ''carol@company.com'', 2, 92000, ''2019-01-10'', NULL),
(4, ''David'', ''Brown'', ''david@company.com'', 2, 68000, ''2022-02-20'', 3),
(5, ''Eve'', ''Davis'', ''eve@company.com'', 3, 78000, ''2021-09-05'', NULL),
(6, ''Frank'', ''Miller'', ''frank@company.com'', 3, 65000, ''2023-01-15'', 5),
(7, ''Grace'', ''Wilson'', ''grace@company.com'', 1, 95000, ''2018-07-22'', NULL);',
    'SELECT DISTINCT department_id FROM employees;',
    'Use the DISTINCT keyword after SELECT.',
    false,
    3
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug, title, difficulty, category, description, table_schema, seed_data, solution_sql, hint, order_sensitive, sort_order)
VALUES (
    'top-5-earners',
    'Top 5 Earners',
    'medium',
    'select',
    'Write a query to get the `first_name`, `last_name`, and `salary` of the top 5 highest-paid employees, sorted by salary in descending order.',
    'CREATE TEMP TABLE employees (
    id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL,
    department_id INT,
    salary NUMERIC(10,2) NOT NULL,
    hire_date DATE NOT NULL,
    manager_id INT
);',
    'INSERT INTO employees VALUES
(1, ''Alice'', ''Johnson'', ''alice@company.com'', 1, 85000, ''2020-03-15'', NULL),
(2, ''Bob'', ''Smith'', ''bob@company.com'', 1, 72000, ''2021-06-01'', 1),
(3, ''Carol'', ''Williams'', ''carol@company.com'', 2, 92000, ''2019-01-10'', NULL),
(4, ''David'', ''Brown'', ''david@company.com'', 2, 68000, ''2022-02-20'', 3),
(5, ''Eve'', ''Davis'', ''eve@company.com'', 3, 78000, ''2021-09-05'', NULL),
(6, ''Frank'', ''Miller'', ''frank@company.com'', 3, 65000, ''2023-01-15'', 5),
(7, ''Grace'', ''Wilson'', ''grace@company.com'', 1, 95000, ''2018-07-22'', NULL),
(8, ''Henry'', ''Moore'', ''henry@company.com'', 2, 71000, ''2022-11-30'', 3);',
    'SELECT first_name, last_name, salary FROM employees ORDER BY salary DESC LIMIT 5;',
    'Use ORDER BY ... DESC and LIMIT.',
    true,
    4
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug, title, difficulty, category, description, table_schema, seed_data, solution_sql, hint, order_sensitive, sort_order)
VALUES (
    'high-salary-employees',
    'High Salary Employees',
    'easy',
    'filtering',
    'Write a query to find all employees with a salary greater than 75000. Return all columns.',
    'CREATE TEMP TABLE employees (
    id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL,
    department_id INT,
    salary NUMERIC(10,2) NOT NULL,
    hire_date DATE NOT NULL,
    manager_id INT
);',
    'INSERT INTO employees VALUES
(1, ''Alice'', ''Johnson'', ''alice@company.com'', 1, 85000, ''2020-03-15'', NULL),
(2, ''Bob'', ''Smith'', ''bob@company.com'', 1, 72000, ''2021-06-01'', 1),
(3, ''Carol'', ''Williams'', ''carol@company.com'', 2, 92000, ''2019-01-10'', NULL),
(4, ''David'', ''Brown'', ''david@company.com'', 2, 68000, ''2022-02-20'', 3),
(5, ''Eve'', ''Davis'', ''eve@company.com'', 3, 78000, ''2021-09-05'', NULL),
(6, ''Frank'', ''Miller'', ''frank@company.com'', 3, 65000, ''2023-01-15'', 5);',
    'SELECT * FROM employees WHERE salary > 75000;',
    'Use WHERE with a comparison operator.',
    false,
    5
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug, title, difficulty, category, description, table_schema, seed_data, solution_sql, hint, order_sensitive, sort_order)
VALUES (
    'customers-in-london',
    'Customers in London',
    'easy',
    'filtering',
    'Find all customers who live in London. Return all columns from the `customers` table.',
    'CREATE TEMP TABLE customers (
    id INT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    city TEXT NOT NULL,
    country TEXT NOT NULL
);',
    'INSERT INTO customers VALUES
(1, ''Alice Brown'', ''alice@example.com'', ''London'', ''UK''),
(2, ''Bob Smith'', ''bob@example.com'', ''Paris'', ''France''),
(3, ''Carol White'', ''carol@example.com'', ''London'', ''UK''),
(4, ''David Lee'', ''david@example.com'', ''Berlin'', ''Germany''),
(5, ''Eve Davis'', ''eve@example.com'', ''London'', ''UK'');',
    'SELECT * FROM customers WHERE city = ''London'';',
    'Use WHERE clause to filter by city.',
    false,
    6
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug, title, difficulty, category, description, table_schema, seed_data, solution_sql, hint, order_sensitive, sort_order)
VALUES (
    'it-department-employees',
    'IT Department Employees',
    'easy',
    'joins',
    'Write a query to find all employees who work in the IT department. Return employee `first_name`, `last_name`, and department `name`.',
    'CREATE TEMP TABLE employees (
    id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    dept_id INT
);
CREATE TEMP TABLE departments (
    id INT PRIMARY KEY,
    name TEXT NOT NULL
);',
    'INSERT INTO departments VALUES (1, ''IT''), (2, ''HR''), (3, ''Finance'');
INSERT INTO employees VALUES
(1, ''Alice'', ''Johnson'', 1),
(2, ''Bob'', ''Smith'', 2),
(3, ''Carol'', ''Williams'', 1),
(4, ''David'', ''Brown'', 3),
(5, ''Eve'', ''Davis'', 1);',
    'SELECT e.first_name, e.last_name, d.name FROM employees e JOIN departments d ON e.dept_id = d.id WHERE d.name = ''IT'';',
    'Use JOIN to connect employees and departments, then filter with WHERE.',
    false,
    7
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug, title, difficulty, category, description, table_schema, seed_data, solution_sql, hint, order_sensitive, sort_order)
VALUES (
    'employees-per-department',
    'Employees Per Department',
    'medium',
    'aggregate',
    'Write a query to count the number of employees in each department. Return department `name` and employee `count`. Include departments with zero employees.',
    'CREATE TEMP TABLE employees (
    id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    dept_id INT
);
CREATE TEMP TABLE departments (
    id INT PRIMARY KEY,
    name TEXT NOT NULL
);',
    'INSERT INTO departments VALUES (1, ''IT''), (2, ''HR''), (3, ''Finance''), (4, ''Marketing'');
INSERT INTO employees VALUES
(1, ''Alice'', 1),
(2, ''Bob'', 2),
(3, ''Carol'', 1),
(4, ''David'', 3),
(5, ''Eve'', 1);',
    'SELECT d.name, COUNT(e.id) AS count FROM departments d LEFT JOIN employees e ON d.id = e.dept_id GROUP BY d.name;',
    'Use LEFT JOIN so departments with no employees appear, then GROUP BY and COUNT.',
    false,
    8
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug, title, difficulty, category, description, table_schema, seed_data, solution_sql, hint, order_sensitive, sort_order)
VALUES (
    'total-revenue',
    'Total Revenue',
    'easy',
    'aggregate',
    'Write a query to calculate the total revenue from all orders. Return a single column named `total_revenue`.',
    'CREATE TEMP TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    amount NUMERIC(10,2) NOT NULL,
    status TEXT NOT NULL,
    order_date DATE NOT NULL
);',
    'INSERT INTO orders VALUES
(1, 1, 250.00, ''completed'', ''2024-01-10''),
(2, 2, 180.50, ''completed'', ''2024-01-11''),
(3, 1, 320.00, ''completed'', ''2024-01-12''),
(4, 3, 95.00, ''pending'', ''2024-01-13''),
(5, 2, 450.00, ''completed'', ''2024-01-14'');',
    'SELECT SUM(amount) AS total_revenue FROM orders;',
    'Use the SUM() aggregate function.',
    false,
    9
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug, title, difficulty, category, description, table_schema, seed_data, solution_sql, hint, order_sensitive, sort_order)
VALUES (
    'users-with-no-posts',
    'Users with No Posts',
    'medium',
    'joins',
    'Find all users who have never created a post. Return their `id` and `username`.',
    'CREATE TEMP TABLE users (
    id INT PRIMARY KEY,
    username TEXT NOT NULL,
    email TEXT NOT NULL
);
CREATE TEMP TABLE posts (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    title TEXT NOT NULL,
    created_at DATE NOT NULL
);',
    'INSERT INTO users VALUES
(1, ''alice'', ''alice@example.com''),
(2, ''bob'', ''bob@example.com''),
(3, ''carol'', ''carol@example.com''),
(4, ''dave'', ''dave@example.com'');
INSERT INTO posts VALUES
(1, 1, ''Hello World'', ''2024-01-01''),
(2, 1, ''Second Post'', ''2024-01-05''),
(3, 3, ''My First Post'', ''2024-01-10'');',
    'SELECT u.id, u.username FROM users u LEFT JOIN posts p ON u.id = p.user_id WHERE p.id IS NULL;',
    'Use LEFT JOIN and filter WHERE the post id IS NULL.',
    false,
    10
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug, title, difficulty, category, description, table_schema, seed_data, solution_sql, hint, order_sensitive, sort_order)
VALUES (
    'salary-above-dept-average',
    'Salary Above Department Average',
    'hard',
    'subquery',
    'Find all employees who earn more than the average salary of their own department. Return `first_name`, `last_name`, `salary`, and `dept_id`.',
    'CREATE TEMP TABLE employees (
    id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    dept_id INT NOT NULL,
    salary NUMERIC(10,2) NOT NULL
);',
    'INSERT INTO employees VALUES
(1, ''Alice'', ''Johnson'', 1, 85000),
(2, ''Bob'', ''Smith'', 1, 72000),
(3, ''Carol'', ''Williams'', 1, 92000),
(4, ''David'', ''Brown'', 2, 68000),
(5, ''Eve'', ''Davis'', 2, 78000),
(6, ''Frank'', ''Miller'', 2, 65000),
(7, ''Grace'', ''Wilson'', 3, 95000),
(8, ''Henry'', ''Moore'', 3, 88000);',
    'SELECT first_name, last_name, salary, dept_id FROM employees e WHERE salary > (SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id);',
    'Use a correlated subquery in the WHERE clause that references the outer query''s dept_id.',
    false,
    11
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug, title, difficulty, category, description, table_schema, seed_data, solution_sql, hint, order_sensitive, sort_order)
VALUES (
    'rank-employees-by-salary',
    'Rank Employees by Salary',
    'hard',
    'window',
    'Write a query to rank employees by their salary within each department. Return `first_name`, `last_name`, `dept_id`, `salary`, and `salary_rank` (1 = highest in dept).',
    'CREATE TEMP TABLE employees (
    id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    dept_id INT NOT NULL,
    salary NUMERIC(10,2) NOT NULL
);',
    'INSERT INTO employees VALUES
(1, ''Alice'', ''Johnson'', 1, 85000),
(2, ''Bob'', ''Smith'', 1, 72000),
(3, ''Carol'', ''Williams'', 1, 92000),
(4, ''David'', ''Brown'', 2, 68000),
(5, ''Eve'', ''Davis'', 2, 78000),
(6, ''Frank'', ''Miller'', 2, 65000);',
    'SELECT first_name, last_name, dept_id, salary, RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS salary_rank FROM employees;',
    'Use RANK() with PARTITION BY dept_id and ORDER BY salary DESC.',
    false,
    12
) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug, title, difficulty, category, description, table_schema, seed_data, solution_sql, hint, order_sensitive, sort_order)
VALUES (
    'top-customers-by-spending',
    'Top Customers by Spending',
    'medium',
    'cte',
    'Use a CTE to find customers who have spent more than $500 total. Return `customer_id` and `total_spent`, ordered by total_spent descending.',
    'CREATE TEMP TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    amount NUMERIC(10,2) NOT NULL
);',
    'INSERT INTO orders VALUES
(1, 1, 250.00),
(2, 1, 320.00),
(3, 2, 180.50),
(4, 3, 600.00),
(5, 2, 95.00),
(6, 3, 450.00),
(7, 4, 120.00);',
    'WITH customer_totals AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM orders
    GROUP BY customer_id
)
SELECT customer_id, total_spent
FROM customer_totals
WHERE total_spent > 500
ORDER BY total_spent DESC;',
    'Create a CTE that groups orders by customer and sums amounts, then filter.',
    true,
    13
) ON CONFLICT (slug) DO NOTHING;

-- ============================================================
-- SEED: SQL Academy Lessons (ported from DevPulse)
-- ============================================================

INSERT INTO sql_lessons (id, module_id, module_title, title, description, content, practice_query, table_schema, seed_data, sort_order)
VALUES
(
    'intro-to-sql',
    'basics',
    '1. The Basics of Data',
    'What is SQL?',
    'Learn what SQL is and why it''s the language of data.',
    'SQL stands for **Structured Query Language**. It is used to communicate with databases. Think of a database like a giant Excel file with many sheets (we call these **Tables**).

In this lesson, you''ll learn your first command: `SELECT`.

`SELECT` is used to pick which columns you want to see.
`FROM` tells the database which table to look into.

**Try it:** Select everything from the `users` table.',
    'SELECT * FROM users;',
    'CREATE TABLE users (id SERIAL PRIMARY KEY, username TEXT, display_name TEXT);',
    'INSERT INTO users (username, display_name) VALUES (''jdoe'', ''John Doe''), (''asmith'', ''Alice Smith'');',
    10
),
(
    'selecting-columns',
    'basics',
    '1. The Basics of Data',
    'Selecting Specific Columns',
    'How to pick only the data you need.',
    'Using `*` gets every column, but usually, we only need a few. To do this, you list the column names separated by commas.

Example: `SELECT name, email FROM users;`

**Try it:** Select only the `username` and `display_name` from the `users` table.',
    'SELECT username, display_name FROM users;',
    'CREATE TABLE users (id SERIAL PRIMARY KEY, username TEXT, display_name TEXT);',
    'INSERT INTO users (username, display_name) VALUES (''jdoe'', ''John Doe''), (''asmith'', ''Alice Smith'');',
    20
),
(
    'where-clause',
    'filtering',
    '2. Filtering Data',
    'The WHERE Clause',
    'Filter rows based on specific conditions.',
    'The `WHERE` clause allows you to filter rows. Only rows that meet the condition will be shown.

Example: `SELECT * FROM products WHERE price > 100;`

**Try it:** Select all products with a price greater than 50.',
    'SELECT * FROM products WHERE price > 50;',
    'CREATE TABLE products (id SERIAL PRIMARY KEY, name TEXT, price DECIMAL);',
    'INSERT INTO products (name, price) VALUES (''Laptop'', 1200), (''Mouse'', 25), (''Keyboard'', 75);',
    30
),
(
    'order-by',
    'filtering',
    '2. Filtering Data',
    'Sorting with ORDER BY',
    'Learn how to sort query results.',
    'The `ORDER BY` clause sorts your results. By default it sorts **ascending** (A to Z, lowest to highest). Use `DESC` for descending order.

Example: `SELECT * FROM products ORDER BY price DESC;`

**Try it:** Select all products ordered by price from highest to lowest.',
    'SELECT * FROM products ORDER BY price DESC;',
    'CREATE TABLE products (id SERIAL PRIMARY KEY, name TEXT, price DECIMAL);',
    'INSERT INTO products (name, price) VALUES (''Laptop'', 1200), (''Mouse'', 25), (''Keyboard'', 75), (''Monitor'', 400);',
    40
),
(
    'aggregate-functions',
    'aggregation',
    '3. Aggregating Data',
    'COUNT, SUM, AVG, MIN, MAX',
    'Learn the most common aggregate functions.',
    'Aggregate functions perform calculations on a set of rows and return a single value:

- `COUNT(*)` — counts all rows
- `SUM(column)` — adds up values
- `AVG(column)` — calculates average
- `MIN(column)` — finds smallest value
- `MAX(column)` — finds largest value

**Try it:** Find the average salary of all employees.',
    'SELECT AVG(salary) AS avg_salary FROM employees;',
    'CREATE TABLE employees (id SERIAL PRIMARY KEY, name TEXT, salary DECIMAL, department TEXT);',
    'INSERT INTO employees (name, salary, department) VALUES (''Alice'', 85000, ''IT''), (''Bob'', 72000, ''HR''), (''Carol'', 92000, ''IT''), (''David'', 68000, ''Finance'');',
    50
),
(
    'group-by',
    'aggregation',
    '3. Aggregating Data',
    'Grouping with GROUP BY',
    'Learn how to group rows and aggregate by category.',
    'The `GROUP BY` clause groups rows that have the same values into summary rows.

Example: `SELECT department, COUNT(*) FROM employees GROUP BY department;`

**Try it:** Count employees in each department.',
    'SELECT department, COUNT(*) AS employee_count FROM employees GROUP BY department;',
    'CREATE TABLE employees (id SERIAL PRIMARY KEY, name TEXT, salary DECIMAL, department TEXT);',
    'INSERT INTO employees (name, salary, department) VALUES (''Alice'', 85000, ''IT''), (''Bob'', 72000, ''HR''), (''Carol'', 92000, ''IT''), (''David'', 68000, ''Finance''), (''Eve'', 78000, ''IT'');',
    60
),
(
    'inner-join',
    'joins',
    '4. Joining Tables',
    'INNER JOIN',
    'Learn how to combine data from multiple tables.',
    'A JOIN combines rows from two or more tables based on a related column.

**INNER JOIN** returns only rows where there is a match in BOTH tables.

```sql
SELECT columns
FROM table1
INNER JOIN table2 ON table1.id = table2.foreign_id;
```

**Try it:** Get employee names with their department names.',
    'SELECT e.name, d.dept_name FROM employees e INNER JOIN departments d ON e.dept_id = d.id;',
    'CREATE TABLE departments (id SERIAL PRIMARY KEY, dept_name TEXT);
CREATE TABLE employees (id SERIAL PRIMARY KEY, name TEXT, dept_id INT REFERENCES departments(id));',
    'INSERT INTO departments (dept_name) VALUES (''IT''), (''HR''), (''Finance'');
INSERT INTO employees (name, dept_id) VALUES (''Alice'', 1), (''Bob'', 2), (''Carol'', 1), (''David'', 3);',
    70
),
(
    'left-join',
    'joins',
    '4. Joining Tables',
    'LEFT JOIN',
    'Return all rows from the left table, even without matches.',
    'A **LEFT JOIN** returns all rows from the left table, and the matching rows from the right table. If there is no match, NULLs are returned for the right side.

This is useful for finding records that don''t have related records (e.g., customers with no orders).

**Try it:** Get all departments and their employees (including departments with no employees).',
    'SELECT d.dept_name, e.name FROM departments d LEFT JOIN employees e ON d.id = e.dept_id;',
    'CREATE TABLE departments (id SERIAL PRIMARY KEY, dept_name TEXT);
CREATE TABLE employees (id SERIAL PRIMARY KEY, name TEXT, dept_id INT);',
    'INSERT INTO departments (dept_name) VALUES (''IT''), (''HR''), (''Finance''), (''Marketing'');
INSERT INTO employees (name, dept_id) VALUES (''Alice'', 1), (''Bob'', 2), (''Carol'', 1);',
    80
),
(
    'subqueries',
    'subqueries',
    '5. Subqueries',
    'Using Subqueries',
    'Nest one query inside another.',
    'A **subquery** is a query nested inside another query. It can be used in WHERE, FROM, or SELECT clauses.

Example — find employees who earn above average:
```sql
SELECT name FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

**Try it:** Find products that cost more than the average price.',
    'SELECT name, price FROM products WHERE price > (SELECT AVG(price) FROM products);',
    'CREATE TABLE products (id SERIAL PRIMARY KEY, name TEXT, price DECIMAL);',
    'INSERT INTO products (name, price) VALUES (''Laptop'', 1200), (''Mouse'', 25), (''Keyboard'', 75), (''Monitor'', 400), (''Webcam'', 120);',
    90
),
(
    'window-functions',
    'window',
    '6. Window Functions',
    'ROW_NUMBER, RANK, DENSE_RANK',
    'Rank and number rows without collapsing them.',
    'Window functions compute a value for each row based on a related set of rows, without collapsing results like GROUP BY.

Common window functions:
- `ROW_NUMBER()` — sequential number per partition
- `RANK()` — rank with gaps (1, 1, 3)
- `DENSE_RANK()` — rank without gaps (1, 1, 2)

```sql
SELECT name, salary,
    RANK() OVER (ORDER BY salary DESC) AS rank
FROM employees;
```

**Try it:** Rank employees by salary.',
    'SELECT name, salary, RANK() OVER (ORDER BY salary DESC) AS salary_rank FROM employees;',
    'CREATE TABLE employees (id SERIAL PRIMARY KEY, name TEXT, salary DECIMAL);',
    'INSERT INTO employees (name, salary) VALUES (''Alice'', 85000), (''Bob'', 72000), (''Carol'', 92000), (''David'', 72000), (''Eve'', 78000);',
    100
)
ON CONFLICT (id) DO NOTHING;
