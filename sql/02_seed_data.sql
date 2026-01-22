-- Education Center Database - Seed Data
-- This script populates the database with meaningful test data
-- Execute after schema.sql

-- ============================================================================
-- INSERT: Students
-- ============================================================================
INSERT INTO students (first_name, last_name, email, phone, date_of_birth, address, enrollment_date) VALUES
('John', 'Smith', 'john.smith@email.com', '+1-555-0101', '1995-03-15', '123 Main St, City, State 12345', '2024-01-10'),
('Emily', 'Johnson', 'emily.johnson@email.com', '+1-555-0102', '1998-07-22', '456 Oak Ave, City, State 12345', '2024-01-12'),
('Michael', 'Williams', 'michael.williams@email.com', '+1-555-0103', '1996-11-08', '789 Pine Rd, City, State 12345', '2024-01-15'),
('Sarah', 'Brown', 'sarah.brown@email.com', '+1-555-0104', '1997-05-30', '321 Elm St, City, State 12345', '2024-02-01'),
('David', 'Jones', 'david.jones@email.com', '+1-555-0105', '1999-09-14', '654 Maple Dr, City, State 12345', '2024-02-05'),
('Jessica', 'Garcia', 'jessica.garcia@email.com', '+1-555-0106', '1994-12-03', '987 Cedar Ln, City, State 12345', '2024-02-10'),
('Christopher', 'Miller', 'christopher.miller@email.com', '+1-555-0107', '1996-02-18', '147 Birch Way, City, State 12345', '2024-02-15'),
('Amanda', 'Davis', 'amanda.davis@email.com', '+1-555-0108', '1998-08-25', '258 Spruce Ct, City, State 12345', '2024-03-01'),
('James', 'Rodriguez', 'james.rodriguez@email.com', '+1-555-0109', '1995-04-11', '369 Willow Pl, City, State 12345', '2024-03-05'),
('Lisa', 'Martinez', 'lisa.martinez@email.com', '+1-555-0110', '1997-10-19', '741 Ash Blvd, City, State 12345', '2024-03-10');

-- ============================================================================
-- INSERT: Teachers
-- ============================================================================
INSERT INTO teachers (first_name, last_name, email, phone, specialization, hire_date) VALUES
('Robert', 'Anderson', 'robert.anderson@education.com', '+1-555-0201', 'Python Programming', '2020-01-15'),
('Maria', 'Gonzalez', 'maria.gonzalez@education.com', '+1-555-0202', 'Spanish Language', '2019-06-01'),
('Thomas', 'Wilson', 'thomas.wilson@education.com', '+1-555-0203', 'Java Programming', '2021-03-10'),
('Jennifer', 'Moore', 'jennifer.moore@education.com', '+1-555-0204', 'French Language', '2020-09-20'),
('William', 'Taylor', 'william.taylor@education.com', '+1-555-0205', 'Web Development', '2021-01-05'),
('Patricia', 'Jackson', 'patricia.jackson@education.com', '+1-555-0206', 'PMP Certification', '2019-11-12'),
('Richard', 'White', 'richard.white@education.com', '+1-555-0207', 'German Language', '2020-05-18'),
('Linda', 'Harris', 'linda.harris@education.com', '+1-555-0208', 'Data Science', '2021-07-22');

-- ============================================================================
-- INSERT: Courses
-- ============================================================================
INSERT INTO courses (course_name, course_type, description, duration_weeks, price) VALUES
('Python Fundamentals', 'Programming', 'Learn Python programming from basics to advanced concepts', 12, 899.00),
('Java Programming', 'Programming', 'Comprehensive Java programming course covering OOP and frameworks', 16, 1199.00),
('Web Development Bootcamp', 'Programming', 'Full-stack web development with HTML, CSS, JavaScript, and React', 20, 1499.00),
('Spanish for Beginners', 'Foreign Language', 'Learn Spanish from scratch with focus on conversation', 10, 599.00),
('French Intermediate', 'Foreign Language', 'Intermediate French course for continuing learners', 12, 699.00),
('German Advanced', 'Foreign Language', 'Advanced German language course for fluent speakers', 14, 799.00),
('PMP Certification Prep', 'Professional Certification', 'Prepare for Project Management Professional certification exam', 8, 1299.00),
('Data Science with Python', 'Programming', 'Data analysis, machine learning, and visualization with Python', 18, 1599.00);

-- ============================================================================
-- INSERT: Groups
-- ============================================================================
INSERT INTO groups (course_id, group_name, start_date, end_date, schedule, max_capacity, teacher_id) VALUES
(1, 'Python-2024-A', '2024-01-15', '2024-04-08', 'Monday, Wednesday, Friday 18:00-20:00', 20, 1),
(1, 'Python-2024-B', '2024-03-01', '2024-05-24', 'Tuesday, Thursday 19:00-21:00', 15, 1),
(2, 'Java-2024-A', '2024-02-01', '2024-05-20', 'Monday, Wednesday 18:30-20:30', 18, 3),
(3, 'WebDev-2024-A', '2024-01-20', '2024-06-10', 'Saturday, Sunday 10:00-14:00', 25, 5),
(4, 'Spanish-2024-A', '2024-02-05', '2024-04-15', 'Monday, Wednesday, Friday 17:00-19:00', 20, 2),
(4, 'Spanish-2024-B', '2024-03-15', '2024-05-24', 'Tuesday, Thursday 18:00-20:00', 20, 2),
(5, 'French-2024-A', '2024-02-10', '2024-05-05', 'Monday, Wednesday 19:00-21:00', 15, 4),
(6, 'German-2024-A', '2024-03-01', '2024-06-10', 'Saturday 14:00-18:00', 12, 7),
(7, 'PMP-2024-A', '2024-01-25', '2024-03-18', 'Sunday 09:00-13:00', 30, 6),
(8, 'DataScience-2024-A', '2024-02-15', '2024-06-24', 'Tuesday, Thursday, Saturday 18:00-20:00', 22, 8);

-- ============================================================================
-- INSERT: Enrollments
-- ============================================================================
INSERT INTO enrollments (student_id, group_id, enrollment_date, status) VALUES
(1, 1, '2024-01-10', 'Active'),
(2, 1, '2024-01-12', 'Active'),
(3, 1, '2024-01-15', 'Active'),
(4, 2, '2024-02-01', 'Active'),
(5, 2, '2024-02-05', 'Active'),
(1, 3, '2024-01-20', 'Active'),
(6, 3, '2024-02-10', 'Active'),
(7, 4, '2024-01-18', 'Active'),
(8, 4, '2024-02-28', 'Active'),
(2, 5, '2024-02-03', 'Active'),
(9, 5, '2024-02-05', 'Active'),
(10, 5, '2024-03-08', 'Active'),
(3, 6, '2024-03-12', 'Active'),
(4, 7, '2024-02-08', 'Active'),
(5, 8, '2024-02-28', 'Active'),
(6, 9, '2024-01-22', 'Active'),
(7, 9, '2024-01-25', 'Active'),
(8, 10, '2024-02-12', 'Active'),
(9, 10, '2024-02-15', 'Active'),
(10, 1, '2024-01-25', 'Completed');

-- ============================================================================
-- INSERT: Attendances
-- ============================================================================
-- Sample attendance records for various enrollments
INSERT INTO attendances (enrollment_id, attendance_date, status, notes) VALUES
(1, '2024-01-15', 'Present', NULL),
(1, '2024-01-17', 'Present', NULL),
(1, '2024-01-19', 'Late', 'Arrived 15 minutes late'),
(1, '2024-01-22', 'Present', NULL),
(1, '2024-01-24', 'Absent', 'Sick leave'),
(2, '2024-01-15', 'Present', NULL),
(2, '2024-01-17', 'Present', NULL),
(2, '2024-01-19', 'Present', NULL),
(2, '2024-01-22', 'Present', NULL),
(2, '2024-01-24', 'Present', NULL),
(3, '2024-01-15', 'Present', NULL),
(3, '2024-01-17', 'Absent', NULL),
(3, '2024-01-19', 'Present', NULL),
(4, '2024-03-01', 'Present', NULL),
(4, '2024-03-05', 'Present', NULL),
(4, '2024-03-07', 'Late', 'Traffic delay'),
(5, '2024-03-01', 'Present', NULL),
(5, '2024-03-05', 'Present', NULL),
(6, '2024-02-01', 'Present', NULL),
(6, '2024-02-05', 'Present', NULL),
(6, '2024-02-07', 'Present', NULL),
(7, '2024-02-10', 'Present', NULL),
(7, '2024-02-12', 'Absent', 'Family emergency'),
(8, '2024-01-20', 'Present', NULL),
(8, '2024-01-27', 'Present', NULL),
(8, '2024-02-03', 'Present', NULL),
(9, '2024-01-20', 'Present', NULL),
(9, '2024-01-27', 'Present', NULL),
(10, '2024-02-05', 'Present', NULL),
(10, '2024-02-07', 'Present', NULL),
(11, '2024-02-05', 'Present', NULL),
(12, '2024-03-15', 'Present', NULL),
(13, '2024-02-10', 'Present', NULL),
(13, '2024-02-12', 'Present', NULL),
(14, '2024-03-01', 'Present', NULL),
(15, '2024-01-25', 'Present', NULL),
(15, '2024-02-01', 'Present', NULL),
(16, '2024-02-15', 'Present', NULL),
(16, '2024-02-17', 'Present', NULL),
(17, '2024-02-15', 'Present', NULL);

-- ============================================================================
-- INSERT: Payments
-- ============================================================================
-- Sample payment records for various enrollments
INSERT INTO payments (enrollment_id, payment_date, amount, payment_method, status) VALUES
(1, '2024-01-10', 899.00, 'Card', 'Completed'),
(2, '2024-01-12', 450.00, 'Card', 'Completed'),
(2, '2024-02-12', 449.00, 'Bank Transfer', 'Completed'),
(3, '2024-01-15', 899.00, 'Cash', 'Completed'),
(4, '2024-02-01', 300.00, 'Card', 'Completed'),
(4, '2024-03-01', 299.00, 'Card', 'Pending'),
(5, '2024-02-05', 599.00, 'Card', 'Completed'),
(6, '2024-01-20', 600.00, 'Bank Transfer', 'Completed'),
(6, '2024-02-20', 599.00, 'Bank Transfer', 'Completed'),
(7, '2024-02-10', 1199.00, 'Card', 'Completed'),
(8, '2024-01-18', 500.00, 'Card', 'Completed'),
(8, '2024-02-18', 500.00, 'Card', 'Completed'),
(8, '2024-03-18', 499.00, 'Card', 'Pending'),
(9, '2024-02-28', 1499.00, 'Bank Transfer', 'Completed'),
(10, '2024-02-03', 599.00, 'Card', 'Completed'),
(11, '2024-02-05', 599.00, 'Cash', 'Completed'),
(12, '2024-03-08', 300.00, 'Card', 'Completed'),
(12, '2024-04-08', 299.00, 'Card', 'Pending'),
(13, '2024-03-12', 599.00, 'Card', 'Completed'),
(14, '2024-02-08', 350.00, 'Card', 'Completed'),
(14, '2024-03-08', 349.00, 'Card', 'Completed'),
(15, '2024-02-28', 799.00, 'Bank Transfer', 'Completed'),
(16, '2024-01-22', 650.00, 'Card', 'Completed'),
(16, '2024-02-22', 649.00, 'Card', 'Completed'),
(17, '2024-01-25', 1299.00, 'Card', 'Completed'),
(18, '2024-02-12', 800.00, 'Bank Transfer', 'Completed'),
(18, '2024-03-12', 799.00, 'Bank Transfer', 'Pending'),
(19, '2024-02-15', 800.00, 'Card', 'Completed'),
(19, '2024-03-15', 799.00, 'Card', 'Pending'),
(20, '2024-01-25', 899.00, 'Card', 'Completed');

-- ============================================================================
-- Verification Queries (Optional - can be run to verify data)
-- ============================================================================

-- Count records in each table
-- SELECT 'Students' as table_name, COUNT(*) as count FROM students
-- UNION ALL
-- SELECT 'Teachers', COUNT(*) FROM teachers
-- UNION ALL
-- SELECT 'Courses', COUNT(*) FROM courses
-- UNION ALL
-- SELECT 'Groups', COUNT(*) FROM groups
-- UNION ALL
-- SELECT 'Enrollments', COUNT(*) FROM enrollments
-- UNION ALL
-- SELECT 'Attendances', COUNT(*) FROM attendances
-- UNION ALL
-- SELECT 'Payments', COUNT(*) FROM payments;
