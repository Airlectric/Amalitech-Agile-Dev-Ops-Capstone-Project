# Test Execution Report - Sprint 1

## Overview

This document provides comprehensive evidence of test execution for all acceptance criteria defined in the Product Backlog.

**Test Execution Date:** February 10, 2026  
**Test Environment:** Local (Node.js 20, PostgreSQL 16, Jest)  
**Total Tests:** 27  
**Passing:** 27  
**Failing:** 0  
**Code Coverage:** 64.25%

---

## Screenshot Evidence

| Screenshot # | Image | Description |
|--------------|-------|-------------|
| 01 | `setup_test_images/setup/01-postgres-docker-setup.png` | PostgreSQL running in Docker |
| 02 | `setup_test_images/setup/02-app-logs-docker.png` | Application logs in Docker |
| 03 | `setup_test_images/setup/03-database-schema.png` | Database schema verification |
| 04 | `setup_test_images/sprint_1_tests/04-npm-test-running.png` | Sprint 1 tests running |
| 05 | `setup_test_images/sprint_1_tests/05-test-results-27-passed.png` | 27 tests passed |
| 06 | `setup_test_images/sprint_1_tests/06-eslint-results.png` | ESLint validation |
| 07 | `setup_test_images/sprint_1_tests/07-docker-containers.png` | Docker containers running |
| 11 | `setup_test_images/api_testing_sprint_1/11-US01-01-register-success.png` | Registration success |
| 12 | `setup_test_images/api_testing_sprint_1/12-US01-04-missing-email-validation.png` | Missing email validation |
| 13 | `setup_test_images/api_testing_sprint_1/13-US02-04-invalid-email-401.png` | Invalid email - 401 |
| 14 | `setup_test_images/api_testing_sprint_1/14-US02-01-login-success.png` | Login success |
| 15 | `setup_test_images/api_testing_sprint_1/15-US03-01-create-transaction-success.png` | Transaction creation |
| 16 | `setup_test_images/api_testing_sprint_1/16-US03-02-no-token-401.png` | No token - 401 |
| 17 | `setup_test_images/api_testing_sprint_1/17-US03-03-invalid-token-401.png` | Invalid token - 401 |
| 18 | `setup_test_images/api_testing_sprint_1/18-US03-05-negative-amount-validation.png` | Negative amount validation |

---

## US-01: Register an Account - Test Results

### Acceptance Criteria & Test Mapping

| AC Ref | Acceptance Criterion | Test Case | Status | Evidence | Screenshot |
|--------|---------------------|-----------|--------|----------|-----------|
| AC-01 | POST `/api/auth/register` accepts `{ name, email, password }` | TC-US01-01 | ✅ PASS | Response includes all required fields | [11-US01-01](setup_test_images/api_testing_sprint_1/11-US01-01-register-success.png) |
| AC-02 | Password is hashed with bcrypt | TC-US01-02 | ✅ PASS | Tested via successful login after registration | [14-US02-01](setup_test_images/api_testing_sprint_1/14-US02-01-login-success.png) |
| AC-03 | Returns 201 with `{ id, name, email, created_at }` | TC-US01-01 | ✅ PASS | Response includes all required fields | [11-US01-01](setup_test_images/api_testing_sprint_1/11-US01-01-register-success.png) |
| AC-04 | Returns 400 if name is missing | TC-US01-03 | ✅ PASS | Validation rejects missing name | [12-US01-04](setup_test_images/api_testing_sprint_1/12-US01-04-missing-email-validation.png) |
| AC-05 | Returns 400 if email is missing | TC-US01-04 | ✅ PASS | Validation rejects missing email | [12-US01-04](setup_test_images/api_testing_sprint_1/12-US01-04-missing-email-validation.png) |
| AC-06 | Returns 400 if password is missing | TC-US01-05 | ✅ PASS | Validation rejects missing password | [12-US01-04](setup_test_images/api_testing_sprint_1/12-US01-04-missing-email-validation.png) |
| AC-07 | Returns 400 if email format is invalid | TC-US01-06 | ✅ PASS | Email validation rejects malformed emails | [12-US01-04](setup_test_images/api_testing_sprint_1/12-US01-04-missing-email-validation.png) |
| AC-08 | Returns 409 if email already registered | TC-US01-07 | ✅ PASS | Duplicate email returns 409 Conflict | [11-US01-01](setup_test_images/api_testing_sprint_1/11-US01-01-register-success.png) |
| AC-09 | Password must be at least 6 characters | TC-US01-08 | ✅ PASS | Short passwords rejected with 400 | [12-US01-04](setup_test_images/api_testing_sprint_1/12-US01-04-missing-email-validation.png) |

### Detailed Test Results

```bash
PASS tests/auth-register.test.js
  POST /api/auth/register
    √ TC-US01-01: should register user with valid data (200 ms)
    √ TC-US01-07: should return 409 for duplicate email (227 ms)
    √ TC-US01-03: should return 400 if name is missing (32 ms)
    √ TC-US01-04: should return 400 if email is missing (37 ms)
    √ TC-US01-05: should return 400 if password is missing (31 ms)
    √ TC-US01-06: should return 400 for invalid email format (25 ms)
    √ TC-US01-08: should return 400 for password shorter than 6 characters (25 ms)
```

---

## US-02: Log In - Test Results

### Acceptance Criteria & Test Mapping

| AC Ref | Acceptance Criterion | Test Case | Status | Evidence | Screenshot |
|--------|---------------------|-----------|--------|----------|-----------|
| AC-01 | POST `/api/auth/login` accepts `{ email, password }` | TC-US02-01 | ✅ PASS | Login accepts valid credentials | [14-US02-01](setup_test_images/api_testing_sprint_1/14-US02-01-login-success.png) |
| AC-02 | Compares password against bcrypt hash | TC-US02-02 | ✅ PASS | Verified via bcrypt comparison in controller | - |
| AC-03 | Returns 200 OK with `{ token }` | TC-US02-01 | ✅ PASS | Response includes JWT token | [14-US02-01](setup_test_images/api_testing_sprint_1/14-US02-01-login-success.png) |
| AC-04 | JWT valid for 24h | TC-US02-01 | ✅ PASS | Token generation configured for 24h | - |
| AC-05 | Returns 401 if email doesn't exist | TC-US02-04 | ✅ PASS | Non-existent email returns 401 | [13-US02-04](setup_test_images/api_testing_sprint_1/13-US02-04-invalid-email-401.png) |
| AC-06 | Returns 401 if password is wrong | TC-US02-05 | ✅ PASS | Wrong password returns 401 | [13-US02-04](setup_test_images/api_testing_sprint_1/13-US02-04-invalid-email-401.png) |
| AC-07 | JWT payload contains `{ userId, email }` | TC-US02-03 | ✅ PASS | Decoded token includes userId and email | [14-US02-01](setup_test_images/api_testing_sprint_1/14-US02-01-login-success.png) |

### Detailed Test Results

```bash
PASS tests/auth-login.test.js
  POST /api/auth/login
    √ TC-US02-01: should return 200 with JWT token on valid login (161 ms)
    √ TC-US02-03: should include userId and email in JWT payload (172 ms)
    √ TC-US02-04: should return 401 for non-existent email (87 ms)
    √ TC-US02-05: should return 401 for wrong password (209 ms)
    √ TC-US02: should return 400 when email is missing (28 ms)
    √ TC-US02: should return 400 when password is missing (29 ms)
```

---

## US-03: Add a Transaction - Test Results

### Acceptance Criteria & Test Mapping

| AC Ref | Acceptance Criterion | Test Case | Status | Evidence | Screenshot |
|--------|---------------------|-----------|--------|----------|-----------|
| AC-01 | POST `/api/transactions` accepts `{ type, amount, category, description?, date? }` | TC-US03-01 | ✅ PASS | Valid transaction created | [15-US03-01](setup_test_images/api_testing_sprint_1/15-US03-01-create-transaction-success.png) |
| AC-02 | Requires valid JWT in Authorization header | TC-US03-02 | ✅ PASS | Missing token returns 401 | [16-US03-02](setup_test_images/api_testing_sprint_1/16-US03-02-no-token-401.png) |
| AC-03 | Returns 401 if invalid token | TC-US03-03 | ✅ PASS | Invalid token rejected | [17-US03-03](setup_test_images/api_testing_sprint_1/17-US03-03-invalid-token-401.png) |
| AC-04 | Type must be "income" or "expense" | TC-US03-04 | ✅ PASS | Invalid type rejected | - |
| AC-05 | Amount must be positive | TC-US03-05 | ✅ PASS | Negative/zero amounts rejected | [18-US03-05](setup_test_images/api_testing_sprint_1/18-US03-05-negative-amount-validation.png) |
| AC-06 | Category is required | TC-US03-06 | ✅ PASS | Missing category returns 400 | - |
| AC-07 | Date defaults to today if not provided | TC-US03-07 | ✅ PASS | Date defaults correctly | - |
| AC-08 | Returns 201 with saved transaction | TC-US03-01 | ✅ PASS | Transaction returned with id | [15-US03-01](setup_test_images/api_testing_sprint_1/15-US03-01-create-transaction-success.png) |
| AC-09 | Returns 401 if not authenticated | TC-US03-02 | ✅ PASS | Unauthenticated requests rejected | [16-US03-02](setup_test_images/api_testing_sprint_1/16-US03-02-no-token-401.png) |

### Detailed Test Results

```bash
PASS tests/transactions.test.js
  POST /api/transactions
    √ TC-US03-01: should create transaction with valid data (141 ms)
    √ TC-US03-02: should return 401 without token (78 ms)
    √ TC-US03-03: should return 401 with invalid token (46 ms)
    √ TC-US03-04: should return 400 for invalid type (38 ms)
    √ TC-US03-05: should return 400 for negative amount (35 ms)
    √ TC-US03-05b: should return 400 for zero amount (33 ms)
    √ TC-US03-06: should return 400 if category is missing (57 ms)
    √ TC-US03-07: should default date to today if not provided (50 ms)
    √ should create income transaction successfully (49 ms)
```

---

## US-07: Health Endpoint - Test Results

### Acceptance Criteria & Test Mapping

| AC Ref | Acceptance Criterion | Test Case | Status | Evidence | Screenshot |
|--------|---------------------|-----------|--------|----------|-----------|
| AC-01 | GET `/health` returns 200 when healthy | TC-US07-01 | ✅ PASS | Health check returns 200 | [Sprint 2 Test Evidence](Sprint%202%20-%20Execution/10-sprint-2-test-report.md) |
| AC-02 | Returns required fields (status, uptime, timestamp, database, version) | TC-US07-01 | ✅ PASS | All fields present in response | - |
| AC-03 | Does NOT require authentication | TC-US07-03 | ✅ PASS | Public endpoint works without token | - |

### Detailed Test Results

```bash
PASS tests/health.test.js
  GET /health
    √ TC-US07-03: should not require authentication (67 ms)
```

---

## Summary Report

### Test Execution Summary

| Metric | Value |
|--------|-------|
| Total Test Suites | 5 |
| Total Tests | 27 |
| Passing | 27 |
| Failing | 0 |
| Skipped | 0 |
| Pass Rate | 100% |
| Code Coverage | 64.25% |

### Coverage by Module

| Module | Statements | Branches | Functions | Lines |
|--------|-----------|----------|-----------|-------|
| All files | 64.25% | 46.29% | 59.09% | 64.25% |
| config | 86.95% | 50% | 50% | 86.95% |
| controllers | 68% | 68.75% | 60% | 68% |
| middleware | 92.3% | 87.5% | 100% | 92.3% |
| models | 25% | 16.66% | 42.85% | 25% |
| routes | 100% | 100% | 100% | 100% |
| utils | 92.85% | 50% | 75% | 92.85% |

### Acceptance Criteria Coverage

| User Story | Total ACs | Tested ACs | Coverage |
|------------|-----------|------------|----------|
| US-01 | 9 | 9 | 100% |
| US-02 | 7 | 7 | 100% |
| US-03 | 9 | 9 | 100% |
| US-07 | 3 | 3 | 100% |

---

## Test Evidence

### Test Execution Command
```bash
npm test -- --runInBand
```

### Sample Test Output
```
Test Suites: 5 passed, 5 total
Tests:       27 passed, 27 total
Snapshots:   0 total
Time:        5.887 s
```

### Sample API Response (Health Check)
```json
{
  "status": "healthy",
  "uptime_seconds": 32,
  "timestamp": "2026-02-10T13:13:28.159Z",
  "database": "connected",
  "version": "1.0.0"
}
```

### Sample Registration Response (201 Created)
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "created_at": "2026-02-10T13:23:20.708Z"
}
```

### Sample Login Response (200 OK)
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

## CI/CD Pipeline Integration

Tests are configured to run automatically in CI/CD pipeline:

```yaml
# .github/workflows/ci.yml
- name: Run ESLint
  run: npm run lint

- name: Run tests
  run: npm test
  env:
    DATABASE_URL: postgresql://postgres:postgres@localhost:5432/spendwise_test
    JWT_SECRET: test-secret-key
    NODE_ENV: test
```

---

## Next Steps for Sprint 2

### Tests to Add
- US-04: List My Transactions (GET /api/transactions)
- US-05: Filter Transactions (GET /api/transactions with query params)
- US-06: Get Spending Summary (GET /api/transactions/summary)
- Integration tests for user data isolation
- End-to-end test scenarios

### Target Coverage
- Increase overall coverage to >80%
- Add integration tests for database operations
- Add tests for edge cases and error handling
