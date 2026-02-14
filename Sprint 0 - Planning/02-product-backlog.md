# Product Backlog

## Overview

The Product Backlog contains all user stories for the SpendWise Personal Expense Tracker API. Each story includes acceptance criteria, story points, and priority.

---

## User Stories

### US-01: Register an Account

**As a** new user, **I want to** create an account with my name, email, and password, **so that** I can start tracking my expenses.

**Acceptance Criteria:**
- POST `/api/auth/register` accepts `{ name, email, password }`
- Password is hashed with bcrypt before storing (never stored in plain text)
- Returns `201 Created` with `{ id, name, email, created_at }` (no password in response)
- Returns `400` if name, email, or password is missing
- Returns `400` if email format is invalid
- Returns `409 Conflict` if email is already registered
- Password must be at least 6 characters

**Story Points:** 3  
**Priority:** P0 (Critical)

---

### US-02: Log In

**As a** registered user, **I want to** log in with my email and password, **so that** I can access my data.

**Acceptance Criteria:**
- POST `/api/auth/login` accepts `{ email, password }`
- Compares password against bcrypt hash
- Returns `200 OK` with `{ token }` (JWT valid for 24h)
- Returns `401 Unauthorized` if email doesn't exist or password is wrong
- The JWT payload contains `{ userId, email }`

**Story Points:** 3  
**Priority:** P0 (Critical)

---

### US-03: Add a Transaction

**As a** logged-in user, **I want to** record an income or expense with an amount, category, and date, **so that** I can track where my money goes.

**Acceptance Criteria:**
- POST `/api/transactions` accepts `{ type, amount, category, description?, date? }`
- Requires a valid JWT in `Authorization: Bearer <token>` header
- `type` must be either `"income"` or `"expense"`
- `amount` must be a positive number
- `category` is required (e.g., "food", "salary", "transport")
- `date` defaults to today if not provided
- Returns `201 Created` with the saved transaction
- Returns `401` if no token or invalid token
- Returns `400` if required fields are missing or invalid

**Story Points:** 3  
**Priority:** P0 (Critical)

---

### US-04: List My Transactions

**As a** logged-in user, **I want to** see all my transactions sorted by date, **so that** I can review my financial activity.

**Acceptance Criteria:**
- GET `/api/transactions` returns only the authenticated user's transactions
- Sorted by date descending (most recent first)
- Each transaction includes `id`, `type`, `amount`, `category`, `description`, `date`
- Returns `200 OK` with empty array if the user has no transactions
- Returns `401` if not authenticated

**Story Points:** 2  
**Priority:** P1 (High)

---

### US-05: Filter Transactions

**As a** logged-in user, **I want to** filter my transactions by type, category, or date range, **so that** I can find specific entries quickly.

**Acceptance Criteria:**
- GET `/api/transactions?type=expense` filters by income or expense
- GET `/api/transactions?category=food` filters by category (case-insensitive)
- GET `/api/transactions?from=2026-01-01&to=2026-01-31` filters by date range
- Filters can be combined: `?type=expense&category=food`
- Returns `200 OK` with matching transactions or empty array
- Returns `401` if not authenticated

**Story Points:** 3  
**Priority:** P1 (High)

---

### US-06: Get Spending Summary

**As a** logged-in user, **I want to** see my total income, total expenses, and balance, broken down by category, **so that** I understand my spending patterns.

**Acceptance Criteria:**
- GET `/api/transactions/summary` returns:
  ```json
  {
    "total_income": 5000.00,
    "total_expenses": 3200.00,
    "balance": 1800.00,
    "by_category": {
      "salary": 5000.00,
      "food": -1200.00,
      "transport": -800.00,
      "entertainment": -1200.00
    }
  }
  ```
- Only computes data for the authenticated user
- Accepts optional `?from=` and `?to=` date range
- Returns zeroed values if user has no transactions
- Returns `401` if not authenticated

**Story Points:** 3  
**Priority:** P2 (Medium)

---

### US-07: Health Endpoint

**As a** DevOps engineer, **I want** a health endpoint that checks the API and database status, **so that** I can monitor the service.

**Acceptance Criteria:**
- GET `/health` returns `200 OK` when healthy:
  ```json
  {
    "status": "healthy",
    "uptime_seconds": 3842,
    "timestamp": "2026-02-08T14:30:00.000Z",
    "database": "connected",
    "version": "1.0.0"
  }
  ```
- Actually runs `SELECT 1` against Postgres to verify DB connectivity
- Returns `503 Service Unavailable` with `"database": "disconnected"` if DB is down
- Does NOT require authentication

**Story Points:** 2  
**Priority:** P1 (High)

---

## Backlog Summary

| ID | Story | Points | Priority |
|----|-------|--------|----------|
| US-01 | Register an Account | 3 | P0 (Critical) |
| US-02 | Log In | 3 | P0 (Critical) |
| US-03 | Add a Transaction | 3 | P0 (Critical) |
| US-04 | List My Transactions | 2 | P1 (High) |
| US-05 | Filter Transactions | 3 | P1 (High) |
| US-06 | Spending Summary | 3 | P2 (Medium) |
| US-07 | Health Endpoint | 2 | P1 (High) |

**Total Story Points:** 19

---

## Priority Naming Convention

This project uses the industry-standard **P0–P3** priority classification:

| Priority Level | Standard Naming | Relationship to Story Points |
|----------------|-----------------|------------------------------|
| Critical | P0 / Blockers | Must be done regardless of Story Point size. |
| High | P1 / Must-Have | High priority; if Points are too high, it must be decomposed. |
| Medium | P2 / Should-Have | Average priority; usually prioritized if Points are low. |
| Low | P3 / Could-Have | Lowest priority; often "parked" if Points exceed 5–8. |

---

## Prioritization Rationale

- **P0 (Critical / Blockers):** US-01, US-02, US-03 form the core authentication and basic transaction functionality. Without these, users cannot use the system.
- **P1 (High / Must-Have):** US-04, US-05, US-07 enhance usability and observability. These are important but not blocking.
- **P2 (Medium / Should-Have):** US-06 provides valuable insights but is not essential for the MVP.

---

## Estimation Method

Story points are assigned using Fibonacci sequence (1, 2, 3, 5, 8, 13). Estimation factors include:
- Complexity of the feature
- Amount of new code required
- Testing effort
- Integration with existing components
