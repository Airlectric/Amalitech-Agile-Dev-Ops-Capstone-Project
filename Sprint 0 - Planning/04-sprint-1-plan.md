# Sprint 1 Plan

## Sprint Overview

| Field | Value |
|-------|-------|
| **Sprint Number** | 1 |
| **Duration** | 2 weeks |
| **Start Date** | TBD |
| **End Date** | TBD |
| **Sprint Goal** | Deliver core authentication and transaction creation functionality |

---

## Selected Stories

### US-01: Register an Account
**Points:** 3  
**Priority:** P0

**Tasks:**
- [ ] Set up Express.js project structure
- [ ] Create database connection module (PostgreSQL)
- [ ] Create users table schema
- [ ] Implement bcrypt password hashing
- [ ] Implement POST /api/auth/register endpoint
- [ ] Add email validation
- [ ] Add duplicate email check
- [ ] Write unit tests for validation logic
- [ ] Write integration tests for registration

---

### US-02: Log In
**Points:** 3  
**Priority:** P0

**Tasks:**
- [ ] Implement JWT token generation
- [ ] Implement POST /api/auth/login endpoint
- [ ] Implement bcrypt password comparison
- [ ] Add JWT middleware for authentication
- [ ] Write unit tests for JWT utilities
- [ ] Write integration tests for login

---

### US-03: Add a Transaction
**Points:** 3  
**Priority:** P0

**Tasks:**
- [ ] Create transactions table schema
- [ ] Implement POST /api/transactions endpoint
- [ ] Add transaction validation (type, amount, category, date)
- [ ] Implement JWT authentication middleware
- [ ] Associate transactions with user_id
- [ ] Write unit tests for validation
- [ ] Write integration tests for transaction creation

---

## Sprint Capacity

| Day | Hours Available |
|-----|-----------------|
| Monday | 2 |
| Tuesday | 2 |
| Wednesday | 2 |
| Thursday | 2 |
| Friday | 2 |
| Saturday | 4 |
| Sunday | 0 |
| **Total** | **14 hours** |

---

## Commitment

| Story | Points | Total Points |
|-------|--------|--------------|
| US-01 | 3 | |
| US-02 | 3 | |
| US-03 | 3 | |
| **Total** | | **9 points** |

---

## Sprint Backlog (Ordered by Priority)

1. US-01: Register an Account (3 points)
2. US-02: Log In (3 points)
3. US-03: Add a Transaction (3 points)

---

## Technical Setup (To Complete in Sprint 0)

Before Sprint 1 begins:

- [ ] Git repository initialized
- [ ] Node.js project initialized with package.json
- [ ] Dependencies installed: express, pg, bcrypt, jsonwebtoken, dotenv, jest, supertest, eslint
- [ ] Docker and docker-compose configured
- [ ] Database schema created
- [ ] CI/CD pipeline configured (GitHub Actions)
- [ ] Development environment ready (docker-compose up works)

---

## Definition of Done for Sprint 1

All items from the Definition of Done must be met for each story.

Additionally for Sprint 1:
- [ ] All 3 stories completed and merged to dev branch
- [ ] CI pipeline passes with all tests
- [ ] Docker image builds successfully
- [ ] Application runs locally with `docker-compose up`
- [ ] Health endpoint implemented (US-07, partial)

---

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Database connectivity issues | High | Use docker-compose for local DB; test CI with PostgreSQL service container |
| JWT token expiration issues | Medium | Set 24h expiry; implement token refresh if needed |
| Integration test complexity | Medium | Use Supertest for HTTP-level testing; mock database where appropriate |
| Time constraints | High | Focus on core functionality first; defer enhancements to Sprint 2 |

---

## Dependencies

- **US-02 depends on:** US-01 (need users table for login)
- **US-03 depends on:** US-02 (need JWT middleware for authentication)

---

## Review Criteria

Sprint 1 will be considered complete when:
1. Users can register with name, email, password
2. Users can log in and receive JWT token
3. Authenticated users can create transactions
4. All tests pass in CI pipeline
5. Code is merged to dev branch
6. Definition of Done is met for all stories
