-- ============================================================
-- 0009_challenges_extended.sql
-- Challenges 14–60 (47 challenges)
-- Topics: SELECT basics, String, NULL, DateTime,
--         CASE WHEN, Set Operations, Filtering advanced
-- ============================================================

-- Extend category CHECK constraint
ALTER TABLE sql_challenges DROP CONSTRAINT IF EXISTS sql_challenges_category_check;
ALTER TABLE sql_challenges ADD CONSTRAINT sql_challenges_category_check
  CHECK (category IN (
    'select','filtering','joins','aggregate','subquery','window','cte','analytics',
    'string','datetime','nulls','case','set_ops'
  ));

-- ══════════════════════════════════════════════════════════
-- GROUP 1: SELECT & Basics  (sort 14–20)
-- ══════════════════════════════════════════════════════════

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'count-all-employees','Count All Employees','easy','select',
  'Write a query to count the total number of employees in the `employees` table. Return a single value named `total`.',
  'เขียน query เพื่อนับจำนวนพนักงานทั้งหมดในตาราง `employees` โดยคืนค่าเดียวชื่อ `total`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  department_id INT, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',1,85000),(2,''Bob'',''Smith'',1,72000),
(3,''Carol'',''Williams'',2,92000),(4,''David'',''Brown'',2,68000),
(5,''Eve'',''Davis'',3,78000),(6,''Frank'',''Miller'',3,65000);',
  'SELECT COUNT(*) AS total FROM employees;',
  'COUNT(*) counts every row, including rows with NULL values.',
  'COUNT(*) นับทุกแถว รวมถึงแถวที่มีค่า NULL ด้วย',
  false,14) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'min-max-salary','Min and Max Salary','easy','select',
  'Find the lowest and highest salary in the `employees` table. Return two columns: `min_salary` and `max_salary`.',
  'หาเงินเดือนต่ำสุดและสูงสุดในตาราง `employees` โดยคืนค่าสองคอลัมน์ชื่อ `min_salary` และ `max_salary`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',85000),(2,''Bob'',72000),(3,''Carol'',92000),
(4,''David'',68000),(5,''Eve'',78000),(6,''Frank'',65000),(7,''Grace'',95000);',
  'SELECT MIN(salary) AS min_salary, MAX(salary) AS max_salary FROM employees;',
  'Use MIN() and MAX() aggregate functions in the same SELECT.',
  'ใช้ MIN() และ MAX() ใน SELECT เดียวกันได้เลย',
  false,15) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'salary-statistics','Salary Statistics','easy','select',
  'Calculate employee count, total salary, average salary, min salary, and max salary in one query. Return columns: `total_employees`, `total_salary`, `avg_salary`, `min_salary`, `max_salary`. Round `avg_salary` to 2 decimal places.',
  'คำนวณจำนวนพนักงาน เงินเดือนรวม ค่าเฉลี่ย ต่ำสุด สูงสุด ในคำสั่งเดียว คืนค่า: `total_employees`, `total_salary`, `avg_salary`, `min_salary`, `max_salary` โดยปัดทศนิยม avg ให้ 2 ตำแหน่ง',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',85000),(2,''Bob'',72000),(3,''Carol'',92000),
(4,''David'',68000),(5,''Eve'',78000),(6,''Frank'',65000);',
  'SELECT COUNT(*) AS total_employees, SUM(salary) AS total_salary,
  ROUND(AVG(salary),2) AS avg_salary, MIN(salary) AS min_salary, MAX(salary) AS max_salary
FROM employees;',
  'You can mix COUNT, SUM, AVG, MIN, MAX in a single SELECT statement.',
  'ใช้ COUNT, SUM, AVG, MIN, MAX ผสมกันใน SELECT เดียวได้เลย',
  false,16) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'employee-annual-salary','Employee Annual Salary','easy','select',
  'Write a query to show each employee''s `first_name`, `last_name`, monthly `salary`, and their annual salary (salary × 12). Name the computed column `annual_salary`.',
  'เขียน query แสดง `first_name`, `last_name`, เงินเดือนรายเดือน `salary` และเงินเดือนรายปี (salary × 12) โดยตั้งชื่อคอลัมน์คำนวณว่า `annual_salary`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',85000),(2,''Bob'',''Smith'',72000),
(3,''Carol'',''Williams'',92000),(4,''David'',''Brown'',68000),(5,''Eve'',''Davis'',78000);',
  'SELECT first_name, last_name, salary, salary * 12 AS annual_salary FROM employees;',
  'Multiply salary by 12 and use AS to name the computed column.',
  'คูณ salary ด้วย 12 แล้วใช้ AS เพื่อตั้งชื่อคอลัมน์',
  false,17) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'column-alias','Column Aliases','easy','select',
  'Write a query returning all employees with columns renamed: `first_name` → `first`, `last_name` → `last`, `salary` → `monthly_pay`.',
  'เขียน query คืนค่าพนักงานทุกคนพร้อมเปลี่ยนชื่อคอลัมน์: `first_name` → `first`, `last_name` → `last`, `salary` → `monthly_pay`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',85000),(2,''Bob'',''Smith'',72000),
(3,''Carol'',''Williams'',92000),(4,''David'',''Brown'',68000);',
  'SELECT first_name AS first, last_name AS last, salary AS monthly_pay FROM employees;',
  'Use the AS keyword after each column name to assign an alias.',
  'ใช้ AS หลังชื่อคอลัมน์เพื่อตั้งชื่อใหม่ (alias)',
  false,18) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'paginate-employees','Paginate Employees','easy','select',
  'Retrieve the 3rd and 4th employees when sorted by `id`. Return all columns. (Page 2, page size 2)',
  'ดึงพนักงานอันดับที่ 3 และ 4 เมื่อเรียงตาม `id` คืนค่าทุกคอลัมน์ (หน้า 2, ขนาดหน้า 2)',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',85000),(2,''Bob'',''Smith'',72000),
(3,''Carol'',''Williams'',92000),(4,''David'',''Brown'',68000),
(5,''Eve'',''Davis'',78000);',
  'SELECT * FROM employees ORDER BY id LIMIT 2 OFFSET 2;',
  'LIMIT sets how many rows to return. OFFSET skips that many rows first.',
  'LIMIT กำหนดจำนวนแถว, OFFSET ข้ามแถวไปก่อนตามจำนวนที่กำหนด',
  false,19) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'sort-multiple-columns','Sort by Multiple Columns','easy','select',
  'Return all employees sorted by `department_id` ascending, then by `salary` descending within each department. Return all columns.',
  'คืนค่าพนักงานทุกคนเรียงตาม `department_id` จากน้อยไปมาก จากนั้นเรียงตาม `salary` จากมากไปน้อยภายในแต่ละแผนก คืนค่าทุกคอลัมน์',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, department_id INT NOT NULL,
  salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',1,85000),(2,''Bob'',1,72000),(3,''Carol'',2,92000),
(4,''David'',2,68000),(5,''Eve'',3,78000),(6,''Frank'',3,65000),(7,''Grace'',2,88000);',
  'SELECT * FROM employees ORDER BY department_id ASC, salary DESC;',
  'Separate multiple sort columns with commas in ORDER BY.',
  'คั่นคอลัมน์เรียงลำดับด้วยเครื่องหมายจุลภาคใน ORDER BY',
  true,20) ON CONFLICT (slug) DO NOTHING;

-- ══════════════════════════════════════════════════════════
-- GROUP 2: String Functions  (sort 21–28)
-- ══════════════════════════════════════════════════════════

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'search-by-name','Search by Name (LIKE)','easy','string',
  'Find all employees whose `first_name` contains the letter ''a'' (case-sensitive). Return all columns.',
  'ค้นหาพนักงานที่มีตัวอักษร ''a'' ปรากฏอยู่ใน `first_name` (แยกตัวพิมพ์ใหญ่-เล็ก) คืนค่าทุกคอลัมน์',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',85000),(2,''Bob'',''Smith'',72000),
(3,''Carol'',''Williams'',92000),(4,''David'',''Brown'',68000),
(5,''Grace'',''Wilson'',95000),(6,''Frank'',''Miller'',65000);',
  'SELECT * FROM employees WHERE first_name LIKE ''%a%'';',
  'Use LIKE with % as a wildcard: % matches any sequence of characters.',
  'ใช้ LIKE กับ % เป็น wildcard: % แทนอักขระใดก็ได้ กี่ตัวก็ได้',
  false,21) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'case-insensitive-search','Case-Insensitive Search','easy','string',
  'Find all employees whose `first_name` is ''alice'' (case-insensitive). Return all columns.',
  'ค้นหาพนักงานที่ชื่อ `first_name` คือ ''alice'' โดยไม่แยกตัวพิมพ์ใหญ่-เล็ก คืนค่าทุกคอลัมน์',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',85000),(2,''ALICE'',''Smith'',72000),
(3,''Carol'',''Williams'',92000),(4,''alice'',''Brown'',68000);',
  'SELECT * FROM employees WHERE LOWER(first_name) = ''alice'';',
  'Use LOWER() to convert the column to lowercase before comparing.',
  'ใช้ LOWER() แปลงคอลัมน์เป็นตัวพิมพ์เล็กก่อนเปรียบเทียบ',
  false,22) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'full-name-concat','Full Name Concatenation','easy','string',
  'Write a query displaying each employee''s full name as a single column named `full_name` (format: "FirstName LastName"), along with their `salary`.',
  'เขียน query แสดงชื่อเต็มของพนักงานในคอลัมน์เดียวชื่อ `full_name` (รูปแบบ: "ชื่อ นามสกุล") พร้อม `salary`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',85000),(2,''Bob'',''Smith'',72000),
(3,''Carol'',''Williams'',92000),(4,''David'',''Brown'',68000);',
  'SELECT first_name || '' '' || last_name AS full_name, salary FROM employees;',
  'Use the || operator to concatenate strings, or use CONCAT(a, '' '', b).',
  'ใช้ตัวดำเนินการ || เพื่อต่อสตริง หรือใช้ CONCAT(a, '' '', b)',
  false,23) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'extract-email-domain','Extract Email Domain','easy','string',
  'Extract the domain part of each employee''s email (everything after ''@''). Return `first_name`, `last_name`, and a column `email_domain`.',
  'ดึงส่วน domain ของ email พนักงาน (ทุกอย่างหลัง ''@'') คืนค่า `first_name`, `last_name` และคอลัมน์ `email_domain`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  email TEXT NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',''alice@corp.com''),
(2,''Bob'',''Smith'',''bob@startup.io''),
(3,''Carol'',''Williams'',''carol@corp.com''),
(4,''David'',''Brown'',''david@freelance.net'');',
  'SELECT first_name, last_name, SPLIT_PART(email, ''@'', 2) AS email_domain FROM employees;',
  'SPLIT_PART(string, delimiter, n) returns the n-th part after splitting by the delimiter.',
  'SPLIT_PART(string, delimiter, n) คืนค่าส่วนที่ n หลังการแบ่งด้วย delimiter',
  false,24) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'name-length','Name Length','easy','string',
  'Return each employee''s `first_name` and the character count of their first name as `name_length`. Order by `name_length` descending.',
  'คืนค่า `first_name` ของพนักงานและจำนวนอักขระในชื่อเป็น `name_length` เรียงตาม `name_length` จากมากไปน้อย',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson''),(2,''Bob'',''Smith''),
(3,''Christopher'',''Williams''),(4,''Jo'',''Brown''),(5,''Eve'',''Davis'');',
  'SELECT first_name, LENGTH(first_name) AS name_length FROM employees ORDER BY name_length DESC;',
  'LENGTH(string) returns the number of characters in a string.',
  'LENGTH(string) คืนค่าจำนวนอักขระในสตริง',
  true,25) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'uppercase-names','Uppercase Names','easy','string',
  'Return all employees with `first_name` and `last_name` converted to uppercase. Name the columns `first_upper` and `last_upper`.',
  'คืนค่าพนักงานทุกคนโดยแปลง `first_name` และ `last_name` เป็นตัวพิมพ์ใหญ่ทั้งหมด ตั้งชื่อคอลัมน์ว่า `first_upper` และ `last_upper`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson''),(2,''Bob'',''Smith''),
(3,''Carol'',''Williams''),(4,''David'',''Brown'');',
  'SELECT UPPER(first_name) AS first_upper, UPPER(last_name) AS last_upper FROM employees;',
  'Use UPPER() to convert text to uppercase. LOWER() does the opposite.',
  'ใช้ UPPER() แปลงเป็นตัวพิมพ์ใหญ่ และ LOWER() แปลงเป็นตัวพิมพ์เล็ก',
  false,26) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'names-starting-with-letter','Names Starting with Letter','easy','string',
  'Find all employees whose `last_name` starts with the letter ''S''. Return `first_name` and `last_name`.',
  'ค้นหาพนักงานที่ `last_name` ขึ้นต้นด้วยตัวอักษร ''S'' คืนค่า `first_name` และ `last_name`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson''),(2,''Bob'',''Smith''),(3,''Carol'',''Stewart''),
(4,''David'',''Brown''),(5,''Eve'',''Spencer''),(6,''Frank'',''Miller'');',
  'SELECT first_name, last_name FROM employees WHERE last_name LIKE ''S%'';',
  'LIKE ''S%'' matches any string that starts with S.',
  'LIKE ''S%'' จับคู่กับสตริงที่ขึ้นต้นด้วย S',
  false,27) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'email-domain-filter','Filter by Email Domain','easy','string',
  'Find all employees who use a ''corp.com'' email address. Return `first_name`, `last_name`, and `email`.',
  'ค้นหาพนักงานที่ใช้ email โดเมน ''corp.com'' คืนค่า `first_name`, `last_name` และ `email`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  email TEXT NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',''alice@corp.com''),
(2,''Bob'',''Smith'',''bob@gmail.com''),
(3,''Carol'',''Williams'',''carol@corp.com''),
(4,''David'',''Brown'',''david@startup.io''),
(5,''Eve'',''Davis'',''eve@corp.com'');',
  'SELECT first_name, last_name, email FROM employees WHERE email LIKE ''%@corp.com'';',
  'Use % before the domain to match any email local part.',
  'ใช้ % ก่อน domain เพื่อจับคู่กับส่วน local ของ email ใดก็ได้',
  false,28) ON CONFLICT (slug) DO NOTHING;

-- ══════════════════════════════════════════════════════════
-- GROUP 3: NULL Handling  (sort 29–33)
-- ══════════════════════════════════════════════════════════

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'employees-without-manager','Employees Without Manager','easy','nulls',
  'Find all employees who do not have a manager (i.e., `manager_id` is NULL). Return `first_name` and `last_name`.',
  'ค้นหาพนักงานที่ไม่มีผู้จัดการ (กล่าวคือ `manager_id` เป็น NULL) คืนค่า `first_name` และ `last_name`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  manager_id INT);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',NULL),(2,''Bob'',''Smith'',1),
(3,''Carol'',''Williams'',NULL),(4,''David'',''Brown'',3),
(5,''Eve'',''Davis'',NULL),(6,''Frank'',''Miller'',3);',
  'SELECT first_name, last_name FROM employees WHERE manager_id IS NULL;',
  'Use IS NULL to find rows where a column has no value. Never use = NULL.',
  'ใช้ IS NULL เพื่อหาแถวที่คอลัมน์ไม่มีค่า ห้ามใช้ = NULL',
  false,29) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'employees-with-department','Employees With Department','easy','nulls',
  'Find all employees who have been assigned to a department (`department_id` is not NULL). Return all columns.',
  'ค้นหาพนักงานทุกคนที่มีแผนกที่ถูกกำหนด (`department_id` ไม่เป็น NULL) คืนค่าทุกคอลัมน์',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  department_id INT, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',1,85000),(2,''Bob'',''Smith'',NULL,72000),
(3,''Carol'',''Williams'',2,92000),(4,''David'',''Brown'',NULL,68000),
(5,''Eve'',''Davis'',3,78000);',
  'SELECT * FROM employees WHERE department_id IS NOT NULL;',
  'IS NOT NULL filters out rows where the column has no value.',
  'IS NOT NULL กรองแถวที่คอลัมน์มีค่า NULL ออก',
  false,30) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'coalesce-manager-display','COALESCE Default Value','easy','nulls',
  'Write a query returning each employee''s `first_name` and their `manager_id`. If `manager_id` is NULL, display 0 instead. Name the output column `manager_id`.',
  'เขียน query คืนค่า `first_name` และ `manager_id` ของพนักงาน ถ้า `manager_id` เป็น NULL ให้แสดง 0 แทน ตั้งชื่อคอลัมน์ผลลัพธ์ว่า `manager_id`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, manager_id INT);',
  'INSERT INTO employees VALUES
(1,''Alice'',NULL),(2,''Bob'',1),(3,''Carol'',NULL),
(4,''David'',3),(5,''Eve'',NULL);',
  'SELECT first_name, COALESCE(manager_id, 0) AS manager_id FROM employees;',
  'COALESCE(value, fallback) returns the first non-NULL argument.',
  'COALESCE(value, fallback) คืนค่า argument แรกที่ไม่ใช่ NULL',
  false,31) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'count-with-vs-without-null','COUNT(*) vs COUNT(column)','easy','nulls',
  'Write a query showing the total row count (`total_rows`) and the number of employees who have a manager (`with_manager`). This demonstrates the difference between COUNT(*) and COUNT(column).',
  'เขียน query แสดงจำนวนแถวทั้งหมด (`total_rows`) และจำนวนพนักงานที่มีผู้จัดการ (`with_manager`) เพื่อแสดงความต่างระหว่าง COUNT(*) และ COUNT(column)',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, manager_id INT);',
  'INSERT INTO employees VALUES
(1,''Alice'',NULL),(2,''Bob'',1),(3,''Carol'',NULL),
(4,''David'',1),(5,''Eve'',3),(6,''Frank'',NULL);',
  'SELECT COUNT(*) AS total_rows, COUNT(manager_id) AS with_manager FROM employees;',
  'COUNT(*) counts all rows; COUNT(column) skips NULL values in that column.',
  'COUNT(*) นับทุกแถว ส่วน COUNT(column) ข้ามค่า NULL ในคอลัมน์นั้น',
  false,32) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'nullif-zero-division','Avoid Division by Zero with NULLIF','medium','nulls',
  'The `scores` table has `name`, `total` (points earned), and `attempts` columns. Calculate the success rate (`total / attempts`) for each person. If `attempts` is 0, return NULL for `success_rate` instead of an error. Return `name`, `total`, `attempts`, and `success_rate` rounded to 2 decimal places.',
  'ตาราง `scores` มีคอลัมน์ `name`, `total` (คะแนนที่ได้) และ `attempts` คำนวณ success rate (`total / attempts`) สำหรับแต่ละคน ถ้า `attempts` = 0 คืนค่า NULL แทนการเกิด error คืนค่า `name`, `total`, `attempts` และ `success_rate` ปัดทศนิยม 2 ตำแหน่ง',
  'CREATE TEMP TABLE scores (
  name TEXT NOT NULL, total INT NOT NULL, attempts INT NOT NULL);',
  'INSERT INTO scores VALUES
(''Alice'',45,9),(''Bob'',0,0),(''Carol'',30,5),(''David'',20,4),(''Eve'',0,0),(''Frank'',50,10);',
  'SELECT name, total, attempts, ROUND(total::NUMERIC / NULLIF(attempts, 0), 2) AS success_rate FROM scores;',
  'NULLIF(x, y) returns NULL when x equals y, preventing division-by-zero errors.',
  'NULLIF(x, y) คืนค่า NULL เมื่อ x เท่ากับ y เพื่อป้องกัน error หารด้วยศูนย์',
  false,33) ON CONFLICT (slug) DO NOTHING;

-- ══════════════════════════════════════════════════════════
-- GROUP 4: Date & Time  (sort 34–43)
-- ══════════════════════════════════════════════════════════

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'hired-in-2022','Hired in 2022','easy','datetime',
  'Find all employees who were hired in the year 2022. Return `first_name`, `last_name`, and `hire_date`.',
  'ค้นหาพนักงานทุกคนที่ถูกจ้างในปี 2022 คืนค่า `first_name`, `last_name` และ `hire_date`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  hire_date DATE NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',''2020-03-15''),(2,''Bob'',''Smith'',''2022-06-01''),
(3,''Carol'',''Williams'',''2019-01-10''),(4,''David'',''Brown'',''2022-02-20''),
(5,''Eve'',''Davis'',''2021-09-05''),(6,''Frank'',''Miller'',''2022-11-30'');',
  'SELECT first_name, last_name, hire_date FROM employees WHERE EXTRACT(YEAR FROM hire_date) = 2022;',
  'EXTRACT(YEAR FROM date) returns the year as a number.',
  'EXTRACT(YEAR FROM date) คืนค่าปีเป็นตัวเลข',
  false,34) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'years-of-service','Years of Service','medium','datetime',
  'Calculate how many complete years each employee has worked as of ''2025-01-01''. Return `first_name`, `last_name`, and `years_of_service`. Order by `years_of_service` descending.',
  'คำนวณจำนวนปีเต็มที่พนักงานแต่ละคนทำงาน ณ วันที่ ''2025-01-01'' คืนค่า `first_name`, `last_name` และ `years_of_service` เรียงจากมากไปน้อย',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  hire_date DATE NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',''2020-03-15''),(2,''Bob'',''Smith'',''2021-06-01''),
(3,''Carol'',''Williams'',''2019-01-10''),(4,''David'',''Brown'',''2022-02-20''),
(5,''Eve'',''Davis'',''2021-09-05''),(6,''Frank'',''Miller'',''2023-01-15''),
(7,''Grace'',''Wilson'',''2018-07-22'');',
  'SELECT first_name, last_name,
  DATE_PART(''year'', AGE(''2025-01-01''::DATE, hire_date))::INT AS years_of_service
FROM employees
ORDER BY years_of_service DESC;',
  'AGE(end, start) returns an interval. Wrap it with DATE_PART(''year'', ...) to get years.',
  'AGE(end, start) คืนค่า interval จากนั้นใช้ DATE_PART(''year'', ...) เพื่อดึงจำนวนปี',
  true,35) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'hired-in-q4-2023','Hired in Q4 2023','easy','datetime',
  'Find employees hired in the last quarter of 2023 (October through December). Return `first_name`, `last_name`, and `hire_date`.',
  'ค้นหาพนักงานที่ถูกจ้างในไตรมาสสุดท้ายของปี 2023 (ตุลาคม-ธันวาคม) คืนค่า `first_name`, `last_name` และ `hire_date`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  hire_date DATE NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',''2023-01-15''),(2,''Bob'',''Smith'',''2023-10-01''),
(3,''Carol'',''Williams'',''2022-11-20''),(4,''David'',''Brown'',''2023-11-15''),
(5,''Eve'',''Davis'',''2023-12-01''),(6,''Frank'',''Miller'',''2024-01-05'');',
  'SELECT first_name, last_name, hire_date FROM employees
WHERE hire_date BETWEEN ''2023-10-01'' AND ''2023-12-31'';',
  'BETWEEN x AND y is inclusive on both ends and works great for date ranges.',
  'BETWEEN x AND y รวมขอบทั้งสองด้าน เหมาะสำหรับกรองช่วงวันที่',
  false,36) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'monthly-order-revenue','Monthly Order Revenue','medium','datetime',
  'Group all orders by month and calculate total revenue per month. Return `order_month` (DATE, truncated to first of month) and `total_revenue`, ordered by `order_month`.',
  'จัดกลุ่มคำสั่งซื้อตามเดือนและคำนวณรายรับรวมต่อเดือน คืนค่า `order_month` (DATE ตัดไปเป็นวันที่ 1 ของเดือน) และ `total_revenue` เรียงตาม `order_month`',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, customer_id INT NOT NULL,
  amount NUMERIC(10,2) NOT NULL, order_date DATE NOT NULL);',
  'INSERT INTO orders VALUES
(1,1,250.00,''2024-01-10''),(2,2,320.00,''2024-01-22''),
(3,3,180.50,''2024-02-05''),(4,1,450.00,''2024-02-18''),
(5,2,95.00,''2024-03-07''),(6,4,600.00,''2024-03-14''),
(7,3,120.00,''2024-03-25''),(8,1,380.00,''2024-04-10'');',
  'SELECT DATE_TRUNC(''month'', order_date)::DATE AS order_month,
  SUM(amount) AS total_revenue
FROM orders
GROUP BY order_month
ORDER BY order_month;',
  'DATE_TRUNC(''month'', date) sets the date to the 1st of the month.',
  'DATE_TRUNC(''month'', date) ตัดวันที่ให้เหลือแค่วันที่ 1 ของเดือน',
  true,37) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'orders-by-weekday','Orders by Day of Week','medium','datetime',
  'Count how many orders were placed on each day of the week. Return `day_of_week` (integer: 0=Sunday, 6=Saturday) and `order_count`. Order by `day_of_week`.',
  'นับจำนวนคำสั่งซื้อในแต่ละวันของสัปดาห์ คืนค่า `day_of_week` (integer: 0=อาทิตย์, 6=เสาร์) และ `order_count` เรียงตาม `day_of_week`',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, customer_id INT NOT NULL,
  amount NUMERIC(10,2) NOT NULL, order_date DATE NOT NULL);',
  'INSERT INTO orders VALUES
(1,1,100,''2024-01-01''),(2,2,200,''2024-01-02''),(3,3,150,''2024-01-03''),
(4,1,300,''2024-01-08''),(5,2,250,''2024-01-09''),(6,4,180,''2024-01-10''),
(7,3,400,''2024-01-15''),(8,1,120,''2024-01-16''),(9,2,90,''2024-01-17''),
(10,4,220,''2024-01-22'');',
  'SELECT EXTRACT(DOW FROM order_date)::INT AS day_of_week, COUNT(*) AS order_count
FROM orders
GROUP BY day_of_week
ORDER BY day_of_week;',
  'EXTRACT(DOW FROM date) returns 0 for Sunday through 6 for Saturday.',
  'EXTRACT(DOW FROM date) คืนค่า 0 สำหรับวันอาทิตย์ถึง 6 สำหรับวันเสาร์',
  true,38) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'format-hire-date','Format Hire Date','easy','datetime',
  'Display each employee''s `first_name` and their `hire_date` formatted as ''DD Mon YYYY'' (e.g. ''15 Mar 2020''). Name the formatted column `hire_date_formatted`.',
  'แสดง `first_name` ของพนักงานและ `hire_date` ในรูปแบบ ''DD Mon YYYY'' (เช่น ''15 Mar 2020'') ตั้งชื่อคอลัมน์ที่แปลงแล้วว่า `hire_date_formatted`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, hire_date DATE NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''2020-03-15''),(2,''Bob'',''2021-06-01''),
(3,''Carol'',''2019-01-10''),(4,''David'',''2022-11-30'');',
  'SELECT first_name, TO_CHAR(hire_date, ''DD Mon YYYY'') AS hire_date_formatted FROM employees;',
  'TO_CHAR(date, format) converts a date to text. Common patterns: DD=day, Mon=short month, YYYY=4-digit year.',
  'TO_CHAR(date, format) แปลงวันที่เป็นข้อความ รูปแบบทั่วไป: DD=วัน, Mon=ชื่อเดือนย่อ, YYYY=ปี 4 หลัก',
  false,39) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'q4-orders-filter','Filter Q4 Orders','easy','datetime',
  'Find all orders placed in Q4 (October, November, or December) of any year. Return `id`, `customer_id`, `amount`, and `order_date`.',
  'ค้นหาคำสั่งซื้อทั้งหมดที่สั่งในไตรมาส 4 (ตุลาคม พฤศจิกายน หรือธันวาคม) ของปีใดก็ได้ คืนค่า `id`, `customer_id`, `amount` และ `order_date`',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, customer_id INT NOT NULL,
  amount NUMERIC(10,2) NOT NULL, order_date DATE NOT NULL);',
  'INSERT INTO orders VALUES
(1,1,250,''2024-01-15''),(2,2,180,''2024-03-22''),(3,3,420,''2024-10-05''),
(4,1,310,''2024-11-18''),(5,2,95,''2023-12-01''),(6,4,500,''2024-07-14''),
(7,3,275,''2023-10-30'');',
  'SELECT id, customer_id, amount, order_date FROM orders
WHERE EXTRACT(QUARTER FROM order_date) = 4;',
  'EXTRACT(QUARTER FROM date) returns 1, 2, 3, or 4 depending on the quarter.',
  'EXTRACT(QUARTER FROM date) คืนค่า 1, 2, 3 หรือ 4 ตามไตรมาส',
  false,40) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'days-since-order','Days Since Order','easy','datetime',
  'Calculate how many days have passed since each order was placed, as of ''2025-01-01''. Return `id`, `order_date`, and `days_ago`. Order by `days_ago` ascending.',
  'คำนวณจำนวนวันที่ผ่านมาตั้งแต่วันที่สั่ง ณ วันที่ ''2025-01-01'' คืนค่า `id`, `order_date` และ `days_ago` เรียงตาม `days_ago` จากน้อยไปมาก',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, customer_id INT NOT NULL,
  amount NUMERIC(10,2) NOT NULL, order_date DATE NOT NULL);',
  'INSERT INTO orders VALUES
(1,1,250,''2024-12-15''),(2,2,180,''2024-11-01''),(3,3,420,''2024-10-05''),
(4,1,310,''2024-09-18''),(5,2,95,''2024-08-01'');',
  'SELECT id, order_date, (''2025-01-01''::DATE - order_date)::INT AS days_ago
FROM orders ORDER BY days_ago ASC;',
  'Subtracting one DATE from another returns the number of days between them.',
  'การลบวันที่สองวันจะได้จำนวนวันระหว่างกัน',
  true,41) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'employees-hired-by-year','Employees Hired by Year','easy','datetime',
  'Count how many employees were hired each year. Return `hire_year` and `employee_count`, ordered by `hire_year` ascending.',
  'นับจำนวนพนักงานที่ถูกจ้างในแต่ละปี คืนค่า `hire_year` และ `employee_count` เรียงตาม `hire_year` จากน้อยไปมาก',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, hire_date DATE NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''2020-03-15''),(2,''Bob'',''2021-06-01''),
(3,''Carol'',''2019-01-10''),(4,''David'',''2022-02-20''),
(5,''Eve'',''2021-09-05''),(6,''Frank'',''2022-01-15''),
(7,''Grace'',''2019-07-22''),(8,''Henry'',''2020-11-30'');',
  'SELECT EXTRACT(YEAR FROM hire_date)::INT AS hire_year, COUNT(*) AS employee_count
FROM employees
GROUP BY hire_year
ORDER BY hire_year;',
  'Use EXTRACT(YEAR FROM hire_date) then GROUP BY the result.',
  'ใช้ EXTRACT(YEAR FROM hire_date) แล้ว GROUP BY ผลลัพธ์',
  true,42) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'monthly-revenue-2024','Monthly Revenue in 2024','medium','datetime',
  'Show total revenue for each month in 2024 only. Return `order_month` and `total_revenue`, ordered by `order_month`.',
  'แสดงรายรับรวมในแต่ละเดือนของปี 2024 เท่านั้น คืนค่า `order_month` และ `total_revenue` เรียงตาม `order_month`',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, amount NUMERIC(10,2) NOT NULL, order_date DATE NOT NULL);',
  'INSERT INTO orders VALUES
(1,250,''2023-12-15''),(2,320,''2024-01-10''),(3,180,''2024-01-22''),
(4,450,''2024-02-05''),(5,95,''2024-02-18''),(6,600,''2024-03-07''),
(7,120,''2024-03-25''),(8,380,''2025-01-10'');',
  'SELECT DATE_TRUNC(''month'', order_date)::DATE AS order_month,
  SUM(amount) AS total_revenue
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2024
GROUP BY order_month
ORDER BY order_month;',
  'Filter by year first with WHERE, then group by truncated month.',
  'กรองปีด้วย WHERE ก่อน แล้วจึง GROUP BY เดือนที่ตัดแล้ว',
  true,43) ON CONFLICT (slug) DO NOTHING;

-- ══════════════════════════════════════════════════════════
-- GROUP 5: CASE WHEN  (sort 44–49)
-- ══════════════════════════════════════════════════════════

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'salary-grade','Salary Grade Classification','easy','case',
  'Classify each employee by salary grade: ''Junior'' (salary < 70000), ''Mid'' (70000–89999), ''Senior'' (>= 90000). Return `first_name`, `last_name`, `salary`, and `grade`.',
  'แบ่งระดับพนักงานตามเงินเดือน: ''Junior'' (น้อยกว่า 70000), ''Mid'' (70000–89999), ''Senior'' (>= 90000) คืนค่า `first_name`, `last_name`, `salary` และ `grade`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',85000),(2,''Bob'',''Smith'',72000),(3,''Carol'',''Williams'',92000),
(4,''David'',''Brown'',65000),(5,''Eve'',''Davis'',78000),(6,''Grace'',''Wilson'',95000);',
  'SELECT first_name, last_name, salary,
  CASE
    WHEN salary < 70000 THEN ''Junior''
    WHEN salary < 90000 THEN ''Mid''
    ELSE ''Senior''
  END AS grade
FROM employees;',
  'CASE evaluates conditions top-to-bottom and returns the first matching result.',
  'CASE ประเมินเงื่อนไขจากบนลงล่างและคืนค่าผลลัพธ์ของเงื่อนไขแรกที่ตรง',
  false,44) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'order-status-label','Order Status Label','easy','case',
  'Display each order with a readable status label: ''completed'' → ''Done'', ''pending'' → ''In Progress'', ''cancelled'' → ''Cancelled''. Return `id`, `amount`, and `status_label`.',
  'แสดงคำสั่งซื้อแต่ละรายการพร้อมป้ายสถานะที่อ่านง่าย: ''completed'' → ''Done'', ''pending'' → ''In Progress'', ''cancelled'' → ''Cancelled'' คืนค่า `id`, `amount` และ `status_label`',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, amount NUMERIC(10,2) NOT NULL, status TEXT NOT NULL);',
  'INSERT INTO orders VALUES
(1,250,''completed''),(2,180,''pending''),(3,420,''completed''),
(4,95,''cancelled''),(5,600,''pending''),(6,120,''completed'');',
  'SELECT id, amount,
  CASE status
    WHEN ''completed'' THEN ''Done''
    WHEN ''pending''   THEN ''In Progress''
    WHEN ''cancelled'' THEN ''Cancelled''
    ELSE ''Unknown''
  END AS status_label
FROM orders;',
  'CASE column WHEN value THEN result is the simple CASE form — cleaner when comparing one column to fixed values.',
  'CASE column WHEN value THEN result เหมาะเมื่อเปรียบเทียบคอลัมน์เดียวกับค่าคงที่หลายค่า',
  false,45) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'salary-with-bonus','Salary with Performance Bonus','medium','case',
  'Each employee receives a bonus: 20% extra if salary >= 90000, otherwise 10% extra. Return `first_name`, `last_name`, `salary`, and `salary_with_bonus` (rounded to 2 decimal places).',
  'พนักงานแต่ละคนได้รับโบนัส: เพิ่ม 20% ถ้าเงินเดือน >= 90000 มิฉะนั้นเพิ่ม 10% คืนค่า `first_name`, `last_name`, `salary` และ `salary_with_bonus` (ปัดทศนิยม 2 ตำแหน่ง)',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',85000),(2,''Bob'',''Smith'',72000),(3,''Carol'',''Williams'',92000),
(4,''David'',''Brown'',65000),(5,''Grace'',''Wilson'',95000);',
  'SELECT first_name, last_name, salary,
  ROUND(salary * CASE WHEN salary >= 90000 THEN 1.20 ELSE 1.10 END, 2) AS salary_with_bonus
FROM employees;',
  'You can use CASE WHEN inside any arithmetic expression.',
  'ใช้ CASE WHEN ภายในนิพจน์คณิตศาสตร์ได้เลย',
  false,46) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'conditional-order-totals','Conditional Order Totals','medium','case',
  'Calculate the total amount of completed orders and the total amount of pending orders in a single query row. Return `completed_total` and `pending_total`.',
  'คำนวณยอดรวมของคำสั่งซื้อที่ completed และ pending ในแถวเดียว คืนค่า `completed_total` และ `pending_total`',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, amount NUMERIC(10,2) NOT NULL, status TEXT NOT NULL);',
  'INSERT INTO orders VALUES
(1,250,''completed''),(2,180,''pending''),(3,420,''completed''),
(4,95,''pending''),(5,600,''completed''),(6,120,''cancelled'');',
  'SELECT
  SUM(CASE WHEN status = ''completed'' THEN amount ELSE 0 END) AS completed_total,
  SUM(CASE WHEN status = ''pending''   THEN amount ELSE 0 END) AS pending_total
FROM orders;',
  'Use SUM(CASE WHEN condition THEN value ELSE 0 END) to conditionally sum values.',
  'ใช้ SUM(CASE WHEN condition THEN value ELSE 0 END) เพื่อรวมค่าแบบมีเงื่อนไข',
  false,47) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'experience-level','Experience Level','medium','case',
  'Classify each employee by tenure as of ''2025-01-01'': ''New'' (< 2 years), ''Experienced'' (2–4 years), ''Veteran'' (5+ years). Return `first_name`, `hire_date`, and `experience_level`.',
  'แบ่งระดับประสบการณ์ของพนักงาน ณ วันที่ ''2025-01-01'': ''New'' (น้อยกว่า 2 ปี), ''Experienced'' (2–4 ปี), ''Veteran'' (5 ปีขึ้นไป) คืนค่า `first_name`, `hire_date` และ `experience_level`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, hire_date DATE NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''2020-03-15''),(2,''Bob'',''2021-06-01''),(3,''Carol'',''2019-01-10''),
(4,''David'',''2022-02-20''),(5,''Frank'',''2023-08-15''),(6,''Grace'',''2018-07-22'');',
  'SELECT first_name, hire_date,
  CASE
    WHEN DATE_PART(''year'', AGE(''2025-01-01''::DATE, hire_date)) < 2 THEN ''New''
    WHEN DATE_PART(''year'', AGE(''2025-01-01''::DATE, hire_date)) < 5 THEN ''Experienced''
    ELSE ''Veteran''
  END AS experience_level
FROM employees;',
  'Calculate years of service inside CASE WHEN using DATE_PART and AGE.',
  'คำนวณปีที่ทำงานภายใน CASE WHEN โดยใช้ DATE_PART และ AGE',
  false,48) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'product-stock-status','Product Stock Status','easy','case',
  'For each product, show its `name`, `stock`, and a `stock_status`: ''Out of Stock'' (stock = 0), ''Low Stock'' (stock 1–10), ''In Stock'' (stock > 10).',
  'สำหรับผลิตภัณฑ์แต่ละชิ้น แสดง `name`, `stock` และ `stock_status`: ''Out of Stock'' (stock = 0), ''Low Stock'' (stock 1–10), ''In Stock'' (stock > 10)',
  'CREATE TEMP TABLE products (
  id INT PRIMARY KEY, name TEXT NOT NULL, stock INT NOT NULL);',
  'INSERT INTO products VALUES
(1,''Laptop'',50),(2,''Mouse'',8),(3,''Keyboard'',0),
(4,''Monitor'',25),(5,''Webcam'',3),(6,''Headset'',0),(7,''Desk Chair'',15);',
  'SELECT name, stock,
  CASE
    WHEN stock = 0  THEN ''Out of Stock''
    WHEN stock <= 10 THEN ''Low Stock''
    ELSE ''In Stock''
  END AS stock_status
FROM products;',
  'Order conditions from most specific (stock = 0) to least specific.',
  'เขียนเงื่อนไขจากเฉพาะที่สุด (stock = 0) ไปถึงกว้างที่สุด',
  false,49) ON CONFLICT (slug) DO NOTHING;

-- ══════════════════════════════════════════════════════════
-- GROUP 6: Set Operations  (sort 50–54)
-- ══════════════════════════════════════════════════════════

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'all-contacts-union-all','All Contacts (UNION ALL)','easy','set_ops',
  'Combine all employees and all contractors into a single list. Return `name` and `type` (''Employee'' or ''Contractor'') for each person. Include duplicates.',
  'รวมพนักงานและ contractor ทั้งหมดเป็นรายการเดียว คืนค่า `name` และ `type` (''Employee'' หรือ ''Contractor'') สำหรับแต่ละคน รวมซ้ำด้วย',
  'CREATE TEMP TABLE employees (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE contractors (id INT PRIMARY KEY, name TEXT NOT NULL);',
  'INSERT INTO employees VALUES (1,''Alice''),(2,''Bob''),(3,''Carol'');
INSERT INTO contractors VALUES (1,''David''),(2,''Eve''),(3,''Alice'');',
  'SELECT name, ''Employee'' AS type FROM employees
UNION ALL
SELECT name, ''Contractor'' FROM contractors;',
  'UNION ALL combines result sets without removing duplicate rows.',
  'UNION ALL รวมผลลัพธ์โดยไม่ลบแถวที่ซ้ำกัน',
  false,50) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'unique-cities-union','Unique Cities Across Offices (UNION)','easy','set_ops',
  'Get all unique cities where either employees or customers are located. Return a single column `city`, sorted alphabetically.',
  'ดึงเมืองที่ไม่ซ้ำกันทั้งหมดที่พนักงานหรือลูกค้าอาศัยอยู่ คืนค่าคอลัมน์เดียว `city` เรียงตามตัวอักษร',
  'CREATE TEMP TABLE employees (id INT PRIMARY KEY, name TEXT NOT NULL, city TEXT NOT NULL);
CREATE TEMP TABLE customers (id INT PRIMARY KEY, name TEXT NOT NULL, city TEXT NOT NULL);',
  'INSERT INTO employees VALUES (1,''Alice'',''London''),(2,''Bob'',''Berlin''),(3,''Carol'',''Paris'');
INSERT INTO customers VALUES (1,''David'',''London''),(2,''Eve'',''Tokyo''),(3,''Frank'',''Paris''),(4,''Grace'',''Sydney'');',
  'SELECT city FROM employees
UNION
SELECT city FROM customers
ORDER BY city;',
  'UNION (without ALL) automatically removes duplicate rows between the two result sets.',
  'UNION (ไม่มี ALL) ลบแถวที่ซ้ำกันระหว่างสองผลลัพธ์โดยอัตโนมัติ',
  true,51) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'products-in-both-lists','Products in Both Lists (INTERSECT)','easy','set_ops',
  'Find `product_id` values that appear in both the `featured_products` table and the `sale_products` table.',
  'ค้นหา `product_id` ที่ปรากฏทั้งในตาราง `featured_products` และ `sale_products`',
  'CREATE TEMP TABLE featured_products (product_id INT NOT NULL);
CREATE TEMP TABLE sale_products (product_id INT NOT NULL);',
  'INSERT INTO featured_products VALUES (1),(2),(3),(5),(7);
INSERT INTO sale_products VALUES (2),(3),(6),(7),(8);',
  'SELECT product_id FROM featured_products
INTERSECT
SELECT product_id FROM sale_products;',
  'INTERSECT returns only rows that appear in BOTH result sets.',
  'INTERSECT คืนค่าเฉพาะแถวที่ปรากฏในผลลัพธ์ทั้งสองชุด',
  false,52) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'churned-customers-except','Churned Customers (EXCEPT)','medium','set_ops',
  'Find customers who placed an order in 2023 but did NOT place any order in 2024. These are "churned" customers. Return `customer_id`.',
  'ค้นหาลูกค้าที่สั่งซื้อในปี 2023 แต่ไม่ได้สั่งซื้อในปี 2024 นับว่าเป็นลูกค้า "churn" คืนค่า `customer_id`',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, customer_id INT NOT NULL, order_date DATE NOT NULL);',
  'INSERT INTO orders VALUES
(1,1,''2023-03-10''),(2,2,''2023-07-15''),(3,3,''2023-11-20''),
(4,4,''2023-05-01''),(5,1,''2024-02-10''),(6,3,''2024-08-05'');',
  'SELECT customer_id FROM orders WHERE EXTRACT(YEAR FROM order_date) = 2023
EXCEPT
SELECT customer_id FROM orders WHERE EXTRACT(YEAR FROM order_date) = 2024;',
  'EXCEPT returns rows from the first query that do not appear in the second query.',
  'EXCEPT คืนค่าแถวจาก query แรกที่ไม่ปรากฏใน query ที่สอง',
  false,53) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'source-count-report','Source Count Report','medium','set_ops',
  'Combine employees and contractors into one result set with a `source` label, then count how many records came from each source. Return `source` and `record_count`.',
  'รวมพนักงานและ contractor เป็นชุดผลลัพธ์เดียวพร้อมป้าย `source` แล้วนับจำนวน record จากแต่ละแหล่ง คืนค่า `source` และ `record_count`',
  'CREATE TEMP TABLE employees (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE contractors (id INT PRIMARY KEY, name TEXT NOT NULL);',
  'INSERT INTO employees VALUES (1,''Alice''),(2,''Bob''),(3,''Carol''),(4,''David'');
INSERT INTO contractors VALUES (1,''Eve''),(2,''Frank''),(3,''Grace'');',
  'SELECT source, COUNT(*) AS record_count
FROM (
  SELECT ''employees'' AS source FROM employees
  UNION ALL
  SELECT ''contractors'' FROM contractors
) combined
GROUP BY source;',
  'Wrap a UNION ALL in a subquery (derived table), then GROUP BY the source column.',
  'ห่อ UNION ALL ด้วย subquery (derived table) แล้ว GROUP BY คอลัมน์ source',
  false,54) ON CONFLICT (slug) DO NOTHING;

-- ══════════════════════════════════════════════════════════
-- GROUP 7: Filtering Advanced  (sort 55–60)
-- ══════════════════════════════════════════════════════════

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'multi-city-customers','Customers in Multiple Cities (IN)','easy','filtering',
  'Find all customers who live in ''London'', ''Paris'', or ''Tokyo''. Return all columns.',
  'ค้นหาลูกค้าทุกคนที่อาศัยอยู่ใน ''London'', ''Paris'' หรือ ''Tokyo'' คืนค่าทุกคอลัมน์',
  'CREATE TEMP TABLE customers (
  id INT PRIMARY KEY, name TEXT NOT NULL, city TEXT NOT NULL, country TEXT NOT NULL);',
  'INSERT INTO customers VALUES
(1,''Alice'',''London'',''UK''),(2,''Bob'',''Berlin'',''Germany''),
(3,''Carol'',''Paris'',''France''),(4,''David'',''New York'',''USA''),
(5,''Eve'',''Tokyo'',''Japan''),(6,''Frank'',''London'',''UK'');',
  'SELECT * FROM customers WHERE city IN (''London'', ''Paris'', ''Tokyo'');',
  'IN (val1, val2, val3) is cleaner than multiple OR conditions.',
  'IN (val1, val2, val3) กระชับกว่าการใช้ OR หลายเงื่อนไข',
  false,55) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'exclude-departments','Exclude Departments (NOT IN)','easy','filtering',
  'Find all employees who are NOT in departments 1 or 3. Return `first_name`, `last_name`, and `department_id`.',
  'ค้นหาพนักงานทุกคนที่ไม่อยู่ในแผนก 1 หรือ 3 คืนค่า `first_name`, `last_name` และ `department_id`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  department_id INT NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',1),(2,''Bob'',''Smith'',2),(3,''Carol'',''Williams'',3),
(4,''David'',''Brown'',2),(5,''Eve'',''Davis'',1),(6,''Frank'',''Miller'',4);',
  'SELECT first_name, last_name, department_id FROM employees
WHERE department_id NOT IN (1, 3);',
  'NOT IN excludes rows whose column value matches any value in the list.',
  'NOT IN ยกเว้นแถวที่ค่าคอลัมน์ตรงกับค่าใดค่าหนึ่งในรายการ',
  false,56) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'salary-between-range','Salary in Range (BETWEEN)','easy','filtering',
  'Find employees with a salary between 70000 and 85000 inclusive. Return `first_name`, `last_name`, and `salary`.',
  'ค้นหาพนักงานที่มีเงินเดือนระหว่าง 70000 ถึง 85000 (รวมขอบ) คืนค่า `first_name`, `last_name` และ `salary`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',85000),(2,''Bob'',''Smith'',72000),(3,''Carol'',''Williams'',92000),
(4,''David'',''Brown'',68000),(5,''Eve'',''Davis'',78000),(6,''Frank'',''Miller'',65000);',
  'SELECT first_name, last_name, salary FROM employees
WHERE salary BETWEEN 70000 AND 85000;',
  'BETWEEN x AND y includes both boundary values (x and y).',
  'BETWEEN x AND y รวมค่าขอบทั้งสองด้าน (x และ y)',
  false,57) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'customers-with-orders-exists','Customers With Orders (EXISTS)','medium','filtering',
  'Find all customers who have placed at least one order. Use EXISTS. Return customer `id` and `name`.',
  'ค้นหาลูกค้าทุกคนที่มีคำสั่งซื้ออย่างน้อยหนึ่งรายการ ใช้ EXISTS คืนค่า `id` และ `name` ของลูกค้า',
  'CREATE TEMP TABLE customers (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE orders (id INT PRIMARY KEY, customer_id INT NOT NULL, amount NUMERIC(10,2));',
  'INSERT INTO customers VALUES (1,''Alice''),(2,''Bob''),(3,''Carol''),(4,''David'');
INSERT INTO orders VALUES (1,1,250),(2,1,320),(3,3,180),(4,3,450);',
  'SELECT id, name FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);',
  'EXISTS returns TRUE if the subquery produces at least one row.',
  'EXISTS คืนค่า TRUE ถ้า subquery มีผลลัพธ์อย่างน้อยหนึ่งแถว',
  false,58) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'customers-no-orders-not-exists','Customers With No Orders (NOT EXISTS)','medium','filtering',
  'Find all customers who have never placed an order. Use NOT EXISTS. Return customer `id` and `name`.',
  'ค้นหาลูกค้าทุกคนที่ไม่เคยสั่งซื้อ ใช้ NOT EXISTS คืนค่า `id` และ `name` ของลูกค้า',
  'CREATE TEMP TABLE customers (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE orders (id INT PRIMARY KEY, customer_id INT NOT NULL, amount NUMERIC(10,2));',
  'INSERT INTO customers VALUES (1,''Alice''),(2,''Bob''),(3,''Carol''),(4,''David'');
INSERT INTO orders VALUES (1,1,250),(2,1,320),(3,3,180);',
  'SELECT id, name FROM customers c
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);',
  'NOT EXISTS returns TRUE if the subquery produces zero rows.',
  'NOT EXISTS คืนค่า TRUE ถ้า subquery ไม่มีผลลัพธ์เลย',
  false,59) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'combined-filters','Combined AND/OR Filters','medium','filtering',
  'Find all orders where the status is ''completed'' AND the amount is greater than 300, OR where the status is ''pending'' AND the amount is greater than 100. Return `id`, `status`, and `amount`.',
  'ค้นหาคำสั่งซื้อที่ status เป็น ''completed'' และยอดมากกว่า 300 หรือ status เป็น ''pending'' และยอดมากกว่า 100 คืนค่า `id`, `status` และ `amount`',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, status TEXT NOT NULL, amount NUMERIC(10,2) NOT NULL);',
  'INSERT INTO orders VALUES
(1,''completed'',450),(2,''completed'',180),(3,''pending'',250),
(4,''pending'',80),(5,''completed'',320),(6,''cancelled'',500);',
  'SELECT id, status, amount FROM orders
WHERE (status = ''completed'' AND amount > 300)
   OR (status = ''pending'' AND amount > 100);',
  'Use parentheses to group AND conditions when combining with OR.',
  'ใช้วงเล็บจัดกลุ่มเงื่อนไข AND เมื่อรวมกับ OR เพื่อให้ลำดับความสำคัญถูกต้อง',
  false,60) ON CONFLICT (slug) DO NOTHING;
