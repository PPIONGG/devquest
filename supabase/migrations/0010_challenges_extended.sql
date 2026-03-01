-- ============================================================
-- 0010_challenges_extended.sql
-- Challenges 61–113 (53 challenges)
-- Topics: Advanced JOINs, Aggregation, Subqueries,
--         Window Functions, CTEs, Analytics
-- ============================================================

-- ══════════════════════════════════════════════════════════
-- GROUP 8: Advanced JOINs  (sort 61–68)
-- ══════════════════════════════════════════════════════════

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'self-join-manager','Employee and Their Manager (Self JOIN)','medium','joins',
  'Write a query listing each employee''s `first_name`, their manager''s name as `manager_name`, and their `salary`. Employees with no manager should still appear (show NULL for manager_name).',
  'เขียน query แสดง `first_name` ของพนักงาน ชื่อผู้จัดการเป็น `manager_name` และ `salary` พนักงานที่ไม่มีผู้จัดการก็ต้องแสดง (แสดง NULL สำหรับ manager_name)',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL,
  salary NUMERIC(10,2) NOT NULL, manager_id INT);',
  'INSERT INTO employees VALUES
(1,''Alice'',95000,NULL),(2,''Bob'',85000,1),(3,''Carol'',78000,1),
(4,''David'',72000,2),(5,''Eve'',68000,2),(6,''Frank'',65000,3);',
  'SELECT e.first_name, m.first_name AS manager_name, e.salary
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;',
  'JOIN a table to itself using two aliases. Use LEFT JOIN to keep employees without a manager.',
  'JOIN ตารางกับตัวเองโดยใช้ alias สองชื่อ ใช้ LEFT JOIN เพื่อเก็บพนักงานที่ไม่มีผู้จัดการ',
  false,61) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'three-table-join','Three-Table JOIN','medium','joins',
  'Write a query returning each employee''s `first_name`, their department `name`, and the department''s `location`. Return only employees who have a department and a location.',
  'เขียน query คืนค่า `first_name` ของพนักงาน `name` ของแผนก และ `location` ของแผนก คืนค่าเฉพาะพนักงานที่มีแผนกและ location',
  'CREATE TEMP TABLE employees (id INT PRIMARY KEY, first_name TEXT NOT NULL, dept_id INT);
CREATE TEMP TABLE departments (id INT PRIMARY KEY, name TEXT NOT NULL, loc_id INT);
CREATE TEMP TABLE locations (id INT PRIMARY KEY, location TEXT NOT NULL);',
  'INSERT INTO locations VALUES (1,''New York''),(2,''London''),(3,''Tokyo'');
INSERT INTO departments VALUES (1,''Engineering'',1),(2,''Marketing'',2),(3,''HR'',3);
INSERT INTO employees VALUES (1,''Alice'',1),(2,''Bob'',1),(3,''Carol'',2),(4,''David'',3),(5,''Eve'',NULL);',
  'SELECT e.first_name, d.name, l.location
FROM employees e
JOIN departments d ON e.dept_id = d.id
JOIN locations l ON d.loc_id = l.id;',
  'Chain multiple JOINs — each ON clause links the new table to a previously joined table.',
  'เชื่อม JOIN หลายตัว — แต่ละ ON เชื่อมตารางใหม่กับตารางที่ JOIN มาก่อน',
  false,62) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'full-outer-join','Full Outer Join','medium','joins',
  'Show all employees and all departments, matching where possible. If an employee has no department, still show them. If a department has no employees, still show it. Return `employee_name` and `dept_name` (NULL where there is no match).',
  'แสดงพนักงานและแผนกทั้งหมด จับคู่กันถ้าเป็นไปได้ ถ้าพนักงานไม่มีแผนกก็ยังแสดง ถ้าแผนกไม่มีพนักงานก็ยังแสดง คืนค่า `employee_name` และ `dept_name` (NULL เมื่อไม่มีคู่)',
  'CREATE TEMP TABLE employees (id INT PRIMARY KEY, name TEXT NOT NULL, dept_id INT);
CREATE TEMP TABLE departments (id INT PRIMARY KEY, name TEXT NOT NULL);',
  'INSERT INTO departments VALUES (1,''Engineering''),(2,''Marketing''),(3,''HR'');
INSERT INTO employees VALUES (1,''Alice'',1),(2,''Bob'',1),(3,''Carol'',NULL),(4,''David'',2);',
  'SELECT e.name AS employee_name, d.name AS dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.id;',
  'FULL OUTER JOIN returns all rows from both tables, with NULLs where there is no match.',
  'FULL OUTER JOIN คืนค่าทุกแถวจากทั้งสองตาราง โดยใช้ NULL เมื่อไม่มีคู่',
  false,63) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'dept-total-salary','Department Total Salary (JOIN + GROUP)','medium','joins',
  'Write a query showing each department''s `name` and the total salary of all its employees as `total_salary`. Include departments with no employees (show 0). Order by `total_salary` descending.',
  'เขียน query แสดง `name` ของแต่ละแผนกและเงินเดือนรวมของพนักงานในแผนกเป็น `total_salary` รวมแผนกที่ไม่มีพนักงาน (แสดง 0) เรียงตาม `total_salary` จากมากไปน้อย',
  'CREATE TEMP TABLE departments (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE employees (id INT PRIMARY KEY, first_name TEXT NOT NULL, dept_id INT, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO departments VALUES (1,''Engineering''),(2,''Marketing''),(3,''HR''),(4,''Finance'');
INSERT INTO employees VALUES
(1,''Alice'',1,85000),(2,''Bob'',1,72000),(3,''Carol'',2,68000),(4,''David'',1,91000),(5,''Eve'',2,74000);',
  'SELECT d.name, COALESCE(SUM(e.salary), 0) AS total_salary
FROM departments d
LEFT JOIN employees e ON d.id = e.dept_id
GROUP BY d.name
ORDER BY total_salary DESC;',
  'Use LEFT JOIN so departments with no employees appear. Wrap SUM in COALESCE to convert NULL to 0.',
  'ใช้ LEFT JOIN เพื่อให้แผนกไม่มีพนักงานปรากฏ ใช้ COALESCE รอบ SUM เพื่อแปลง NULL เป็น 0',
  true,64) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'active-customers-multiple-orders','Customers With Multiple Orders (JOIN + HAVING)','medium','joins',
  'Find customers who have placed 2 or more orders. Return customer `name` and `order_count`.',
  'ค้นหาลูกค้าที่มีคำสั่งซื้อตั้งแต่ 2 รายการขึ้นไป คืนค่า `name` ของลูกค้าและ `order_count`',
  'CREATE TEMP TABLE customers (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE orders (id INT PRIMARY KEY, customer_id INT NOT NULL, amount NUMERIC(10,2));',
  'INSERT INTO customers VALUES (1,''Alice''),(2,''Bob''),(3,''Carol''),(4,''David'');
INSERT INTO orders VALUES (1,1,250),(2,1,320),(3,2,180),(4,3,450),(5,3,210),(6,3,90),(7,4,150);',
  'SELECT c.name, COUNT(o.id) AS order_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.name
HAVING COUNT(o.id) >= 2;',
  'Use HAVING to filter groups after aggregation. HAVING COUNT(...) >= 2 keeps groups with 2+ rows.',
  'ใช้ HAVING เพื่อกรอง group หลังจาก aggregate แล้ว HAVING COUNT(...) >= 2 เก็บ group ที่มี 2 แถวขึ้นไป',
  false,65) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'customers-never-ordered','Customers Who Never Ordered (LEFT JOIN NULL)','medium','joins',
  'Find all customers who have never placed an order. Use LEFT JOIN. Return customer `id` and `name`.',
  'ค้นหาลูกค้าทุกคนที่ไม่เคยสั่งซื้อ ใช้ LEFT JOIN คืนค่า `id` และ `name` ของลูกค้า',
  'CREATE TEMP TABLE customers (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE orders (id INT PRIMARY KEY, customer_id INT NOT NULL, amount NUMERIC(10,2));',
  'INSERT INTO customers VALUES (1,''Alice''),(2,''Bob''),(3,''Carol''),(4,''David''),(5,''Eve'');
INSERT INTO orders VALUES (1,1,250),(2,1,320),(3,3,180),(4,3,450);',
  'SELECT c.id, c.name
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.id IS NULL;',
  'LEFT JOIN keeps all customers; WHERE o.id IS NULL keeps only those with no matching order.',
  'LEFT JOIN เก็บลูกค้าทั้งหมด; WHERE o.id IS NULL เก็บเฉพาะที่ไม่มีคำสั่งซื้อตรงกัน',
  false,66) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'products-never-sold','Products Never Sold','medium','joins',
  'Find all products that have never appeared in any order. Return product `id` and `name`.',
  'ค้นหาผลิตภัณฑ์ทุกชิ้นที่ไม่เคยปรากฏในคำสั่งซื้อ คืนค่า `id` และ `name` ของผลิตภัณฑ์',
  'CREATE TEMP TABLE products (id INT PRIMARY KEY, name TEXT NOT NULL, price NUMERIC(10,2));
CREATE TEMP TABLE order_items (id INT PRIMARY KEY, order_id INT NOT NULL, product_id INT NOT NULL, quantity INT);',
  'INSERT INTO products VALUES (1,''Laptop'',1200),(2,''Mouse'',25),(3,''Keyboard'',75),(4,''Monitor'',400),(5,''Webcam'',120);
INSERT INTO order_items VALUES (1,1,1,2),(2,1,2,5),(3,2,3,1),(4,3,1,1);',
  'SELECT p.id, p.name
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
WHERE oi.id IS NULL;',
  'LEFT JOIN products to order_items; NULL on the right side means the product was never ordered.',
  'LEFT JOIN products กับ order_items; NULL ด้านขวาหมายความว่าผลิตภัณฑ์นั้นไม่เคยถูกสั่ง',
  false,67) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'employee-project-count','Employee Project Count (Many-to-Many)','medium','joins',
  'Count how many projects each employee is assigned to. Return `first_name` and `project_count`. Include employees with zero projects.',
  'นับจำนวน project ที่พนักงานแต่ละคนได้รับมอบหมาย คืนค่า `first_name` และ `project_count` รวมพนักงานที่ไม่มี project',
  'CREATE TEMP TABLE employees (id INT PRIMARY KEY, first_name TEXT NOT NULL);
CREATE TEMP TABLE projects (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE employee_projects (employee_id INT NOT NULL, project_id INT NOT NULL);',
  'INSERT INTO employees VALUES (1,''Alice''),(2,''Bob''),(3,''Carol''),(4,''David'');
INSERT INTO projects VALUES (1,''Alpha''),(2,''Beta''),(3,''Gamma'');
INSERT INTO employee_projects VALUES (1,1),(1,2),(1,3),(2,1),(3,2);',
  'SELECT e.first_name, COUNT(ep.project_id) AS project_count
FROM employees e
LEFT JOIN employee_projects ep ON e.id = ep.employee_id
GROUP BY e.id, e.first_name
ORDER BY project_count DESC;',
  'LEFT JOIN the junction table so employees with no projects show COUNT = 0.',
  'LEFT JOIN ตารางกลาง (junction) เพื่อให้พนักงานที่ไม่มี project แสดง COUNT = 0',
  false,68) ON CONFLICT (slug) DO NOTHING;

-- ══════════════════════════════════════════════════════════
-- GROUP 9: Advanced Aggregation  (sort 69–76)
-- ══════════════════════════════════════════════════════════

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'departments-multiple-employees','Departments With Many Employees (HAVING)','medium','aggregate',
  'Find departments that have 3 or more employees. Return department `name` and `employee_count`.',
  'ค้นหาแผนกที่มีพนักงานตั้งแต่ 3 คนขึ้นไป คืนค่า `name` ของแผนกและ `employee_count`',
  'CREATE TEMP TABLE departments (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE employees (id INT PRIMARY KEY, first_name TEXT NOT NULL, dept_id INT NOT NULL);',
  'INSERT INTO departments VALUES (1,''Engineering''),(2,''Marketing''),(3,''HR'');
INSERT INTO employees VALUES
(1,''Alice'',1),(2,''Bob'',1),(3,''Carol'',1),(4,''David'',2),(5,''Eve'',2),
(6,''Frank'',1),(7,''Grace'',3);',
  'SELECT d.name, COUNT(e.id) AS employee_count
FROM departments d
JOIN employees e ON d.id = e.dept_id
GROUP BY d.name
HAVING COUNT(e.id) >= 3;',
  'Use HAVING to filter after GROUP BY. WHERE runs before grouping; HAVING runs after.',
  'ใช้ HAVING เพื่อกรองหลังจาก GROUP BY; WHERE ทำงานก่อน group, HAVING ทำงานหลัง',
  false,69) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'high-avg-salary-departments','High-Paying Departments (HAVING AVG)','medium','aggregate',
  'Find departments where the average employee salary exceeds 80000. Return department `name` and `avg_salary` rounded to 2 decimal places.',
  'ค้นหาแผนกที่เงินเดือนเฉลี่ยของพนักงานเกิน 80000 คืนค่า `name` ของแผนกและ `avg_salary` ปัดทศนิยม 2 ตำแหน่ง',
  'CREATE TEMP TABLE departments (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE employees (id INT PRIMARY KEY, dept_id INT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO departments VALUES (1,''Engineering''),(2,''Marketing''),(3,''HR'');
INSERT INTO employees VALUES
(1,1,90000),(2,1,85000),(3,1,92000),(4,2,72000),(5,2,68000),(6,3,81000),(7,3,83000);',
  'SELECT d.name, ROUND(AVG(e.salary), 2) AS avg_salary
FROM departments d
JOIN employees e ON d.id = e.dept_id
GROUP BY d.name
HAVING AVG(e.salary) > 80000;',
  'HAVING AVG(column) > value filters groups by their average.',
  'HAVING AVG(column) > value กรอง group ตามค่าเฉลี่ย',
  false,70) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'revenue-by-status','Revenue by Order Status','easy','aggregate',
  'Calculate the total revenue grouped by order status. Return `status` and `total_revenue`, ordered by `total_revenue` descending.',
  'คำนวณรายรับรวมจัดกลุ่มตามสถานะคำสั่งซื้อ คืนค่า `status` และ `total_revenue` เรียงตาม `total_revenue` จากมากไปน้อย',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, amount NUMERIC(10,2) NOT NULL, status TEXT NOT NULL);',
  'INSERT INTO orders VALUES
(1,250,''completed''),(2,180,''completed''),(3,420,''pending''),
(4,95,''cancelled''),(5,600,''completed''),(6,120,''pending''),(7,310,''completed'');',
  'SELECT status, SUM(amount) AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;',
  'GROUP BY status groups all rows with the same status together for aggregation.',
  'GROUP BY status จัดกลุ่มแถวที่มีสถานะเดียวกันเพื่อทำ aggregate',
  true,71) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'salary-percent-of-total','Salary as Percent of Total','hard','aggregate',
  'Show each employee''s `first_name`, `salary`, and what percentage of the company''s total salary their salary represents as `salary_pct` (rounded to 2 decimal places).',
  'แสดง `first_name`, `salary` ของพนักงาน และเปอร์เซ็นต์ที่เงินเดือนของพวกเขาคิดเป็นส่วนของเงินเดือนรวมทั้งบริษัทเป็น `salary_pct` (ปัดทศนิยม 2 ตำแหน่ง)',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',85000),(2,''Bob'',72000),(3,''Carol'',92000),
(4,''David'',68000),(5,''Eve'',78000);',
  'SELECT first_name, salary,
  ROUND(salary * 100.0 / SUM(salary) OVER (), 2) AS salary_pct
FROM employees;',
  'SUM(salary) OVER () (a window function with no partition) computes the grand total in every row.',
  'SUM(salary) OVER () (window function ไม่มี partition) คำนวณผลรวมทั้งหมดในทุกแถว',
  false,72) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'annual-revenue-by-year','Annual Revenue by Year','easy','aggregate',
  'Calculate total revenue for each year. Return `order_year` and `total_revenue`, ordered by `order_year`.',
  'คำนวณรายรับรวมสำหรับแต่ละปี คืนค่า `order_year` และ `total_revenue` เรียงตาม `order_year`',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, amount NUMERIC(10,2) NOT NULL, order_date DATE NOT NULL);',
  'INSERT INTO orders VALUES
(1,250,''2022-03-10''),(2,320,''2022-07-15''),(3,450,''2023-01-20''),
(4,180,''2023-05-05''),(5,600,''2023-11-30''),(6,310,''2024-02-12''),(7,275,''2024-08-20'');',
  'SELECT EXTRACT(YEAR FROM order_date)::INT AS order_year, SUM(amount) AS total_revenue
FROM orders
GROUP BY order_year
ORDER BY order_year;',
  'EXTRACT(YEAR FROM date) gets the year; then GROUP BY and SUM to aggregate.',
  'EXTRACT(YEAR FROM date) ดึงปี จากนั้น GROUP BY และ SUM เพื่อ aggregate',
  true,73) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'revenue-by-product-category','Revenue by Product Category','medium','aggregate',
  'Calculate total revenue (quantity × unit_price) for each product category. Return `category` and `total_revenue`, ordered by `total_revenue` descending.',
  'คำนวณรายรับรวม (quantity × unit_price) สำหรับแต่ละหมวดผลิตภัณฑ์ คืนค่า `category` และ `total_revenue` เรียงตาม `total_revenue` จากมากไปน้อย',
  'CREATE TEMP TABLE products (id INT PRIMARY KEY, name TEXT NOT NULL, category TEXT NOT NULL);
CREATE TEMP TABLE order_items (id INT PRIMARY KEY, product_id INT NOT NULL, quantity INT NOT NULL, unit_price NUMERIC(10,2) NOT NULL);',
  'INSERT INTO products VALUES (1,''Laptop'',''Electronics''),(2,''Mouse'',''Electronics''),(3,''Keyboard'',''Electronics''),(4,''Desk Chair'',''Furniture''),(5,''Bookshelf'',''Furniture'');
INSERT INTO order_items VALUES (1,1,2,1200),(2,2,10,25),(3,3,5,75),(4,4,3,350),(5,5,1,180),(6,1,1,1200);',
  'SELECT p.category, SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;',
  'Multiply quantity by unit_price inside SUM() to get line item revenue before grouping.',
  'คูณ quantity กับ unit_price ภายใน SUM() เพื่อคำนวณรายรับต่อรายการก่อน group',
  true,74) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'top-selling-product','Top-Selling Product','medium','aggregate',
  'Find the single product with the highest total units sold. Return `name` and `total_sold`.',
  'ค้นหาผลิตภัณฑ์ที่มียอดขายรวมสูงสุดเพียงชิ้นเดียว คืนค่า `name` และ `total_sold`',
  'CREATE TEMP TABLE products (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE order_items (id INT PRIMARY KEY, product_id INT NOT NULL, quantity INT NOT NULL);',
  'INSERT INTO products VALUES (1,''Laptop''),(2,''Mouse''),(3,''Keyboard''),(4,''Monitor'');
INSERT INTO order_items VALUES (1,1,2),(2,2,15),(3,3,8),(4,2,10),(5,1,3),(6,3,5),(7,2,7),(8,4,2);',
  'SELECT p.name, SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY total_sold DESC
LIMIT 1;',
  'GROUP BY product, SUM quantity, then ORDER BY DESC LIMIT 1 to get the top result.',
  'GROUP BY ผลิตภัณฑ์, SUM quantity แล้ว ORDER BY DESC LIMIT 1 เพื่อได้อันดับหนึ่ง',
  true,75) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'avg-order-per-customer','Average Order Value per Customer','medium','aggregate',
  'Calculate the average order amount for each customer. Return `customer_id` and `avg_order_value` (rounded to 2 decimal places), ordered by `avg_order_value` descending.',
  'คำนวณมูลค่าคำสั่งซื้อเฉลี่ยสำหรับลูกค้าแต่ละราย คืนค่า `customer_id` และ `avg_order_value` (ปัดทศนิยม 2 ตำแหน่ง) เรียงตาม `avg_order_value` จากมากไปน้อย',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, customer_id INT NOT NULL, amount NUMERIC(10,2) NOT NULL);',
  'INSERT INTO orders VALUES
(1,1,250),(2,1,320),(3,2,180),(4,2,95),(5,2,430),(6,3,600),(7,3,150),(8,4,80);',
  'SELECT customer_id, ROUND(AVG(amount), 2) AS avg_order_value
FROM orders
GROUP BY customer_id
ORDER BY avg_order_value DESC;',
  'GROUP BY customer_id then use AVG(amount) to compute the average per customer.',
  'GROUP BY customer_id แล้วใช้ AVG(amount) เพื่อคำนวณค่าเฉลี่ยต่อลูกค้า',
  true,76) ON CONFLICT (slug) DO NOTHING;

-- ══════════════════════════════════════════════════════════
-- GROUP 10: Subqueries  (sort 77–84)
-- ══════════════════════════════════════════════════════════

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'employees-in-it-subquery','Employees in IT (Subquery IN)','medium','subquery',
  'Find all employees who work in the IT department. Use a subquery with IN — do not use JOIN. Return `first_name` and `last_name`.',
  'ค้นหาพนักงานทุกคนที่ทำงานในแผนก IT ใช้ subquery กับ IN ไม่ใช้ JOIN คืนค่า `first_name` และ `last_name`',
  'CREATE TEMP TABLE employees (id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL, dept_id INT);
CREATE TEMP TABLE departments (id INT PRIMARY KEY, name TEXT NOT NULL);',
  'INSERT INTO departments VALUES (1,''IT''),(2,''HR''),(3,''Finance'');
INSERT INTO employees VALUES (1,''Alice'',''Johnson'',1),(2,''Bob'',''Smith'',2),(3,''Carol'',''Williams'',1),(4,''David'',''Brown'',3),(5,''Eve'',''Davis'',1);',
  'SELECT first_name, last_name FROM employees
WHERE dept_id IN (SELECT id FROM departments WHERE name = ''IT'');',
  'IN (subquery) matches rows where the column equals any value returned by the subquery.',
  'IN (subquery) จับคู่แถวที่คอลัมน์ตรงกับค่าใดค่าหนึ่งที่ subquery คืนมา',
  false,77) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'customers-made-orders-exists','Customers Who Ordered (EXISTS subquery)','medium','subquery',
  'Find all customers who have placed at least one completed order. Use EXISTS with a subquery. Return customer `name`.',
  'ค้นหาลูกค้าทุกคนที่มีคำสั่งซื้อที่ completed อย่างน้อยหนึ่งรายการ ใช้ EXISTS กับ subquery คืนค่า `name` ของลูกค้า',
  'CREATE TEMP TABLE customers (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE orders (id INT PRIMARY KEY, customer_id INT NOT NULL, status TEXT NOT NULL);',
  'INSERT INTO customers VALUES (1,''Alice''),(2,''Bob''),(3,''Carol''),(4,''David'');
INSERT INTO orders VALUES (1,1,''completed''),(2,2,''pending''),(3,3,''completed''),(4,2,''cancelled'');',
  'SELECT name FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id AND o.status = ''completed'');',
  'The subquery references the outer query''s c.id — this is a correlated subquery.',
  'Subquery อ้างอิง c.id จาก query ภายนอก นี่คือ correlated subquery',
  false,78) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'products-with-no-sales','Products With No Sales (NOT EXISTS)','medium','subquery',
  'Find all products that have no entries in the `order_items` table. Use NOT EXISTS. Return product `name`.',
  'ค้นหาผลิตภัณฑ์ทุกชิ้นที่ไม่มีรายการใน `order_items` ใช้ NOT EXISTS คืนค่า `name` ของผลิตภัณฑ์',
  'CREATE TEMP TABLE products (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE order_items (id INT PRIMARY KEY, product_id INT NOT NULL, quantity INT);',
  'INSERT INTO products VALUES (1,''Laptop''),(2,''Mouse''),(3,''Keyboard''),(4,''Monitor''),(5,''Webcam'');
INSERT INTO order_items VALUES (1,1,2),(2,2,5),(3,1,1);',
  'SELECT name FROM products p
WHERE NOT EXISTS (SELECT 1 FROM order_items oi WHERE oi.product_id = p.id);',
  'NOT EXISTS with a correlated subquery is a clean way to find "no matching rows" relationships.',
  'NOT EXISTS กับ correlated subquery เป็นวิธีที่ดีในการหาความสัมพันธ์แบบ "ไม่มีแถวที่ตรงกัน"',
  false,79) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'orders-with-customer-name','Orders With Customer Name (Scalar Subquery)','medium','subquery',
  'Write a query returning each order''s `id`, `amount`, and the ordering customer''s `name` as `customer_name` — using a scalar subquery in the SELECT clause.',
  'เขียน query คืนค่า `id`, `amount` ของคำสั่งซื้อ และ `name` ของลูกค้าเป็น `customer_name` โดยใช้ scalar subquery ใน SELECT clause',
  'CREATE TEMP TABLE customers (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE orders (id INT PRIMARY KEY, customer_id INT NOT NULL, amount NUMERIC(10,2) NOT NULL);',
  'INSERT INTO customers VALUES (1,''Alice''),(2,''Bob''),(3,''Carol'');
INSERT INTO orders VALUES (1,1,250),(2,2,180),(3,1,320),(4,3,450),(5,2,95);',
  'SELECT id, amount,
  (SELECT name FROM customers WHERE id = orders.customer_id) AS customer_name
FROM orders;',
  'A scalar subquery returns exactly one row and one column; it can be used anywhere an expression is valid.',
  'Scalar subquery คืนค่าหนึ่งแถวหนึ่งคอลัมน์ สามารถใช้ได้ทุกที่ที่ expression ถูกต้อง',
  false,80) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'above-avg-salary','Employees Above Company Average Salary','medium','subquery',
  'Find all employees who earn more than the company-wide average salary. Return `first_name`, `last_name`, and `salary`. Order by `salary` descending.',
  'ค้นหาพนักงานทุกคนที่มีเงินเดือนสูงกว่าค่าเฉลี่ยของบริษัท คืนค่า `first_name`, `last_name` และ `salary` เรียงตาม `salary` จากมากไปน้อย',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',85000),(2,''Bob'',''Smith'',72000),(3,''Carol'',''Williams'',92000),
(4,''David'',''Brown'',68000),(5,''Eve'',''Davis'',78000),(6,''Grace'',''Wilson'',95000);',
  'SELECT first_name, last_name, salary FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;',
  'Use a scalar subquery in WHERE to compare each row to the overall average.',
  'ใช้ scalar subquery ใน WHERE เพื่อเปรียบเทียบแต่ละแถวกับค่าเฉลี่ยรวม',
  true,81) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'highest-paid-per-dept','Highest Paid Per Department (Correlated Subquery)','hard','subquery',
  'Find the highest-paid employee in each department. Return `first_name`, `dept_id`, and `salary`.',
  'ค้นหาพนักงานที่มีเงินเดือนสูงสุดในแต่ละแผนก คืนค่า `first_name`, `dept_id` และ `salary`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL,
  dept_id INT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',1,85000),(2,''Bob'',1,72000),(3,''Carol'',1,92000),
(4,''David'',2,68000),(5,''Eve'',2,78000),(6,''Frank'',3,95000),(7,''Grace'',3,88000);',
  'SELECT first_name, dept_id, salary FROM employees e
WHERE salary = (SELECT MAX(salary) FROM employees WHERE dept_id = e.dept_id);',
  'The correlated subquery runs once per row, using e.dept_id from the outer query.',
  'Correlated subquery รันครั้งต่อแถว โดยใช้ e.dept_id จาก query ภายนอก',
  false,82) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'second-highest-salary','Second Highest Salary','hard','subquery',
  'Find the second-highest distinct salary in the `employees` table. Return a single column `second_highest_salary`.',
  'ค้นหาเงินเดือนสูงสุดอันดับสองที่ไม่ซ้ำกันในตาราง `employees` คืนค่าคอลัมน์เดียวชื่อ `second_highest_salary`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',85000),(2,''Bob'',72000),(3,''Carol'',92000),
(4,''David'',92000),(5,''Eve'',78000),(6,''Grace'',95000);',
  'SELECT MAX(salary) AS second_highest_salary FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);',
  'Find the MAX salary that is less than the overall MAX — that is the second-highest.',
  'หาค่า MAX ของเงินเดือนที่น้อยกว่า MAX รวม นั่นคือเงินเดือนสูงสุดอันดับสอง',
  false,83) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'orders-above-customer-avg','Orders Above Customer Average (Derived Table)','hard','subquery',
  'Find orders where the amount exceeds that customer''s own average order value. Use a subquery in FROM (derived table). Return `order_id`, `customer_id`, `amount`, and `customer_avg`.',
  'ค้นหาคำสั่งซื้อที่มียอดเกินค่าเฉลี่ยของลูกค้าคนนั้น ใช้ subquery ใน FROM (derived table) คืนค่า `order_id`, `customer_id`, `amount` และ `customer_avg`',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, customer_id INT NOT NULL, amount NUMERIC(10,2) NOT NULL);',
  'INSERT INTO orders VALUES
(1,1,100),(2,1,300),(3,1,200),(4,2,500),(5,2,100),(6,2,600),(7,3,250);',
  'SELECT o.id AS order_id, o.customer_id, o.amount,
  ca.customer_avg
FROM orders o
JOIN (SELECT customer_id, AVG(amount) AS customer_avg FROM orders GROUP BY customer_id) ca
  ON o.customer_id = ca.customer_id
WHERE o.amount > ca.customer_avg;',
  'Build a derived table in FROM that pre-computes each customer''s average, then JOIN and filter.',
  'สร้าง derived table ใน FROM ที่คำนวณค่าเฉลี่ยของแต่ละลูกค้าล่วงหน้า แล้ว JOIN และกรอง',
  false,84) ON CONFLICT (slug) DO NOTHING;

-- ══════════════════════════════════════════════════════════
-- GROUP 11: Window Functions  (sort 85–96)
-- ══════════════════════════════════════════════════════════

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'row-number-per-dept','Row Number Per Department','medium','window',
  'Assign a row number to each employee within their department, ordered by salary descending. Return `first_name`, `dept_id`, `salary`, and `rn`.',
  'กำหนดหมายเลขแถวให้พนักงานแต่ละคนภายในแผนก เรียงตามเงินเดือนจากมากไปน้อย คืนค่า `first_name`, `dept_id`, `salary` และ `rn`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL,
  dept_id INT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',1,85000),(2,''Bob'',1,72000),(3,''Carol'',1,92000),
(4,''David'',2,68000),(5,''Eve'',2,78000),(6,''Frank'',2,65000);',
  'SELECT first_name, dept_id, salary,
  ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn
FROM employees;',
  'ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...) numbers rows within each partition.',
  'ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...) กำหนดหมายเลขแถวภายในแต่ละ partition',
  false,85) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'running-total-sales','Running Total of Sales','medium','window',
  'Calculate a cumulative (running) total of order amounts ordered by `order_date`. Return `order_date`, `amount`, and `running_total`.',
  'คำนวณยอดรวมสะสม (running total) ของยอดคำสั่งซื้อเรียงตาม `order_date` คืนค่า `order_date`, `amount` และ `running_total`',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, amount NUMERIC(10,2) NOT NULL, order_date DATE NOT NULL);',
  'INSERT INTO orders VALUES
(1,100,''2024-01-05''),(2,250,''2024-01-12''),(3,180,''2024-01-20''),
(4,320,''2024-02-03''),(5,95,''2024-02-14''),(6,450,''2024-02-28'');',
  'SELECT order_date, amount,
  SUM(amount) OVER (ORDER BY order_date ROWS UNBOUNDED PRECEDING) AS running_total
FROM orders;',
  'SUM() OVER (ORDER BY ...) with ROWS UNBOUNDED PRECEDING computes a running cumulative sum.',
  'SUM() OVER (ORDER BY ...) ด้วย ROWS UNBOUNDED PRECEDING คำนวณผลรวมสะสมแบบ running',
  true,86) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'lag-previous-month-sales','Previous Month Sales (LAG)','medium','window',
  'For each month''s sales record, show the current month revenue and the previous month''s revenue as `prev_revenue`. Order by `sale_month`.',
  'สำหรับบันทึกยอดขายแต่ละเดือน แสดงรายรับเดือนปัจจุบันและรายรับเดือนก่อนหน้าเป็น `prev_revenue` เรียงตาม `sale_month`',
  'CREATE TEMP TABLE monthly_sales (
  sale_month DATE PRIMARY KEY, revenue NUMERIC(12,2) NOT NULL);',
  'INSERT INTO monthly_sales VALUES
(''2024-01-01'',45000),(''2024-02-01'',52000),(''2024-03-01'',48000),
(''2024-04-01'',61000),(''2024-05-01'',55000),(''2024-06-01'',67000);',
  'SELECT sale_month, revenue,
  LAG(revenue) OVER (ORDER BY sale_month) AS prev_revenue
FROM monthly_sales;',
  'LAG(column) OVER (ORDER BY ...) returns the value from the previous row in the ordered partition.',
  'LAG(column) OVER (ORDER BY ...) คืนค่าจากแถวก่อนหน้าในลำดับ',
  true,87) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'lead-next-month-target','Next Month Target (LEAD)','medium','window',
  'For each monthly sales record, show the current revenue and the next month''s revenue as `next_revenue`. Order by `sale_month`.',
  'สำหรับบันทึกยอดขายรายเดือน แสดงรายรับปัจจุบันและรายรับเดือนถัดไปเป็น `next_revenue` เรียงตาม `sale_month`',
  'CREATE TEMP TABLE monthly_sales (
  sale_month DATE PRIMARY KEY, revenue NUMERIC(12,2) NOT NULL);',
  'INSERT INTO monthly_sales VALUES
(''2024-01-01'',45000),(''2024-02-01'',52000),(''2024-03-01'',48000),
(''2024-04-01'',61000),(''2024-05-01'',55000),(''2024-06-01'',67000);',
  'SELECT sale_month, revenue,
  LEAD(revenue) OVER (ORDER BY sale_month) AS next_revenue
FROM monthly_sales;',
  'LEAD(column) OVER (ORDER BY ...) returns the value from the next row in the ordered result.',
  'LEAD(column) OVER (ORDER BY ...) คืนค่าจากแถวถัดไปในลำดับ',
  true,88) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'top-earner-per-dept-first-value','Top Earner in Department (FIRST_VALUE)','medium','window',
  'For every employee, show their `first_name`, `dept_id`, `salary`, and the highest salary in their department as `dept_top_salary`.',
  'สำหรับพนักงานทุกคน แสดง `first_name`, `dept_id`, `salary` และเงินเดือนสูงสุดในแผนกของตนเองเป็น `dept_top_salary`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL,
  dept_id INT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',1,85000),(2,''Bob'',1,72000),(3,''Carol'',1,92000),
(4,''David'',2,68000),(5,''Eve'',2,78000),(6,''Frank'',2,65000);',
  'SELECT first_name, dept_id, salary,
  FIRST_VALUE(salary) OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_top_salary
FROM employees;',
  'FIRST_VALUE() OVER (PARTITION BY dept ORDER BY salary DESC) returns the highest salary in each department for every row.',
  'FIRST_VALUE() OVER (PARTITION BY dept ORDER BY salary DESC) คืนเงินเดือนสูงสุดในแต่ละแผนกให้ทุกแถว',
  false,89) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'salary-quartile-ntile','Salary Quartile (NTILE)','medium','window',
  'Divide all employees into 4 salary quartiles (1=lowest, 4=highest). Return `first_name`, `salary`, and `quartile`.',
  'แบ่งพนักงานทุกคนออกเป็น 4 ไตรมาสเงินเดือน (1=ต่ำสุด, 4=สูงสุด) คืนค่า `first_name`, `salary` และ `quartile`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',85000),(2,''Bob'',72000),(3,''Carol'',92000),(4,''David'',68000),
(5,''Eve'',78000),(6,''Frank'',65000),(7,''Grace'',95000),(8,''Henry'',71000);',
  'SELECT first_name, salary,
  NTILE(4) OVER (ORDER BY salary) AS quartile
FROM employees;',
  'NTILE(n) divides ordered rows into n equally-sized buckets.',
  'NTILE(n) แบ่งแถวที่เรียงแล้วออกเป็น n กลุ่มขนาดเท่าๆ กัน',
  false,90) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'rank-vs-dense-rank','RANK vs DENSE_RANK','medium','window',
  'Show each employee''s `first_name`, `salary`, their `rnk` using RANK(), and their `dense_rnk` using DENSE_RANK() — both ordered by salary descending.',
  'แสดง `first_name`, `salary` ของพนักงาน `rnk` โดยใช้ RANK() และ `dense_rnk` โดยใช้ DENSE_RANK() ทั้งสองเรียงตามเงินเดือนจากมากไปน้อย',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',85000),(2,''Bob'',72000),(3,''Carol'',85000),
(4,''David'',68000),(5,''Eve'',72000),(6,''Grace'',95000);',
  'SELECT first_name, salary,
  RANK()       OVER (ORDER BY salary DESC) AS rnk,
  DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rnk
FROM employees;',
  'RANK() leaves gaps after ties (1,1,3); DENSE_RANK() does not (1,1,2).',
  'RANK() เว้นช่องว่างหลังค่าที่เท่ากัน (1,1,3); DENSE_RANK() ไม่เว้น (1,1,2)',
  false,91) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'percent-rank-salary','Salary Percentile Rank (PERCENT_RANK)','medium','window',
  'Calculate the percentile rank of each employee''s salary. Return `first_name`, `salary`, and `pct_rank` (rounded to 4 decimal places). Order by `salary` ascending.',
  'คำนวณ percentile rank ของเงินเดือนพนักงานแต่ละคน คืนค่า `first_name`, `salary` และ `pct_rank` (ปัดทศนิยม 4 ตำแหน่ง) เรียงตาม `salary` จากน้อยไปมาก',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',85000),(2,''Bob'',72000),(3,''Carol'',92000),
(4,''David'',65000),(5,''Eve'',78000),(6,''Frank'',68000);',
  'SELECT first_name, salary,
  ROUND(PERCENT_RANK() OVER (ORDER BY salary)::NUMERIC, 4) AS pct_rank
FROM employees
ORDER BY salary;',
  'PERCENT_RANK() returns a value from 0.0 to 1.0 representing the row''s relative position.',
  'PERCENT_RANK() คืนค่า 0.0 ถึง 1.0 แสดงตำแหน่งสัมพัทธ์ของแถว',
  true,92) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'top-3-per-department-window','Top 3 Earners Per Department','hard','window',
  'Find the top 3 highest-paid employees within each department. Return `first_name`, `dept_id`, `salary`, and their rank `salary_rank`. Only return rows with rank <= 3.',
  'ค้นหาพนักงาน 3 อันดับที่มีเงินเดือนสูงสุดในแต่ละแผนก คืนค่า `first_name`, `dept_id`, `salary` และ `salary_rank` คืนค่าเฉพาะแถวที่ rank <= 3',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL,
  dept_id INT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',1,85000),(2,''Bob'',1,72000),(3,''Carol'',1,92000),(4,''Dan'',1,68000),
(5,''Eve'',2,78000),(6,''Frank'',2,65000),(7,''Grace'',2,88000),(8,''Henry'',2,71000);',
  'SELECT first_name, dept_id, salary, salary_rank
FROM (
  SELECT first_name, dept_id, salary,
    RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS salary_rank
  FROM employees
) ranked
WHERE salary_rank <= 3;',
  'Compute the rank in a subquery or CTE, then filter WHERE rank <= 3 in the outer query.',
  'คำนวณ rank ใน subquery หรือ CTE แล้วกรองด้วย WHERE rank <= 3 ใน query ภายนอก',
  false,93) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'moving-3-period-avg','3-Period Moving Average','hard','window',
  'Calculate the 3-period moving average of monthly revenue (current + 2 preceding months). Return `sale_month`, `revenue`, and `moving_avg` (rounded to 2 decimal places).',
  'คำนวณค่าเฉลี่ยเคลื่อนที่ 3 ช่วง (เดือนปัจจุบัน + 2 เดือนก่อนหน้า) คืนค่า `sale_month`, `revenue` และ `moving_avg` (ปัดทศนิยม 2 ตำแหน่ง)',
  'CREATE TEMP TABLE monthly_sales (
  sale_month DATE PRIMARY KEY, revenue NUMERIC(12,2) NOT NULL);',
  'INSERT INTO monthly_sales VALUES
(''2024-01-01'',45000),(''2024-02-01'',52000),(''2024-03-01'',48000),
(''2024-04-01'',61000),(''2024-05-01'',55000),(''2024-06-01'',67000);',
  'SELECT sale_month, revenue,
  ROUND(AVG(revenue) OVER (ORDER BY sale_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg
FROM monthly_sales;',
  'ROWS BETWEEN 2 PRECEDING AND CURRENT ROW defines a 3-row window for the moving average.',
  'ROWS BETWEEN 2 PRECEDING AND CURRENT ROW กำหนด window 3 แถวสำหรับ moving average',
  true,94) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'salary-vs-dept-average','Salary vs Department Average','medium','window',
  'For each employee, show their `first_name`, `salary`, their department average salary as `dept_avg`, and the difference as `diff_from_avg`. Round both avg and diff to 2 decimal places.',
  'สำหรับพนักงานแต่ละคน แสดง `first_name`, `salary`, เงินเดือนเฉลี่ยแผนกเป็น `dept_avg` และส่วนต่างเป็น `diff_from_avg` ปัดทศนิยม 2 ตำแหน่ง',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL,
  dept_id INT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',1,85000),(2,''Bob'',1,72000),(3,''Carol'',1,92000),
(4,''David'',2,68000),(5,''Eve'',2,78000),(6,''Frank'',2,65000);',
  'SELECT first_name, salary,
  ROUND(AVG(salary) OVER (PARTITION BY dept_id), 2) AS dept_avg,
  ROUND(salary - AVG(salary) OVER (PARTITION BY dept_id), 2) AS diff_from_avg
FROM employees;',
  'Use AVG() OVER (PARTITION BY dept_id) to compute the department average without collapsing rows.',
  'ใช้ AVG() OVER (PARTITION BY dept_id) เพื่อคำนวณค่าเฉลี่ยแผนกโดยไม่ยุบแถว',
  false,95) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'month-over-month-pct','Month-over-Month Revenue Change','hard','window',
  'Calculate the month-over-month revenue percentage change for each month. Return `sale_month`, `revenue`, and `mom_pct_change` (rounded to 2 decimal places). NULL is acceptable for the first month.',
  'คำนวณการเปลี่ยนแปลงรายรับเดือนต่อเดือนเป็นเปอร์เซ็นต์ คืนค่า `sale_month`, `revenue` และ `mom_pct_change` (ปัดทศนิยม 2 ตำแหน่ง) ยอมรับ NULL สำหรับเดือนแรก',
  'CREATE TEMP TABLE monthly_sales (
  sale_month DATE PRIMARY KEY, revenue NUMERIC(12,2) NOT NULL);',
  'INSERT INTO monthly_sales VALUES
(''2024-01-01'',45000),(''2024-02-01'',52000),(''2024-03-01'',48000),
(''2024-04-01'',61000),(''2024-05-01'',55000),(''2024-06-01'',67000);',
  'SELECT sale_month, revenue,
  ROUND(
    (revenue - LAG(revenue) OVER (ORDER BY sale_month)) * 100.0
    / NULLIF(LAG(revenue) OVER (ORDER BY sale_month), 0),
    2
  ) AS mom_pct_change
FROM monthly_sales;',
  '(current - previous) / previous * 100 gives the % change. Use LAG for previous, NULLIF to avoid division by zero.',
  '(ปัจจุบัน - ก่อนหน้า) / ก่อนหน้า * 100 = เปอร์เซ็นต์การเปลี่ยนแปลง ใช้ LAG สำหรับก่อนหน้า และ NULLIF ป้องกันหารศูนย์',
  true,96) ON CONFLICT (slug) DO NOTHING;

-- ══════════════════════════════════════════════════════════
-- GROUP 12: CTEs  (sort 97–102)
-- ══════════════════════════════════════════════════════════

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'basic-cte','Basic CTE','medium','cte',
  'Use a CTE named `high_earners` to select employees with salary >= 80000, then query that CTE to return `first_name`, `last_name`, and `salary`.',
  'ใช้ CTE ชื่อ `high_earners` เพื่อ select พนักงานที่มีเงินเดือน >= 80000 จากนั้น query จาก CTE นั้นเพื่อคืนค่า `first_name`, `last_name` และ `salary`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, last_name TEXT NOT NULL,
  salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',''Johnson'',85000),(2,''Bob'',''Smith'',72000),(3,''Carol'',''Williams'',92000),
(4,''David'',''Brown'',68000),(5,''Eve'',''Davis'',78000),(6,''Grace'',''Wilson'',95000);',
  'WITH high_earners AS (
  SELECT first_name, last_name, salary
  FROM employees
  WHERE salary >= 80000
)
SELECT first_name, last_name, salary FROM high_earners;',
  'WITH name AS (SELECT ...) defines a CTE. You can then SELECT from it like a regular table.',
  'WITH name AS (SELECT ...) กำหนด CTE คุณสามารถ SELECT จากมันได้เหมือนตารางปกติ',
  false,97) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'cte-dept-stats','CTE: Department Salary Stats','medium','cte',
  'Use a CTE `dept_stats` to compute each department''s average salary, then JOIN it to the employees table to show each employee''s `first_name`, `salary`, and their department''s `avg_salary`.',
  'ใช้ CTE `dept_stats` คำนวณเงินเดือนเฉลี่ยของแต่ละแผนก จากนั้น JOIN กับตาราง employees เพื่อแสดง `first_name`, `salary` และ `avg_salary` ของแผนก',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL,
  dept_id INT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',1,85000),(2,''Bob'',1,72000),(3,''Carol'',1,92000),
(4,''David'',2,68000),(5,''Eve'',2,78000),(6,''Frank'',2,65000);',
  'WITH dept_stats AS (
  SELECT dept_id, ROUND(AVG(salary), 2) AS avg_salary
  FROM employees
  GROUP BY dept_id
)
SELECT e.first_name, e.salary, ds.avg_salary
FROM employees e
JOIN dept_stats ds ON e.dept_id = ds.dept_id;',
  'Define the aggregation in the CTE, then JOIN it to avoid repeating the subquery per row.',
  'กำหนด aggregation ใน CTE แล้ว JOIN เพื่อหลีกเลี่ยงการทำ subquery ซ้ำในแต่ละแถว',
  false,98) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'cte-top-earner-per-dept','CTE: Top Earner Per Department','hard','cte',
  'Use a CTE with ROW_NUMBER() to find the single highest-paid employee in each department. Return `first_name`, `dept_id`, and `salary`.',
  'ใช้ CTE ร่วมกับ ROW_NUMBER() เพื่อหาพนักงานที่มีเงินเดือนสูงสุดเพียงคนเดียวในแต่ละแผนก คืนค่า `first_name`, `dept_id` และ `salary`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL,
  dept_id INT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',1,85000),(2,''Bob'',1,72000),(3,''Carol'',1,92000),
(4,''David'',2,68000),(5,''Eve'',2,78000),(6,''Frank'',3,91000),(7,''Grace'',3,88000);',
  'WITH ranked AS (
  SELECT first_name, dept_id, salary,
    ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn
  FROM employees
)
SELECT first_name, dept_id, salary FROM ranked WHERE rn = 1;',
  'Compute ROW_NUMBER in a CTE, then filter WHERE rn = 1 to get only the top row per group.',
  'คำนวณ ROW_NUMBER ใน CTE แล้วกรอง WHERE rn = 1 เพื่อเอาเฉพาะแถวสูงสุดของแต่ละกลุ่ม',
  false,99) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'cte-deduplication','CTE: Remove Duplicate Emails','hard','cte',
  'The `contacts` table has duplicate email addresses. Use a CTE with ROW_NUMBER() to return only the first occurrence of each email (lowest id). Return `id`, `name`, and `email`.',
  'ตาราง `contacts` มี email ที่ซ้ำกัน ใช้ CTE กับ ROW_NUMBER() เพื่อคืนค่าเฉพาะการปรากฏครั้งแรกของแต่ละ email (id ต่ำสุด) คืนค่า `id`, `name` และ `email`',
  'CREATE TEMP TABLE contacts (
  id INT PRIMARY KEY, name TEXT NOT NULL, email TEXT NOT NULL);',
  'INSERT INTO contacts VALUES
(1,''Alice'',''alice@example.com''),(2,''Bob'',''bob@example.com''),
(3,''Alice2'',''alice@example.com''),(4,''Carol'',''carol@example.com''),
(5,''Bob2'',''bob@example.com'');',
  'WITH deduped AS (
  SELECT id, name, email,
    ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS rn
  FROM contacts
)
SELECT id, name, email FROM deduped WHERE rn = 1;',
  'PARTITION BY email ORDER BY id ASC numbers rows per email, giving rn=1 to the earliest record.',
  'PARTITION BY email ORDER BY id ASC กำหนดหมายเลขแถวต่อ email โดย rn=1 คือ record เก่าสุด',
  false,100) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'recursive-cte-hierarchy','Recursive CTE: Org Chart','hard','cte',
  'Use a recursive CTE to traverse the employee hierarchy starting from the CEO (manager_id IS NULL). Return each employee''s `id`, `name`, and `level` (CEO = 1, direct reports = 2, etc.).',
  'ใช้ recursive CTE ในการ traverse โครงสร้างองค์กร เริ่มจาก CEO (manager_id IS NULL) คืนค่า `id`, `name` และ `level` ของพนักงาน (CEO = 1, รายงานตรง = 2 เป็นต้น)',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, name TEXT NOT NULL, manager_id INT);',
  'INSERT INTO employees VALUES
(1,''Alice (CEO)'',NULL),(2,''Bob'',1),(3,''Carol'',1),
(4,''David'',2),(5,''Eve'',2),(6,''Frank'',3),(7,''Grace'',4);',
  'WITH RECURSIVE hierarchy AS (
  SELECT id, name, manager_id, 1 AS level
  FROM employees WHERE manager_id IS NULL
  UNION ALL
  SELECT e.id, e.name, e.manager_id, h.level + 1
  FROM employees e
  JOIN hierarchy h ON e.manager_id = h.id
)
SELECT id, name, level FROM hierarchy ORDER BY level, id;',
  'A recursive CTE has two parts: an anchor (base case) and a recursive member joined with UNION ALL.',
  'Recursive CTE มีสองส่วน: anchor (base case) และส่วน recursive เชื่อมด้วย UNION ALL',
  true,101) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'multi-cte-pipeline','Multi-CTE Pipeline','hard','cte',
  'Use two CTEs: `dept_revenue` to sum order revenue per department, and `ranked_depts` to rank departments by revenue. Return department `name`, `total_revenue`, and `revenue_rank`. Order by `revenue_rank`.',
  'ใช้สอง CTE: `dept_revenue` เพื่อรวมรายรับต่อแผนก และ `ranked_depts` เพื่อจัดอันดับแผนกตามรายรับ คืนค่า `name`, `total_revenue` และ `revenue_rank` เรียงตาม `revenue_rank`',
  'CREATE TEMP TABLE departments (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE orders (id INT PRIMARY KEY, dept_id INT NOT NULL, amount NUMERIC(10,2) NOT NULL);',
  'INSERT INTO departments VALUES (1,''Engineering''),(2,''Marketing''),(3,''Sales'');
INSERT INTO orders VALUES
(1,1,5000),(2,1,3000),(3,2,7000),(4,2,2000),(5,3,9000),(6,3,4000),(7,3,6000);',
  'WITH dept_revenue AS (
  SELECT dept_id, SUM(amount) AS total_revenue
  FROM orders GROUP BY dept_id
),
ranked_depts AS (
  SELECT d.name, dr.total_revenue,
    RANK() OVER (ORDER BY dr.total_revenue DESC) AS revenue_rank
  FROM departments d
  JOIN dept_revenue dr ON d.id = dr.dept_id
)
SELECT name, total_revenue, revenue_rank FROM ranked_depts ORDER BY revenue_rank;',
  'Chain multiple CTEs with commas: WITH cte1 AS (...), cte2 AS (...) SELECT FROM cte2.',
  'เชื่อม CTE หลายตัวด้วยจุลภาค: WITH cte1 AS (...), cte2 AS (...) SELECT FROM cte2',
  true,102) ON CONFLICT (slug) DO NOTHING;

-- ══════════════════════════════════════════════════════════
-- GROUP 13: Analytics  (sort 103–113)
-- ══════════════════════════════════════════════════════════

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'year-over-year-revenue','Year-over-Year Revenue Comparison','hard','analytics',
  'Show each year''s total revenue alongside the previous year''s revenue as `prev_year_revenue` and the absolute change as `yoy_change`. Order by `order_year`.',
  'แสดงรายรับรวมของแต่ละปีพร้อมรายรับปีก่อนหน้าเป็น `prev_year_revenue` และส่วนต่างเป็น `yoy_change` เรียงตาม `order_year`',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, amount NUMERIC(10,2) NOT NULL, order_date DATE NOT NULL);',
  'INSERT INTO orders VALUES
(1,12000,''2022-03-10''),(2,18000,''2022-07-15''),(3,15000,''2022-11-20''),
(4,22000,''2023-01-05''),(5,19000,''2023-06-18''),(6,24000,''2023-10-30''),
(7,28000,''2024-02-14''),(8,31000,''2024-08-22'');',
  'WITH yearly AS (
  SELECT EXTRACT(YEAR FROM order_date)::INT AS order_year, SUM(amount) AS total_revenue
  FROM orders GROUP BY order_year
)
SELECT order_year, total_revenue,
  LAG(total_revenue) OVER (ORDER BY order_year) AS prev_year_revenue,
  total_revenue - LAG(total_revenue) OVER (ORDER BY order_year) AS yoy_change
FROM yearly
ORDER BY order_year;',
  'Aggregate by year in a CTE, then use LAG() OVER (ORDER BY year) for the previous year.',
  'รวมตามปีใน CTE แล้วใช้ LAG() OVER (ORDER BY year) สำหรับปีก่อนหน้า',
  true,103) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'customer-first-order','Customer First Order Date','easy','analytics',
  'Find the date of the first order for each customer. Return `customer_id` and `first_order_date`, ordered by `first_order_date`.',
  'ค้นหาวันที่คำสั่งซื้อแรกของแต่ละลูกค้า คืนค่า `customer_id` และ `first_order_date` เรียงตาม `first_order_date`',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, customer_id INT NOT NULL, amount NUMERIC(10,2), order_date DATE NOT NULL);',
  'INSERT INTO orders VALUES
(1,1,100,''2024-01-10''),(2,2,200,''2024-01-15''),(3,1,150,''2024-02-01''),
(4,3,300,''2024-01-20''),(5,2,180,''2024-03-05''),(6,3,220,''2024-02-28'');',
  'SELECT customer_id, MIN(order_date) AS first_order_date
FROM orders
GROUP BY customer_id
ORDER BY first_order_date;',
  'MIN(order_date) per customer returns the earliest order date.',
  'MIN(order_date) ต่อลูกค้าคืนค่าวันที่คำสั่งซื้อเก่าสุด',
  true,104) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'customer-cohort-analysis','Customer Cohort Analysis','hard','analytics',
  'Group customers by their acquisition month (the month of their first order) and count how many customers are in each cohort. Return `cohort_month` and `customer_count`, ordered by `cohort_month`.',
  'จัดกลุ่มลูกค้าตามเดือนที่เริ่มใช้งาน (เดือนของคำสั่งซื้อแรก) และนับจำนวนลูกค้าในแต่ละ cohort คืนค่า `cohort_month` และ `customer_count` เรียงตาม `cohort_month`',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, customer_id INT NOT NULL, order_date DATE NOT NULL);',
  'INSERT INTO orders VALUES
(1,1,''2024-01-10''),(2,2,''2024-01-15''),(3,3,''2024-01-20''),
(4,4,''2024-02-05''),(5,1,''2024-02-10''),(6,5,''2024-02-18''),
(7,6,''2024-03-01''),(8,2,''2024-03-08'');',
  'WITH first_orders AS (
  SELECT customer_id, DATE_TRUNC(''month'', MIN(order_date))::DATE AS cohort_month
  FROM orders GROUP BY customer_id
)
SELECT cohort_month, COUNT(*) AS customer_count
FROM first_orders
GROUP BY cohort_month
ORDER BY cohort_month;',
  'Find each customer''s first order month in a CTE, then GROUP BY that month.',
  'หาเดือนของคำสั่งซื้อแรกของแต่ละลูกค้าใน CTE แล้ว GROUP BY เดือนนั้น',
  true,105) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'repeat-customers','Repeat Customers','medium','analytics',
  'Find customers who have placed orders on 2 or more distinct dates (i.e., they came back). Return `customer_id` and `order_days` (number of distinct order dates).',
  'ค้นหาลูกค้าที่สั่งซื้อในวันที่ต่างกัน 2 วันขึ้นไป (กลับมาซื้อซ้ำ) คืนค่า `customer_id` และ `order_days` (จำนวนวันที่สั่งซื้อที่ต่างกัน)',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, customer_id INT NOT NULL, order_date DATE NOT NULL);',
  'INSERT INTO orders VALUES
(1,1,''2024-01-10''),(2,1,''2024-01-10''),(3,1,''2024-02-05''),
(4,2,''2024-01-15''),(5,3,''2024-02-01''),(6,3,''2024-02-28''),(7,3,''2024-03-10'');',
  'SELECT customer_id, COUNT(DISTINCT order_date) AS order_days
FROM orders
GROUP BY customer_id
HAVING COUNT(DISTINCT order_date) >= 2;',
  'COUNT(DISTINCT order_date) counts unique order dates per customer.',
  'COUNT(DISTINCT order_date) นับวันที่สั่งซื้อที่ไม่ซ้ำกันต่อลูกค้า',
  false,106) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'find-duplicate-emails','Find Duplicate Emails','easy','analytics',
  'Find all email addresses that appear more than once in the `users` table. Return `email` and `count`, ordered by `count` descending.',
  'ค้นหา email ทั้งหมดที่ปรากฏมากกว่าหนึ่งครั้งในตาราง `users` คืนค่า `email` และ `count` เรียงตาม `count` จากมากไปน้อย',
  'CREATE TEMP TABLE users (
  id INT PRIMARY KEY, name TEXT NOT NULL, email TEXT NOT NULL);',
  'INSERT INTO users VALUES
(1,''Alice'',''alice@example.com''),(2,''Bob'',''bob@example.com''),
(3,''Alice2'',''alice@example.com''),(4,''Carol'',''carol@example.com''),
(5,''Bob2'',''bob@example.com''),(6,''Bob3'',''bob@example.com'');',
  'SELECT email, COUNT(*) AS count
FROM users
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY count DESC;',
  'GROUP BY email then HAVING COUNT(*) > 1 to find emails appearing more than once.',
  'GROUP BY email แล้ว HAVING COUNT(*) > 1 เพื่อหา email ที่ปรากฏมากกว่าหนึ่งครั้ง',
  true,107) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'median-salary','Median Salary','hard','analytics',
  'Calculate the median salary of all employees. Return a single column `median_salary`.',
  'คำนวณเงินเดือนมัธยฐาน (median) ของพนักงานทั้งหมด คืนค่าคอลัมน์เดียวชื่อ `median_salary`',
  'CREATE TEMP TABLE employees (
  id INT PRIMARY KEY, first_name TEXT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO employees VALUES
(1,''Alice'',85000),(2,''Bob'',72000),(3,''Carol'',92000),
(4,''David'',65000),(5,''Eve'',78000),(6,''Frank'',68000),(7,''Grace'',95000);',
  'SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary FROM employees;',
  'PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) is the PostgreSQL way to compute the median.',
  'PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) คือวิธีคำนวณ median ใน PostgreSQL',
  false,108) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'quarterly-revenue-pivot','Quarterly Revenue Pivot','hard','analytics',
  'Write a query showing total revenue broken out by quarter in a single row. Return `q1`, `q2`, `q3`, `q4` (sum of amounts in each quarter for 2024).',
  'เขียน query แสดงรายรับรวมแยกตามไตรมาสในแถวเดียว คืนค่า `q1`, `q2`, `q3`, `q4` (ผลรวมยอดในแต่ละไตรมาสของปี 2024)',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, amount NUMERIC(10,2) NOT NULL, order_date DATE NOT NULL);',
  'INSERT INTO orders VALUES
(1,1000,''2024-01-15''),(2,1500,''2024-02-20''),(3,800,''2024-03-10''),
(4,2000,''2024-04-05''),(5,1200,''2024-05-18''),(6,900,''2024-06-30''),
(7,3000,''2024-07-22''),(8,1800,''2024-08-14''),(9,2200,''2024-09-05''),
(10,2500,''2024-10-11''),(11,3100,''2024-11-20''),(12,4000,''2024-12-25'');',
  'SELECT
  SUM(CASE WHEN EXTRACT(QUARTER FROM order_date) = 1 THEN amount ELSE 0 END) AS q1,
  SUM(CASE WHEN EXTRACT(QUARTER FROM order_date) = 2 THEN amount ELSE 0 END) AS q2,
  SUM(CASE WHEN EXTRACT(QUARTER FROM order_date) = 3 THEN amount ELSE 0 END) AS q3,
  SUM(CASE WHEN EXTRACT(QUARTER FROM order_date) = 4 THEN amount ELSE 0 END) AS q4
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2024;',
  'Use SUM(CASE WHEN quarter = N ...) to pivot rows into columns.',
  'ใช้ SUM(CASE WHEN quarter = N ...) เพื่อ pivot แถวเป็นคอลัมน์',
  false,109) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'customer-lifetime-value','Customer Lifetime Value (CLV)','medium','analytics',
  'Calculate total lifetime spend per customer. Return `customer_id`, `total_orders`, and `lifetime_value`, ordered by `lifetime_value` descending.',
  'คำนวณยอดใช้จ่ายสะสมทั้งหมดต่อลูกค้า คืนค่า `customer_id`, `total_orders` และ `lifetime_value` เรียงตาม `lifetime_value` จากมากไปน้อย',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, customer_id INT NOT NULL, amount NUMERIC(10,2) NOT NULL);',
  'INSERT INTO orders VALUES
(1,1,250),(2,1,320),(3,2,180),(4,2,95),(5,2,430),
(6,3,600),(7,3,150),(8,4,80),(9,1,450),(10,3,280);',
  'SELECT customer_id,
  COUNT(*) AS total_orders,
  SUM(amount) AS lifetime_value
FROM orders
GROUP BY customer_id
ORDER BY lifetime_value DESC;',
  'COUNT(*) for number of orders, SUM(amount) for total spend — both grouped per customer.',
  'COUNT(*) สำหรับจำนวนคำสั่งซื้อ, SUM(amount) สำหรับยอดรวม ทั้งคู่ GROUP BY ต่อลูกค้า',
  true,110) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'product-revenue-market-share','Product Revenue Market Share','hard','analytics',
  'Calculate each product''s total revenue and its percentage share of total revenue as `revenue_pct` (rounded to 2 decimal places). Order by `total_revenue` descending.',
  'คำนวณรายรับรวมของแต่ละผลิตภัณฑ์และเปอร์เซ็นต์ส่วนแบ่งรายรับเป็น `revenue_pct` (ปัดทศนิยม 2 ตำแหน่ง) เรียงตาม `total_revenue` จากมากไปน้อย',
  'CREATE TEMP TABLE products (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE order_items (id INT PRIMARY KEY, product_id INT NOT NULL, quantity INT NOT NULL, unit_price NUMERIC(10,2) NOT NULL);',
  'INSERT INTO products VALUES (1,''Laptop''),(2,''Mouse''),(3,''Keyboard''),(4,''Monitor'');
INSERT INTO order_items VALUES
(1,1,2,1200),(2,2,10,25),(3,3,5,75),(4,4,1,400),(5,1,1,1200),(6,2,8,25),(7,4,2,400);',
  'WITH product_rev AS (
  SELECT p.name, SUM(oi.quantity * oi.unit_price) AS total_revenue
  FROM products p
  JOIN order_items oi ON p.id = oi.product_id
  GROUP BY p.id, p.name
)
SELECT name, total_revenue,
  ROUND(total_revenue * 100.0 / SUM(total_revenue) OVER (), 2) AS revenue_pct
FROM product_rev
ORDER BY total_revenue DESC;',
  'Use SUM() OVER () as a window function to get the grand total for percentage calculation.',
  'ใช้ SUM() OVER () เป็น window function เพื่อได้ผลรวมทั้งหมดสำหรับคำนวณเปอร์เซ็นต์',
  true,111) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'daily-active-users','Daily Active Users (DAU)','medium','analytics',
  'Count how many distinct users were active (placed an order) on each day. Return `order_date` and `daily_active_users`, ordered by `order_date`.',
  'นับจำนวน user ที่ไม่ซ้ำที่ active (สั่งซื้อ) ในแต่ละวัน คืนค่า `order_date` และ `daily_active_users` เรียงตาม `order_date`',
  'CREATE TEMP TABLE orders (
  id INT PRIMARY KEY, user_id INT NOT NULL, order_date DATE NOT NULL);',
  'INSERT INTO orders VALUES
(1,1,''2024-01-10''),(2,2,''2024-01-10''),(3,1,''2024-01-10''),
(4,3,''2024-01-11''),(5,1,''2024-01-11''),(6,4,''2024-01-12''),
(7,2,''2024-01-12''),(8,3,''2024-01-12''),(9,4,''2024-01-12'');',
  'SELECT order_date, COUNT(DISTINCT user_id) AS daily_active_users
FROM orders
GROUP BY order_date
ORDER BY order_date;',
  'COUNT(DISTINCT user_id) counts unique users per day, ignoring duplicate orders from the same user.',
  'COUNT(DISTINCT user_id) นับ user ที่ไม่ซ้ำต่อวัน ไม่นับคำสั่งซื้อซ้ำจาก user เดียวกัน',
  true,112) ON CONFLICT (slug) DO NOTHING;

INSERT INTO sql_challenges (slug,title,difficulty,category,description,description_th,table_schema,seed_data,solution_sql,hint,hint_th,order_sensitive,sort_order) VALUES (
  'employee-full-pipeline','Employee Analytics Pipeline','hard','analytics',
  'Write a single query that shows each department''s name, employee count, average salary, highest salary, and the name of the top earner. Order by average salary descending.',
  'เขียน query เดียวที่แสดงชื่อแผนก จำนวนพนักงาน เงินเดือนเฉลี่ย เงินเดือนสูงสุด และชื่อพนักงานที่มีเงินเดือนสูงสุด เรียงตามเงินเดือนเฉลี่ยจากมากไปน้อย',
  'CREATE TEMP TABLE departments (id INT PRIMARY KEY, name TEXT NOT NULL);
CREATE TEMP TABLE employees (id INT PRIMARY KEY, first_name TEXT NOT NULL, dept_id INT NOT NULL, salary NUMERIC(10,2) NOT NULL);',
  'INSERT INTO departments VALUES (1,''Engineering''),(2,''Marketing''),(3,''HR'');
INSERT INTO employees VALUES
(1,''Alice'',1,92000),(2,''Bob'',1,85000),(3,''Carol'',1,78000),
(4,''David'',2,72000),(5,''Eve'',2,68000),(6,''Frank'',3,95000),(7,''Grace'',3,88000);',
  'WITH dept_stats AS (
  SELECT dept_id,
    COUNT(*) AS emp_count,
    ROUND(AVG(salary), 2) AS avg_salary,
    MAX(salary) AS max_salary
  FROM employees GROUP BY dept_id
),
top_earners AS (
  SELECT dept_id, first_name AS top_earner
  FROM (
    SELECT dept_id, first_name,
      ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn
    FROM employees
  ) r WHERE rn = 1
)
SELECT d.name, ds.emp_count, ds.avg_salary, ds.max_salary, te.top_earner
FROM departments d
JOIN dept_stats ds ON d.id = ds.dept_id
JOIN top_earners te ON d.id = te.dept_id
ORDER BY ds.avg_salary DESC;',
  'Break it into two CTEs: one for aggregate stats, one for the top earner name (ROW_NUMBER). Then JOIN both to departments.',
  'แบ่งเป็นสอง CTE: อันหนึ่งสำหรับ aggregate stats อีกอันสำหรับชื่อผู้มีเงินเดือนสูงสุด (ROW_NUMBER) แล้ว JOIN ทั้งคู่กับ departments',
  true,113) ON CONFLICT (slug) DO NOTHING;
