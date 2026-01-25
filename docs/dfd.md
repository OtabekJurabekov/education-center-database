# Data Flow Diagrams (DFD) - Education Center Database System

This document provides comprehensive Data Flow Diagrams (DFDs) showing how data flows through the Education Center Database System at different levels of detail.

---

## Table of Contents

1. [Context Diagram (Level 0)](#context-diagram-level-0)
2. [Level 1 DFD - System Overview](#level-1-dfd-system-overview)
3. [Level 2 DFD - Student Management](#level-2-dfd-student-management)
4. [Level 2 DFD - Course Management](#level-2-dfd-course-management)
5. [Level 2 DFD - Enrollment Management](#level-2-dfd-enrollment-management)
6. [Level 2 DFD - Attendance Management](#level-2-dfd-attendance-management)
7. [Level 2 DFD - Payment Management](#level-2-dfd-payment-management)
8. [Level 2 DFD - Reporting System](#level-2-dfd-reporting-system)

---

## Context Diagram (Level 0)

This diagram shows the system as a single process and its interactions with external entities.

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                   │
│                    Education Center Database System               │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                                                          │   │
│  │              Database Management System                  │   │
│  │                                                          │   │
│  │  • Student Management                                    │   │
│  │  • Course Management                                     │   │
│  │  • Enrollment Management                                 │   │
│  │  • Attendance Tracking                                   │   │
│  │  • Payment Processing                                    │   │
│  │  • Report Generation                                     │   │
│  │                                                          │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
         │                    │                    │
         │                    │                    │
    ┌────▼────┐          ┌────▼────┐          ┌────▼────┐
    │         │          │         │          │         │
    │Students │          │Teachers │          │  Admin  │
    │         │          │         │          │  Staff  │
    └────┬────┘          └────┬────┘          └────┬────┘
         │                    │                    │
         │                    │                    │
    Student Info         Teacher Info         Management
    Enrollment          Assignment           Reports
    Attendance          Schedule             Queries
    Payments            Updates              Updates

DATA FLOWS:
- Student Information → System
- Enrollment Requests → System
- Attendance Records → System
- Payment Information → System
- Course Information → System
- Teacher Assignments → System
- Reports ← System
- Student Records ← System
- Enrollment Confirmations ← System
```

---

## Level 1 DFD - System Overview

This diagram breaks down the system into major processes.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         Education Center Database System                      │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────┐
│   Students   │
└──────┬───────┘
       │ Student Data
       │
       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                               │
│  ┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐       │
│  │  1.0 Student     │    │  2.0 Course      │    │  3.0 Enrollment  │       │
│  │  Management      │    │  Management     │    │  Management     │       │
│  │                  │    │                  │    │                  │       │
│  │  • Register      │    │  • Create Course │    │  • Enroll Student│       │
│  │  • Update        │    │  • Create Group  │    │  • Update Status │       │
│  │  • View          │    │  • Assign Teacher│    │  • View          │       │
│  └────────┬─────────┘    └────────┬─────────┘    └────────┬─────────┘       │
│           │                       │                       │                  │
│           │                       │                       │                  │
│  ┌────────▼─────────┐    ┌───────▼────────┐    ┌───────▼────────┐       │
│  │  4.0 Attendance   │    │  5.0 Payment    │    │  6.0 Reporting │       │
│  │  Tracking         │    │  Processing     │    │  System         │       │
│  │                    │    │                  │    │                  │       │
│  │  • Record         │    │  • Record Payment│    │  • Generate      │       │
│  │  • Calculate      │    │  • Calculate     │    │    Reports       │       │
│  │  • View           │    │  • View Balance │    │  • Statistics     │       │
│  └────────┬──────────┘    └────────┬─────────┘    └────────┬─────────┘       │
│           │                       │                       │                  │
│           │                       │                       │                  │
│           └───────────────────────┼───────────────────────┘                  │
│                                   │                                           │
│                           ┌───────▼────────┐                                  │
│                           │   Database     │                                  │
│                           │   (PostgreSQL) │                                  │
│                           │                 │                                  │
│                           │  • students     │                                  │
│                           │  • teachers     │                                  │
│                           │  • courses      │                                  │
│                           │  • groups       │                                  │
│                           │  • enrollments  │                                  │
│                           │  • attendances   │                                  │
│                           │  • payments     │                                  │
│                           └─────────────────┘                                  │
│                                                                               │
└───────────────────────────────────────────────────────────────────────────────┘

EXTERNAL ENTITIES:
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   Students   │         │   Teachers  │         │  Admin Staff │
└──────────────┘         └──────────────┘         └──────────────┘
```

---

## Level 2 DFD - Student Management

```
┌─────────────────────────────────────────────────────────────────┐
│                   1.0 Student Management                         │
└─────────────────────────────────────────────────────────────────┘

┌──────────────┐
│   Students   │
└──────┬───────┘
       │ Student Registration Data
       │
       ▼
┌──────────────────┐
│  1.1 Register    │
│  New Student     │
└────────┬─────────┘
         │
         │ Validated Student Data
         │
         ▼
┌──────────────────┐         ┌──────────────────┐
│  1.2 Validate    │         │  1.3 Store      │
│  Student Data    │─────────▶│  Student Record  │
│                  │          │                  │
│  • Email format  │          │  • Insert into   │
│  • DOB check     │          │    students table│
│  • Required      │          │  • Generate ID   │
│    fields        │          │  • Return        │
└──────────────────┘          └────────┬─────────┘
                                        │
                                        │ Student Record
                                        │
                                        ▼
                               ┌──────────────────┐
                               │   Database       │
                               │   students table │
                               └──────────────────┘

DATA FLOWS:
- Student Registration Data → 1.1
- Validated Data → 1.2
- Student Record → Database
- Confirmation ← 1.3
```

---

## Level 2 DFD - Course Management

```
┌─────────────────────────────────────────────────────────────────┐
│                   2.0 Course Management                          │
└─────────────────────────────────────────────────────────────────┘

┌──────────────┐
│  Admin Staff │
└──────┬───────┘
       │ Course/Group Data
       │
       ▼
┌──────────────────┐
│  2.1 Create      │
│  Course          │
└────────┬─────────┘
         │
         │ Course Data
         │
         ▼
┌──────────────────┐         ┌──────────────────┐
│  2.2 Validate     │         │  2.3 Store       │
│  Course Data      │─────────▶│  Course Record  │
│                   │          │                  │
│  • Course type    │          │  • Insert into  │
│  • Price >= 0    │          │    courses table │
│  • Duration > 0  │          │  • Generate ID   │
└──────────────────┘          └────────┬─────────┘
                                        │
                                        │ Course Record
                                        │
                                        ▼
                               ┌──────────────────┐
                               │   Database       │
                               │   courses table  │
                               └──────────────────┘

┌──────────────┐
│  Admin Staff │
└──────┬───────┘
       │ Group Data
       │
       ▼
┌──────────────────┐
│  2.4 Create       │
│  Group            │
└────────┬─────────┘
         │
         │ Group Data
         │
         ▼
┌──────────────────┐         ┌──────────────────┐
│  2.5 Validate     │         │  2.6 Store      │
│  Group Data       │─────────▶│  Group Record   │
│                   │          │                  │
│  • Course exists  │          │  • Insert into  │
│  • Teacher exists │          │    groups table │
│  • Dates valid    │          │  • Link to      │
│  • Capacity > 0   │          │    course/teacher│
└──────────────────┘          └────────┬─────────┘
                                        │
                                        │ Group Record
                                        │
                                        ▼
                               ┌──────────────────┐
                               │   Database       │
                               │   groups table   │
                               └──────────────────┘
```

---

## Level 2 DFD - Enrollment Management

```
┌─────────────────────────────────────────────────────────────────┐
│                   3.0 Enrollment Management                     │
└─────────────────────────────────────────────────────────────────┘

┌──────────────┐
│   Students   │
└──────┬───────┘
       │ Enrollment Request
       │
       ▼
┌──────────────────┐
│  3.1 Check       │
│  Student Exists  │
└────────┬─────────┘
         │
         │ Student Data
         │
         ▼
┌──────────────────┐
│  3.2 Check        │
│  Group Available │
└────────┬─────────┘
         │
         │ Group Data
         │
         ▼
┌──────────────────┐
│  3.3 Check       │
│  Duplicate       │
│  Enrollment      │
└────────┬─────────┘
         │
         │ Valid Enrollment
         │
         ▼
┌──────────────────┐         ┌──────────────────┐
│  3.4 Create      │         │  3.5 Store       │
│  Enrollment      │─────────▶│  Enrollment      │
│  Record          │          │  Record          │
│                   │          │                  │
│  • Set status    │          │  • Insert into   │
│  • Set date      │          │    enrollments   │
│  • Link student  │          │  • Generate ID   │
│    and group     │          │  • Return         │
└──────────────────┘          └────────┬─────────┘
                                        │
                                        │ Enrollment Record
                                        │
                                        ▼
                               ┌──────────────────┐
                               │   Database       │
                               │   enrollments    │
                               │   table          │
                               └──────────────────┘
                                        │
                                        │ Enrollment Data
                                        │
                                        ▼
                               ┌──────────────────┐
                               │  Confirmation    │
                               │  to Student      │
                               └──────────────────┘
```

---

## Level 2 DFD - Attendance Management

```
┌─────────────────────────────────────────────────────────────────┐
│                   4.0 Attendance Tracking                       │
└─────────────────────────────────────────────────────────────────┘

┌──────────────┐
│   Teachers   │
└──────┬───────┘
       │ Attendance Data
       │
       ▼
┌──────────────────┐
│  4.1 Validate     │
│  Enrollment      │
└────────┬─────────┘
         │
         │ Enrollment Data
         │
         ▼
┌──────────────────┐
│  4.2 Check       │
│  Duplicate       │
│  Attendance      │
└────────┬─────────┘
         │
         │ Valid Attendance
         │
         ▼
┌──────────────────┐         ┌──────────────────┐
│  4.3 Record      │         │  4.4 Store        │
│  Attendance      │─────────▶│  Attendance      │
│                   │          │  Record          │
│  • Status        │          │                  │
│  • Date          │          │  • Insert into    │
│  • Notes         │          │    attendances   │
│                   │          │  • Generate ID   │
└──────────────────┘          └────────┬─────────┘
                                        │
                                        │ Attendance Record
                                        │
                                        ▼
                               ┌──────────────────┐
                               │   Database       │
                               │   attendances    │
                               │   table          │
                               └──────────────────┘
                                        │
                                        │ Attendance Data
                                        │
                                        ▼
                               ┌──────────────────┐
                               │  4.5 Calculate   │
                               │  Statistics     │
                               │                  │
                               │  • Total classes │
                               │  • Present count │
                               │  • Percentage    │
                               └────────┬─────────┘
                                        │
                                        │ Statistics
                                        │
                                        ▼
                               ┌──────────────────┐
                               │  Reports         │
                               └──────────────────┘
```

---

## Level 2 DFD - Payment Management

```
┌─────────────────────────────────────────────────────────────────┐
│                   5.0 Payment Processing                        │
└─────────────────────────────────────────────────────────────────┘

┌──────────────┐
│   Students   │
└──────┬───────┘
       │ Payment Data
       │
       ▼
┌──────────────────┐
│  5.1 Validate     │
│  Enrollment      │
└────────┬─────────┘
         │
         │ Enrollment Data
         │
         ▼
┌──────────────────┐
│  5.2 Get Course  │
│  Price           │
└────────┬─────────┘
         │
         │ Course Price
         │
         ▼
┌──────────────────┐
│  5.3 Calculate   │
│  Outstanding     │
│  Balance         │
└────────┬─────────┘
         │
         │ Balance Data
         │
         ▼
┌──────────────────┐
│  5.4 Validate    │
│  Payment Data    │
│                   │
│  • Amount > 0    │
│  • Method valid  │
│  • Status valid  │
└────────┬─────────┘
         │
         │ Valid Payment
         │
         ▼
┌──────────────────┐         ┌──────────────────┐
│  5.5 Record      │         │  5.6 Store       │
│  Payment         │─────────▶│  Payment Record  │
│                   │          │                  │
│  • Amount        │          │  • Insert into   │
│  • Method        │          │    payments table│
│  • Date          │          │  • Generate ID   │
│  • Status        │          │  • Return        │
└──────────────────┘          └────────┬─────────┘
                                        │
                                        │ Payment Record
                                        │
                                        ▼
                               ┌──────────────────┐
                               │   Database       │
                               │   payments table │
                               └──────────────────┘
                                        │
                                        │ Payment Data
                                        │
                                        ▼
                               ┌──────────────────┐
                               │  5.7 Update      │
                               │  Balance         │
                               │                  │
                               │  • Total paid    │
                               │  • Outstanding   │
                               └────────┬─────────┘
                                        │
                                        │ Updated Balance
                                        │
                                        ▼
                               ┌──────────────────┐
                               │  Confirmation    │
                               │  to Student      │
                               └──────────────────┘
```

---

## Level 2 DFD - Reporting System

```
┌─────────────────────────────────────────────────────────────────┐
│                   6.0 Reporting System                          │
└─────────────────────────────────────────────────────────────────┘

┌──────────────┐
│  Admin Staff │
└──────┬───────┘
       │ Report Request
       │
       ▼
┌──────────────────┐
│  6.1 Determine   │
│  Report Type     │
└────────┬─────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐
│6.2     │  │6.3     │  │6.4     │  │6.5     │
│Attendance│ │Payment │  │Enrollment│ │Teacher │
│Report  │  │Report  │  │Report   │  │Workload│
└───┬────┘  └───┬────┘  └───┬────┘  └───┬────┘
    │           │           │           │
    │           │           │           │
    └───────────┼───────────┼───────────┘
                │           │
                │           │
                ▼           ▼
        ┌───────────────────────┐
        │  6.6 Execute Query     │
        │                        │
        │  • JOIN tables         │
        │  • Filter data         │
        │  • Aggregate data      │
        │  • Sort results        │
        └───────────┬───────────┘
                    │
                    │ Query Results
                    │
                    ▼
        ┌───────────────────────┐
        │   Database             │
        │   (All Tables)         │
        └───────────┬───────────┘
                    │
                    │ Data
                    │
                    ▼
        ┌───────────────────────┐
        │  6.7 Format Results   │
        │                        │
        │  • Calculate           │
        │  • Format numbers      │
        │  • Structure output    │
        └───────────┬───────────┘
                    │
                    │ Formatted Report
                    │
                    ▼
        ┌───────────────────────┐
        │  Report to Admin       │
        └───────────────────────┘
```

---

## Data Dictionary for DFD

### Data Stores

| Data Store | Description | Contents |
|------------|-------------|----------|
| **D1: Students** | Student information | student_id, name, email, phone, DOB, address |
| **D2: Teachers** | Teacher information | teacher_id, name, email, specialization |
| **D3: Courses** | Course definitions | course_id, name, type, price, duration |
| **D4: Groups** | Class groups | group_id, course_id, teacher_id, schedule, capacity |
| **D5: Enrollments** | Student enrollments | enrollment_id, student_id, group_id, status |
| **D6: Attendances** | Attendance records | attendance_id, enrollment_id, date, status |
| **D7: Payments** | Payment records | payment_id, enrollment_id, amount, method, status |

### Data Flows

| Data Flow | From | To | Description |
|-----------|------|-----|-------------|
| Student Registration Data | Students | 1.1 Register | Student personal information |
| Validated Student Data | 1.2 Validate | 1.3 Store | Validated student information |
| Student Record | 1.3 Store | D1: Students | Complete student record |
| Enrollment Request | Students | 3.1 Check | Request to enroll in group |
| Attendance Data | Teachers | 4.1 Validate | Attendance information |
| Payment Data | Students | 5.1 Validate | Payment information |
| Report Request | Admin Staff | 6.1 Determine | Request for specific report |
| Report | 6.7 Format | Admin Staff | Formatted report output |

---

## Summary

These Data Flow Diagrams provide:

1. **Context Level (Level 0)**: System boundaries and external entities
2. **Level 1**: Major system processes
3. **Level 2**: Detailed process breakdowns for:
   - Student Management
   - Course Management
   - Enrollment Management
   - Attendance Tracking
   - Payment Processing
   - Reporting System

Each DFD shows:
- ✅ **Processes**: What the system does
- ✅ **Data Stores**: Where data is stored
- ✅ **Data Flows**: How data moves through the system
- ✅ **External Entities**: Who interacts with the system

These diagrams help understand the complete data flow and system architecture of the Education Center Database System.
