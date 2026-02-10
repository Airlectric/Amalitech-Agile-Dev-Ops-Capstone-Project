# Comprehensive Testing Guide - Sprint 1 & Sprint 2

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Environment Setup](#2-environment-setup)
3. [Docker Setup & Running](#3-docker-setup--running)
4. [PostgreSQL Database Setup](#4-postgresql-database-setup)
5. [Running Tests for Sprint 1](#5-running-tests-for-sprint-1)
6. [Manual API Testing - Sprint 1](#6-manual-api-testing---sprint-1)
7. [Running Tests for Sprint 2](#7-running-tests-for-sprint-2)
8. [Manual API Testing - Sprint 2](#8-manual-api-testing---sprint-2)
9. [Screenshot Evidence Guide](#9-screenshot-evidence-guide)

---

## 1. Prerequisites

Ensure the following are installed on your system:

| Tool | Version | Purpose |
|------|---------|---------|
| Node.js | 20+ | Runtime environment |
| npm | 9+ | Package manager |
| Docker Desktop | Latest | Containerization |
| Docker Compose | Latest | Multi-container setup |
| PostgreSQL Client (optional) | 16+ | Database CLI |

### Verify Installation

```bash
# Check Node.js
node --version
# Expected: v20.x.x

# Check npm
npm --version
# Expected: 10.x.x

# Check Docker
docker --version
# Expected: Docker version 25.x.x

# Check Docker Compose
docker-compose --version
# Expected: v2.x.x
```

---

## 2. Environment Setup

### Step 1: Clone Repository

```bash
git clone https://github.com/Airlectric/Amalitech-Agile-Dev-Ops-Capstone-Project.git
cd Amalitech-Agile-Dev-Ops-Capstone-Project
```

### Step 2: Install Dependencies

```bash
npm install
```

**Expected Output:**
```
added 193 packages, and audited 194 packages in 10s
```

### Step 3: Configure Environment

```bash
# Copy environment template
cp .env.example .env

# Edit .env file with your settings
notepad .env
```

**Contents of .env:**
```
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/spendwise
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRES_IN=24h
HOST=0.0.0.0
LOG_LEVEL=debug
```

---

## 3. Docker Setup & Running

### Step 1: Start Docker Services

```bash
docker-compose up -d
```

**Expected Output:**
```
[+] Running 3/3
 ✔ Container project-db-1      Running
 ✔ Container project-app-1     Created
 ✔ Container project-app-1     Started
```

### Step 2: Verify Docker Containers

```bash
docker-compose ps
```

**Expected Output:**
```
NAME            IMAGE                    COMMAND              SERVICE    CREATED   STATUS    PORTS
project-app-1   project-app:latest      "docker-entrypoint.s…"   app        2 hours ago   Up 2 hours   0.0.0.0:3000->3000/tcp
project-db-1    postgres:16-alpine      "docker-entrypoint.s…"   postgres   2 hours ago   Up 2 hours   0.0.0.0:5432->5432/tcp
```

### Step 3: View Docker Logs

```bash
# View all logs
docker-compose logs

# View app logs only
docker-compose logs app

# View database logs only
docker-compose logs db

# Follow logs in real-time
docker-compose logs -f
```

**Expected App Logs Output:**
```
project-app-1  | info: Server running on port 3000
project-app-1  | info: Environment: development
project-app-1  | Connected to PostgreSQL database
```

### Step 4: Stop Docker Services

```bash
docker-compose down
```

**Expected Output:**
```
[+] Running 3/3
 ✔ Container project-app-1  Stopped
 ✔ Container project-db-1  Stopped
 ✔ Network project_default  Removed
```

---

## 4. PostgreSQL Database Setup

### Option A: Using Docker (Recommended)

```bash
# Start only the database
docker-compose up -d db

# Verify database is running
docker exec -it project-db-1 psql -U postgres -d spendwise
```

### Option B: Local PostgreSQL Installation

```bash
# Create database
createdb spendwise

# Connect to database
psql -d spendwise

# Verify connection
\l  # List databases
\dt   # List tables
```

### Run Database Migrations

```bash
npm run db:migrate
```

**Expected Output:**
```
Migration completed successfully
```

### Verify Tables Created

```bash
docker exec -it project-db-1 psql -U postgres -d spendwise -c "\dt"
```

**Expected Output:**
```
            List of relations
 Schema |     Name     | Type  |  Owner   
--------+--------------+-------+----------
 public | transactions | table | postgres
 public | users        | table | postgres
(2 rows)
```

---

## 5. Running Tests for Sprint 1

Sprint 1 covers: US-01, US-02, US-03

### Test Commands

```bash
# Run all Sprint 1 tests
npm test -- tests/auth.test.js
npm test -- tests/auth-register.test.js
npm test -- tests/auth-login.test.js
npm test -- tests/transactions.test.js
```

### Run All Tests with Coverage

```bash
npm test
```

**EXPECTED OUTPUT - Test Results:**
```
> spendwise@1.0.0 test
> jest --coverage --runInBand

Test Suites: 4 passed, 4 total
Tests:       27 passed, 27 total
Snapshots:   0 total
Time:        5.887 s
```

**EXPECTED OUTPUT - Coverage Report:**
```
---------------------------|---------|----------|---------|---------|
File                       | % Stmts | % Branch | % Funcs | Lines |
---------------------------|---------|----------|---------|---------|
All files                  |   64.25 |    5.55  |   9.09  | 64.25% |
 config                    |   78.26 |      75  |      25 |  78.26% |
 controllers               |      24 |       0  |       0 |     24% |
 middleware                |   38.46 |     12.5 |      50 |  38.46% |
 models                    |   13.88 |       0  |       0 |  13.88% |
 routes                    |     100 |      100 |     100 |    100% |
 utils                     |   57.14 |       0  |      75 |  57.14% |
---------------------------|---------|----------|---------|---------|
```

### Screenshots to Take for Sprint 1

| Screenshot # | What to Capture | Command/Action |
|-------------|-----------------|----------------|
| 1 | Terminal showing `npm test` running | Run `npm test` |
| 2 | Jest test results (27 passed) | After tests complete |
| 3 | ESLint results | Run `npm run lint` |
| 4 | Docker containers running | Run `docker-compose ps` |
| 5 | Database tables created | Run migration command |
| 6 | App logs showing server start | Run `docker-compose logs app` |

---

## 6. Manual API Testing - Sprint 1

Start the application first:
```bash
docker-compose up -d
# OR for development:
npm run dev
```

### Base URL
```
http://localhost:3000
```

---

### US-01: Register an Account

#### TC-US01-01: Register with Valid Data

**Request:**
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john.doe@example.com",
    "password": "secure123"
  }'
```

**Expected Response (201 Created):**
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john.doe@example.com",
  "created_at": "2026-02-10T13:00:00.000Z"
}
```

**Screenshot Required:** ✅

---

#### TC-US01-03: Missing Name - 400 Bad Request

**Request:**
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "secure123"
  }'
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "Validation failed",
  "details": [
    {
      "location": "body",
      "msg": "Name is required",
      "path": "name",
      "type": "field",
      "value": ""
    }
  ]
}
```

**Screenshot Required:** ✅

---

#### TC-US01-04: Missing Email - 400 Bad Request

**Request:**
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "password": "secure123"
  }'
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "Validation failed",
  "details": [
    {
      "location": "body",
      "msg": "Valid email is required",
      "path": "email",
      "type": "field"
    }
  ]
}
```

**Screenshot Required:** ✅

---

#### TC-US01-05: Missing Password - 400 Bad Request

**Request:**
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com"
  }'
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "Validation failed"
}
```

**Screenshot Required:** ✅

---

#### TC-US01-06: Invalid Email Format - 400 Bad Request

**Request:**
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "not-an-email",
    "password": "secure123"
  }'
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "Validation failed"
}
```

**Screenshot Required:** ✅

---

#### TC-US01-07: Duplicate Email - 409 Conflict

**Request:**
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Second User",
    "email": "john.doe@example.com",
    "password": "anotherpass"
  }'
```

**Expected Response (409 Conflict):**
```json
{
  "error": "Email already registered"
}
```

**Screenshot Required:** ✅

---

#### TC-US01-08: Short Password - 400 Bad Request

**Request:**
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "12345"
  }'
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "Validation failed"
}
```

**Screenshot Required:** ✅

---

### US-02: Log In

First, register a user, then test login:

```bash
# Register first
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name": "Login Test", "email": "login@test.com", "password": "password123"}'
```

#### TC-US02-01: Valid Login

**Request:**
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "login@test.com",
    "password": "password123"
  }'
```

**Expected Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImVtYWlsIjoibG9naW5AdGVzdC5jb20iLCJpYXQiOjE3MTAwMDAwMDAsImV4cCI6MTcxMDAwMDAwMH0.xxxxxxxxxxxxxxxxxxxxx"
}
```

**Screenshot Required:** ✅

---

#### TC-US02-03: JWT Payload Verification

**Request:**
```bash
# Decode the token to verify payload
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "login@test.com", "password": "password123"}' | jq .
```

**Expected JWT Payload (decoded):**
```json
{
  "userId": 1,
  "email": "login@test.com",
  "iat": 1700000000,
  "exp": 1700000000
}
```

**Screenshot Required:** ✅

---

#### TC-US02-04: Invalid Email - 401 Unauthorized

**Request:**
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "nonexistent@test.com",
    "password": "password123"
  }'
```

**Expected Response (401 Unauthorized):**
```json
{
  "error": "Invalid credentials"
}
```

**Screenshot Required:** ✅

---

#### TC-US02-05: Invalid Password - 401 Unauthorized

**Request:**
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "login@test.com",
    "password": "wrongpassword"
  }'
```

**Expected Response (401 Unauthorized):**
```json
{
  "error": "Invalid credentials"
}
```

**Screenshot Required:** ✅

---

### US-03: Add a Transaction

Get a token first, then test transactions:

```bash
# Get token
TOKEN=$(curl -s -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "login@test.com", "password": "password123"}' | jq -r '.token')
```

#### TC-US03-01: Create Valid Transaction

**Request:**
```bash
curl -X POST http://localhost:3000/api/transactions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "type": "expense",
    "amount": 50.00,
    "category": "Food",
    "description": "Lunch at restaurant"
  }'
```

**Expected Response (201 Created):**
```json
{
  "id": 1,
  "user_id": 1,
  "type": "expense",
  "amount": "50.00",
  "category": "Food",
  "description": "Lunch at restaurant",
  "date": "2026-02-10",
  "created_at": "2026-02-10T13:00:00.000Z"
}
```

**Screenshot Required:** ✅

---

#### TC-US03-02: No Token - 401 Unauthorized

**Request:**
```bash
curl -X POST http://localhost:3000/api/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "type": "expense",
    "amount": 25.00,
    "category": "Coffee"
  }'
```

**Expected Response (401 Unauthorized):**
```json
{
  "error": "Authorization header required"
}
```

**Screenshot Required:** ✅

---

#### TC-US03-03: Invalid Token - 401 Unauthorized

**Request:**
```bash
curl -X POST http://localhost:3000/api/transactions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer invalid-token-here" \
  -d '{
    "type": "expense",
    "amount": 25.00,
    "category": "Coffee"
  }'
```

**Expected Response (401 Unauthorized):**
```json
{
  "error": "Invalid or expired token"
}
```

**Screenshot Required:** ✅

---

#### TC-US03-04: Invalid Type - 400 Bad Request

**Request:**
```bash
curl -X POST http://localhost:3000/api/transactions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "type": "savings",
    "amount": 100.00,
    "category": "Investment"
  }'
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "Validation failed"
}
```

**Screenshot Required:** ✅

---

#### TC-US03-05: Negative Amount - 400 Bad Request

**Request:**
```bash
curl -X POST http://localhost:3000/api/transactions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "type": "expense",
    "amount": -50.00,
    "category": "Food"
  }'
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "Validation failed"
}
```

**Screenshot Required:** ✅

---

#### TC-US03-06: Missing Category - 400 Bad Request

**Request:**
```bash
curl -X POST http://localhost:3000/api/transactions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "type": "expense",
    "amount": 50.00
  }'
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "Validation failed"
}
```

**Screenshot Required:** ✅

---

#### TC-US03-07: Default Date

**Request:**
```bash
curl -X POST http://localhost:3000/api/transactions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "type": "income",
    "amount": 5000.00,
    "category": "Salary"
  }'
```

**Expected Response (201 Created):**
```json
{
  "id": 2,
  "user_id": 1,
  "type": "income",
  "amount": "5000.00",
  "category": "Salary",
  "date": "2026-02-10",
  "created_at": "2026-02-10T13:00:00.000Z"
}
```

**Screenshot Required:** ✅

---

## 7. Running Tests for Sprint 2

Sprint 2 covers: US-04, US-05, US-06, US-07

### Run All Tests

```bash
npm test
```

**EXPECTED OUTPUT - Test Results:**
```
> spendwise@1.0.0 test
> jest --coverage --runInBand

Test Suites: 7 passed, 7 total
Tests:       45 passed, 45 total
Snapshots:   0 total
Time:        14.37 s
```

**EXPECTED OUTPUT - Coverage Report:**
```
---------------------------|---------|----------|---------|---------|
File                       | % Stmts | % Branch | % Funcs | Lines |
---------------------------|---------|----------|---------|---------|
All files                  |   90.63 |    81.48 |   81.81 | 90.63% |
 config                    |   86.95 |       50 |      50 |  86.95% |
 controllers               |   81.33 |       75 |     100 |  81.33% |
 middleware                |   92.3  |     87.5 |     100 |   92.3% |
 models                    |   97.22 |    91.66 |   85.71 |  97.22% |
 routes                    |     100 |      100 |     100 |    100% |
 utils                     |   92.85 |       50 |      75 |  92.85% |
---------------------------|---------|----------|---------|---------|
```

### Run Specific Test Files

```bash
# Sprint 1 tests
npm test -- tests/auth.test.js
npm test -- tests/auth-register.test.js
npm test -- tests/auth-login.test.js
npm test -- tests/transactions.test.js

# Sprint 2 tests
npm test -- tests/transactions-list.test.js
npm test -- tests/summary.test.js
npm test -- tests/health.test.js
```

### Screenshots to Take for Sprint 2

| Screenshot # | What to Capture | Command/Action |
|-------------|-----------------|----------------|
| 7 | Terminal showing all 45 tests passing | Run `npm test` |
| 8 | Coverage report (90.63%) | After tests complete |
| 9 | Each test file output | Run individual test commands |
| 10 | Health endpoint response | `curl http://localhost:3000/health` |
| 11 | Docker logs showing DB connection | `docker-compose logs app` |
| 12 | Summary endpoint response | After creating transactions |

---

## 8. Manual API Testing - Sprint 2

### US-04: List My Transactions

#### TC-US04-01: List All Transactions

**Request:**
```bash
curl -X GET http://localhost:3000/api/transactions \
  -H "Authorization: Bearer $TOKEN"
```

**Expected Response (200 OK):**
```json
[
  {
    "id": 2,
    "type": "income",
    "amount": "5000.00",
    "category": "Salary",
    "date": "2026-02-10",
    "created_at": "2026-02-10T13:00:00.000Z"
  },
  {
    "id": 1,
    "type": "expense",
    "amount": "50.00",
    "category": "Food",
    "description": "Lunch at restaurant",
    "date": "2026-02-10",
    "created_at": "2026-02-10T13:00:00.000Z"
  }
]
```

**Screenshot Required:** ✅

---

#### TC-US04-02: Sorted by Date Descending

Verify in the response that transactions are sorted with most recent first.

**Screenshot Required:** ✅

---

#### TC-US04-03: Empty Array for New User

Register a new user and list their transactions:

```bash
# Register new user
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name": "New User", "email": "new@user.com", "password": "password123"}'

# Get token
NEW_TOKEN=$(curl -s -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "new@user.com", "password": "password123"}' | jq -r '.token')

# List transactions
curl -X GET http://localhost:3000/api/transactions \
  -H "Authorization: Bearer $NEW_TOKEN"
```

**Expected Response (200 OK):**
```json
[]
```

**Screenshot Required:** ✅

---

#### TC-US04-04: 401 Without Authentication

**Request:**
```bash
curl -X GET http://localhost:3000/api/transactions
```

**Expected Response (401 Unauthorized):**
```json
{
  "error": "Authorization header required"
}
```

**Screenshot Required:** ✅

---

### US-05: Filter Transactions

#### TC-US05-01: Filter by Type

**Request:**
```bash
curl -X GET "http://localhost:3000/api/transactions?type=expense" \
  -H "Authorization: Bearer $TOKEN"
```

**Expected Response:**
```json
[
  {
    "id": 1,
    "type": "expense",
    "amount": "50.00",
    "category": "Food",
    "date": "2026-02-10"
  }
]
```

**Screenshot Required:** ✅

---

#### TC-US05-02: Filter by Category (Case-Insensitive)

**Request:**
```bash
curl -X GET "http://localhost:3000/api/transactions?category=FOOD" \
  -H "Authorization: Bearer $TOKEN"
```

**Expected Response (filtered by case-insensitive match):**
```json
[
  {
    "id": 1,
    "type": "expense",
    "amount": "50.00",
    "category": "Food",
    "date": "2026-02-10"
  }
]
```

**Screenshot Required:** ✅

---

#### TC-US05-03: Filter by Date Range

**Request:**
```bash
curl -X GET "http://localhost:3000/api/transactions?from=2026-02-01&to=2026-02-28" \
  -H "Authorization: Bearer $TOKEN"
```

**Expected Response:**
```json
[
  {
    "id": 2,
    "type": "income",
    "amount": "5000.00",
    "category": "Salary",
    "date": "2026-02-10"
  },
  {
    "id": 1,
    "type": "expense",
    "amount": "50.00",
    "category": "Food",
    "date": "2026-02-10"
  }
]
```

**Screenshot Required:** ✅

---

#### TC-US05-04: Combined Filters

**Request:**
```bash
curl -X GET "http://localhost:3000/api/transactions?type=expense&category=food&from=2026-02-01" \
  -H "Authorization: Bearer $TOKEN"
```

**Expected Response:**
```json
[
  {
    "id": 1,
    "type": "expense",
    "amount": "50.00",
    "category": "Food",
    "date": "2026-02-10"
  }
]
```

**Screenshot Required:** ✅

---

#### TC-US05-05: No Matches

**Request:**
```bash
curl -X GET "http://localhost:3000/api/transactions?category=nonexistent" \
  -H "Authorization: Bearer $TOKEN"
```

**Expected Response:**
```json
[]
```

**Screenshot Required:** ✅

---

### US-06: Get Spending Summary

#### TC-US06-01: Complete Summary

**Request:**
```bash
curl -X GET http://localhost:3000/api/transactions/summary \
  -H "Authorization: Bearer $TOKEN"
```

**Expected Response (200 OK):**
```json
{
  "total_income": 5000.00,
  "total_expenses": 150.00,
  "balance": 4850.00,
  "by_category": {
    "Salary": 5000.00,
    "Food": -50.00,
    "Transport": -100.00
  }
}
```

**Screenshot Required:** ✅

---

#### TC-US06-02: User Data Isolation

Create a second user and verify they see only their own data:

```bash
# Verify other user's summary is different
curl -X GET http://localhost:3000/api/transactions/summary \
  -H "Authorization: Bearer $NEW_TOKEN"
```

**Expected Response (200 OK):**
```json
{
  "total_income": 0,
  "total_expenses": 0,
  "balance": 0,
  "by_category": {}
}
```

**Screenshot Required:** ✅

---

#### TC-US06-03: Summary with Date Range

**Request:**
```bash
curl -X GET "http://localhost:3000/api/transactions/summary?from=2026-02-01&to=2026-02-10" \
  -H "Authorization: Bearer $TOKEN"
```

**Expected Response (filtered by date range):**
```json
{
  "total_income": 5000.00,
  "total_expenses": 150.00,
  "balance": 4850.00,
  "by_category": {
    "Salary": 5000.00,
    "Food": -50.00,
    "Transport": -100.00
  }
}
```

**Screenshot Required:** ✅

---

#### TC-US06-04: Zero Values for New User

**Request:**
```bash
curl -X GET http://localhost:3000/api/transactions/summary \
  -H "Authorization: Bearer $NEW_TOKEN"
```

**Expected Response:**
```json
{
  "total_income": 0,
  "total_expenses": 0,
  "balance": 0,
  "by_category": {}
}
```

**Screenshot Required:** ✅

---

### US-07: Health Endpoint

#### TC-US07-01: Healthy Response

**Request:**
```bash
curl http://localhost:3000/health
```

**Expected Response (200 OK):**
```json
{
  "status": "healthy",
  "uptime_seconds": 86400,
  "timestamp": "2026-02-10T13:00:00.000Z",
  "database": "connected",
  "version": "1.0.0"
}
```

**Screenshot Required:** ✅

---

#### TC-US07-02: Database Connectivity Check

Verify that "database" field shows "connected".

**Screenshot Required:** ✅

---

#### TC-US07-03: No Authentication Required

The health endpoint is public and does not require a token.

**Screenshot Required:** ✅

---

## 9. Screenshot Evidence Guide

### Complete Screenshot Checklist

| # | Test Case | Screenshot Description | File to Reference |
|---|-----------|----------------------|-------------------|
| 1 | Sprint 1 Tests Running | Terminal with `npm test` running | - |
| 2 | Sprint 1 Results | 27 tests passed, 64% coverage | `07-test-execution-report.md` |
| 3 | ESLint Results | No linting errors | - |
| 4 | Docker Containers | `docker-compose ps` output | - |
| 5 | Database Tables | Migration success + table list | - |
| 6 | App Logs | Server started, DB connected | `docker-compose logs app` |
| 7 | Sprint 2 Tests Running | Terminal with `npm test` running | - |
| 8 | Sprint 2 Results | 45 tests passed, 90% coverage | `08-sprint-2-test-report.md` |
| 9 | Individual Test Results | Each test file output | Individual test files |
| 10 | Health Endpoint | JSON response from /health | - |
| 11 | DB Connection in Logs | "Connected to PostgreSQL database" | - |
| 12 | Summary Endpoint | JSON with totals and categories | - |
| 13-30 | Individual API Tests | curl commands and responses | Sections 6 & 8 |

---

### How to Take Perfect Screenshots

#### Terminal Screenshot Tips:

1. **Resize terminal** to show full output
2. **Scroll to top** before capturing
3. **Include command prompt** in screenshot
4. **Use light background** for better visibility

#### Browser Screenshot Tips (if using browser):

1. **Use JSON formatter** extension
2. **Show headers** in response
3. **Include status code** in screenshot

---

### Organize Screenshots by Sprint

**Create folders:**
```
screenshots/
├── sprint-1/
│   ├── 01-npm-test-running.png
│   ├── 02-test-results.png
│   ├── 03-eslint-results.png
│   ├── 04-docker-containers.png
│   ├── 05-database-tables.png
│   ├── 06-app-logs.png
│   ├── 07-register-success.png
│   ├── 08-register-validation.png
│   ├── 09-login-success.png
│   ├── 10-login-validation.png
│   ├── 11-create-transaction.png
│   ├── 12-transaction-validation.png
│   └── ...
└── sprint-2/
    ├── 01-npm-test-running.png
    ├── 02-test-results.png
    ├── 03-health-endpoint.png
    ├── 04-list-transactions.png
    ├── 05-filter-by-type.png
    ├── 06-filter-by-category.png
    ├── 07-date-range-filter.png
    ├── 08-combined-filters.png
    ├── 09-summary-endpoint.png
    ├── 10-zero-summary.png
    └── ...
```

---

### After Taking Screenshots

1. **Rename files** to match test case numbers
2. **Update documents** with screenshot references
3. **Commit changes** to git
4. **Push to GitHub**

```bash
git add screenshots/
git commit -m "docs: add testing screenshots"
git push origin dev
```

---

## Quick Reference Commands

```bash
# Start everything
docker-compose up -d

# Run tests
npm test

# Run linter
npm run lint

# View logs
docker-compose logs -f

# Stop everything
docker-compose down

# Reset database
docker-compose down -v
docker-compose up -d
npm run db:migrate
```

---

## Troubleshooting

| Issue | Solution |
|-------|-----------|
| Port 3000 already in use | `docker-compose down` then restart |
| Database connection refused | Ensure PostgreSQL container is running |
| Tests failing | Run `npm run db:migrate` first |
| ESLint errors | Run `npm run lint:fix` to auto-fix |
| Docker memory issues | Increase Docker Desktop memory to 4GB |

---

*Document Version: 1.0*  
*Last Updated: February 10, 2026*
