# SpendWise - Personal Expense Tracker API

A REST API for tracking personal income and expenses, built with Node.js, Express, and PostgreSQL.

## Features

- User registration and authentication (JWT)
- Create, list, and filter transactions
- Spending summary with category breakdown
- Health monitoring endpoint
- Docker containerization
- CI/CD pipeline with GitHub Actions

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

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| NODE_ENV | Environment | development |
| PORT | API port | 3000 |
| DATABASE_URL | PostgreSQL connection string | - |
| JWT_SECRET | Secret for JWT signing | - |
| JWT_EXPIRES_IN | Token expiration | 24h |

## Development

```bash
# Run tests
npm test

# Run linter
npm run lint

# Run linter with fix
npm run lint:fix
```

## Project Structure

```
spendwise/
├── src/
│   ├── controllers/    # Request handlers
│   ├── middleware/      # Express middleware
│   ├── models/         # Data models
│   ├── routes/         # API routes
│   ├── utils/          # Helper functions
│   ├── config/         # Configuration
│   └── server.js       # Entry point
├── tests/              # Test files
├── .github/workflows/  # CI/CD configuration
├── Dockerfile
├── docker-compose.yml
└── package.json
```

## License

MIT
