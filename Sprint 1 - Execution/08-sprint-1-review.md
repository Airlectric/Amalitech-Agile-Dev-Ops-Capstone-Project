# Sprint 1 Review Document

## Sprint Information

| Field | Value |
|-------|-------|
| **Sprint Number** | 1 |
| **Duration** | 2 weeks |
| **Start Date** | February 10, 2026 |
| **End Date** | February 10, 2026 |
| **Team Size** | 1 (Individual Project) |

---

## Sprint Goal

Deliver core authentication and transaction creation functionality, establishing the foundation for the SpendWise API.

---

## Commitment

| User Story | Feature | Points | Status |
|------------|---------|--------|--------|
| US-01 | Register an Account | 3 | ✅ Complete |
| US-02 | Log In | 3 | ✅ Complete |
| US-03 | Add a Transaction | 3 | ✅ Complete |
| **Total** | | **9 points** | **100%** |

---

## Work Completed

### US-01: Register an Account ✅

**Features Delivered:**
- POST `/api/auth/register` endpoint
- Password hashing with bcrypt
- Email validation and duplicate checking
- Returns 201 with user data (no password)

**Code Changes:**
- `src/controllers/authController.js` - Registration logic
- `src/models/user.js` - User CRUD operations
- `src/routes/authRoutes.js` - Auth routing
- `src/middleware/validate.js` - Input validation

---

### US-02: Log In ✅

**Features Delivered:**
- POST `/api/auth/login` endpoint
- JWT token generation (24h expiry)
- Password comparison with bcrypt
- Returns 200 with JWT token

**Code Changes:**
- `src/utils/jwt.js` - JWT utilities
- `src/middleware/auth.js` - JWT authentication middleware

---

### US-03: Add a Transaction ✅

**Features Delivered:**
- POST `/api/transactions` endpoint
- JWT authentication required
- Transaction validation (type, amount, category)
- Date defaults to today

**Code Changes:**
- `src/controllers/transactionController.js` - Transaction logic
- `src/models/transaction.js` - Transaction CRUD
- `src/routes/transactionRoutes.js` - Transaction routing

---

## Technical Foundation Established

| Component | Status | Notes |
|----------|--------|-------|
| Express.js API | ✅ | RESTful structure |
| PostgreSQL Database | ✅ | Users & transactions tables |
| Authentication (JWT) | ✅ | bcrypt + jsonwebtoken |
| Input Validation | ✅ | express-validator |
| Logging | ✅ | Winston + Morgan |
| Docker Support | ✅ | Dockerfile + docker-compose |
| CI/CD Pipeline | ✅ | GitHub Actions |

---

## Test Results

| Metric | Value |
|--------|-------|
| Test Suites | 4 |
| Total Tests | 27 |
| Passing | 27 |
| Failing | 0 |
| Pass Rate | 100% |
| Code Coverage | 64.25% |

**Test Files:**
- `tests/auth.test.js` - Auth validation tests
- `tests/auth-register.test.js` - Registration tests
- `tests/auth-login.test.js` - Login tests
- `tests/transactions.test.js` - Transaction tests

---

## Demo: API Endpoints in Action

### Registration

**Request:**
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com", "password": "secret123"}'
```

**Response (201 Created):**
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "created_at": "2026-02-10T13:23:20.708Z"
}
```

---

### Login

**Request:**
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "john@example.com", "password": "secret123"}'
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### Create Transaction

**Request:**
```bash
curl -X POST http://localhost:3000/api/transactions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{"type": "expense", "amount": 50.00, "category": "food", "description": "Lunch"}'
```

**Response (201 Created):**
```json
{
  "id": 1,
  "user_id": 1,
  "type": "expense",
  "amount": "50.00",
  "category": "food",
  "description": "Lunch",
  "date": "2026-02-10T00:00:00.000Z",
  "created_at": "2026-02-10T13:23:21.000Z"
}
```

---

## CI/CD Pipeline Status

The GitHub Actions pipeline runs on every push and PR:

| Job | Status |
|-----|--------|
| Build & Test | ✅ Passing |
| ESLint | ✅ Passing |
| Jest Tests | ✅ Passing (27/27) |

---

## Acceptance Criteria Coverage

| User Story | Total ACs | Tested | Coverage |
|------------|-----------|--------|----------|
| US-01 | 9 | 9 | 100% |
| US-02 | 7 | 7 | 100% |
| US-03 | 9 | 9 | 100% |
| **Total** | **25** | **25** | **100%** |

---

## Definition of Done Status

| Criterion | Status |
|-----------|--------|
| Code follows style guidelines | ✅ ESLint passes |
| Tests pass | ✅ 100% pass rate |
| Code merged to dev | ✅ Completed |
| CI pipeline passes | ✅ Passing |
| Documentation updated | ✅ Complete |

---

## Challenges Encountered

1. **PostgreSQL Connection Issues**
   - Initial connection errors due to DATABASE_URL
   - Fixed by ensuring .env file was properly configured

2. **Test Database Isolation**
   - Multiple test suites interfering with shared pool
   - Fixed by using `--runInBand` flag in Jest

3. **Date Format Handling**
   - PostgreSQL returning timestamps vs date strings
   - Fixed by adjusting test assertions to use `.toContain()`

---

## Sprint 1 Burndown

| Day | Points Completed | Cumulative |
|-----|------------------|------------|
| Day 1 | 3 (US-01) | 3 |
| Day 2 | 3 (US-02) | 6 |
| Day 3 | 3 (US-03) | 9 |
| Day 4+ | Testing & Documentation | 9 |

---

## Summary

Sprint 1 successfully delivered all 3 planned user stories (9 story points) with:

- ✅ Fully functional authentication system
- ✅ Transaction creation capability
- ✅ 27 passing tests (64% coverage)
- ✅ CI/CD pipeline configured
- ✅ Docker support for local development
- ✅ Comprehensive API documentation

**Sprint 1 Goal: ACHIEVED**
