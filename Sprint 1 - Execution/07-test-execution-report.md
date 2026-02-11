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


---

## Test Summary

### Test Results

| Test Suite | Tests | Passing | Failing |
|------------|-------|---------|---------|
| auth-register.test.js | 7 | 7 | 0 |
| auth-login.test.js | 6 | 6 | 0 |
| transactions.test.js | 9 | 9 | 0 |
| auth.test.js | 4 | 4 | 0 |
| health.test.js | 1 | 1 | 0 |
| **Total** | **27** | **27** | **0** |

### Code Coverage

| Module | Coverage |
|--------|----------|
| All files | 64.25% |
| config | 86.95% |
| controllers | 68% |
| middleware | 92.3% |
| routes | 100% |
| utils | 92.85% |

---

## Acceptance Criteria Coverage

### US-01: Register an Account - ✅ ALL PASSED (9/9)

| AC | Description | Status |
|----|-------------|--------|
| AC-01 | POST /api/auth/register accepts { name, email, password } | ✅ PASS |
| AC-02 | Password hashed with bcrypt | ✅ PASS |
| AC-03 | Returns 201 with { id, name, email, created_at } | ✅ PASS |
| AC-04 | Returns 400 if name missing | ✅ PASS |
| AC-05 | Returns 400 if email missing | ✅ PASS |
| AC-06 | Returns 400 if password missing | ✅ PASS |
| AC-07 | Returns 400 if email format invalid | ✅ PASS |
| AC-08 | Returns 409 if email already registered | ✅ PASS |
| AC-09 | Password minimum 6 characters | ✅ PASS |

**Evidence:** [11-US01-01](setup_test_images/api_testing_sprint_1/11-US01-01-register-success.png), [12-US01-04](setup_test_images/api_testing_sprint_1/12-US01-04-missing-email-validation.png)

### US-02: Log In - ✅ ALL PASSED (7/7)

| AC | Description | Status |
|----|-------------|--------|
| AC-01 | POST /api/auth/login accepts { email, password } | ✅ PASS |
| AC-02 | Password compared against bcrypt hash | ✅ PASS |
| AC-03 | Returns 200 with { token } | ✅ PASS |
| AC-04 | JWT valid for 24h | ✅ PASS |
| AC-05 | Returns 401 if email doesn't exist | ✅ PASS |
| AC-06 | Returns 401 if password wrong | ✅ PASS |
| AC-07 | JWT payload contains { userId, email } | ✅ PASS |

**Evidence:** [13-US02-04](setup_test_images/api_testing_sprint_1/13-US02-04-invalid-email-401.png), [14-US02-01](setup_test_images/api_testing_sprint_1/14-US02-01-login-success.png)

### US-03: Add a Transaction - ✅ ALL PASSED (9/9)

| AC | Description | Status |
|----|-------------|--------|
| AC-01 | POST /api/transactions accepts required fields | ✅ PASS |
| AC-02 | Requires valid JWT in Authorization header | ✅ PASS |
| AC-03 | Returns 401 if invalid token | ✅ PASS |
| AC-04 | Type must be "income" or "expense" | ✅ PASS |
| AC-05 | Amount must be positive | ✅ PASS |
| AC-06 | Category is required | ✅ PASS |
| AC-07 | Date defaults to today if not provided | ✅ PASS |
| AC-08 | Returns 201 with saved transaction | ✅ PASS |
| AC-09 | Returns 401 if not authenticated | ✅ PASS |

**Evidence:** [15-US03-01](setup_test_images/api_testing_sprint_1/15-US03-01-create-transaction-success.png), [16-US03-02](setup_test_images/api_testing_sprint_1/16-US03-02-no-token-401.png), [17-US03-03](setup_test_images/api_testing_sprint_1/17-US03-03-invalid-token-401.png), [18-US03-05](setup_test_images/api_testing_sprint_1/18-US03-05-negative-amount-validation.png)

### US-07: Health Endpoint - ✅ ALL PASSED (3/3)

| AC | Description | Status |
|----|-------------|--------|
| AC-01 | GET /health returns 200 when healthy | ✅ PASS |
| AC-02 | Returns required fields | ✅ PASS |
| AC-03 | Does NOT require authentication | ✅ PASS |

**Evidence:** [Sprint 2 tests show health endpoint working](setup_test_images/sprint_2_tests/25-US07-01-health-endpoint.png)

---

## Detailed Test Output

### Sprint 1 Test Execution

```
Test Suites: 5 passed, 5 total
Tests:       27 passed, 27 total
Snapshots:   0 total
Time:        5.887s
```

### Sample Test Output

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

PASS tests/auth-login.test.js
  POST /api/auth/login
    √ TC-US02-01: should return 200 with JWT token on valid login (161 ms)
    √ TC-US02-03: should include userId and email in JWT payload (172 ms)
    √ TC-US02-04: should return 401 for non-existent email (87 ms)
    √ TC-US02-05: should return 401 for wrong password (209 ms)

PASS tests/transactions.test.js
  POST /api/transactions
    √ TC-US03-01: should create transaction with valid data (141 ms)
    √ TC-US03-02: should return 401 without token (78 ms)
    √ TC-US03-03: should return 401 with invalid token (46 ms)
    √ TC-US03-04: should return 400 for invalid type (38 ms)
    √ TC-US03-05: should return 400 for negative amount (35 ms)
    √ TC-US03-06: should return 400 if category is missing (57 ms)
    √ TC-US03-07: should default date to today (50 ms)
```

---

## Sample API Responses

### Health Check Response
```json
{
  "status": "healthy",
  "uptime_seconds": 32,
  "timestamp": "2026-02-10T13:13:28.159Z",
  "database": "connected",
  "version": "1.0.0"
}
```

### Registration Response (201 Created)
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "created_at": "2026-02-10T13:23:20.708Z"
}
```

### Login Response (200 OK)
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

## CI/CD Pipeline Integration

Tests run automatically in CI/CD pipeline. See [CI/CD Evidence](../Deployment%20-%20CI_CD/14-cicd-evidence.md) for deployment pipeline details.

---

## Notes

- All 27 tests passed in Sprint 1
- Screenshot evidence provided for key acceptance criteria
- Additional screenshots captured in Sprint 2 for remaining endpoints
- Code coverage: 64.25% (target: >80% by Sprint 2)
