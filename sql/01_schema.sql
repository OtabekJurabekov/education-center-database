-- Education Center Database Schema
-- This script creates all tables, constraints, and relationships
-- Database: education_center
-- PostgreSQL 15+

-- Drop existing tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS attendances CASCADE;
DROP TABLE IF EXISTS enrollments CASCADE;
DROP TABLE IF EXISTS groups CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS teachers CASCADE;
DROP TABLE IF EXISTS students CASCADE;

-- ============================================================================
-- TABLE: students
-- Description: Stores student personal and enrollment information
-- ============================================================================
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    date_of_birth DATE NOT NULL,
    address TEXT,
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT chk_student_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT chk_student_dob CHECK (date_of_birth < CURRENT_DATE)
);

-- ============================================================================
-- TABLE: teachers
-- Description: Stores teacher information and specializations
-- ============================================================================
CREATE TABLE teachers (
    teacher_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    specialization VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT chk_teacher_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT chk_teacher_hire_date CHECK (hire_date <= CURRENT_DATE)
);

-- ============================================================================
-- TABLE: courses
-- Description: Stores course definitions and details
-- ============================================================================
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(200) NOT NULL,
    course_type VARCHAR(50) NOT NULL,
    description TEXT,
    duration_weeks INTEGER NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT chk_course_type CHECK (course_type IN ('Programming', 'Foreign Language', 'Professional Certification')),
    CONSTRAINT chk_course_duration CHECK (duration_weeks > 0),
    CONSTRAINT chk_course_price CHECK (price >= 0)
);

-- ============================================================================
-- TABLE: groups
-- Description: Stores specific class groups within courses
-- ============================================================================
CREATE TABLE groups (
    group_id SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL,
    group_name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    schedule VARCHAR(200) NOT NULL,
    max_capacity INTEGER NOT NULL,
    teacher_id INTEGER NOT NULL,
    CONSTRAINT fk_group_course FOREIGN KEY (course_id) 
        REFERENCES courses(course_id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    CONSTRAINT fk_group_teacher FOREIGN KEY (teacher_id) 
        REFERENCES teachers(teacher_id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    CONSTRAINT chk_group_dates CHECK (end_date > start_date),
    CONSTRAINT chk_group_capacity CHECK (max_capacity > 0),
    CONSTRAINT uk_group_name UNIQUE (group_name)
);

-- ============================================================================
-- TABLE: enrollments
-- Description: Junction table linking students to groups (Many-to-Many)
-- ============================================================================
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT fk_enrollment_student FOREIGN KEY (student_id) 
        REFERENCES students(student_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_enrollment_group FOREIGN KEY (group_id) 
        REFERENCES groups(group_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT chk_enrollment_status CHECK (status IN ('Active', 'Completed', 'Cancelled')),
    CONSTRAINT uk_student_group UNIQUE (student_id, group_id)
);

-- ============================================================================
-- TABLE: attendances
-- Description: Tracks student attendance for each class session
-- ============================================================================
CREATE TABLE attendances (
    attendance_id SERIAL PRIMARY KEY,
    enrollment_id INTEGER NOT NULL,
    attendance_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    notes TEXT,
    CONSTRAINT fk_attendance_enrollment FOREIGN KEY (enrollment_id) 
        REFERENCES enrollments(enrollment_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT chk_attendance_status CHECK (status IN ('Present', 'Absent', 'Late')),
    CONSTRAINT uk_enrollment_date UNIQUE (enrollment_id, attendance_date)
);

-- ============================================================================
-- TABLE: payments
-- Description: Records financial transactions for enrollments
-- ============================================================================
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    enrollment_id INTEGER NOT NULL,
    payment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Completed',
    CONSTRAINT fk_payment_enrollment FOREIGN KEY (enrollment_id) 
        REFERENCES enrollments(enrollment_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT chk_payment_amount CHECK (amount > 0),
    CONSTRAINT chk_payment_method CHECK (payment_method IN ('Cash', 'Card', 'Bank Transfer')),
    CONSTRAINT chk_payment_status CHECK (status IN ('Completed', 'Pending', 'Refunded'))
);

-- ============================================================================
-- INDEXES for Performance Optimization
-- ============================================================================

-- Indexes on foreign keys for faster joins
CREATE INDEX idx_groups_course_id ON groups(course_id);
CREATE INDEX idx_groups_teacher_id ON groups(teacher_id);
CREATE INDEX idx_enrollments_student_id ON enrollments(student_id);
CREATE INDEX idx_enrollments_group_id ON enrollments(group_id);
CREATE INDEX idx_attendances_enrollment_id ON attendances(enrollment_id);
CREATE INDEX idx_payments_enrollment_id ON payments(enrollment_id);

-- Indexes on frequently queried columns
CREATE INDEX idx_students_email ON students(email);
CREATE INDEX idx_teachers_email ON teachers(email);
CREATE INDEX idx_enrollments_status ON enrollments(status);
CREATE INDEX idx_attendances_date ON attendances(attendance_date);
CREATE INDEX idx_payments_date ON payments(payment_date);

-- ============================================================================
-- COMMENTS for Documentation
-- ============================================================================

COMMENT ON TABLE students IS 'Stores student personal and enrollment information';
COMMENT ON TABLE teachers IS 'Stores teacher information and specializations';
COMMENT ON TABLE courses IS 'Stores course definitions and details';
COMMENT ON TABLE groups IS 'Stores specific class groups within courses';
COMMENT ON TABLE enrollments IS 'Junction table linking students to groups (Many-to-Many relationship)';
COMMENT ON TABLE attendances IS 'Tracks student attendance for each class session';
COMMENT ON TABLE payments IS 'Records financial transactions for enrollments';

COMMENT ON COLUMN students.student_id IS 'Primary key: Unique identifier for each student';
COMMENT ON COLUMN groups.course_id IS 'Foreign key: References courses.course_id';
COMMENT ON COLUMN groups.teacher_id IS 'Foreign key: References teachers.teacher_id';
COMMENT ON COLUMN enrollments.student_id IS 'Foreign key: References students.student_id';
COMMENT ON COLUMN enrollments.group_id IS 'Foreign key: References groups.group_id';
COMMENT ON COLUMN attendances.enrollment_id IS 'Foreign key: References enrollments.enrollment_id';
COMMENT ON COLUMN payments.enrollment_id IS 'Foreign key: References enrollments.enrollment_id';
