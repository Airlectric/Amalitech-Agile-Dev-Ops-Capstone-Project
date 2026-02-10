# Sprint 2 Plan

## Sprint Overview

| Field | Value |
|-------|-------|
| **Sprint Number** | 2 |
| **Duration** | 2 weeks |
| **Start Date** | TBD |
| **End Date** | TBD |
| **Sprint Goal** | Deliver transaction listing, filtering, summary, and health monitoring |

---

## Selected Stories

### US-04: List My Transactions
**Points:** 2  
**Priority:** P1

**Tasks:**
- [x] Implement GET /api/transactions endpoint
- [x] Add user isolation (only own transactions)
- [x] Sort by date descending
- [x] Write unit tests
- [x] Write integration tests

---

### US-05: Filter Transactions
**Points:** 3  
**Priority:** P1

**Tasks:**
- [x] Add type filter (?type=income|expense)
- [x] Add category filter (?category=foo) - case insensitive
- [x] Add date range filter (?from=YYYY-MM-DD&to=YYYY-MM-DD)
- [x] Support combined filters
- [x] Write unit tests
- [x] Write integration tests

---

### US-06: Get Spending Summary
**Points:** 3  
**Priority:** P2

**Tasks:**
- [x] Implement GET /api/transactions/summary endpoint
- [x] Calculate total_income
- [x] Calculate total_expenses
- [x] Calculate balance
- [x] Generate by_category breakdown
- [x] Support date range filtering
- [x] Write unit tests
- [x] Write integration tests

---

### US-07: Health Endpoint
**Points:** 2  
**Priority:** P1

**Tasks:**
- [x] Implement GET /health endpoint
- [x] Check database connectivity (SELECT 1)
- [x] Return status, uptime, timestamp, database, version
- [x] Return 503 if database is down
- [x] No authentication required
- [x] Write integration tests

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

| Story | Points | Status |
|-------|--------|--------|
| US-04 | 2 | ✅ Complete |
| US-05 | 3 | ✅ Complete |
| US-06 | 3 | ✅ Complete |
| US-07 | 2 | ✅ Complete |
| **Total** | **10 points** | **100%** |

---

## Definition of Done for Sprint 2

All items from the global Definition of Done must be met.

Additionally for Sprint 2:
- [x] All 4 stories completed and merged to dev branch
- [x] CI pipeline passes with all 45 tests
- [x] Code coverage > 80% (achieved 90.63%)
- [x] All user stories tested with acceptance criteria mapped
- [x] Test execution report documented

---

## Technical Considerations

### Database Queries
- Use parameterized queries to prevent SQL injection
- Index on user_id and date for efficient filtering
- Aggregate queries for summary calculations

### Performance
- Pagination not required for MVP (list endpoint)
- Date range queries use indexes
- Summary calculations are lightweight

### Security
- JWT authentication required for all transaction endpoints
- Health endpoint is public (intentional)
- User data isolation enforced at query level

---

## Dependencies

- Sprint 1 completion (JWT authentication)
- Database schema in place
- CI/CD pipeline configured

---

## Review Criteria

Sprint 2 will be considered complete when:
1. [x] Users can list their transactions
2. [x] Users can filter by type, category, and date
3. [x] Users can view spending summary by category
4. [x] Health endpoint monitors API and DB status
5. [x] All 45 tests pass
6. [x] Code coverage > 80%
7. [x] Code merged to dev branch
8. [x] Definition of Done met for all stories
