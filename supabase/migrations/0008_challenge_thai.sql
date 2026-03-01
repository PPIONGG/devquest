-- ============================================================
-- ADD Thai translations for challenge descriptions & hints
-- ============================================================

ALTER TABLE sql_challenges ADD COLUMN IF NOT EXISTS description_th TEXT DEFAULT '';
ALTER TABLE sql_challenges ADD COLUMN IF NOT EXISTS hint_th TEXT DEFAULT '';

-- 1. select-all-employees
UPDATE sql_challenges SET
  description_th = 'เขียน query เพื่อดึงข้อมูลทุกคอลัมน์และทุกแถวจากตาราง `employees`',
  hint_th = 'ใช้ SELECT * เพื่อดึงทุกคอลัมน์'
WHERE slug = 'select-all-employees';

-- 2. employee-names-and-salaries
UPDATE sql_challenges SET
  description_th = 'เขียน query เพื่อดึงเฉพาะคอลัมน์ `first_name`, `last_name` และ `salary` จากตาราง `employees`',
  hint_th = 'ระบุชื่อคอลัมน์ที่ต้องการ คั่นด้วยเครื่องหมายจุลภาค (comma)'
WHERE slug = 'employee-names-and-salaries';

-- 3. unique-departments
UPDATE sql_challenges SET
  description_th = 'เขียน query เพื่อดึงค่า `department_id` ที่ไม่ซ้ำกัน (distinct) ทั้งหมดจากตาราง `employees` โดยคืนค่าคอลัมน์เดียวชื่อ `department_id`',
  hint_th = 'ใช้คีย์เวิร์ด DISTINCT หลัง SELECT'
WHERE slug = 'unique-departments';

-- 4. top-5-earners
UPDATE sql_challenges SET
  description_th = 'เขียน query เพื่อดึง `first_name`, `last_name` และ `salary` ของพนักงาน 5 อันดับที่มีเงินเดือนสูงสุด โดยเรียงลำดับเงินเดือนจากมากไปน้อย',
  hint_th = 'ใช้ ORDER BY ... DESC และ LIMIT'
WHERE slug = 'top-5-earners';

-- 5. high-salary-employees
UPDATE sql_challenges SET
  description_th = 'เขียน query เพื่อค้นหาพนักงานทุกคนที่มีเงินเดือนมากกว่า 75000 โดยคืนค่าทุกคอลัมน์',
  hint_th = 'ใช้ WHERE กับตัวดำเนินการเปรียบเทียบ (comparison operator)'
WHERE slug = 'high-salary-employees';

-- 6. customers-in-london
UPDATE sql_challenges SET
  description_th = 'ค้นหาลูกค้าทุกคนที่อาศัยอยู่ในลอนดอน โดยคืนค่าทุกคอลัมน์จากตาราง `customers`',
  hint_th = 'ใช้ WHERE clause เพื่อกรองตามเมือง (city)'
WHERE slug = 'customers-in-london';

-- 7. it-department-employees
UPDATE sql_challenges SET
  description_th = 'เขียน query เพื่อค้นหาพนักงานทุกคนที่ทำงานในแผนก IT โดยคืนค่า `first_name`, `last_name` ของพนักงาน และ `name` ของแผนก',
  hint_th = 'ใช้ JOIN เพื่อเชื่อมตาราง employees กับ departments แล้วกรองด้วย WHERE'
WHERE slug = 'it-department-employees';

-- 8. employees-per-department
UPDATE sql_challenges SET
  description_th = 'เขียน query เพื่อนับจำนวนพนักงานในแต่ละแผนก โดยคืนค่า `name` ของแผนกและจำนวนพนักงาน (`count`) รวมถึงแผนกที่ไม่มีพนักงานด้วย',
  hint_th = 'ใช้ LEFT JOIN เพื่อให้แผนกที่ไม่มีพนักงานแสดงด้วย จากนั้นใช้ GROUP BY และ COUNT'
WHERE slug = 'employees-per-department';

-- 9. total-revenue
UPDATE sql_challenges SET
  description_th = 'เขียน query เพื่อคำนวณรายได้รวม (total revenue) จากคำสั่งซื้อทั้งหมด โดยคืนค่าคอลัมน์เดียวชื่อ `total_revenue`',
  hint_th = 'ใช้ฟังก์ชัน SUM() ซึ่งเป็น aggregate function'
WHERE slug = 'total-revenue';

-- 10. users-with-no-posts
UPDATE sql_challenges SET
  description_th = 'ค้นหาผู้ใช้ทุกคนที่ไม่เคยสร้างโพสต์เลย โดยคืนค่า `id` และ `username`',
  hint_th = 'ใช้ LEFT JOIN แล้วกรองด้วย WHERE ที่ post id IS NULL'
WHERE slug = 'users-with-no-posts';

-- 11. salary-above-dept-average
UPDATE sql_challenges SET
  description_th = 'ค้นหาพนักงานทุกคนที่มีเงินเดือนสูงกว่าค่าเฉลี่ยของแผนกตนเอง โดยคืนค่า `first_name`, `last_name`, `salary` และ `dept_id`',
  hint_th = 'ใช้ correlated subquery ใน WHERE clause โดยอ้างอิง dept_id จาก query ภายนอก'
WHERE slug = 'salary-above-dept-average';

-- 12. rank-employees-by-salary
UPDATE sql_challenges SET
  description_th = 'เขียน query เพื่อจัดอันดับพนักงานตามเงินเดือนภายในแต่ละแผนก โดยคืนค่า `first_name`, `last_name`, `dept_id`, `salary` และ `salary_rank` (1 = เงินเดือนสูงสุดในแผนก)',
  hint_th = 'ใช้ RANK() ร่วมกับ PARTITION BY dept_id และ ORDER BY salary DESC'
WHERE slug = 'rank-employees-by-salary';

-- 13. top-customers-by-spending
UPDATE sql_challenges SET
  description_th = 'ใช้ CTE เพื่อค้นหาลูกค้าที่มียอดใช้จ่ายรวมมากกว่า $500 โดยคืนค่า `customer_id` และ `total_spent` เรียงตาม total_spent จากมากไปน้อย',
  hint_th = 'สร้าง CTE ที่จัดกลุ่มคำสั่งซื้อตามลูกค้าและรวมยอด จากนั้นกรองผลลัพธ์'
WHERE slug = 'top-customers-by-spending';
