-- Education Center Database - Sample Queries
-- This file contains example queries demonstrating JOINs, filtering, sorting, and aggregation
-- These queries transform raw data into meaningful management information

-- ============================================================================
-- QUERY 1: List all students with their enrolled groups and course information
-- Demonstrates: INNER JOIN, multiple table joins
-- ============================================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    s.email,
    g.group_name,
    c.course_name,
    c.course_type,
    e.enrollment_date,
    e.status AS enrollment_status
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN groups g ON e.group_id = g.group_id
INNER JOIN courses c ON g.course_id = c.course_id
ORDER BY s.last_name, s.first_name, e.enrollment_date;

-- ============================================================================
-- QUERY 2: List all groups with their assigned teacher and course details
-- Demonstrates: INNER JOIN, LEFT JOIN (to show groups without teachers if any)
-- ============================================================================
SELECT 
    g.group_id,
    g.group_name,
    c.course_name,
    c.course_type,
    c.price,
    t.first_name || ' ' || t.last_name AS teacher_name,
    t.specialization,
    g.start_date,
    g.end_date,
    g.schedule,
    g.max_capacity,
    (SELECT COUNT(*) FROM enrollments WHERE group_id = g.group_id) AS current_enrollments
FROM groups g
INNER JOIN courses c ON g.course_id = c.course_id
INNER JOIN teachers t ON g.teacher_id = t.teacher_id
ORDER BY c.course_type, g.start_date;

-- ============================================================================
-- QUERY 3: Student attendance report for a specific group
-- Demonstrates: JOIN, filtering, date functions
-- ============================================================================
SELECT 
    s.first_name || ' ' || s.last_name AS student_name,
    g.group_name,
    a.attendance_date,
    a.status AS attendance_status,
    a.notes
FROM attendances a
INNER JOIN enrollments e ON a.enrollment_id = e.enrollment_id
INNER JOIN students s ON e.student_id = s.student_id
INNER JOIN groups g ON e.group_id = g.group_id
WHERE g.group_name = 'Python-2024-A'
ORDER BY a.attendance_date, s.last_name;

-- ============================================================================
-- QUERY 4: Attendance statistics per student
-- Demonstrates: JOIN, GROUP BY, aggregation (COUNT, CASE)
-- ============================================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    g.group_name,
    COUNT(a.attendance_id) AS total_classes,
    COUNT(CASE WHEN a.status = 'Present' THEN 1 END) AS present_count,
    COUNT(CASE WHEN a.status = 'Absent' THEN 1 END) AS absent_count,
    COUNT(CASE WHEN a.status = 'Late' THEN 1 END) AS late_count,
    ROUND(
        COUNT(CASE WHEN a.status = 'Present' THEN 1 END)::NUMERIC / 
        NULLIF(COUNT(a.attendance_id), 0) * 100, 
        2
    ) AS attendance_percentage
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN groups g ON e.group_id = g.group_id
LEFT JOIN attendances a ON e.enrollment_id = a.enrollment_id
WHERE e.status = 'Active'
GROUP BY s.student_id, s.first_name, s.last_name, g.group_name
ORDER BY attendance_percentage DESC, s.last_name;

-- ============================================================================
-- QUERY 5: Payment summary per enrollment
-- Demonstrates: JOIN, GROUP BY, aggregation (SUM, COUNT)
-- ============================================================================
SELECT 
    s.first_name || ' ' || s.last_name AS student_name,
    g.group_name,
    c.course_name,
    c.price AS course_price,
    COUNT(p.payment_id) AS payment_count,
    COALESCE(SUM(CASE WHEN p.status = 'Completed' THEN p.amount ELSE 0 END), 0) AS total_paid,
    COALESCE(SUM(CASE WHEN p.status = 'Pending' THEN p.amount ELSE 0 END), 0) AS pending_amount,
    (c.price - COALESCE(SUM(CASE WHEN p.status = 'Completed' THEN p.amount ELSE 0 END), 0)) AS outstanding_balance
FROM enrollments e
INNER JOIN students s ON e.student_id = s.student_id
INNER JOIN groups g ON e.group_id = g.group_id
INNER JOIN courses c ON g.course_id = c.course_id
LEFT JOIN payments p ON e.enrollment_id = p.enrollment_id
WHERE e.status = 'Active'
GROUP BY s.student_id, s.first_name, s.last_name, g.group_name, c.course_name, c.price
ORDER BY outstanding_balance DESC, s.last_name;

-- ============================================================================
-- QUERY 6: Students with outstanding payments
-- Demonstrates: JOIN, GROUP BY, HAVING clause, aggregation
-- ============================================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    s.email,
    s.phone,
    g.group_name,
    c.course_name,
    c.price AS course_price,
    COALESCE(SUM(CASE WHEN p.status = 'Completed' THEN p.amount ELSE 0 END), 0) AS total_paid,
    (c.price - COALESCE(SUM(CASE WHEN p.status = 'Completed' THEN p.amount ELSE 0 END), 0)) AS outstanding_balance
FROM enrollments e
INNER JOIN students s ON e.student_id = s.student_id
INNER JOIN groups g ON e.group_id = g.group_id
INNER JOIN courses c ON g.course_id = c.course_id
LEFT JOIN payments p ON e.enrollment_id = p.enrollment_id
WHERE e.status = 'Active'
GROUP BY s.student_id, s.first_name, s.last_name, s.email, s.phone, g.group_name, c.course_name, c.price
HAVING (c.price - COALESCE(SUM(CASE WHEN p.status = 'Completed' THEN p.amount ELSE 0 END), 0)) > 0
ORDER BY outstanding_balance DESC;

-- ============================================================================
-- QUERY 7: Course enrollment statistics
-- Demonstrates: JOIN, GROUP BY, aggregation (COUNT, AVG)
-- ============================================================================
SELECT 
    c.course_id,
    c.course_name,
    c.course_type,
    c.price,
    COUNT(DISTINCT g.group_id) AS total_groups,
    COUNT(DISTINCT e.enrollment_id) AS total_enrollments,
    COUNT(DISTINCT e.student_id) AS unique_students,
    AVG(g.max_capacity) AS avg_group_capacity,
    SUM(g.max_capacity) AS total_capacity
FROM courses c
LEFT JOIN groups g ON c.course_id = g.course_id
LEFT JOIN enrollments e ON g.group_id = e.group_id AND e.status = 'Active'
GROUP BY c.course_id, c.course_name, c.course_type, c.price
ORDER BY total_enrollments DESC;

-- ============================================================================
-- QUERY 8: Teacher workload report
-- Demonstrates: JOIN, GROUP BY, aggregation, date filtering
-- ============================================================================
SELECT 
    t.teacher_id,
    t.first_name || ' ' || t.last_name AS teacher_name,
    t.specialization,
    COUNT(DISTINCT g.group_id) AS active_groups,
    COUNT(DISTINCT e.enrollment_id) AS total_students,
    COUNT(DISTINCT c.course_id) AS courses_taught,
    MIN(g.start_date) AS earliest_group_start,
    MAX(g.end_date) AS latest_group_end
FROM teachers t
LEFT JOIN groups g ON t.teacher_id = g.teacher_id
LEFT JOIN courses c ON g.course_id = c.course_id
LEFT JOIN enrollments e ON g.group_id = e.group_id AND e.status = 'Active'
WHERE g.end_date >= CURRENT_DATE OR g.end_date IS NULL
GROUP BY t.teacher_id, t.first_name, t.last_name, t.specialization
ORDER BY active_groups DESC, teacher_name;

-- ============================================================================
-- QUERY 9: Monthly revenue report
-- Demonstrates: JOIN, date functions, GROUP BY, aggregation (SUM)
-- ============================================================================
SELECT 
    DATE_TRUNC('month', p.payment_date) AS payment_month,
    COUNT(DISTINCT p.payment_id) AS total_transactions,
    COUNT(DISTINCT p.enrollment_id) AS enrollments_paid,
    SUM(p.amount) AS total_revenue,
    AVG(p.amount) AS average_payment,
    COUNT(CASE WHEN p.payment_method = 'Card' THEN 1 END) AS card_payments,
    COUNT(CASE WHEN p.payment_method = 'Cash' THEN 1 END) AS cash_payments,
    COUNT(CASE WHEN p.payment_method = 'Bank Transfer' THEN 1 END) AS transfer_payments
FROM payments p
WHERE p.status = 'Completed'
GROUP BY DATE_TRUNC('month', p.payment_date)
ORDER BY payment_month DESC;

-- ============================================================================
-- QUERY 10: Students enrolled in multiple courses
-- Demonstrates: JOIN, GROUP BY, HAVING clause
-- ============================================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    s.email,
    COUNT(DISTINCT e.enrollment_id) AS total_enrollments,
    COUNT(DISTINCT c.course_id) AS courses_enrolled,
    STRING_AGG(DISTINCT c.course_name, ', ' ORDER BY c.course_name) AS courses_list
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN groups g ON e.group_id = g.group_id
INNER JOIN courses c ON g.course_id = c.course_id
WHERE e.status = 'Active'
GROUP BY s.student_id, s.first_name, s.last_name, s.email
HAVING COUNT(DISTINCT c.course_id) > 1
ORDER BY courses_enrolled DESC, s.last_name;

-- ============================================================================
-- QUERY 11: Groups with low enrollment (below 50% capacity)
-- Demonstrates: JOIN, subquery, aggregation, filtering
-- ============================================================================
SELECT 
    g.group_id,
    g.group_name,
    c.course_name,
    g.max_capacity,
    COUNT(e.enrollment_id) AS current_enrollments,
    ROUND(COUNT(e.enrollment_id)::NUMERIC / g.max_capacity * 100, 2) AS enrollment_percentage,
    g.start_date,
    g.end_date
FROM groups g
INNER JOIN courses c ON g.course_id = c.course_id
LEFT JOIN enrollments e ON g.group_id = e.group_id AND e.status = 'Active'
GROUP BY g.group_id, g.group_name, c.course_name, g.max_capacity, g.start_date, g.end_date
HAVING COUNT(e.enrollment_id)::NUMERIC / g.max_capacity < 0.5
ORDER BY enrollment_percentage ASC, g.start_date;

-- ============================================================================
-- QUERY 12: Complete student profile with all related information
-- Demonstrates: Multiple JOINs, comprehensive data retrieval
-- ============================================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    s.email,
    s.phone,
    s.date_of_birth,
    s.enrollment_date AS student_enrollment_date,
    g.group_name,
    c.course_name,
    c.course_type,
    t.first_name || ' ' || t.last_name AS teacher_name,
    e.enrollment_date,
    e.status AS enrollment_status,
    COUNT(DISTINCT a.attendance_id) AS attendance_records,
    COUNT(DISTINCT p.payment_id) AS payment_records,
    COALESCE(SUM(CASE WHEN p.status = 'Completed' THEN p.amount ELSE 0 END), 0) AS total_paid
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN groups g ON e.group_id = g.group_id
LEFT JOIN courses c ON g.course_id = c.course_id
LEFT JOIN teachers t ON g.teacher_id = t.teacher_id
LEFT JOIN attendances a ON e.enrollment_id = a.enrollment_id
LEFT JOIN payments p ON e.enrollment_id = p.enrollment_id
WHERE s.student_id = 1  -- Replace with specific student_id or remove WHERE for all students
GROUP BY s.student_id, s.first_name, s.last_name, s.email, s.phone, s.date_of_birth, 
         s.enrollment_date, g.group_name, c.course_name, c.course_type, 
         t.first_name, t.last_name, e.enrollment_date, e.status
ORDER BY e.enrollment_date DESC;
