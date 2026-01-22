# Quick Start Guide

## 🚀 Getting Started in 3 Steps

### Step 1: Start the Database
```bash
./init.sh
```

This will:
- Start PostgreSQL and Adminer containers
- Automatically create all database tables
- Load test data (10 students, 8 teachers, 8 courses, etc.)

### Step 2: Access Adminer
Open your browser and go to: **http://localhost:8080**

**Login Credentials:**
- System: `PostgreSQL`
- Server: `postgres`
- Username: `education_user`
- Password: `education_password`
- Database: `education_center`

### Step 3: Verify Everything Works
```bash
./verify_db.sh
```

## 📊 Database Statistics

After initialization, you'll have:
- ✅ 7 tables (students, teachers, courses, groups, enrollments, attendances, payments)
- ✅ 10 students
- ✅ 8 teachers
- ✅ 8 courses
- ✅ 10 groups
- ✅ 20 enrollments
- ✅ 40+ attendance records
- ✅ 30+ payment records

## 🔍 Quick Queries

### View All Students
```sql
SELECT student_id, first_name, last_name, email 
FROM students 
ORDER BY last_name;
```

### View Active Enrollments
```sql
SELECT s.first_name || ' ' || s.last_name AS student_name,
       c.course_name,
       g.group_name
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN groups g ON e.group_id = g.group_id
JOIN courses c ON g.course_id = c.course_id
WHERE e.status = 'Active';
```

### View Payment Summary
```sql
SELECT s.first_name || ' ' || s.last_name AS student_name,
       c.course_name,
       SUM(p.amount) AS total_paid
FROM payments p
JOIN enrollments e ON p.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN groups g ON e.group_id = g.group_id
JOIN courses c ON g.course_id = c.course_id
WHERE p.status = 'Completed'
GROUP BY s.student_id, s.first_name, s.last_name, c.course_name;
```

## 📁 Important Files

- `sql/01_schema.sql` - Database structure (run first)
- `sql/02_seed_data.sql` - Test data (run second)
- `sql/99_queries.sql` - Sample queries for reference

## 🛠️ Common Commands

### Stop the Database
```bash
docker-compose down
```

### Stop and Remove All Data
```bash
docker-compose down -v
```

### View Database Logs
```bash
docker logs education_postgres
```

### Connect via psql
```bash
docker exec -it education_postgres psql -U education_user -d education_center
```

### Restart Everything
```bash
docker-compose down -v && ./init.sh
```

## 🧪 Testing

Run the test plan from `docs/test_plan.md` to verify:
- ✅ Functional requirements
- ✅ Structural integrity
- ✅ Data constraints
- ✅ Query operations

## 📚 Full Documentation

- [README.md](README.md) - Complete project documentation
- [docs/requirements.md](docs/requirements.md) - Requirements analysis
- [docs/erd.md](docs/erd.md) - Entity Relationship Diagram
- [docs/normalization.md](docs/normalization.md) - Normalization process
- [docs/test_plan.md](docs/test_plan.md) - Testing documentation

## ❓ Troubleshooting

### Containers won't start
```bash
docker-compose down -v
./init.sh
```

### Database connection fails
Check if containers are running:
```bash
docker ps
```

### Need to reset database
```bash
docker-compose down -v
./init.sh
```

### Adminer not accessible
Make sure port 8080 is not in use:
```bash
lsof -i :8080
```
