# Entity Relationship Diagram (ERD)

## Entities and Attributes

### 1. Students
- **student_id** (PK): Unique identifier for each student
- **first_name**: Student's first name
- **last_name**: Student's last name
- **email**: Student's email address (UNIQUE)
- **phone**: Contact phone number
- **date_of_birth**: Student's date of birth
- **address**: Student's address
- **enrollment_date**: Date when student first registered with the center

### 2. Courses
- **course_id** (PK): Unique identifier for each course
- **course_name**: Name of the course
- **course_type**: Type of course (Programming, Foreign Language, Professional Certification)
- **description**: Course description
- **duration_weeks**: Duration of the course in weeks
- **price**: Course price

### 3. Groups
- **group_id** (PK): Unique identifier for each group
- **course_id** (FK): Reference to the course this group belongs to
- **group_name**: Name/identifier for the group (e.g., "Python-2024-A")
- **start_date**: Group start date
- **end_date**: Group end date
- **schedule**: Class schedule (e.g., "Monday, Wednesday, Friday 18:00-20:00")
- **max_capacity**: Maximum number of students in the group
- **teacher_id** (FK): Reference to the assigned teacher

### 4. Teachers
- **teacher_id** (PK): Unique identifier for each teacher
- **first_name**: Teacher's first name
- **last_name**: Teacher's last name
- **email**: Teacher's email address (UNIQUE)
- **phone**: Contact phone number
- **specialization**: Teacher's area of expertise
- **hire_date**: Date when teacher was hired

### 5. Enrollments
- **enrollment_id** (PK): Unique identifier for each enrollment
- **student_id** (FK): Reference to the student
- **group_id** (FK): Reference to the group
- **enrollment_date**: Date when student enrolled in the group
- **status**: Enrollment status (Active, Completed, Cancelled)
- **UNIQUE constraint**: (student_id, group_id) - prevents duplicate enrollments

### 6. Attendances
- **attendance_id** (PK): Unique identifier for each attendance record
- **enrollment_id** (FK): Reference to the enrollment
- **attendance_date**: Date of the class session
- **status**: Attendance status (Present, Absent, Late)
- **notes**: Optional notes about the attendance

### 7. Payments
- **payment_id** (PK): Unique identifier for each payment
- **enrollment_id** (FK): Reference to the enrollment
- **payment_date**: Date when payment was made
- **amount**: Payment amount
- **payment_method**: Method of payment (Cash, Card, Bank Transfer)
- **status**: Payment status (Completed, Pending, Refunded)

## Relationships and Cardinality

### 1. Courses → Groups
- **Relationship**: One-to-Many
- **Cardinality**: One course can have many groups
- **Foreign Key**: `Groups.course_id` references `Courses.course_id`
- **Business Rule**: A group must belong to exactly one course

### 2. Teachers → Groups
- **Relationship**: One-to-Many
- **Cardinality**: One teacher can teach many groups
- **Foreign Key**: `Groups.teacher_id` references `Teachers.teacher_id`
- **Business Rule**: A group must have exactly one assigned teacher

### 3. Students ↔ Groups (through Enrollments)
- **Relationship**: Many-to-Many
- **Cardinality**: One student can enroll in many groups, one group can have many students
- **Junction Table**: Enrollments
- **Foreign Keys**: 
  - `Enrollments.student_id` references `Students.student_id`
  - `Enrollments.group_id` references `Groups.group_id`
- **Business Rule**: A student can enroll in multiple groups, but only once per group

### 4. Enrollments → Attendances
- **Relationship**: One-to-Many
- **Cardinality**: One enrollment can have many attendance records
- **Foreign Key**: `Attendances.enrollment_id` references `Enrollments.enrollment_id`
- **Business Rule**: Each attendance record is linked to a specific enrollment

### 5. Enrollments → Payments
- **Relationship**: One-to-Many
- **Cardinality**: One enrollment can have many payment records
- **Foreign Key**: `Payments.enrollment_id` references `Enrollments.enrollment_id`
- **Business Rule**: Multiple payments can be made for a single enrollment (installments)

## ERD Diagram (Text Representation)

```
┌─────────────┐
│  Students   │
├─────────────┤
│ student_id  │◄──┐
│ first_name  │   │
│ last_name   │   │
│ email       │   │
│ phone       │   │
│ date_of_birth│  │
│ address     │   │
│ enrollment_date││
└─────────────┘   │
                  │
                  │ Many
                  │
┌─────────────┐   │   ┌──────────────┐
│  Enrollments│   │   │    Groups    │
├─────────────┤   │   ├──────────────┤
│enrollment_id│───┼───│  group_id    │
│ student_id  │───┘   │  course_id   │───┐
│ group_id    │───┐   │  group_name  │   │
│enrollment_date│  │   │  start_date  │   │
│ status       │  │   │  end_date    │   │
└─────────────┘  │   │  schedule    │   │
      │          │   │  max_capacity│   │
      │          │   │  teacher_id  │───┼───┐
      │          │   └──────────────┘   │   │
      │          │                      │   │
      │          │                      │   │
      │          │   ┌──────────────┐   │   │
      │          └───│   Courses    │   │   │
      │              ├──────────────┤   │   │
      │              │  course_id   │◄──┘   │
      │              │  course_name │       │
      │              │  course_type │       │
      │              │  description │       │
      │              │duration_weeks│       │
      │              │    price     │       │
      │              └──────────────┘       │
      │                                    │
      │ One                                │ One
      │                                    │
      │                                    │
┌─────────────┐                    ┌─────────────┐
│ Attendances │                    │  Teachers   │
├─────────────┤                    ├─────────────┤
│attendance_id│                    │  teacher_id │◄──┘
│enrollment_id│                    │  first_name │
│attendance_date│                  │  last_name  │
│   status    │                    │   email     │
│   notes     │                    │   phone     │
└─────────────┘                    │specialization│
                                   │  hire_date  │
┌─────────────┐                    └─────────────┘
│  Payments   │
├─────────────┤
│  payment_id │
│enrollment_id│
│ payment_date│
│   amount    │
│payment_method│
│   status    │
└─────────────┘
```

## Primary Keys (PK)
- All entities have a primary key that uniquely identifies each record
- Primary keys are auto-incrementing integers for simplicity and performance

## Foreign Keys (FK)
- Foreign keys maintain referential integrity
- Cascade rules: ON DELETE CASCADE for enrollments when students/groups are deleted
- ON DELETE RESTRICT for groups when courses/teachers are referenced

## Constraints Summary

1. **UNIQUE Constraints**:
   - Students.email
   - Teachers.email
   - (student_id, group_id) in Enrollments

2. **NOT NULL Constraints**:
   - All primary keys
   - All foreign keys
   - Essential attributes (names, dates, etc.)

3. **CHECK Constraints**:
   - Payment amounts must be positive
   - Dates must be valid (end_date > start_date)
   - Status values must be from predefined lists
   - Email format validation
