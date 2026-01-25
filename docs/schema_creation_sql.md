# Database Schema Creation Flow - SQL Code Reference

This document provides the complete SQL code for each step in the Database Schema Creation Flow, showing exactly what SQL statements are executed to create the database structure.

---

## Overview

The schema creation process follows this sequence:
1. Drop existing tables (if any)
2. Create `students` table
3. Create `teachers` table
4. Create `courses` table
5. Create `groups` table
6. Create `enrollments` table
7. Create `attendances` table
8. Create `payments` table
9. Create indexes
10. Add table and column comments

---

## Step 1: Drop Existing Tables (Cleanup)

```sql
-- Drop existing tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS attendances CASCADE;
DROP TABLE IF EXISTS enrollments CASCADE;
DROP TABLE IF EXISTS groups CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS teachers CASCADE;
DROP TABLE IF EXISTS students CASCADE;
```

**Purpose**: Ensures a clean slate by removing any existing tables. The `CASCADE` option also drops dependent objects.

---

## Step 2: Create Students Table

```sql
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
```

**Key Features**:
- **Primary Key**: `student_id` (auto-incrementing SERIAL)
- **Unique Constraint**: `email` (prevents duplicate emails)
- **Check Constraint**: Email format validation using regex
- **Check Constraint**: Date of birth must be in the past
- **NOT NULL**: Required fields (first_name, last_name, email, date_of_birth, enrollment_date)
- **Default Value**: `enrollment_date` defaults to current date

---

## Step 3: Create Teachers Table

```sql
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
```

**Key Features**:
- **Primary Key**: `teacher_id` (auto-incrementing SERIAL)
- **Unique Constraint**: `email` (prevents duplicate emails)
- **Check Constraint**: Email format validation
- **Check Constraint**: Hire date cannot be in the future
- **NOT NULL**: Required fields (first_name, last_name, email, specialization, hire_date)
- **Default Value**: `hire_date` defaults to current date

---

## Step 4: Create Courses Table

```sql
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
```

**Key Features**:
- **Primary Key**: `course_id` (auto-incrementing SERIAL)
- **Check Constraint**: `course_type` must be one of: 'Programming', 'Foreign Language', 'Professional Certification'
- **Check Constraint**: `duration_weeks` must be greater than 0
- **Check Constraint**: `price` must be non-negative (>= 0)
- **NOT NULL**: Required fields (course_name, course_type, duration_weeks, price)
- **Data Types**: 
  - `DECIMAL(10, 2)` for price (supports up to 99,999,999.99)
  - `INTEGER` for duration in weeks

---

## Step 5: Create Groups Table

```sql
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
```

**Key Features**:
- **Primary Key**: `group_id` (auto-incrementing SERIAL)
- **Foreign Key**: `course_id` → references `courses(course_id)`
  - `ON DELETE RESTRICT`: Prevents deleting a course if groups exist
  - `ON UPDATE CASCADE`: Updates group's course_id if course_id changes
- **Foreign Key**: `teacher_id` → references `teachers(teacher_id)`
  - `ON DELETE RESTRICT`: Prevents deleting a teacher if groups exist
  - `ON UPDATE CASCADE`: Updates group's teacher_id if teacher_id changes
- **Check Constraint**: `end_date` must be after `start_date`
- **Check Constraint**: `max_capacity` must be greater than 0
- **Unique Constraint**: `group_name` must be unique
- **NOT NULL**: All fields are required

---

## Step 6: Create Enrollments Table

```sql
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
```

**Key Features**:
- **Primary Key**: `enrollment_id` (auto-incrementing SERIAL)
- **Foreign Key**: `student_id` → references `students(student_id)`
  - `ON DELETE CASCADE`: Deletes enrollments when student is deleted
  - `ON UPDATE CASCADE`: Updates enrollment's student_id if student_id changes
- **Foreign Key**: `group_id` → references `groups(group_id)`
  - `ON DELETE CASCADE`: Deletes enrollments when group is deleted
  - `ON UPDATE CASCADE`: Updates enrollment's group_id if group_id changes
- **Check Constraint**: `status` must be one of: 'Active', 'Completed', 'Cancelled'
- **Unique Constraint**: `(student_id, group_id)` - prevents duplicate enrollments
- **Default Values**: 
  - `enrollment_date` defaults to current date
  - `status` defaults to 'Active'

---

## Step 7: Create Attendances Table

```sql
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
```

**Key Features**:
- **Primary Key**: `attendance_id` (auto-incrementing SERIAL)
- **Foreign Key**: `enrollment_id` → references `enrollments(enrollment_id)`
  - `ON DELETE CASCADE`: Deletes attendance records when enrollment is deleted
  - `ON UPDATE CASCADE`: Updates attendance's enrollment_id if enrollment_id changes
- **Check Constraint**: `status` must be one of: 'Present', 'Absent', 'Late'
- **Unique Constraint**: `(enrollment_id, attendance_date)` - prevents duplicate attendance for same date
- **NOT NULL**: Required fields (enrollment_id, attendance_date, status)
- **Optional**: `notes` field for additional information

---

## Step 8: Create Payments Table

```sql
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
```

**Key Features**:
- **Primary Key**: `payment_id` (auto-incrementing SERIAL)
- **Foreign Key**: `enrollment_id` → references `enrollments(enrollment_id)`
  - `ON DELETE CASCADE`: Deletes payment records when enrollment is deleted
  - `ON UPDATE CASCADE`: Updates payment's enrollment_id if enrollment_id changes
- **Check Constraint**: `amount` must be greater than 0
- **Check Constraint**: `payment_method` must be one of: 'Cash', 'Card', 'Bank Transfer'
- **Check Constraint**: `status` must be one of: 'Completed', 'Pending', 'Refunded'
- **Default Values**: 
  - `payment_date` defaults to current date
  - `status` defaults to 'Completed'
- **Data Type**: `DECIMAL(10, 2)` for amount (supports up to 99,999,999.99)

---

## Step 9: Create Indexes for Performance

```sql
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
```

**Purpose**: 
- **Foreign Key Indexes**: Speed up JOIN operations between related tables
- **Query Optimization Indexes**: Speed up common queries on:
  - Email lookups (students, teachers)
  - Status filtering (enrollments)
  - Date range queries (attendances, payments)

---

## Step 10: Add Documentation Comments

```sql
-- Table comments
COMMENT ON TABLE students IS 'Stores student personal and enrollment information';
COMMENT ON TABLE teachers IS 'Stores teacher information and specializations';
COMMENT ON TABLE courses IS 'Stores course definitions and details';
COMMENT ON TABLE groups IS 'Stores specific class groups within courses';
COMMENT ON TABLE enrollments IS 'Junction table linking students to groups (Many-to-Many relationship)';
COMMENT ON TABLE attendances IS 'Tracks student attendance for each class session';
COMMENT ON TABLE payments IS 'Records financial transactions for enrollments';

-- Column comments
COMMENT ON COLUMN students.student_id IS 'Primary key: Unique identifier for each student';
COMMENT ON COLUMN groups.course_id IS 'Foreign key: References courses.course_id';
COMMENT ON COLUMN groups.teacher_id IS 'Foreign key: References teachers.teacher_id';
COMMENT ON COLUMN enrollments.student_id IS 'Foreign key: References students.student_id';
COMMENT ON COLUMN enrollments.group_id IS 'Foreign key: References groups.group_id';
COMMENT ON COLUMN attendances.enrollment_id IS 'Foreign key: References enrollments.enrollment_id';
COMMENT ON COLUMN payments.enrollment_id IS 'Foreign key: References enrollments.enrollment_id';
```

**Purpose**: Provides documentation that can be queried using PostgreSQL's information schema, making the database self-documenting.

---

## Complete Schema Creation Flow Summary

### Execution Order

1. **Cleanup Phase**
   ```sql
   DROP TABLE IF EXISTS ... (7 tables)
   ```

2. **Core Entity Tables** (No dependencies)
   ```sql
   CREATE TABLE students
   CREATE TABLE teachers
   CREATE TABLE courses
   ```

3. **Dependent Tables** (Require core entities)
   ```sql
   CREATE TABLE groups (depends on: courses, teachers)
   ```

4. **Junction Table** (Requires students and groups)
   ```sql
   CREATE TABLE enrollments (depends on: students, groups)
   ```

5. **Transaction Tables** (Require enrollments)
   ```sql
   CREATE TABLE attendances (depends on: enrollments)
   CREATE TABLE payments (depends on: enrollments)
   ```

6. **Performance Optimization**
   ```sql
   CREATE INDEX ... (9 indexes)
   ```

7. **Documentation**
   ```sql
   COMMENT ON TABLE ... (7 table comments)
   COMMENT ON COLUMN ... (7 column comments)
   ```

---

## Constraint Summary

### Primary Keys (7)
- `students.student_id`
- `teachers.teacher_id`
- `courses.course_id`
- `groups.group_id`
- `enrollments.enrollment_id`
- `attendances.attendance_id`
- `payments.payment_id`

### Foreign Keys (6)
- `groups.course_id` → `courses.course_id`
- `groups.teacher_id` → `teachers.teacher_id`
- `enrollments.student_id` → `students.student_id`
- `enrollments.group_id` → `groups.group_id`
- `attendances.enrollment_id` → `enrollments.enrollment_id`
- `payments.enrollment_id` → `enrollments.enrollment_id`

### Unique Constraints (4)
- `students.email`
- `teachers.email`
- `groups.group_name`
- `enrollments(student_id, group_id)`
- `attendances(enrollment_id, attendance_date)`

### Check Constraints (12)
- Email format validation (2)
- Date validations (3)
- Positive value checks (3)
- Status value validations (4)

---

## Data Type Reference

| Data Type | Usage | Examples |
|-----------|-------|----------|
| `SERIAL` | Auto-incrementing primary keys | `student_id`, `teacher_id` |
| `VARCHAR(n)` | Variable-length strings | Names, emails, statuses |
| `TEXT` | Long text fields | Descriptions, addresses, notes |
| `DATE` | Date values | Birth dates, enrollment dates |
| `INTEGER` | Whole numbers | Duration, capacity, counts |
| `DECIMAL(10,2)` | Monetary values | Prices, payment amounts |

---

## Relationship Summary

```
courses (1) ──→ (many) groups
teachers (1) ──→ (many) groups
students (many) ←→ (many) groups [via enrollments]
enrollments (1) ──→ (many) attendances
enrollments (1) ──→ (many) payments
```

---

## Verification Queries

After schema creation, you can verify the structure:

```sql
-- List all tables
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;

-- List all constraints
SELECT 
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type
FROM information_schema.table_constraints tc
WHERE tc.table_schema = 'public'
ORDER BY tc.table_name, tc.constraint_type;

-- List all foreign keys
SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.table_name;
```

---

This SQL code creates a fully normalized, constraint-enforced, and indexed database schema ready for production use.
