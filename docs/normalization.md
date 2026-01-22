# Database Normalization Process

## Overview

This document describes the normalization process from First Normal Form (1NF) through Third Normal Form (3NF) for the Education Center Database System.

## Initial Unnormalized Data

The initial data structure might look like a single table with all information:

```
StudentCourseData (Unnormalized)
- Student Name, Student Email, Student Phone, Student DOB, Student Address
- Course Name, Course Type, Course Price, Course Duration
- Group Name, Group Schedule, Group Start Date, Group End Date
- Teacher Name, Teacher Email, Teacher Phone, Teacher Specialization
- Enrollment Date, Enrollment Status
- Attendance Date 1, Status 1, Attendance Date 2, Status 2, ...
- Payment Date 1, Amount 1, Payment Date 2, Amount 2, ...
```

**Problems with this structure:**
- Data duplication (student info repeated for each course)
- Update anomalies (changing student email requires multiple updates)
- Insertion anomalies (cannot add a course without a student)
- Deletion anomalies (deleting a student removes course information)
- Difficult to query and maintain

---

## First Normal Form (1NF)

### Rules
- Eliminate repeating groups
- Each cell contains atomic (indivisible) values
- Each row is unique

### Transformation

**Step 1: Separate repeating groups into separate tables**

1. **Students Table** (1NF)
   - student_id, first_name, last_name, email, phone, date_of_birth, address, enrollment_date

2. **Courses Table** (1NF)
   - course_id, course_name, course_type, description, duration_weeks, price

3. **Groups Table** (1NF)
   - group_id, course_id, group_name, start_date, end_date, schedule, max_capacity, teacher_id

4. **Teachers Table** (1NF)
   - teacher_id, first_name, last_name, email, phone, specialization, hire_date

5. **Enrollments Table** (1NF)
   - enrollment_id, student_id, group_id, enrollment_date, status

6. **Attendances Table** (1NF)
   - attendance_id, enrollment_id, attendance_date, status, notes

7. **Payments Table** (1NF)
   - payment_id, enrollment_id, payment_date, amount, payment_method, status

### Result
- All repeating groups are eliminated
- Each table contains atomic values
- Each row is uniquely identifiable

**Remaining Issues:**
- Partial dependencies may exist
- Transitive dependencies may exist

---

## Second Normal Form (2NF)

### Rules
- Must be in 1NF
- All non-key attributes must be fully functionally dependent on the primary key
- No partial dependencies (for composite keys)

### Analysis

#### Students Table
- **Primary Key**: student_id
- **Dependencies**: All attributes depend on student_id
- **Status**: ✅ Already in 2NF (single attribute primary key)

#### Courses Table
- **Primary Key**: course_id
- **Dependencies**: All attributes depend on course_id
- **Status**: ✅ Already in 2NF

#### Teachers Table
- **Primary Key**: teacher_id
- **Dependencies**: All attributes depend on teacher_id
- **Status**: ✅ Already in 2NF

#### Groups Table
- **Primary Key**: group_id
- **Dependencies**: 
  - group_name, start_date, end_date, schedule, max_capacity depend on group_id
  - course_id depends on group_id (a group belongs to one course)
  - teacher_id depends on group_id (a group has one teacher)
- **Status**: ✅ Already in 2NF

#### Enrollments Table
- **Primary Key**: enrollment_id
- **Dependencies**: All attributes depend on enrollment_id
- **Note**: We could use composite key (student_id, group_id), but using enrollment_id as PK is better for 2NF compliance
- **Status**: ✅ Already in 2NF

#### Attendances Table
- **Primary Key**: attendance_id
- **Dependencies**: All attributes depend on attendance_id
- **Status**: ✅ Already in 2NF

#### Payments Table
- **Primary Key**: payment_id
- **Dependencies**: All attributes depend on payment_id
- **Status**: ✅ Already in 2NF

### Result
- All tables are in 2NF
- No partial dependencies exist

**Remaining Issues:**
- Need to check for transitive dependencies

---

## Third Normal Form (3NF)

### Rules
- Must be in 2NF
- No transitive dependencies
- Non-key attributes must not depend on other non-key attributes

### Analysis

#### Students Table
- **Primary Key**: student_id
- **Dependencies Check**:
  - first_name, last_name, email, phone, date_of_birth, address, enrollment_date all depend directly on student_id
  - No transitive dependencies (e.g., address doesn't determine email)
- **Status**: ✅ Already in 3NF

#### Courses Table
- **Primary Key**: course_id
- **Dependencies Check**:
  - All attributes depend directly on course_id
  - No transitive dependencies
- **Status**: ✅ Already in 3NF

#### Teachers Table
- **Primary Key**: teacher_id
- **Dependencies Check**:
  - All attributes depend directly on teacher_id
  - No transitive dependencies
- **Status**: ✅ Already in 3NF

#### Groups Table
- **Primary Key**: group_id
- **Dependencies Check**:
  - group_name, start_date, end_date, schedule, max_capacity depend on group_id
  - course_id is a foreign key (depends on group_id, references Courses)
  - teacher_id is a foreign key (depends on group_id, references Teachers)
  - **Potential Issue**: If course_id determined course_name, that would be transitive, but course_id is a foreign key reference, not a dependency within this table
- **Status**: ✅ Already in 3NF

#### Enrollments Table
- **Primary Key**: enrollment_id
- **Dependencies Check**:
  - enrollment_date, status depend on enrollment_id
  - student_id and group_id are foreign keys
  - No transitive dependencies
- **Status**: ✅ Already in 3NF

#### Attendances Table
- **Primary Key**: attendance_id
- **Dependencies Check**:
  - attendance_date, status, notes depend on attendance_id
  - enrollment_id is a foreign key
  - No transitive dependencies
- **Status**: ✅ Already in 3NF

#### Payments Table
- **Primary Key**: payment_id
- **Dependencies Check**:
  - payment_date, amount, payment_method, status depend on payment_id
  - enrollment_id is a foreign key
  - No transitive dependencies
- **Status**: ✅ Already in 3NF

### Result
- All tables are in 3NF
- No transitive dependencies exist
- Data redundancy is minimized
- Update, insertion, and deletion anomalies are eliminated

---

## Normalization Summary

### Benefits Achieved

1. **Eliminated Data Redundancy**
   - Student information stored once
   - Course information stored once
   - Teacher information stored once

2. **Prevented Update Anomalies**
   - Changing student email requires update in one place only
   - Course details can be updated without affecting student records

3. **Prevented Insertion Anomalies**
   - Can add courses without students
   - Can add teachers without assignments
   - Can add students without enrollments

4. **Prevented Deletion Anomalies**
   - Deleting a student doesn't delete course information
   - Deleting an enrollment doesn't delete student or group data

5. **Improved Data Integrity**
   - Foreign key constraints ensure referential integrity
   - Unique constraints prevent duplicate data
   - Check constraints enforce business rules

6. **Enhanced Query Performance**
   - Smaller, focused tables
   - Efficient indexing on primary and foreign keys
   - Better join performance

### Final Schema Structure

```
Students (3NF)
├── student_id (PK)
└── All attributes depend on student_id

Courses (3NF)
├── course_id (PK)
└── All attributes depend on course_id

Teachers (3NF)
├── teacher_id (PK)
└── All attributes depend on teacher_id

Groups (3NF)
├── group_id (PK)
├── course_id (FK → Courses)
├── teacher_id (FK → Teachers)
└── All attributes depend on group_id

Enrollments (3NF)
├── enrollment_id (PK)
├── student_id (FK → Students)
├── group_id (FK → Groups)
└── All attributes depend on enrollment_id

Attendances (3NF)
├── attendance_id (PK)
├── enrollment_id (FK → Enrollments)
└── All attributes depend on attendance_id

Payments (3NF)
├── payment_id (PK)
├── enrollment_id (FK → Enrollments)
└── All attributes depend on payment_id
```

### Normalization Complete ✅

The database schema is now in Third Normal Form (3NF), ensuring:
- No repeating groups
- No partial dependencies
- No transitive dependencies
- Optimal data structure for the Education Center Database System
