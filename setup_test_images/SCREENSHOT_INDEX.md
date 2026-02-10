# Screenshot Index - All Evidence Images

## Overview

This file documents all screenshot evidence for the Agile & DevOps Capstone Project.

---

## File Naming Convention

```
##-US##-##-description.png
```

Where:
- `##` = Screenshot number (01-25)
- `US##` = User story number
- `##` = Test case number within the user story

---

## Complete Screenshot List

### Setup & Infrastructure (01-07)

| # | Filename | Description | Test Case |
|---|----------|-------------|-----------|
| 01 | `setup/01-postgres-docker-setup.png` | PostgreSQL running in Docker | Docker setup verification |
| 02 | `setup/02-app-logs-docker.png` | Application logs in Docker | App startup logs |
| 03 | `setup/03-database-schema.png` | Database schema verification | PostgreSQL tables |
| 04 | `sprint_1_tests/04-npm-test-running.png` | Sprint 1 tests running | `npm test` execution |
| 05 | `sprint_1_tests/05-test-results-27-passed.png` | 27 tests passed | Sprint 1 test results |
| 06 | `sprint_1_tests/06-eslint-results.png` | ESLint validation | Code quality check |
| 07 | `sprint_1_tests/07-docker-containers.png` | Docker containers running | Service status |

### Sprint 1 API Testing (08-18)

| # | Filename | Description | Test Case |
|---|----------|-------------|-----------|
| 08 | `sprint_2_tests/08-sprint2-tests-running.png` | Sprint 2 tests running | `npm test` execution |
| 09 | `sprint_2_tests/09-test-results-45-passed.png` | 45 tests passed | Sprint 2 test results |
| 10 | `sprint_2_tests/10-coverage-report-90percent.png` | 90.63% coverage | Code coverage report |
| 11 | `api_testing_sprint_1/11-US01-01-register-success.png` | Register with valid data | TC-US01-01 |
| 12 | `api_testing_sprint_1/12-US01-04-missing-email-validation.png` | Missing email validation | TC-US01-04 |
| 13 | `api_testing_sprint_1/13-US02-04-invalid-email-401.png` | Invalid email - 401 | TC-US02-04 |
| 14 | `api_testing_sprint_1/14-US02-01-login-success.png` | Login success | TC-US02-01 |
| 15 | `api_testing_sprint_1/15-US03-01-create-transaction-success.png` | Create transaction | TC-US03-01 |
| 16 | `api_testing_sprint_1/16-US03-02-no-token-401.png` | No token - 401 | TC-US03-02 |
| 17 | `api_testing_sprint_1/17-US03-03-invalid-token-401.png` | Invalid token - 401 | TC-US03-03 |
| 18 | `api_testing_sprint_1/18-US03-05-negative-amount-validation.png` | Negative amount validation | TC-US03-05 |

### Sprint 2 API Testing (19-25)

| # | Filename | Description | Test Case |
|---|----------|-------------|-----------|
| 19 | `api_testing_sprint_2/19-US04-01-list-transactions.png` | List all transactions | TC-US04-01 |
| 20 | `api_testing_sprint_2/20-US05-01-filter-by-type.png` | Filter by type | TC-US05-01 |
| 21 | `api_testing_sprint_2/21-US05-02-filter-by-category.png` | Filter by category | TC-US05-02 |
| 22 | `api_testing_sprint_2/22-US05-03-filter-by-date-range.png` | Filter by date range | TC-US05-03 |
| 23 | `api_testing_sprint_2/23-US05-04-combined-filters.png` | Combined filters | TC-US05-04 |
| 24 | `api_testing_sprint_2/24-US06-01-summary-endpoint.png` | Spending summary | TC-US06-01 |
| 25 | `api_testing_sprint_2/25-US07-01-health-endpoint.png` | Health check | TC-US07-01 |

---

## Folder Structure

```
setup_test_images/
├── setup/
│   ├── 01-postgres-docker-setup.png
│   ├── 02-app-logs-docker.png
│   └── 03-database-schema.png
├── sprint_1_tests/
│   ├── 04-npm-test-running.png
│   ├── 05-test-results-27-passed.png
│   ├── 06-eslint-results.png
│   └── 07-docker-containers.png
├── sprint_2_tests/
│   ├── 08-sprint2-tests-running.png
│   ├── 09-test-results-45-passed.png
│   └── 10-coverage-report-90percent.png
├── api_testing_sprint_1/
│   ├── 11-US01-01-register-success.png
│   ├── 12-US01-04-missing-email-validation.png
│   ├── 13-US02-04-invalid-email-401.png
│   ├── 14-US02-01-login-success.png
│   ├── 15-US03-01-create-transaction-success.png
│   ├── 16-US03-02-no-token-401.png
│   ├── 17-US03-03-invalid-token-401.png
│   └── 18-US03-05-negative-amount-validation.png
└── api_testing_sprint_2/
    ├── 19-US04-01-list-transactions.png
    ├── 20-US05-01-filter-by-type.png
    ├── 21-US05-02-filter-by-category.png
    ├── 22-US05-03-filter-by-date-range.png
    ├── 23-US05-04-combined-filters.png
    ├── 24-US06-01-summary-endpoint.png
    └── 25-US07-01-health-endpoint.png
```

---

## Usage in Documents

### Reference Format

```
![Test Case Description](setup_test_images/FILENAME)
```

### Example

```markdown
## US-01: Register an Account

### TC-US01-01: Register with Valid Data

![Registration Success](setup_test_images/api_testing_sprint_1/11-US01-01-register-success.png)
```

---

## Test Coverage Summary

| Sprint | Tests Passed | Coverage | Screenshots |
|--------|-------------|----------|-------------|
| Sprint 1 | 27/27 | 64.25% | 11 screenshots |
| Sprint 2 | 45/45 | 90.63% | 14 screenshots |
| **Total** | **45/45** | **90.63%** | **25 screenshots** |

---

## Evidence by User Story

### US-01: Register an Account (3 screenshots)
- 11: Success case
- 12: Missing email validation

### US-02: Log In (2 screenshots)
- 13: Invalid credentials
- 14: Success case

### US-03: Add Transaction (4 screenshots)
- 15: Success case
- 16: No token
- 17: Invalid token
- 18: Validation error

### US-04: List Transactions (1 screenshot)
- 19: List all transactions

### US-05: Filter Transactions (4 screenshots)
- 20: Filter by type
- 21: Filter by category
- 22: Filter by date range
- 23: Combined filters

### US-06: Get Spending Summary (1 screenshot)
- 24: Summary endpoint

### US-07: Health Endpoint (1 screenshot)
- 25: Health check

---

## Additional Evidence (8 screenshots)

| # | Category | Description |
|---|----------|-------------|
| 01 | Infrastructure | PostgreSQL in Docker |
| 02 | Infrastructure | App logs |
| 03 | Infrastructure | Database schema |
| 04 | Sprint 1 | Tests running |
| 05 | Sprint 1 | 27 tests passed |
| 06 | Sprint 1 | ESLint results |
| 07 | Sprint 1 | Docker containers |
| 08 | Sprint 2 | Tests running |
| 09 | Sprint 2 | 45 tests passed |
| 10 | Sprint 2 | Coverage report |

---

*Last Updated: February 10, 2026*
