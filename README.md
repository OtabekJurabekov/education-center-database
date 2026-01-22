# 🎓 Education Center Database System

<div align="center">

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

**A comprehensive relational database system for managing educational centers**

[Features](#-features) • [Quick Start](#-quick-start) • [Documentation](#-documentation) • [Architecture](#-architecture)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Quick Start](#-quick-start)
- [Database Schema](#-database-schema)
- [Documentation](#-documentation)
- [Usage Examples](#-usage-examples)
- [Project Structure](#-project-structure)
- [Testing](#-testing)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Overview

The **Education Center Database System** is a production-ready, fully normalized relational database solution designed to replace manual spreadsheets and paper-based record keeping in private educational institutions. This system manages programming courses, foreign language classes, and professional certification programs with comprehensive tracking of students, teachers, courses, enrollments, attendance, and payments.

### Key Highlights

- ✅ **Fully Normalized** - Database designed to Third Normal Form (3NF)
- ✅ **Dockerized** - One-command setup with PostgreSQL and Adminer
- ✅ **Production Ready** - Complete with constraints, indexes, and relationships
- ✅ **Well Documented** - Comprehensive documentation for all components
- ✅ **Tested** - Includes complete test plan with 14 test cases
- ✅ **Scalable** - Designed to handle growth in students, courses, and teachers

### Problem Statement

Educational centers often struggle with:
- ❌ Data duplication across multiple spreadsheets
- ❌ Inconsistencies in student and course information
- ❌ Difficulty tracking attendance and payments
- ❌ Lack of automated reporting for management decisions
- ❌ Manual processes prone to human error

### Solution

This database system provides:
- ✅ Centralized data storage with referential integrity
- ✅ Automated relationship management
- ✅ Real-time attendance and payment tracking
- ✅ Comprehensive reporting capabilities
- ✅ Data validation and constraint enforcement

---

## ✨ Features

### 🎓 Student Management
- Complete student profile management (personal info, contact details)
- Enrollment history tracking
- Multi-course enrollment support
- Student search and filtering capabilities

### 📚 Course & Group Management
- Course catalog with detailed information
- Multiple groups per course with scheduling
- Capacity management for groups
- Course type categorization (Programming, Foreign Language, Professional Certification)

### 👨‍🏫 Staff Management
- Teacher profile management
- Specialization tracking
- Teacher-to-group assignment
- Workload monitoring

### 📊 Operational Tracking
- **Attendance Management**: Track student attendance with status (Present, Absent, Late)
- **Payment Processing**: Record and track payments with multiple payment methods
- **Financial Reporting**: Outstanding balance tracking and payment history

### 📈 Reporting & Analytics
- Enrollment statistics by course
- Attendance rate calculations
- Payment status reports
- Teacher workload analysis
- Revenue reports by month
- Low enrollment group identification

---

## 🏗️ Architecture

### Database Design

The system follows **Third Normal Form (3NF)** normalization principles, ensuring:
- No data redundancy
- Elimination of update, insertion, and deletion anomalies
- Optimal query performance
- Maintainable and scalable structure

### Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| **Database** | PostgreSQL | 15 |
| **Containerization** | Docker & Docker Compose | Latest |
| **Management UI** | Adminer | Latest |
| **Query Language** | SQL | PostgreSQL 15 |

### Entity Relationship Model

The database consists of **7 interrelated tables**:

```
┌─────────────┐       ┌──────────────┐       ┌─────────────┐
│  Students   │◄──────┤ Enrollments  ├──────►│   Groups   │
└─────────────┘       └──────────────┘       └─────────────┘
                              │                     │
                              │                     │
                    ┌─────────┴─────────┐   ┌──────┴──────┐
                    │                   │   │             │
              ┌─────▼─────┐       ┌─────▼───┐│    ┌───────▼──────┐
              │Attendances│       │Payments ││    │   Courses    │
              └───────────┘       └─────────┘│    └──────────────┘
                                             │
                                    ┌────────┴────────┐
                                    │   Teachers     │
                                    └────────────────┘
```

**Key Relationships:**
- **One-to-Many**: Courses → Groups, Teachers → Groups, Enrollments → Attendances/Payments
- **Many-to-Many**: Students ↔ Groups (via Enrollments)

---

## 🚀 Quick Start

### Prerequisites

Ensure you have the following installed:
- [Docker](https://www.docker.com/get-started) (version 20.10+)
- [Docker Compose](https://docs.docker.com/compose/install/) (version 2.0+)
- Git (for cloning the repository)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/education-center-database.git
   cd education-center-database
   ```

2. **Initialize the database**
   ```bash
   chmod +x init.sh verify_db.sh
   ./init.sh
   ```

3. **Verify installation**
   ```bash
   ./verify_db.sh
   ```

4. **Access Adminer**
   - Open your browser: `http://localhost:8080`
   - Login with:
     - **System**: PostgreSQL
     - **Server**: postgres
     - **Username**: education_user
     - **Password**: education_password
     - **Database**: education_center

### What Happens During Initialization?

The `init.sh` script automatically:
1. ✅ Starts PostgreSQL and Adminer containers
2. ✅ Creates all database tables with constraints
3. ✅ Loads seed data (10 students, 8 teachers, 8 courses, etc.)
4. ✅ Verifies database integrity

---

## 🗄️ Database Schema

### Core Tables

| Table | Description | Key Attributes |
|-------|-------------|----------------|
| **students** | Student personal information | student_id, email (unique), enrollment_date |
| **teachers** | Teacher profiles and specializations | teacher_id, email (unique), specialization |
| **courses** | Course catalog | course_id, course_type, price, duration_weeks |
| **groups** | Class groups within courses | group_id, course_id (FK), teacher_id (FK), schedule |
| **enrollments** | Student-group relationships | enrollment_id, student_id (FK), group_id (FK), status |
| **attendances** | Attendance tracking | attendance_id, enrollment_id (FK), attendance_date, status |
| **payments** | Payment transactions | payment_id, enrollment_id (FK), amount, payment_method |

### Constraints & Integrity

- **Primary Keys**: All tables have auto-incrementing primary keys
- **Foreign Keys**: Referential integrity enforced with CASCADE/RESTRICT rules
- **Unique Constraints**: Email addresses, group names, enrollment combinations
- **Check Constraints**: Date validations, positive amounts, valid status values
- **Indexes**: Optimized for common query patterns

### Sample Data

After initialization, the database includes:
- 📊 **10 students** with complete profiles
- 👨‍🏫 **8 teachers** across different specializations
- 📚 **8 courses** (Programming, Languages, Certifications)
- 🎯 **10 groups** with schedules and capacity limits
- 📝 **20 enrollments** linking students to groups
- ✅ **40+ attendance records** for tracking
- 💰 **30+ payment records** with various payment methods

---

## 📚 Documentation

Comprehensive documentation is available in the `docs/` directory:

| Document | Description |
|----------|-------------|
| [**Requirements Analysis**](docs/requirements.md) | User and system requirements, functional specifications |
| [**Entity Relationship Diagram**](docs/erd.md) | Complete ERD with entities, attributes, and relationships |
| [**Normalization Process**](docs/normalization.md) | Step-by-step normalization from 1NF to 3NF |
| [**Test Plan**](docs/test_plan.md) | Comprehensive testing documentation with 14 test cases |
| [**Quick Start Guide**](QUICK_START.md) | Quick reference for common operations |

---

## 💡 Usage Examples

### Example 1: View All Active Enrollments

```sql
SELECT 
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_name,
    g.group_name,
    e.enrollment_date,
    e.status
FROM enrollments e
INNER JOIN students s ON e.student_id = s.student_id
INNER JOIN groups g ON e.group_id = g.group_id
INNER JOIN courses c ON g.course_id = c.course_id
WHERE e.status = 'Active'
ORDER BY e.enrollment_date DESC;
```

### Example 2: Calculate Attendance Statistics

```sql
SELECT 
    s.first_name || ' ' || s.last_name AS student_name,
    g.group_name,
    COUNT(a.attendance_id) AS total_classes,
    COUNT(CASE WHEN a.status = 'Present' THEN 1 END) AS present_count,
    ROUND(
        COUNT(CASE WHEN a.status = 'Present' THEN 1 END)::NUMERIC / 
        NULLIF(COUNT(a.attendance_id), 0) * 100, 
        2
    ) AS attendance_percentage
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN groups g ON e.group_id = g.group_id
LEFT JOIN attendances a ON e.enrollment_id = a.enrollment_id
WHERE e.status = 'Active'
GROUP BY s.student_id, s.first_name, s.last_name, g.group_name
ORDER BY attendance_percentage DESC;
```

### Example 3: Find Students with Outstanding Payments

```sql
SELECT 
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_name,
    c.price AS course_price,
    COALESCE(SUM(CASE WHEN p.status = 'Completed' THEN p.amount ELSE 0 END), 0) AS total_paid,
    (c.price - COALESCE(SUM(CASE WHEN p.status = 'Completed' THEN p.amount ELSE 0 END), 0)) AS outstanding_balance
FROM enrollments e
INNER JOIN students s ON e.student_id = s.student_id
INNER JOIN groups g ON e.group_id = g.group_id
INNER JOIN courses c ON g.course_id = c.course_id
LEFT JOIN payments p ON e.enrollment_id = p.enrollment_id
WHERE e.status = 'Active'
GROUP BY s.student_id, s.first_name, s.last_name, c.course_name, c.price
HAVING (c.price - COALESCE(SUM(CASE WHEN p.status = 'Completed' THEN p.amount ELSE 0 END), 0)) > 0
ORDER BY outstanding_balance DESC;
```

**More examples** available in [`sql/99_queries.sql`](sql/99_queries.sql)

---

## 📁 Project Structure

```
education-center-database/
│
├── 📄 README.md                 # This file
├── 📄 QUICK_START.md           # Quick reference guide
├── 📄 PROJECT_STATUS.md         # Project completion status
├── 🐳 docker-compose.yml        # Docker services configuration
├── 🔧 init.sh                   # Database initialization script
├── ✅ verify_db.sh              # Database verification script
├── 🚫 .gitignore                # Git ignore rules
│
├── 📂 docs/                     # Documentation
│   ├── requirements.md          # Requirements analysis
│   ├── erd.md                  # Entity Relationship Diagram
│   ├── normalization.md        # Normalization documentation
│   └── test_plan.md            # Testing documentation
│
└── 📂 sql/                      # SQL scripts
    ├── 01_schema.sql           # Database schema (tables, constraints)
    ├── 02_seed_data.sql       # Test data population
    └── 99_queries.sql          # Sample queries and examples
```

---

## 🧪 Testing

The project includes a comprehensive test plan covering:

### Functional Testing
- ✅ Student registration and validation
- ✅ Course and group creation
- ✅ Enrollment management
- ✅ Attendance recording
- ✅ Payment processing

### Structural Testing
- ✅ Referential integrity (foreign keys)
- ✅ Primary key constraints
- ✅ Unique constraints
- ✅ Check constraints validation

### Query Testing
- ✅ JOIN operations
- ✅ Aggregation functions
- ✅ Filtering and sorting
- ✅ Complex reporting queries

**See [Test Plan](docs/test_plan.md) for complete testing documentation.**

### Running Verification

```bash
./verify_db.sh
```

This script verifies:
- Container status
- Table creation
- Data population
- Database connectivity
- Sample query execution

---

## 🛠️ Development

### Prerequisites for Development

- PostgreSQL 15+ (or use Docker)
- SQL client (psql, Adminer, or any PostgreSQL client)
- Text editor with SQL syntax highlighting

### Common Operations

#### Start Services
```bash
docker-compose up -d
```

#### Stop Services
```bash
docker-compose down
```

#### Reset Database
```bash
docker-compose down -v
./init.sh
```

#### Access PostgreSQL CLI
```bash
docker exec -it education_postgres psql -U education_user -d education_center
```

#### View Logs
```bash
docker logs education_postgres
docker logs education_adminer
```

---

## 📊 Database Statistics

After initialization, the system contains:

| Entity | Count | Description |
|--------|-------|-------------|
| Students | 10 | Complete student profiles |
| Teachers | 8 | Teachers with specializations |
| Courses | 8 | Various course types |
| Groups | 10 | Active class groups |
| Enrollments | 20 | Student-group relationships |
| Attendance Records | 40+ | Class attendance tracking |
| Payment Records | 30+ | Financial transactions |

---

## 🎓 Educational Context

This project was developed as part of the **BTEC Level 4 Unit 10: Database Design** assignment, demonstrating:

- **LO1**: Design and requirements analysis
  - Requirements documentation
  - Entity Relationship Diagram (ERD)
  - Database normalization to 3NF

- **LO2**: Implementation and development
  - SQL schema creation
  - Data validation and constraints
  - Query development with JOINs and aggregations

- **LO3**: Functional and structural testing
  - Comprehensive test plan
  - Functional test cases
  - Structural integrity testing

---

## 🤝 Contributing

Contributions are welcome! If you'd like to contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines

- Follow SQL style guidelines
- Add comments to complex queries
- Update documentation for new features
- Include test cases for new functionality

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Note**: This project was created for educational purposes as part of BTEC Level 4 Unit 10 Assignment.

---

## 👤 Author

**Otabek Jurabekov**

- GitHub: [@OtabekJurabekov](https://github.com/OtabekJurabekov)
- Email: 110520340+OtabekJurabekov@users.noreply.github.com

---

## 🙏 Acknowledgments

- PostgreSQL community for excellent documentation
- Docker team for containerization platform
- Adminer for the lightweight database management tool
- BTEC Level 4 curriculum for the assignment framework

---

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Documentation](docs/) directory
2. Review the [Quick Start Guide](QUICK_START.md)
3. Open an [Issue](https://github.com/YOUR_USERNAME/education-center-database/issues)

---

<div align="center">

**⭐ If you find this project helpful, please consider giving it a star! ⭐**

Made with ❤️ for educational purposes

</div>
