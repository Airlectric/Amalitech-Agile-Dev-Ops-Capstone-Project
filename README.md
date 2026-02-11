# SpendWise - Personal Expense Tracker API

## Agile & DevOps Capstone Project Complete Documentation

---

## Project Overview

**SpendWise** is a REST API for tracking personal income and expenses, built with Node.js, Express, and PostgreSQL. This project demonstrates Agile principles and DevOps practices throughout its development lifecycle.

![Project Timeline](Workflow_diagrams/Project%20Timeline.png)

---

## Table of Contents

### [1. Sprint 0 - Planning](Sprint%200%20-%20Planning/)
- [01-product-vision.md](Sprint%200%20-%20Planning/01-product-vision.md)
- [02-product-backlog.md](Sprint%200%20-%20Planning/02-product-backlog.md)
- [03-definition-of-done.md](Sprint%200%20-%20Planning/03-definition-of-done.md)
- [04-sprint-1-plan.md](Sprint%200%20-%20Planning/04-sprint-1-plan.md)
- [05-sprint-2-plan.md](Sprint%200%20-%20Planning/05-sprint-2-plan.md)
- [06-sprint-0-summary.md](Sprint%200%20-%20Planning/06-sprint-0-summary.md)

### [2. Sprint 1 - Execution](Sprint%201%20-%20Execution/)
- [07-test-execution-report.md](Sprint%201%20-%20Execution/07-test-execution-report.md)
- [08-sprint-1-review.md](Sprint%201%20-%20Execution/08-sprint-1-review.md)
- [09-sprint-1-retrospective.md](Sprint%201%20-%20Execution/09-sprint-1-retrospective.md)

### [3. Sprint 2 - Execution & Improvement](Sprint%202%20-%20Execution/)
- [10-sprint-2-test-report.md](Sprint%202%20-%20Execution/10-sprint-2-test-report.md)
- [11-sprint-2-review.md](Sprint%202%20-%20Execution/11-sprint-2-review.md)

### [4. Deployment - CI/CD](Deployment%20-%20CI_CD/)
- [12-final-project-report.md](Deployment%20-%20CI_CD/12-final-project-report.md)
- [13-final-retrospective.md](Deployment%20-%20CI_CD/13-final-retrospective.md)
- [14-cicd-evidence.md](Deployment%20-%20CI_CD/14-cicd-evidence.md)
- [15-testing-evidence.md](Deployment%20-%20CI_CD/15-testing-evidence.md)

---

## Project Flow Diagram

![Overall Flow Diagram](Workflow_diagrams/Overall%20flow%20diagram.png)

---

## Quick Links

| Resource | Link |
|----------|------|
| GitHub Repository | https://github.com/Airlectric/Amalitech-Agile-DevOps-Capstone-Project |
| API Documentation | See [README.md](README.md) |
| Deployment Guide | See [Deployment - CI_CD/14-cicd-evidence.md](Deployment%20-%20CI_CD/14-cicd-evidence.md) |
| Test Results | See [Deployment - CI_CD/15-testing-evidence.md](Deployment%20-%20CI_CD/15-testing-evidence.md) |

---

## Key Achievements

### Agile Practice
- ✅ Clear Product Vision defined
- ✅ Well-structured Product Backlog with 7 user stories
- ✅ Acceptance criteria and story points for each story
- ✅ Proper sprint planning with achievable commitments
- ✅ Definition of Done established

### DevOps Practice
- ✅ CI/CD pipeline with GitHub Actions
- ✅ Automated testing (45 tests, 90%+ coverage)
- ✅ Docker containerization
- ✅ Automated deployment to Render on master branch push
- ✅ Neon PostgreSQL for production database

### Delivery Discipline
- ✅ Incremental commits (no big-bang commits)
- ✅ Feature branches for all work
- ✅ Descriptive commit messages
- ✅ Pull requests with clear descriptions

### Prototype Quality
- ✅ All 7 user stories implemented
- ✅ 45 tests passing
- ✅ API endpoints fully functional
- ✅ Production deployment successful

### Reflection
- ✅ Sprint 1 retrospective with improvements identified
- ✅ Sprint 2 retrospective with lessons learned
- ✅ Continuous process improvement demonstrated

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Runtime | Node.js 20 |
| Framework | Express.js |
| Database | PostgreSQL (Local + Neon) |
| Authentication | JWT (jsonwebtoken) |
| Password Hashing | bcrypt |
| Testing | Jest + Supertest |
| Containerization | Docker |
| CI/CD | GitHub Actions |
| Deployment | Render |
| Database Hosting | Neon PostgreSQL |

---

## Project Structure

```
spendwise/
├── Sprint 0 - Planning/          # Sprint 0 documentation
├── Sprint 1 - Execution/          # Sprint 1 documentation
├── Sprint 2 - Execution/         # Sprint 2 documentation
├── Deployment - CI_CD/           # CI/CD and final documentation
├── Workflow_diagrams/            # Project flow diagrams
├── setup_test_images/            # Evidence screenshots
│   ├── setup/                    # Environment setup images
│   ├── sprint_1_tests/           # Sprint 1 test evidence
│   ├── sprint_2_tests/           # Sprint 2 test evidence
│   ├── api_testing_sprint_1/     # API testing Sprint 1
│   ├── api_testing_sprint_2/     # API testing Sprint 2
│   └── CI_CD/                    # CI/CD evidence
├── src/                          # Application source code
├── tests/                        # Test files
├── .github/workflows/            # GitHub Actions CI/CD
├── Dockerfile                    # Docker configuration
├── docker-compose.yml            # Docker Compose configuration
└── README.md                    # API documentation
```

---

## Evidence Screenshots Reference

### Setup Phase
| Screenshot | Description |
|------------|-------------|
| ![PostgreSQL Setup](setup_test_images/setup/01-postgres-docker-setup.png) | PostgreSQL Docker setup |
| ![App Logs](setup_test_images/setup/02-app-logs-docker.png) | Application running in Docker |
| ![Database Schema](setup_test_images/setup/03-database-schema.png) | Database schema created |

### Sprint 1 Testing
| Screenshot | Description |
|------------|-------------|
| ![Tests Running](setup_test_images/sprint_1_tests/04-npm-test-running.png) | Sprint 1 tests running |
| ![Test Results](setup_test_images/sprint_1_tests/05-test-results-27-passed.png) | 27 tests passed |
| ![ESLint](setup_test_images/sprint_1_tests/06-eslint-results.png) | ESLint passed |
| ![Docker Containers](setup_test_images/sprint_1_tests/07-docker-containers.png) | Docker containers running |

### Sprint 2 Testing
| Screenshot | Description |
|------------|-------------|
| ![Sprint 2 Tests](setup_test_images/sprint_2_tests/08-sprint2-tests-running.png) | Sprint 2 tests running |
| ![45 Tests Passed](setup_test_images/sprint_2_tests/09-test-results-45-passed.png) | 45 tests passed |
| ![90% Coverage](setup_test_images/sprint_2_tests/10-coverage-report-90percent.png) | 90.63% code coverage |

### API Testing Sprint 1
| Screenshot | Description |
|------------|-------------|
| ![Register Success](setup_test_images/api_testing_sprint_1/11-US01-01-register-success.png) | User registration successful |
| ![Missing Email Validation](setup_test_images/api_testing_sprint_1/12-US01-04-missing-email-validation.png) | Email validation working |
| ![Invalid Login](setup_test_images/api_testing_sprint_1/13-US02-04-invalid-email-401.png) | Invalid login returns 401 |
| ![Login Success](setup_test_images/api_testing_sprint_1/14-US02-01-login-success.png) | Login successful |
| ![Create Transaction](setup_test_images/api_testing_sprint_1/15-US03-01-create-transaction-success.png) | Transaction created |
| ![No Token](setup_test_images/api_testing_sprint_1/16-US03-02-no-token-401.png) | No token returns 401 |
| ![Invalid Token](setup_test_images/api_testing_sprint_1/17-US03-03-invalid-token-401.png) | Invalid token returns 401 |
| ![Negative Amount](setup_test_images/api_testing_sprint_1/18-US03-05-negative-amount-validation.png) | Validation working |

### API Testing Sprint 2
| Screenshot | Description |
|------------|-------------|
| ![List Transactions](setup_test_images/api_testing_sprint_2/19-US04-01-list-transactions.png) | List transactions endpoint |
| ![Filter by Type](setup_test_images/api_testing_sprint_2/20-US05-01-filter-by-type.png) | Filter by type |
| ![Filter by Category](setup_test_images/api_testing_sprint_2/21-US05-02-filter-by-category.png) | Filter by category |
| ![Filter by Date](setup_test_images/api_testing_sprint_2/22-US05-03-filter-by-date-range.png) | Filter by date range |
| ![Combined Filters](setup_test_images/api_testing_sprint_2/23-US05-04-combined-filters.png) | Combined filters |
| ![Summary Endpoint](setup_test_images/api_testing_sprint_2/24-US06-01-summary-endpoint.png) | Summary endpoint |
| ![Health Endpoint](setup_test_images/api_testing_sprint_2/25-US07-01-health-endpoint.png) | Health check endpoint |

### CI/CD Deployment
| Screenshot | Description |
|------------|-------------|
| ![Remote DB Migration](setup_test_images/CI_CD/tables_migrated_successfully_to_remote_db.png) | Tables migrated to Neon |
| ![Docker Config](setup_test_images/CI_CD/deployment_configuration_in_docker.png) | Docker deployment config |
| ![Render Deploy Hook](setup_test_images/CI_CD/retrieving_render_deploy_hooks_after_deploying_the_service.png) | Render deploy hook created |
| ![GitHub Secrets](setup_test_images/CI_CD/render_production_deploy_hook_added_to_github_actions_secrets.png) | Deploy hook in GitHub secrets |
| ![Disabled Auto Deploy](setup_test_images/CI_CD/disabled_render_autodeploy_feature_so_that_ci_cd_handles_deployment.png) | Render auto-deploy disabled |
| ![First CI/CD Failed](setup_test_images/CI_CD/first_ci_cd_test_on_master_failed.png) | First CI/CD attempt (failed) |
| ![CI/CD Success](setup_test_images/CI_CD/successful_deployment_seen_on_github_actions_dashboard.png) | CI/CD deployment successful |

---

## Features

- **User registration and authentication (JWT)**
- **Create, list, and filter transactions**
- **Spending summary with category breakdown**
- **Health monitoring endpoint**
- **Docker containerization**
- **CI/CD pipeline with GitHub Actions**

---

## Quick Start

### Prerequisites

- Node.js 20+
- Docker & Docker Compose
- PostgreSQL 16 (if not using Docker)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd spendwise
```

2. Install dependencies:
```bash
npm install
```

3. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. Start the database (Docker):
```bash
docker-compose up -d db
```

5. Run database migrations:
```bash
npm run db:migrate
```

6. Start the application:
```bash
npm run dev
```

### Using Docker

Start all services:
```bash
docker-compose up --build
```

The API will be available at `http://localhost:3000`

---

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login and get JWT token

### Transactions
- `POST /api/transactions` - Create a transaction
- `GET /api/transactions` - List user's transactions
- `GET /api/transactions?type=expense&category=food&from=2026-01-01&to=2026-01-31` - Filter transactions

### Summary
- `GET /api/transactions/summary` - Get spending summary

### Health
- `GET /health` - Health check endpoint

---

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| NODE_ENV | Environment | development |
| PORT | API port | 3000 |
| DATABASE_URL | PostgreSQL connection string | - |
| JWT_SECRET | Secret for JWT signing | - |
| JWT_EXPIRES_IN | Token expiration | 24h |

---

## Development

```bash
# Run tests
npm test

# Run linter
npm run lint

# Run linter with fix
npm run lint:fix
```

---

## License

MIT
