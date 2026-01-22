#!/bin/bash

# Database Initialization Script
# This script sets up and initializes the Education Center Database

echo "=========================================="
echo "Education Center Database Setup"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}✗ Docker is not running. Please start Docker first.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker is running${NC}"
echo ""

# Stop and remove existing containers and volumes
echo -e "${BLUE}Cleaning up existing containers and volumes...${NC}"
docker-compose down -v 2>/dev/null
echo -e "${GREEN}✓ Cleanup complete${NC}"
echo ""

# Start containers
echo -e "${BLUE}Starting Docker containers...${NC}"
docker-compose up -d

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Failed to start containers${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Containers started${NC}"
echo ""

# Wait for PostgreSQL to be ready
echo -e "${BLUE}Waiting for PostgreSQL to be ready...${NC}"
for i in {1..30}; do
    if docker exec education_postgres pg_isready -U education_user -d education_center > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PostgreSQL is ready${NC}"
        break
    fi
    if [ $i -eq 30 ]; then
        echo -e "${RED}✗ PostgreSQL failed to start within timeout${NC}"
        exit 1
    fi
    sleep 1
done

echo ""
echo -e "${BLUE}Waiting for database initialization...${NC}"
sleep 5

# Verify initialization
echo ""
echo -e "${BLUE}Verifying database initialization...${NC}"

# Check if tables exist
TABLES=$(docker exec education_postgres psql -U education_user -d education_center -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | tr -d ' ')

if [ -z "$TABLES" ] || [ "$TABLES" = "0" ]; then
    echo -e "${YELLOW}⚠ Tables not found. Running initialization scripts manually...${NC}"
    
    # Run schema
    echo "Running 01_schema.sql..."
    docker exec -i education_postgres psql -U education_user -d education_center < sql/01_schema.sql
    
    # Run seed data
    echo "Running 02_seed_data.sql..."
    docker exec -i education_postgres psql -U education_user -d education_center < sql/02_seed_data.sql
    
    echo -e "${GREEN}✓ Manual initialization complete${NC}"
else
    echo -e "${GREEN}✓ Database automatically initialized with $TABLES tables${NC}"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}Setup Complete!${NC}"
echo "=========================================="
echo ""
echo "Database is ready to use!"
echo ""
echo "Access Adminer at: http://localhost:8080"
echo ""
echo "Login credentials:"
echo "  System: PostgreSQL"
echo "  Server: postgres"
echo "  Username: education_user"
echo "  Password: education_password"
echo "  Database: education_center"
echo ""
echo "To verify the database, run: ./verify_db.sh"
echo ""
