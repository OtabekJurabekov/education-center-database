#!/bin/bash

# Database Verification Script
# This script verifies that the database has been properly initialized

echo "=========================================="
echo "Education Center Database Verification"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if containers are running
echo "Checking Docker containers..."
if docker ps | grep -q "education_postgres"; then
    echo -e "${GREEN}✓ PostgreSQL container is running${NC}"
else
    echo -e "${RED}✗ PostgreSQL container is not running${NC}"
    exit 1
fi

if docker ps | grep -q "education_adminer"; then
    echo -e "${GREEN}✓ Adminer container is running${NC}"
else
    echo -e "${RED}✗ Adminer container is not running${NC}"
    exit 1
fi

echo ""
echo "Checking database tables..."

# Wait for database to be ready
sleep 2

# Check if tables exist
TABLES=$(docker exec education_postgres psql -U education_user -d education_center -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | tr -d ' ')

if [ -z "$TABLES" ] || [ "$TABLES" = "0" ]; then
    echo -e "${RED}✗ No tables found in database${NC}"
    exit 1
else
    echo -e "${GREEN}✓ Found $TABLES tables in database${NC}"
fi

echo ""
echo "Checking table record counts..."

# Check each table
check_table() {
    local table=$1
    local count=$(docker exec education_postgres psql -U education_user -d education_center -t -c "SELECT COUNT(*) FROM $table;" 2>/dev/null | tr -d ' ')
    if [ -n "$count" ] && [ "$count" != "0" ]; then
        echo -e "  ${GREEN}✓ $table: $count records${NC}"
        return 0
    else
        echo -e "  ${YELLOW}⚠ $table: $count records${NC}"
        return 1
    fi
}

check_table "students"
check_table "teachers"
check_table "courses"
check_table "groups"
check_table "enrollments"
check_table "attendances"
check_table "payments"

echo ""
echo "Testing database connectivity..."
if docker exec education_postgres psql -U education_user -d education_center -c "SELECT 1;" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Database connection successful${NC}"
else
    echo -e "${RED}✗ Database connection failed${NC}"
    exit 1
fi

echo ""
echo "Running sample query..."
SAMPLE_RESULT=$(docker exec education_postgres psql -U education_user -d education_center -t -c "SELECT COUNT(*) FROM students s INNER JOIN enrollments e ON s.student_id = e.student_id;" 2>/dev/null | tr -d ' ')

if [ -n "$SAMPLE_RESULT" ]; then
    echo -e "${GREEN}✓ Sample JOIN query executed successfully: $SAMPLE_RESULT enrollments found${NC}"
else
    echo -e "${RED}✗ Sample query failed${NC}"
    exit 1
fi

echo ""
echo "=========================================="
echo -e "${GREEN}Database verification complete!${NC}"
echo "=========================================="
echo ""
echo "Access Adminer at: http://localhost:8080"
echo "Login credentials:"
echo "  System: PostgreSQL"
echo "  Server: postgres"
echo "  Username: education_user"
echo "  Password: education_password"
echo "  Database: education_center"
echo ""
