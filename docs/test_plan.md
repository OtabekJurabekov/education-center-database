# Test Plan - Education Center Database System

## Overview

This document outlines the comprehensive testing strategy for the Education Center Database System, covering both functional and structural testing to ensure the system meets all requirements and maintains data integrity.

## Testing Objectives

1. **Functional Testing**: Verify that the system fulfills user requirements
2. **Structural Testing**: Confirm referential integrity and constraint enforcement
3. **Data Integrity Testing**: Ensure data validation rules work correctly
4. **Query Testing**: Validate that queries return expected results

---

## Test Environment

- **Database**: PostgreSQL 15
- **Management Tool**: Adminer
- **Test Data**: Provided in `seed_data.sql`

---

## Test Cases

### Section 1: Functional Testing

#### TC-F001: Student Registration
**Objective**: Verify that new students can be registered with all required information

**Test Steps**:
1. Insert a new student record with all required fields
2. Verify the record is created successfully
3. Attempt to insert a student with duplicate email
4. Attempt to insert a student with invalid email format
5. Attempt to insert a student with NULL required fields

**Expected Results**:
- ✅ Student record created with auto-generated student_id
- ✅ Duplicate email insertion fails with UNIQUE constraint error
- ✅ Invalid email format fails with CHECK constraint error
- ✅ NULL required fields fail with NOT NULL constraint error

**Actual Results**: [To be filled during testing]

**Status**: [ ] Pass [ ] Fail

---

#### TC-F002: Course Creation
**Objective**: Verify that courses can be created with proper validation

**Test Steps**:
1. Insert a new course with valid data
2. Attempt to insert a course with invalid course_type
3. Attempt to insert a course with negative price
4. Attempt to insert a course with zero or negative duration

**Expected Results**:
- ✅ Course created successfully
- ✅ Invalid course_type fails (must be: Programming, Foreign Language, Professional Certification)
- ✅ Negative price fails with CHECK constraint
- ✅ Invalid duration fails with CHECK constraint

**Actual Results**: [To be filled during testing]

**Status**: [ ] Pass [ ] Fail

---

#### TC-F003: Group Creation and Teacher Assignment
**Objective**: Verify that groups can be created and teachers assigned

**Test Steps**:
1. Create a new group with valid course_id and teacher_id
2. Attempt to create a group with non-existent course_id
3. Attempt to create a group with non-existent teacher_id
4. Attempt to create a group with end_date before start_date
5. Attempt to create a group with duplicate group_name

**Expected Results**:
- ✅ Group created successfully
- ✅ Non-existent course_id fails with foreign key constraint
- ✅ Non-existent teacher_id fails with foreign key constraint
- ✅ Invalid date range fails with CHECK constraint
- ✅ Duplicate group_name fails with UNIQUE constraint

**Actual Results**: [To be filled during testing]

**Status**: [ ] Pass [ ] Fail

---

#### TC-F004: Student Enrollment
**Objective**: Verify that students can be enrolled in groups

**Test Steps**:
1. Enroll a student in a group
2. Attempt to enroll the same student in the same group twice
3. Enroll a student in multiple different groups
4. Attempt to enroll a student in a non-existent group
5. Attempt to enroll a non-existent student in a group

**Expected Results**:
- ✅ Enrollment created successfully
- ✅ Duplicate enrollment fails with UNIQUE constraint
- ✅ Student can be enrolled in multiple groups
- ✅ Non-existent group fails with foreign key constraint
- ✅ Non-existent student fails with foreign key constraint

**Actual Results**: [To be filled during testing]

**Status**: [ ] Pass [ ] Fail

---

#### TC-F005: Attendance Recording
**Objective**: Verify that attendance can be recorded for enrolled students

**Test Steps**:
1. Record attendance for an enrolled student
2. Attempt to record attendance for a non-existent enrollment
3. Attempt to record duplicate attendance for the same enrollment and date
4. Attempt to record attendance with invalid status
5. Record multiple attendance records for the same enrollment

**Expected Results**:
- ✅ Attendance recorded successfully
- ✅ Non-existent enrollment fails with foreign key constraint
- ✅ Duplicate attendance fails with UNIQUE constraint
- ✅ Invalid status fails (must be: Present, Absent, Late)
- ✅ Multiple attendance records allowed for different dates

**Actual Results**: [To be filled during testing]

**Status**: [ ] Pass [ ] Fail

---

#### TC-F006: Payment Processing
**Objective**: Verify that payments can be recorded and validated

**Test Steps**:
1. Record a payment for an enrollment
2. Attempt to record a payment with negative amount
3. Attempt to record a payment with zero amount
4. Attempt to record a payment with invalid payment_method
5. Attempt to record a payment with invalid status
6. Record multiple payments for the same enrollment (installments)

**Expected Results**:
- ✅ Payment recorded successfully
- ✅ Negative amount fails with CHECK constraint
- ✅ Zero amount fails with CHECK constraint
- ✅ Invalid payment_method fails (must be: Cash, Card, Bank Transfer)
- ✅ Invalid status fails (must be: Completed, Pending, Refunded)
- ✅ Multiple payments allowed for same enrollment

**Actual Results**: [To be filled during testing]

**Status**: [ ] Pass [ ] Fail

---

### Section 2: Structural Testing

#### TC-S001: Referential Integrity - Foreign Keys
**Objective**: Verify that foreign key constraints maintain referential integrity

**Test Steps**:
1. Attempt to delete a course that has groups assigned
2. Attempt to delete a teacher that has groups assigned
3. Delete a student and verify cascade deletion of enrollments
4. Delete an enrollment and verify cascade deletion of attendances and payments
5. Attempt to update a course_id that is referenced by groups

**Expected Results**:
- ✅ Course deletion fails with RESTRICT constraint (groups exist)
- ✅ Teacher deletion fails with RESTRICT constraint (groups exist)
- ✅ Student deletion cascades to enrollments (CASCADE)
- ✅ Enrollment deletion cascades to attendances and payments (CASCADE)
- ✅ Course_id update cascades to groups (CASCADE)

**Actual Results**: [To be filled during testing]

**Status**: [ ] Pass [ ] Fail

---

#### TC-S002: Primary Key Constraints
**Objective**: Verify that primary keys are unique and not nullable

**Test Steps**:
1. Attempt to insert a record with NULL primary key
2. Attempt to insert duplicate primary key values
3. Verify auto-increment functionality

**Expected Results**:
- ✅ NULL primary key fails
- ✅ Duplicate primary key fails
- ✅ Primary keys auto-increment correctly

**Actual Results**: [To be filled during testing]

**Status**: [ ] Pass [ ] Fail

---

#### TC-S003: Unique Constraints
**Objective**: Verify that UNIQUE constraints prevent duplicate values

**Test Steps**:
1. Attempt to insert duplicate student email
2. Attempt to insert duplicate teacher email
3. Attempt to create duplicate group_name
4. Attempt to create duplicate (student_id, group_id) enrollment

**Expected Results**:
- ✅ All duplicate insertions fail with UNIQUE constraint error

**Actual Results**: [To be filled during testing]

**Status**: [ ] Pass [ ] Fail

---

#### TC-S004: Check Constraints
**Objective**: Verify that CHECK constraints enforce business rules

**Test Steps**:
1. Test all CHECK constraints defined in schema:
   - Email format validation
   - Date validations (DOB < current date, end_date > start_date)
   - Positive values (price, amount, duration, capacity)
   - Status values (enrollment, attendance, payment statuses)
   - Course type values
   - Payment method values

**Expected Results**:
- ✅ All invalid values fail with appropriate CHECK constraint errors

**Actual Results**: [To be filled during testing]

**Status**: [ ] Pass [ ] Fail

---

### Section 3: Query Testing

#### TC-Q001: JOIN Operations
**Objective**: Verify that JOIN queries return correct related data

**Test Steps**:
1. Execute query joining students, enrollments, groups, and courses
2. Execute query joining groups, teachers, and courses
3. Execute query with LEFT JOIN to show all students (including those without enrollments)
4. Verify that JOIN results match expected relationships

**Expected Results**:
- ✅ All JOIN queries return correct related data
- ✅ No orphaned records in results
- ✅ LEFT JOIN shows NULL for missing relationships

**Actual Results**: [To be filled during testing]

**Status**: [ ] Pass [ ] Fail

---

#### TC-Q002: Aggregation Functions
**Objective**: Verify that aggregation queries calculate correctly

**Test Steps**:
1. Execute query counting enrollments per course
2. Execute query summing payments per enrollment
3. Execute query calculating average attendance percentage
4. Verify aggregation results match manual calculations

**Expected Results**:
- ✅ COUNT, SUM, AVG functions return correct values
- ✅ GROUP BY clauses work correctly
- ✅ Results match expected calculations

**Actual Results**: [To be filled during testing]

**Status**: [ ] Pass [ ] Fail

---

#### TC-Q003: Filtering and Sorting
**Objective**: Verify that WHERE and ORDER BY clauses work correctly

**Test Steps**:
1. Filter students by enrollment status
2. Filter payments by date range
3. Sort results by multiple columns
4. Combine filtering and sorting

**Expected Results**:
- ✅ WHERE clauses filter correctly
- ✅ ORDER BY sorts correctly
- ✅ Combined operations work as expected

**Actual Results**: [To be filled during testing]

**Status**: [ ] Pass [ ] Fail

---

#### TC-Q004: Complex Reporting Queries
**Objective**: Verify that complex reporting queries return meaningful data

**Test Steps**:
1. Execute attendance statistics query
2. Execute payment summary query
3. Execute outstanding payments query
4. Execute teacher workload report
5. Verify report accuracy

**Expected Results**:
- ✅ All reporting queries execute successfully
- ✅ Reports contain accurate, meaningful data
- ✅ Reports support management decision-making

**Actual Results**: [To be filled during testing]

**Status**: [ ] Pass [ ] Fail

---

## Test Execution Log

| Test Case ID | Test Date | Tester | Result | Notes |
|--------------|-----------|--------|--------|-------|
| TC-F001 | | | | |
| TC-F002 | | | | |
| TC-F003 | | | | |
| TC-F004 | | | | |
| TC-F005 | | | | |
| TC-F006 | | | | |
| TC-S001 | | | | |
| TC-S002 | | | | |
| TC-S003 | | | | |
| TC-S004 | | | | |
| TC-Q001 | | | | |
| TC-Q002 | | | | |
| TC-Q003 | | | | |
| TC-Q004 | | | | |

---

## Test Data Requirements

### Test Scenarios Covered:
1. ✅ Valid data insertion
2. ✅ Invalid data rejection
3. ✅ Relationship integrity
4. ✅ Cascade operations
5. ✅ Constraint enforcement
6. ✅ Query accuracy

### Sample Test Data:
- 10 students
- 8 teachers
- 8 courses
- 10 groups
- 20 enrollments
- 30+ attendance records
- 25+ payment records

---

## Known Issues and Limitations

[To be documented during testing]

---

## Test Summary

### Overall Test Results:
- **Total Test Cases**: 14
- **Passed**: [To be filled]
- **Failed**: [To be filled]
- **Pass Rate**: [To be calculated]

### Critical Issues:
[To be documented]

### Recommendations:
[To be documented]

---

## Appendix: SQL Test Scripts

### Test Script 1: Functional Test - Student Registration
```sql
-- Valid student insertion
INSERT INTO students (first_name, last_name, email, phone, date_of_birth, address)
VALUES ('Test', 'Student', 'test.student@email.com', '+1-555-9999', '2000-01-01', 'Test Address');

-- Duplicate email (should fail)
INSERT INTO students (first_name, last_name, email, phone, date_of_birth, address)
VALUES ('Test2', 'Student2', 'test.student@email.com', '+1-555-9998', '2000-01-02', 'Test Address2');

-- Invalid email format (should fail)
INSERT INTO students (first_name, last_name, email, phone, date_of_birth, address)
VALUES ('Test3', 'Student3', 'invalid-email', '+1-555-9997', '2000-01-03', 'Test Address3');
```

### Test Script 2: Structural Test - Referential Integrity
```sql
-- Attempt to delete course with groups (should fail)
DELETE FROM courses WHERE course_id = 1;

-- Delete student (should cascade to enrollments)
DELETE FROM students WHERE student_id = 1;
SELECT COUNT(*) FROM enrollments WHERE student_id = 1; -- Should return 0
```

### Test Script 3: Query Test - JOIN Operations
```sql
-- Test comprehensive JOIN query
SELECT s.first_name, s.last_name, c.course_name, g.group_name
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN groups g ON e.group_id = g.group_id
INNER JOIN courses c ON g.course_id = c.course_id
LIMIT 10;
```

---

**Document Version**: 1.0  
**Last Updated**: [Date]  
**Prepared By**: [Name]
