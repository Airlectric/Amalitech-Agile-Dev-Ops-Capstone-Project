# Supabase & Render Deployment Guide

## Table of Contents

1. [Supabase PostgreSQL Setup](#1-supabase-postgresql-setup)
2. [Render Deployment](#2-render-deployment)
3. [Environment Variables Configuration](#3-environment-variables-configuration)
4. [Database Migration to Supabase](#4-database-migration-to-supabase)
5. [CI/CD Pipeline Update](#5-cicd-pipeline-update)
6. [Troubleshooting](#6-troubleshooting)

---

## 1. Supabase PostgreSQL Setup

### Step 1: Create Supabase Account

1. Go to https://supabase.com
2. Click "Start your project" or "Sign Up"
3. Create account using GitHub or email

### Step 2: Create New Project

1. Click "New Project"
2. Select your organization
3. Fill in project details:

| Field | Value |
|-------|-------|
| Name | spendwise-api |
| Database Password | (generate a strong password) |
| Region | Select closest to your location |
| Pricing Plan | Free (included) |

### Step 3: Get Database Credentials

1. Go to **Settings** → **Database**
2. Find the following credentials:

**Important Credentials:**
```
Host: db.xxxxxxxx.supabase.co
Port: 5432
Database: postgres
User: postgres
Password: (your generated password)
Connection String: postgresql://postgres:password@db.xxxxxxxx.supabase.co:5432/postgres
```

### Step 4: Update Local .env File

```bash
# Copy current .env
cp .env .env.local

# Edit .env with Supabase credentials
notepad .env
```

**Updated .env:**
```
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://postgres:your_password@db.xxxxxxxx.supabase.co:5432/postgres
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRES_IN=24h
HOST=0.0.0.0
LOG_LEVEL=debug
```

### Step 5: Connect to Supabase from Local Machine

```bash
# Test connection (requires PostgreSQL client)
psql "postgresql://postgres:your_password@db.xxxxxxxx.supabase.co:5432/postgres"

# Or using Docker exec from container
docker exec -it project-db-1 psql "postgresql://postgres:your_password@db.xxxxxxxx.supabase.co:5432/postgres"
```

**Expected Output:**
```
psql (16.1)
Type "help" for help.

postgres=#
```

---

## 2. Render Deployment

### Step 1: Create Render Account

1. Go to https://render.com
2. Click "Sign Up"
3. Create account using GitHub

### Step 2: Create Web Service

1. Click "New" → "Web Service"
2. Connect your GitHub repository
3. Configure the service:

| Setting | Value |
|---------|-------|
| Name | spendwise-api |
| Root Directory | (leave empty) |
| Environment | Node |
| Build Command | `npm install` |
| Start Command | `npm start` |

### Step 3: Configure Environment Variables

In Render Dashboard, go to **Environment** tab and add:

| Variable | Value |
|----------|-------|
| NODE_ENV | production |
| PORT | 10000 |
| DATABASE_URL | (Supabase connection string) |
| JWT_SECRET | (generate strong random string) |
| JWT_EXPIRES_IN | 24h |

### Step 4: Create Database Service (Optional)

If you want Render-managed PostgreSQL:

1. Click "New" → "PostgreSQL"
2. Configure:

| Setting | Value |
|---------|-------|
| Name | spendwise-db |
| Database | spendwise |
| User | spendwise |
| Plan | Free |

### Step 5: Connect Database to Web Service

1. In PostgreSQL service, click "Connect"
2. Copy the "Internal Database URL"
3. In Web Service environment variables, add:
   ```
   DATABASE_URL=postgresql://spendwise:password@localhost:5432/spendwise
   ```

---

## 3. Environment Variables Configuration

### Local Development (.env)

```bash
# Application
NODE_ENV=development
PORT=3000

# Local PostgreSQL
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/spendwise

# JWT
JWT_SECRET=your-dev-secret-key
JWT_EXPIRES_IN=24h

# Logging
LOG_LEVEL=debug
```

### Production (.env.production)

```bash
# Application
NODE_ENV=production
PORT=10000

# Supabase PostgreSQL
DATABASE_URL=postgresql://postgres:your_password@db.xxxxxxxx.supabase.co:5432/postgres

# JWT (use strong random string)
JWT_SECRET=super-secret-production-key-min-32-characters-long!

# For Render: Use environment variable reference
# DATABASE_URL=${DATABASE_URL}
```

### Render Environment Variables

Add these in Render Dashboard:

| Key | Value | Secret |
|-----|-------|--------|
| NODE_ENV | production | No |
| PORT | 10000 | No |
| DATABASE_URL | (Supabase connection string) | Yes |
| JWT_SECRET | (generate: `openssl rand -base64 32`) | Yes |
| JWT_EXPIRES_IN | 24h | No |

### Generate Secure JWT Secret

```bash
# Using OpenSSL (Linux/Mac/WSL)
openssl rand -base64 32

# Using Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"
```

**Expected Output:**
```
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 4. Database Migration to Supabase

### Option A: Using psql (Recommended)

```bash
# Connect to Supabase
psql "postgresql://postgres:your_password@db.xxxxxxxx.supabase.co:5432/postgres"

# Run migration commands
\i src/config/migrate.sql
```

### Option B: Using Docker

```bash
# Create migration file
cat > migrate-supabase.sql << 'EOF'
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS transactions (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type VARCHAR(10) NOT NULL CHECK (type IN ('income', 'expense')),
  amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
  category VARCHAR(50) NOT NULL,
  description VARCHAR(255),
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_user_date ON transactions(user_id, date DESC);
EOF

# Execute migration
psql "postgresql://postgres:your_password@db.xxxxxxxx.supabase.co:5432/postgres" -f migrate-supabase.sql
```

### Option C: Using Application Migration Script

```bash
# Set Supabase DATABASE_URL
export DATABASE_URL="postgresql://postgres:your_password@db.xxxxxxxx.supabase.co:5432/postgres"

# Run migration
npm run db:migrate
```

**Expected Output:**
```
Migration completed successfully
```

### Verify Migration

```bash
psql "postgresql://postgres:your_password@db.xxxxxxxx.supabase.co:5432/postgres" -c "\dt"
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

## 5. CI/CD Pipeline Update

### Update GitHub Actions Workflow

Edit `.github/workflows/ci.yml`:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: ["*"]
  pull_request:
    branches: [master, dev]

jobs:
  build-and-test:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:16-alpine
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: spendwise_test
        ports:
          - 5432:5432
        options: >-
          --health-cpgrep_isready -U postgres"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build Docker image
        run: docker build -t spendwise:test .

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "npm"

      - name: Install dependencies
        run: npm ci

      - name: Run ESLint
        run: npm run lint

      - name: Run tests
        run: npm test
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/spendwise_test
          JWT_SECRET: test-secret-key
          NODE_ENV: test

  deploy-staging:
    needs: build-and-test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/dev'
    steps:
      - name: Deploy to Render (Staging)
        run: curl -X POST "${{ secrets.RENDER_DEPLOY_HOOK_URL }}"

  deploy-production:
    needs: build-and-test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/master'
    steps:
      - name: Deploy to Render (Production)
        run: curl -X POST "${{ secrets.RENDER_PRODUCTION_DEPLOY_HOOK_URL }}"
```

### Add GitHub Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Add the following secrets:

| Secret Name | Value |
|------------|-------|
| RENDER_DEPLOY_HOOK_URL | Render webhook URL for staging |
| RENDER_PRODUCTION_DEPLOY_HOOK_URL | Render webhook URL for production |
| DATABASE_URL | Supabase connection string (optional, use Render env vars) |

---

## 6. Testing Deployment

### Test Local with Supabase

```bash
# Set Supabase DATABASE_URL
export DATABASE_URL="postgresql://postgres:your_password@db.xxxxxxxx.supabase.co:5432/postgres"

# Run application
npm run dev

# Test health endpoint
curl http://localhost:3000/health

# Register a user
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name": "Cloud User", "email": "cloud@test.com", "password": "password123"}'
```

### Test Production Endpoint

Once deployed to Render:

```bash
# Get your Render service URL from dashboard
# Usually: https://spendwise-api.onrender.com

# Test health
curl https://spendwise-api.onrender.com/health

# Test registration
curl -X POST https://spendwise-api.onrender.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name": "Production User", "email": "prod@test.com", "password": "password123"}'
```

---

## Troubleshooting

### Connection Refused

```
Error: connect ECONNREFUSED 127.0.0.1:5432
```

**Solution:** Ensure PostgreSQL container is running:
```bash
docker-compose ps
docker-compose up -d db
```

### Authentication Failed

```
Error: password authentication failed for user postgres
```

**Solution:** Check password in connection string:
```bash
# Verify .env file
cat .env | grep DATABASE_URL
```

### Role Does Not Exist

```
Error: role "postgres" does not exist
```

**Solution:** Use correct Supabase credentials from dashboard.

### Database Does Not Exist

```
Error: database "spendwise" does not exist
```

**Solution:** Create the database:
```sql
CREATE DATABASE spendwise;
```

---

## Deployment Checklist

| Task | Status |
|------|--------|
| Create Supabase account | ☐ |
| Create Supabase project | ☐ |
| Get database credentials | ☐ |
| Test local connection to Supabase | ☐ |
| Create Render account | ☐ |
| Create Render web service | ☐ |
| Configure environment variables | ☐ |
| Add GitHub secrets | ☐ |
| Run database migration | ☐ |
| Test production endpoint | ☐ |
| Configure custom domain (optional) | ☐ |

---

## Screenshots to Take

| Screenshot # | What to Capture |
|-------------|-----------------|
| 1 | Supabase project dashboard |
| 2 | Supabase database credentials |
| 3 | Render web service configuration |
| 4 | Render environment variables |
| 5 | GitHub Actions secrets page |
| 6 | Successful deployment log |
| 7 | Production health endpoint response |
| 8 | Production API test (registration) |

---

## Final URLs

| Environment | URL |
|------------|-----|
| Local | http://localhost:3000 |
| Staging (Render) | https://spendwise-staging.onrender.com |
| Production (Render) | https://spendwise-api.onrender.com |
| Supabase Dashboard | https://supabase.com/dashboard |

---

*Document Version: 1.0*  
*Last Updated: February 10, 2026*
