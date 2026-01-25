# Data Dictionary - Education Center Database System

This document provides a comprehensive data dictionary for all tables, columns, data types, constraints, and relationships in the Education Center Database System.

---

## Table of Contents

1. [Students Table](#students-table)
2. [Teachers Table](#teachers-table)
3. [Courses Table](#courses-table)
4. [Groups Table](#groups-table)
5. [Enrollments Table](#enrollments-table)
6. [Attendances Table](#attendances-table)
7. [Payments Table](#payments-table)
8. [Indexes](#indexes)
9. [Relationships Summary](#relationships-summary)

---

## Students Table

**Table Name**: `students`  
**Description**: Stores student personal and enrollment information  
**Primary Key**: `student_id`  
**Number of Rows**: 10 (sample data)

| Column Name | Data Type | Length | Nullable | Default | Constraints | Description |
|------------|-----------|--------|----------|---------|-------------|-------------|
| `student_id` | SERIAL | - | NO | Auto-increment | PRIMARY KEY | Unique identifier for each student |
| `first_name` | VARCHAR | 100 | NO | - | NOT NULL | Student's first name |
| `last_name` | VARCHAR | 100 | NO | - | NOT NULL | Student's last name |
| `email` | VARCHAR | 255 | NO | - | UNIQUE, CHECK (email format) | Student's email address (must be unique) |
| `phone` | VARCHAR | 20 | YES | NULL | - | Contact phone number |
| `date_of_birth` | DATE | - | NO | - | NOT NULL, CHECK (< CURRENT_DATE) | Student's date of birth (must be in past) |
| `address` | TEXT | - | YES | NULL | - | Student's physical address |
| `enrollment_date` | DATE | - | NO | CURRENT_DATE | NOT NULL, DEFAULT | Date when student first registered with center |

**Constraints**:
- **Primary Key**: `student_id` (auto-incrementing)
- **Unique**: `email` (no duplicate emails allowed)
- **Check**: `chk_student_email` - Email must match regex pattern: `^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$`
- **Check**: `chk_student_dob` - Date of birth must be before current date

**Indexes**:
- `idx_students_email` on `email` (for fast email lookups)

**Referenced By**:
- `enrollments.student_id` (Foreign Key)

---

## Teachers Table

**Table Name**: `teachers`  
**Description**: Stores teacher information and specializations  
**Primary Key**: `teacher_id`  
**Number of Rows**: 8 (sample data)

| Column Name | Data Type | Length | Nullable | Default | Constraints | Description |
|------------|-----------|--------|----------|---------|-------------|-------------|
| `teacher_id` | SERIAL | - | NO | Auto-increment | PRIMARY KEY | Unique identifier for each teacher |
| `first_name` | VARCHAR | 100 | NO | - | NOT NULL | Teacher's first name |
| `last_name` | VARCHAR | 100 | NO | - | NOT NULL | Teacher's last name |
| `email` | VARCHAR | 255 | NO | - | UNIQUE, CHECK (email format) | Teacher's email address (must be unique) |
| `phone` | VARCHAR | 20 | YES | NULL | - | Contact phone number |
| `specialization` | VARCHAR | 100 | NO | - | NOT NULL | Teacher's area of expertise (e.g., "Python Programming") |
| `hire_date` | DATE | - | NO | CURRENT_DATE | NOT NULL, DEFAULT, CHECK (<= CURRENT_DATE) | Date when teacher was hired (cannot be future date) |

**Constraints**:
- **Primary Key**: `teacher_id` (auto-incrementing)
- **Unique**: `email` (no duplicate emails allowed)
- **Check**: `chk_teacher_email` - Email must match regex pattern
- **Check**: `chk_teacher_hire_date` - Hire date cannot be in the future

**Indexes**:
- `idx_teachers_email` on `email` (for fast email lookups)

**Referenced By**:
- `groups.teacher_id` (Foreign Key)

---

## Courses Table

**Table Name**: `courses`  
**Description**: Stores course definitions and details  
**Primary Key**: `course_id`  
**Number of Rows**: 8 (sample data)

| Column Name | Data Type | Length | Nullable | Default | Constraints | Description |
|------------|-----------|--------|----------|---------|-------------|-------------|
| `course_id` | SERIAL | - | NO | Auto-increment | PRIMARY KEY | Unique identifier for each course |
| `course_name` | VARCHAR | 200 | NO | - | NOT NULL | Name of the course (e.g., "Python Fundamentals") |
| `course_type` | VARCHAR | 50 | NO | - | NOT NULL, CHECK (IN list) | Type of course: 'Programming', 'Foreign Language', or 'Professional Certification' |
| `description` | TEXT | - | YES | NULL | - | Detailed description of the course |
| `duration_weeks` | INTEGER | - | NO | - | NOT NULL, CHECK (> 0) | Duration of the course in weeks (must be positive) |
| `price` | DECIMAL | 10,2 | NO | - | NOT NULL, CHECK (>= 0) | Course price in currency (supports up to 99,999,999.99) |

**Constraints**:
- **Primary Key**: `course_id` (auto-incrementing)
- **Check**: `chk_course_type` - Must be one of: 'Programming', 'Foreign Language', 'Professional Certification'
- **Check**: `chk_course_duration` - Duration must be greater than 0
- **Check**: `chk_course_price` - Price must be non-negative (>= 0)

**Referenced By**:
- `groups.course_id` (Foreign Key)

**Sample Values**:
- `course_type`: 'Programming', 'Foreign Language', 'Professional Certification'
- `duration_weeks`: 8, 10, 12, 14, 16, 18, 20
- `price`: 599.00, 699.00, 799.00, 899.00, 1199.00, 1299.00, 1499.00, 1599.00

---

## Groups Table

**Table Name**: `groups`  
**Description**: Stores specific class groups within courses  
**Primary Key**: `group_id`  
**Number of Rows**: 10 (sample data)

| Column Name | Data Type | Length | Nullable | Default | Constraints | Description |
|------------|-----------|--------|----------|---------|-------------|-------------|
| `group_id` | SERIAL | - | NO | Auto-increment | PRIMARY KEY | Unique identifier for each group |
| `course_id` | INTEGER | - | NO | - | NOT NULL, FOREIGN KEY | Reference to the course this group belongs to |
| `group_name` | VARCHAR | 100 | NO | - | NOT NULL, UNIQUE | Name/identifier for the group (e.g., "Python-2024-A") |
| `start_date` | DATE | - | NO | - | NOT NULL | Group start date |
| `end_date` | DATE | - | NO | - | NOT NULL, CHECK (> start_date) | Group end date (must be after start date) |
| `schedule` | VARCHAR | 200 | NO | - | NOT NULL | Class schedule (e.g., "Monday, Wednesday, Friday 18:00-20:00") |
| `max_capacity` | INTEGER | - | NO | - | NOT NULL, CHECK (> 0) | Maximum number of students in the group |
| `teacher_id` | INTEGER | - | NO | - | NOT NULL, FOREIGN KEY | Reference to the assigned teacher |

**Constraints**:
- **Primary Key**: `group_id` (auto-incrementing)
- **Foreign Key**: `fk_group_course` → `courses(course_id)` 
  - ON DELETE RESTRICT (cannot delete course if groups exist)
  - ON UPDATE CASCADE (updates group's course_id if course_id changes)
- **Foreign Key**: `fk_group_teacher` → `teachers(teacher_id)`
  - ON DELETE RESTRICT (cannot delete teacher if groups exist)
  - ON UPDATE CASCADE (updates group's teacher_id if teacher_id changes)
- **Unique**: `uk_group_name` - Group name must be unique
- **Check**: `chk_group_dates` - End date must be after start date
- **Check**: `chk_group_capacity` - Maximum capacity must be greater than 0

**Indexes**:
- `idx_groups_course_id` on `course_id` (for fast joins with courses)
- `idx_groups_teacher_id` on `teacher_id` (for fast joins with teachers)

**Referenced By**:
- `enrollments.group_id` (Foreign Key)

**Sample Values**:
- `group_name`: "Python-2024-A", "Java-2024-A", "Spanish-2024-A", etc.
- `schedule`: "Monday, Wednesday, Friday 18:00-20:00", "Tuesday, Thursday 19:00-21:00"
- `max_capacity`: 12, 15, 18, 20, 22, 25, 30

---

## Enrollments Table

**Table Name**: `enrollments`  
**Description**: Junction table linking students to groups (Many-to-Many relationship)  
**Primary Key**: `enrollment_id`  
**Number of Rows**: 20 (sample data)

| Column Name | Data Type | Length | Nullable | Default | Constraints | Description |
|------------|-----------|--------|----------|---------|-------------|-------------|
| `enrollment_id` | SERIAL | - | NO | Auto-increment | PRIMARY KEY | Unique identifier for each enrollment |
| `student_id` | INTEGER | - | NO | - | NOT NULL, FOREIGN KEY | Reference to the student |
| `group_id` | INTEGER | - | NO | - | NOT NULL, FOREIGN KEY | Reference to the group |
| `enrollment_date` | DATE | - | NO | CURRENT_DATE | NOT NULL, DEFAULT | Date when student enrolled in the group |
| `status` | VARCHAR | 20 | NO | 'Active' | NOT NULL, DEFAULT, CHECK (IN list) | Enrollment status: 'Active', 'Completed', or 'Cancelled' |

**Constraints**:
- **Primary Key**: `enrollment_id` (auto-incrementing)
- **Foreign Key**: `fk_enrollment_student` → `students(student_id)`
  - ON DELETE CASCADE (deletes enrollments when student is deleted)
  - ON UPDATE CASCADE (updates enrollment's student_id if student_id changes)
- **Foreign Key**: `fk_enrollment_group` → `groups(group_id)`
  - ON DELETE CASCADE (deletes enrollments when group is deleted)
  - ON UPDATE CASCADE (updates enrollment's group_id if group_id changes)
- **Unique**: `uk_student_group` - Combination of (student_id, group_id) must be unique (prevents duplicate enrollments)
- **Check**: `chk_enrollment_status` - Status must be one of: 'Active', 'Completed', 'Cancelled'

**Indexes**:
- `idx_enrollments_student_id` on `student_id` (for fast joins with students)
- `idx_enrollments_group_id` on `group_id` (for fast joins with groups)
- `idx_enrollments_status` on `status` (for filtering by status)

**Referenced By**:
- `attendances.enrollment_id` (Foreign Key)
- `payments.enrollment_id` (Foreign Key)

**Sample Values**:
- `status`: 'Active', 'Completed', 'Cancelled'
- `enrollment_date`: Various dates (typically current date or past)

---

## Attendances Table

**Table Name**: `attendances`  
**Description**: Tracks student attendance for each class session  
**Primary Key**: `attendance_id`  
**Number of Rows**: 40+ (sample data)

| Column Name | Data Type | Length | Nullable | Default | Constraints | Description |
|------------|-----------|--------|----------|---------|-------------|-------------|
| `attendance_id` | SERIAL | - | NO | Auto-increment | PRIMARY KEY | Unique identifier for each attendance record |
| `enrollment_id` | INTEGER | - | NO | - | NOT NULL, FOREIGN KEY | Reference to the enrollment (student+group) |
| `attendance_date` | DATE | - | NO | - | NOT NULL | Date of the class session |
| `status` | VARCHAR | 20 | NO | - | NOT NULL, CHECK (IN list) | Attendance status: 'Present', 'Absent', or 'Late' |
| `notes` | TEXT | - | YES | NULL | - | Optional notes about the attendance (e.g., reason for absence) |

**Constraints**:
- **Primary Key**: `attendance_id` (auto-incrementing)
- **Foreign Key**: `fk_attendance_enrollment` → `enrollments(enrollment_id)`
  - ON DELETE CASCADE (deletes attendance records when enrollment is deleted)
  - ON UPDATE CASCADE (updates attendance's enrollment_id if enrollment_id changes)
- **Unique**: `uk_enrollment_date` - Combination of (enrollment_id, attendance_date) must be unique (prevents duplicate attendance for same date)
- **Check**: `chk_attendance_status` - Status must be one of: 'Present', 'Absent', 'Late'

**Indexes**:
- `idx_attendances_enrollment_id` on `enrollment_id` (for fast joins with enrollments)
- `idx_attendances_date` on `attendance_date` (for date range queries)

**Sample Values**:
- `status`: 'Present', 'Absent', 'Late'
- `attendance_date`: Various class session dates
- `notes`: "Sick leave", "Traffic delay", "Family emergency", NULL

---

## Payments Table

**Table Name**: `payments`  
**Description**: Records financial transactions for enrollments  
**Primary Key**: `payment_id`  
**Number of Rows**: 30+ (sample data)

| Column Name | Data Type | Length | Nullable | Default | Constraints | Description |
|------------|-----------|--------|----------|---------|-------------|-------------|
| `payment_id` | SERIAL | - | NO | Auto-increment | PRIMARY KEY | Unique identifier for each payment |
| `enrollment_id` | INTEGER | - | NO | - | NOT NULL, FOREIGN KEY | Reference to the enrollment |
| `payment_date` | DATE | - | NO | CURRENT_DATE | NOT NULL, DEFAULT | Date when payment was made |
| `amount` | DECIMAL | 10,2 | NO | - | NOT NULL, CHECK (> 0) | Payment amount (must be positive, supports up to 99,999,999.99) |
| `payment_method` | VARCHAR | 50 | NO | - | NOT NULL, CHECK (IN list) | Method of payment: 'Cash', 'Card', or 'Bank Transfer' |
| `status` | VARCHAR | 20 | NO | 'Completed' | NOT NULL, DEFAULT, CHECK (IN list) | Payment status: 'Completed', 'Pending', or 'Refunded' |

**Constraints**:
- **Primary Key**: `payment_id` (auto-incrementing)
- **Foreign Key**: `fk_payment_enrollment` → `enrollments(enrollment_id)`
  - ON DELETE CASCADE (deletes payment records when enrollment is deleted)
  - ON UPDATE CASCADE (updates payment's enrollment_id if enrollment_id changes)
- **Check**: `chk_payment_amount` - Amount must be greater than 0
- **Check**: `chk_payment_method` - Payment method must be one of: 'Cash', 'Card', 'Bank Transfer'
- **Check**: `chk_payment_status` - Status must be one of: 'Completed', 'Pending', 'Refunded'

**Indexes**:
- `idx_payments_enrollment_id` on `enrollment_id` (for fast joins with enrollments)
- `idx_payments_date` on `payment_date` (for date range queries)

**Sample Values**:
- `amount`: 300.00, 450.00, 599.00, 800.00, 899.00, 1199.00, 1299.00, 1499.00
- `payment_method`: 'Cash', 'Card', 'Bank Transfer'
- `status`: 'Completed', 'Pending', 'Refunded'

---

## Indexes

The following indexes are created to optimize query performance:

| Index Name | Table | Column(s) | Purpose |
|------------|-------|------------|---------|
| `idx_groups_course_id` | groups | course_id | Fast joins with courses table |
| `idx_groups_teacher_id` | groups | teacher_id | Fast joins with teachers table |
| `idx_enrollments_student_id` | enrollments | student_id | Fast joins with students table |
| `idx_enrollments_group_id` | enrollments | group_id | Fast joins with groups table |
| `idx_attendances_enrollment_id` | attendances | enrollment_id | Fast joins with enrollments table |
| `idx_payments_enrollment_id` | payments | enrollment_id | Fast joins with enrollments table |
| `idx_students_email` | students | email | Fast email lookups |
| `idx_teachers_email` | teachers | email | Fast email lookups |
| `idx_enrollments_status` | enrollments | status | Fast filtering by enrollment status |
| `idx_attendances_date` | attendances | attendance_date | Fast date range queries |
| `idx_payments_date` | payments | payment_date | Fast date range queries |

---

## Relationships Summary

### One-to-Many Relationships

1. **Courses → Groups**
   - One course can have many groups
   - Foreign Key: `groups.course_id` → `courses.course_id`
   - Cascade Rule: RESTRICT on delete, CASCADE on update

2. **Teachers → Groups**
   - One teacher can teach many groups
   - Foreign Key: `groups.teacher_id` → `teachers.teacher_id`
   - Cascade Rule: RESTRICT on delete, CASCADE on update

3. **Enrollments → Attendances**
   - One enrollment can have many attendance records
   - Foreign Key: `attendances.enrollment_id` → `enrollments.enrollment_id`
   - Cascade Rule: CASCADE on delete and update

4. **Enrollments → Payments**
   - One enrollment can have many payment records
   - Foreign Key: `payments.enrollment_id` → `enrollments.enrollment_id`
   - Cascade Rule: CASCADE on delete and update

### Many-to-Many Relationships

1. **Students ↔ Groups** (via Enrollments)
   - One student can enroll in many groups
   - One group can have many students
   - Junction Table: `enrollments`
   - Foreign Keys: 
     - `enrollments.student_id` → `students.student_id`
     - `enrollments.group_id` → `groups.group_id`
   - Unique Constraint: `(student_id, group_id)` prevents duplicate enrollments

---

## Data Type Reference

| Data Type | Description | Storage | Range/Format |
|-----------|-------------|---------|--------------|
| `SERIAL` | Auto-incrementing integer | 4 bytes | 1 to 2,147,483,647 |
| `VARCHAR(n)` | Variable-length string | Variable | Up to n characters |
| `TEXT` | Unlimited length string | Variable | Unlimited |
| `DATE` | Date value | 4 bytes | 4713 BC to 5874897 AD |
| `INTEGER` | Whole number | 4 bytes | -2,147,483,648 to 2,147,483,647 |
| `DECIMAL(p,s)` | Exact numeric | Variable | Precision p, scale s |

---

## Constraint Types Summary

| Constraint Type | Count | Purpose |
|----------------|-------|---------|
| **Primary Keys** | 7 | Unique identification of each row |
| **Foreign Keys** | 6 | Referential integrity between tables |
| **Unique Constraints** | 4 | Prevent duplicate values |
| **Check Constraints** | 12 | Enforce business rules and data validation |
| **NOT NULL** | 20+ | Ensure required fields are populated |
| **DEFAULT Values** | 5 | Provide default values for columns |

---

## Business Rules Enforced

1. **Email Validation**: All email addresses must match standard email format
2. **Date Validation**: Dates of birth and hire dates cannot be in the future
3. **Date Range Validation**: Group end dates must be after start dates
4. **Positive Values**: Prices, amounts, durations, and capacities must be positive
5. **Status Values**: Status fields must match predefined lists
6. **Unique Enrollments**: Students cannot enroll in the same group twice
7. **Unique Attendance**: Cannot record duplicate attendance for same enrollment and date
8. **Referential Integrity**: Foreign keys ensure data consistency across tables

---

This data dictionary provides a complete reference for understanding the structure, constraints, and relationships in the Education Center Database System.
