# System Flowchart - Education Center Database System

This document provides comprehensive flowcharts showing how the Education Center Database System works, from initialization to daily operations.

---

## Table of Contents

1. [System Initialization Flow](#1-system-initialization-flow)
2. [Database Schema Creation Flow](#2-database-schema-creation-flow)
3. [Student Enrollment Flow](#3-student-enrollment-flow)
4. [Attendance Recording Flow](#4-attendance-recording-flow)
5. [Payment Processing Flow](#5-payment-processing-flow)
6. [Query Execution Flow](#6-query-execution-flow)
7. [Data Relationship Flow](#7-data-relationship-flow)
8. [Report Generation Flow](#8-report-generation-flow)
9. [System Architecture Flow](#9-system-architecture-flow)

---

## 1. System Initialization Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    SYSTEM INITIALIZATION                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  User runs       │
                    │  ./init.sh       │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Check Docker    │
                    │  Installation    │
                    └────────┬─────────┘
                             │
                    ┌────────┴────────┐
                    │                 │
              ┌─────▼─────┐   ┌──────▼──────┐
              │  Docker   │   │   Docker    │
              │  Running? │   │   Not Found │
              └─────┬─────┘   └──────┬──────┘
                    │                │
                    │                └──────────┐
                    │                           │
                    ▼                           ▼
          ┌──────────────────┐      ┌──────────────────┐
          │  Stop existing   │      │  Display Error   │
          │  containers      │      │  & Exit         │
          │  docker-compose  │      └──────────────────┘
          │  down -v        │
          └────────┬─────────┘
                   │
                   ▼
          ┌──────────────────┐
          │  Start PostgreSQL │
          │  Container       │
          └────────┬─────────┘
                   │
                   ▼
          ┌──────────────────┐
          │  Wait for DB     │
          │  Health Check    │
          └────────┬─────────┘
                   │
          ┌────────┴────────┐
          │                 │
    ┌─────▼─────┐   ┌──────▼──────┐
    │  Healthy  │   │  Timeout    │
    └─────┬─────┘   └──────┬──────┘
          │                │
          │                └──────────┐
          │                           │
          ▼                           ▼
  ┌──────────────────┐      ┌──────────────────┐
  │  Start Adminer   │      │  Display Error   │
  │  Container       │      │  & Exit         │
  └────────┬─────────┘      └──────────────────┘
           │
           ▼
  ┌──────────────────┐
  │  Auto-execute    │
  │  SQL Files       │
  └────────┬─────────┘
           │
           ▼
  ┌──────────────────┐
  │  01_schema.sql   │
  │  (Create Tables) │
  └────────┬─────────┘
           │
           ▼
  ┌──────────────────┐
  │  02_seed_data.sql│
  │  (Load Test Data)│
  └────────┬─────────┘
           │
           ▼
  ┌──────────────────┐
  │  System Ready    │
  │  ✓ 7 Tables     │
  │  ✓ Test Data    │
  └──────────────────┘
```

---

## 2. Database Schema Creation Flow

```
┌─────────────────────────────────────────────────────────────────┐
│              DATABASE SCHEMA CREATION PROCESS                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  Execute         │
                    │  01_schema.sql   │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Drop Existing   │
                    │  Tables (if any)│
                    └────────┬─────────┘
                             │
                             ▼
        ┌──────────────────────────────────────┐
        │  CREATE TABLE students                │
        │  - Primary Key: student_id           │
        │  - Constraints: email UNIQUE         │
        │  - Check: email format, DOB < today  │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  CREATE TABLE teachers                │
        │  - Primary Key: teacher_id           │
        │  - Constraints: email UNIQUE          │
        │  - Check: email format, hire_date    │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  CREATE TABLE courses                │
        │  - Primary Key: course_id           │
        │  - Check: course_type, price >= 0   │
        │  - Check: duration_weeks > 0        │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  CREATE TABLE groups                  │
        │  - Primary Key: group_id             │
        │  - Foreign Key: course_id → courses │
        │  - Foreign Key: teacher_id → teachers│
        │  - Check: end_date > start_date      │
        │  - Check: max_capacity > 0           │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  CREATE TABLE enrollments            │
        │  - Primary Key: enrollment_id        │
        │  - Foreign Key: student_id → students│
        │  - Foreign Key: group_id → groups    │
        │  - Unique: (student_id, group_id)    │
        │  - Check: status values              │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  CREATE TABLE attendances            │
        │  - Primary Key: attendance_id        │
        │  - Foreign Key: enrollment_id        │
        │  - Unique: (enrollment_id, date)      │
        │  - Check: status values              │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  CREATE TABLE payments               │
        │  - Primary Key: payment_id          │
        │  - Foreign Key: enrollment_id        │
        │  - Check: amount > 0                 │
        │  - Check: payment_method values     │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  CREATE INDEXES                      │
        │  - Foreign key indexes              │
        │  - Frequently queried columns         │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  Schema Creation Complete            │
        │  ✓ 7 Tables Created                  │
        │  ✓ All Constraints Applied            │
        │  ✓ Indexes Created                   │
        └──────────────────────────────────────┘
```

---

## 3. Student Enrollment Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    STUDENT ENROLLMENT PROCESS                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  User wants to   │
                    │  enroll student │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Check if        │
                    │  Student Exists  │
                    └────────┬─────────┘
                             │
                    ┌────────┴────────┐
                    │                 │
              ┌─────▼─────┐   ┌──────▼──────┐
              │  Exists   │   │  Not Found  │
              └─────┬─────┘   └──────┬──────┘
                    │                │
                    │                ▼
                    │      ┌──────────────────┐
                    │      │  Create Student  │
                    │      │  Record         │
                    │      └────────┬─────────┘
                    │               │
                    │               ▼
                    │      ┌──────────────────┐
                    │      │  Validate Data   │
                    │      │  - Email format  │
                    │      │  - DOB < today    │
                    │      └────────┬─────────┘
                    │               │
                    │      ┌────────┴────────┐
                    │      │                │
                    │ ┌────▼────┐    ┌──────▼──────┐
                    │ │ Valid   │    │  Invalid   │
                    │ └────┬────┘    └──────┬──────┘
                    │      │                │
                    │      │                └──────────┐
                    │      │                           │
                    │      ▼                           ▼
                    │ ┌──────────────────┐  ┌──────────────────┐
                    │ │ Insert Student    │  │  Return Error    │
                    │ └────────┬─────────┘  └──────────────────┘
                    │          │
                    │          ▼
                    │ ┌──────────────────┐
                    │ │ Student Created   │
                    │ └────────┬─────────┘
                    │          │
                    └──────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Select Group    │
                    │  for Enrollment  │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Check Group     │
                    │  Availability    │
                    └────────┬─────────┘
                             │
                    ┌────────┴────────┐
                    │                 │
              ┌─────▼─────┐   ┌──────▼──────┐
              │ Available │   │  Full       │
              └─────┬─────┘   └──────┬──────┘
                    │                │
                    │                └──────────┐
                    │                           │
                    ▼                           ▼
          ┌──────────────────┐      ┌──────────────────┐
          │  Check Existing  │      │  Return Error    │
          │  Enrollment      │      │  "Group Full"    │
          └────────┬─────────┘      └──────────────────┘
                   │
          ┌────────┴────────┐
          │                 │
    ┌─────▼─────┐   ┌──────▼──────┐
    │  Not      │   │  Already    │
    │  Enrolled │   │  Enrolled   │
    └─────┬─────┘   └──────┬──────┘
          │                │
          │                └──────────┐
          │                           │
          ▼                           ▼
  ┌──────────────────┐      ┌──────────────────┐
  │  Create         │      │  Return Error    │
  │  Enrollment     │      │  "Already        │
  │  Record         │      │   Enrolled"      │
  └────────┬────────┘      └──────────────────┘
           │
           ▼
  ┌──────────────────┐
  │  Validate        │
  │  Enrollment Data  │
  │  - Status value   │
  │  - Date <= today │
  └────────┬─────────┘
           │
  ┌────────┴────────┐
  │                 │
┌─▼─────┐    ┌──────▼──────┐
│ Valid │    │  Invalid    │
└─┬─────┘    └──────┬──────┘
  │                 │
  │                 └──────────┐
  │                            │
  ▼                            ▼
┌──────────────────┐  ┌──────────────────┐
│ Insert Enrollment│  │  Return Error    │
│ Record           │  └──────────────────┘
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Enrollment       │
│ Successful       │
│ ✓ Student ID     │
│ ✓ Group ID       │
│ ✓ Enrollment Date│
│ ✓ Status: Active │
└──────────────────┘
```

---

## 4. Attendance Recording Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                  ATTENDANCE RECORDING PROCESS                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  Teacher/Admin   │
                    │  Records         │
                    │  Attendance      │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Select          │
                    │  Enrollment     │
                    │  (Student+Group)│
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Check if        │
                    │  Enrollment     │
                    │  Exists & Active │
                    └────────┬─────────┘
                             │
                    ┌────────┴────────┐
                    │                 │
              ┌─────▼─────┐   ┌──────▼──────┐
              │  Valid    │   │  Invalid   │
              └─────┬─────┘   └──────┬──────┘
                    │                │
                    │                └──────────┐
                    │                           │
                    ▼                           ▼
          ┌──────────────────┐      ┌──────────────────┐
          │  Check Existing  │      │  Return Error    │
          │  Attendance for  │      │  "Invalid        │
          │  This Date       │      │   Enrollment"    │
          └────────┬─────────┘      └──────────────────┘
                   │
          ┌────────┴────────┐
          │                 │
    ┌─────▼─────┐   ┌──────▼──────┐
    │  No Record│   │  Record     │
    │  Exists    │   │  Exists     │
    └─────┬─────┘   └──────┬──────┘
          │                │
          │                └──────────┐
          │                           │
          ▼                           ▼
  ┌──────────────────┐      ┌──────────────────┐
  │  Enter           │      │  Update Existing │
  │  Attendance Data │      │  Record or       │
  │  - Date          │      │  Return Error    │
  │  - Status        │      │  "Duplicate"     │
  │  - Notes (opt)   │      └──────────────────┘
  └────────┬─────────┘
           │
           ▼
  ┌──────────────────┐
  │  Validate Data   │
  │  - Date format   │
  │  - Status:       │
  │    Present/      │
  │    Absent/Late   │
  └────────┬─────────┘
           │
  ┌────────┴────────┐
  │                 │
┌─▼─────┐    ┌──────▼──────┐
│ Valid │    │  Invalid    │
└─┬─────┘    └──────┬──────┘
  │                 │
  │                 └──────────┐
  │                            │
  ▼                            ▼
┌──────────────────┐  ┌──────────────────┐
│ Insert/Update    │  │  Return Error    │
│ Attendance       │  │  with Details    │
│ Record           │  └──────────────────┘
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Attendance       │
│ Recorded         │
│ ✓ Enrollment ID  │
│ ✓ Date          │
│ ✓ Status        │
│ ✓ Notes (if any)│
└──────────────────┘
         │
         ▼
┌──────────────────┐
│  Can Calculate   │
│  Attendance      │
│  Statistics      │
│  - Total Classes │
│  - Present Count │
│  - Percentage    │
└──────────────────┘
```

---

## 5. Payment Processing Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    PAYMENT PROCESSING FLOW                      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  Student/Admin   │
                    │  Makes Payment   │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Select          │
                    │  Enrollment     │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Get Course      │
                    │  Price          │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Calculate       │
                    │  Outstanding    │
                    │  Balance        │
                    └────────┬─────────┘
                             │
                    ┌────────┴────────┐
                    │                 │
              ┌─────▼─────┐   ┌──────▼──────┐
              │  Balance   │   │  Fully      │
              │  > 0       │   │  Paid       │
              └─────┬─────┘   └──────┬──────┘
                    │                │
                    │                └──────────┐
                    │                           │
                    ▼                           ▼
          ┌──────────────────┐      ┌──────────────────┐
          │  Enter Payment    │      │  Return Message  │
          │  Details          │      │  "No Balance     │
          │  - Amount         │      │   Outstanding"   │
          │  - Method         │      └──────────────────┘
          │  - Date          │
          └────────┬─────────┘
                   │
                   ▼
          ┌──────────────────┐
          │  Validate        │
          │  Payment Data    │
          │  - Amount > 0    │
          │  - Method valid  │
          │  - Date <= today │
          └────────┬─────────┘
                   │
          ┌────────┴────────┐
          │                 │
    ┌─────▼─────┐   ┌──────▼──────┐
    │  Valid    │   │  Invalid    │
    └─────┬─────┘   └──────┬──────┘
          │                │
          │                └──────────┐
          │                           │
          ▼                           ▼
  ┌──────────────────┐      ┌──────────────────┐
  │  Check Amount    │      │  Return Error    │
  │  vs Balance      │      │  with Details    │
  └────────┬─────────┘      └──────────────────┘
           │
  ┌────────┴────────┐
  │                 │
┌─▼─────┐    ┌──────▼──────┐
│ Valid │    │  Exceeds    │
│ Amount│    │  Balance    │
└─┬─────┘    └──────┬──────┘
  │                 │
  │                 └──────────┐
  │                            │
  ▼                            ▼
┌──────────────────┐  ┌──────────────────┐
│ Create Payment   │  │  Return Error    │
│ Record           │  │  "Amount exceeds │
│ - enrollment_id   │  │   balance"       │
│ - amount         │  └──────────────────┘
│ - payment_method │
│ - payment_date   │
│ - status:        │
│   Completed/     │
│   Pending        │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Payment Recorded │
│ ✓ Payment ID     │
│ ✓ Amount         │
│ ✓ Method         │
│ ✓ Date           │
│ ✓ Status         │
└──────────────────┘
         │
         ▼
┌──────────────────┐
│  Update Balance  │
│  Calculation     │
│  - Total Paid    │
│  - Outstanding   │
│  - Payment Count │
└──────────────────┘
```

---

## 6. Query Execution Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    QUERY EXECUTION FLOW                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  User Submits    │
                    │  SQL Query       │
                    │  (via Adminer/   │
                    │   psql)          │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  PostgreSQL      │
                    │  Receives Query  │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Parse Query     │
                    │  - Syntax Check │
                    │  - Validate     │
                    └────────┬─────────┘
                             │
                    ┌────────┴────────┐
                    │                 │
              ┌─────▼─────┐   ┌──────▼──────┐
              │  Valid    │   │  Invalid    │
              └─────┬─────┘   └──────┬──────┘
                    │                │
                    │                └──────────┐
                    │                           │
                    ▼                           ▼
          ┌──────────────────┐      ┌──────────────────┐
          │  Query Planner   │      │  Return Syntax   │
          │  - Analyze Query  │      │  Error          │
          │  - Choose Indexes │      └──────────────────┘
          │  - Optimize Plan  │
          └────────┬─────────┘
                   │
                   ▼
          ┌──────────────────┐
          │  Execute Query    │
          │  - Access Tables  │
          │  - Apply JOINs     │
          │  - Filter Data     │
          │  - Sort Results    │
          │  - Aggregate Data  │
          └────────┬─────────┘
                   │
                   ▼
          ┌──────────────────┐
          │  Apply Constraints │
          │  - Foreign Keys    │
          │  - Check Rules     │
          │  - Unique Rules    │
          └────────┬─────────┘
                   │
                   ▼
          ┌──────────────────┐
          │  Return Results   │
          │  to User          │
          └──────────────────┘
```

### Example: Complex JOIN Query Flow

```
┌─────────────────────────────────────────────────────────────────┐
│              COMPLEX JOIN QUERY EXECUTION                      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  SELECT Query    │
                    │  with JOINs     │
                    └────────┬─────────┘
                             │
                             ▼
        ┌──────────────────────────────────────┐
        │  FROM students s                     │
        │  JOIN enrollments e                  │
        │  JOIN groups g                       │
        │  JOIN courses c                      │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  1. Start with students table        │
        │     (Base table)                     │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  2. JOIN enrollments                │
        │     ON s.student_id = e.student_id  │
        │     - Use index on student_id       │
        │     - Match records                 │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  3. JOIN groups                     │
        │     ON e.group_id = g.group_id     │
        │     - Use index on group_id         │
        │     - Match records                 │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  4. JOIN courses                    │
        │     ON g.course_id = c.course_id   │
        │     - Use index on course_id       │
        │     - Match records                │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  5. Apply WHERE clause              │
        │     - Filter conditions             │
        │     - e.status = 'Active'           │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  6. Apply ORDER BY                  │
        │     - Sort by specified columns     │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  7. Return Result Set              │
        │     - Combined data from all tables │
        └──────────────────────────────────────┘
```

---

## 7. Data Relationship Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                  DATA RELATIONSHIP FLOW                         │
└─────────────────────────────────────────────────────────────────┘

┌──────────────┐
│   COURSES    │
│  (course_id) │
└──────┬───────┘
       │
       │ One-to-Many
       │
       ▼
┌──────────────┐         ┌──────────────┐
│    GROUPS    │◄────────┤   TEACHERS   │
│  (group_id)  │         │ (teacher_id) │
│ course_id FK │         └──────────────┘
│ teacher_id FK│              │
└──────┬───────┘              │
       │                      │
       │                      │ One-to-Many
       │                      │
       │ Many-to-Many         │
       │                      │
       ▼                      ▼
┌──────────────┐         ┌──────────────┐
│ ENROLLMENTS  │         │   STUDENTS   │
│(enrollment_id)│        │ (student_id) │
│ student_id FK│         └──────────────┘
│  group_id FK │              │
└──────┬───────┘              │
       │                      │
       │ One-to-Many          │
       │                      │
       │                      │
       ▼                      │
┌──────────────┐             │
│ ATTENDANCES  │             │
│(attendance_id)│            │
│enrollment_id │             │
│     FK       │             │
└──────────────┘             │
                              │
                              │
       ┌──────────────────────┘
       │
       ▼
┌──────────────┐
│   PAYMENTS   │
│ (payment_id) │
│enrollment_id │
│     FK       │
└──────────────┘

DATA FLOW EXAMPLES:

1. Course → Group Creation:
   Course (Python) → Creates → Group (Python-2024-A)
   
2. Student Enrollment:
   Student (John) + Group (Python-2024-A) → Creates → Enrollment
   
3. Attendance Tracking:
   Enrollment → Records → Attendance (Date, Status)
   
4. Payment Processing:
   Enrollment → Records → Payment (Amount, Method, Date)
   
5. Reporting:
   All Tables → JOIN → Reports (Statistics, Analytics)
```

---

## 8. Report Generation Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                  REPORT GENERATION FLOW                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  User Requests   │
                    │  Report          │
                    │  (e.g.,          │
                    │   Attendance     │
                    │   Statistics)    │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Determine       │
                    │  Report Type     │
                    └────────┬─────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Attendance  │    │   Payment     │    │  Enrollment  │
│   Report     │    │   Report      │    │   Report     │
└──────┬───────┘    └──────┬───────┘    └──────┬───────┘
       │                   │                    │
       ▼                   ▼                    ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ Query:       │    │ Query:       │    │ Query:       │
│ - JOIN       │    │ - JOIN        │    │ - JOIN       │
│   students   │    │   enrollments │    │   students   │
│   enrollments│    │   payments    │    │   groups     │
│   attendances│    │   courses     │    │   courses    │
│ - GROUP BY   │    │ - SUM amounts │    │ - COUNT      │
│ - COUNT      │    │ - Calculate   │    │ - GROUP BY   │
│ - Calculate  │    │   balances    │    │   course     │
│   percentage │    │ - Filter by   │    │ - ORDER BY   │
│              │    │   status       │    │   enrollment │
└──────┬───────┘    └──────┬───────┘    └──────┬───────┘
       │                   │                    │
       └───────────────────┼───────────────────┘
                           │
                           ▼
                  ┌──────────────────┐
                  │  Execute Query   │
                  │  - Use Indexes   │
                  │  - Join Tables    │
                  │  - Aggregate Data│
                  └────────┬─────────┘
                           │
                           ▼
                  ┌──────────────────┐
                  │  Format Results  │
                  │  - Calculate     │
                  │    percentages   │
                  │  - Sort Data     │
                  │  - Format Numbers│
                  └────────┬─────────┘
                           │
                           ▼
                  ┌──────────────────┐
                  │  Display Report  │
                  │  - Table Format   │
                  │  - Summary Stats  │
                  │  - Export Option  │
                  └──────────────────┘
```

### Example: Attendance Statistics Report Flow

```
┌─────────────────────────────────────────────────────────────────┐
│            ATTENDANCE STATISTICS REPORT GENERATION              │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  SELECT Query    │
                    │  with Aggregation│
                    └────────┬─────────┘
                             │
                             ▼
        ┌──────────────────────────────────────┐
        │  FROM students s                     │
        │  JOIN enrollments e                  │
        │  JOIN groups g                       │
        │  LEFT JOIN attendances a             │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  WHERE e.status = 'Active'           │
        │  - Filter active enrollments only   │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  GROUP BY                            │
        │  s.student_id,                       │
        │  s.first_name,                       │
        │  s.last_name,                        │
        │  g.group_name                        │
        │  - Group by student and group        │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  Aggregate Functions:                │
        │  - COUNT(a.attendance_id)            │
        │    AS total_classes                  │
        │  - COUNT(CASE WHEN a.status =        │
        │    'Present' THEN 1 END)              │
        │    AS present_count                  │
        │  - COUNT(CASE WHEN a.status =        │
        │    'Absent' THEN 1 END)              │
        │    AS absent_count                   │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  Calculate Percentage:               │
        │  - present_count / total_classes     │
        │    * 100 AS attendance_percentage    │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  ORDER BY                            │
        │  attendance_percentage DESC,          │
        │  s.last_name                          │
        │  - Sort by percentage, then name     │
        └──────────────┬───────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────────┐
        │  Return Results:                     │
        │  - Student Name                      │
        │  - Group Name                       │
        │  - Total Classes                    │
        │  - Present Count                    │
        │  - Absent Count                     │
        │  - Attendance Percentage            │
        └──────────────────────────────────────┘
```

---

## 9. System Architecture Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                  SYSTEM ARCHITECTURE FLOW                        │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                         USER LAYER                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │   Adminer    │  │   psql CLI   │  │  Application  │         │
│  │  (Web UI)    │  │  (Terminal)  │  │   (Future)    │         │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘         │
│         │                 │                  │                  │
└─────────┼─────────────────┼──────────────────┼──────────────────┘
          │                 │                  │
          │                 │                  │
          │         SQL Queries / Commands     │
          │                 │                  │
          │                 │                  │
┌─────────▼─────────────────▼──────────────────▼──────────────────┐
│                    DATABASE LAYER                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              PostgreSQL 15 Database                      │   │
│  │  ┌────────────────────────────────────────────────────┐  │   │
│  │  │  Query Parser & Planner                            │  │   │
│  │  └────────────────────────────────────────────────────┘  │   │
│  │  ┌────────────────────────────────────────────────────┐  │   │
│  │  │  Transaction Manager                                │  │   │
│  │  └────────────────────────────────────────────────────┘  │   │
│  │  ┌────────────────────────────────────────────────────┐  │   │
│  │  │  Constraint Enforcer                               │  │   │
│  │  │  - Primary Keys                                     │  │   │
│  │  │  - Foreign Keys                                     │  │   │
│  │  │  - Unique Constraints                              │  │   │
│  │  │  - Check Constraints                               │  │   │
│  │  └────────────────────────────────────────────────────┘  │   │
│  │  ┌────────────────────────────────────────────────────┐  │   │
│  │  │  Index Manager                                      │  │   │
│  │  │  - Foreign Key Indexes                              │  │   │
│  │  │  - Query Optimization Indexes                       │  │   │
│  │  └────────────────────────────────────────────────────┘  │   │
│  └──────────────────────────────────────────────────────────┘   │
│                          │                                        │
│                          │ Data Access                            │
│                          │                                        │
└──────────────────────────┼────────────────────────────────────────┘
                           │
                           │
┌──────────────────────────▼────────────────────────────────────────┐
│                    STORAGE LAYER                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  PostgreSQL Data Files                                     │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │   │
│  │  │students  │  │teachers  │  │courses   │  │groups    │  │   │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐              │   │
│  │  │enrollments│ │attendances│ │payments  │              │   │
│  │  └──────────┘  └──────────┘  └──────────┘              │   │
│  └──────────────────────────────────────────────────────────┘   │
└───────────────────────────────────────────────────────────────────┘

DATA FLOW:
1. User submits query/command
2. PostgreSQL parses and validates
3. Query planner optimizes execution
4. Constraint enforcer validates data
5. Index manager uses indexes for speed
6. Transaction manager ensures ACID
7. Data stored/retrieved from storage
8. Results returned to user
```

---

## Summary

This flowchart documentation provides a comprehensive view of how the Education Center Database System operates:

1. **Initialization**: How the system starts up and creates the database
2. **Schema Creation**: How tables and constraints are established
3. **Student Enrollment**: Complete enrollment workflow
4. **Attendance Recording**: How attendance is tracked
5. **Payment Processing**: Payment workflow and validation
6. **Query Execution**: How queries are processed
7. **Data Relationships**: How tables connect and relate
8. **Report Generation**: How reports are created
9. **System Architecture**: Overall system structure

Each flowchart shows the decision points, validation steps, and data flow through the system, making it easy to understand how the database system operates end-to-end.
