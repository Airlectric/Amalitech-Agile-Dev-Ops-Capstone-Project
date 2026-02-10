# Docker & PostgreSQL Setup Guide

## Table of Contents

1. [Docker Installation Verification](#1-docker-installation-verification)
2. [Docker Compose Configuration](#2-docker-compose-configuration)
3. [Starting Services](#3-starting-services)
4. [Monitoring Logs](#4-monitoring-logs)
5. [PostgreSQL Database Setup](#5-postgresql-database-setup)
6. [Database Operations](#6-database-operations)
7. [Troubleshooting](#7-troubleshooting)

---

## 1. Docker Installation Verification

### Check Docker Version

```bash
docker --version
```

**Expected Output:**
```
Docker version 25.0.3, build 4debf41
```

### Check Docker Compose Version

```bash
docker-compose --version
```

**Expected Output:**
```
Docker Compose version v2.24.5
```

### Verify Docker Daemon is Running

```bash
docker info
```

**Expected Output (first few lines):**
```
Client: Docker Engine - Community
 Version:    25.0.3
 OS/Arch:    windows/amd64
 Context:    default
 Docker Root Dir:  C:\ProgramData\Docker\Desktop
 Server:
  Version:    25.0.3
  OS/Arch:    windows/amd64
```

### Test Docker with Hello World

```bash
docker run hello-world
```

**Expected Output:**
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

---

## 2. Docker Compose Configuration

### Project Structure

```
spendwise/
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
└── src/
```

### Dockerfile

```dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY src/ ./src/

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

CMD ["node", "src/server.js"]
```

### docker-compose.yml

```yaml
version: "3.9"

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/spendwise
      - JWT_SECRET=dev-secret-change-in-production
      - NODE_ENV=development
      - PORT=3000
    depends_on:
      db:
        condition: service_healthy

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: spendwise
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 3s
      retries: 5
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

### .dockerignore

```
node_modules
.git
.github
docs
tests
coverage
logs
*.md
.env
docker-compose.yml
.env.example
README.md
```

---

## 3. Starting Services

### Start All Services

```bash
docker-compose up -d
```

**EXPECTED OUTPUT:**
```
[+] Building 0.0s (0/0)
[+] Running 4/4
 ✔ Network project_default         Created
 ✔ Container project-db-1          Started
 ✔ Container project-app-1       Built
 ✔ Container project-app-1       Started
```

### Verify Services Are Running

```bash
docker-compose ps
```

**EXPECTED OUTPUT:**
```
NAME            IMAGE                    COMMAND              SERVICE    CREATED   STATUS    PORTS
project-app-1   project-app:latest      "docker-entrypoint.s…"   app        10 min ago   Up 10 min   0.0.0.0:3000->3000/tcp
project-db-1    postgres:16-alpine      "docker-entrypoint.s…"   postgres   10 min ago   Up 10 min   0.0.0.0:5432->5432/tcp
```

### Check Service Health

```bash
# Check app health
curl http://localhost:3000/health

# Check database health inside container
docker exec -it project-db-1 pg_isready -U postgres
```

**App Health Expected Output:**
```json
{
  "status": "healthy",
  "uptime_seconds": 600,
  "timestamp": "2026-02-10T13:10:00.000Z",
  "database": "connected",
  "version": "1.0.0"
}
```

**Database Expected Output:**
```
/var/run/postgresql:5432 - accepting connections
```

---

## 4. Monitoring Logs

### View All Logs

```bash
docker-compose logs
```

**EXPECTED OUTPUT:**
```
project-db-1  | 2026-02-10 13:00:00.123 UTC [1] LOG:  starting PostgreSQL 16.1 on x86_64-pc-linux-musl, compiled by gcc (Alpine 13.2.1_git20231014) 13.2.1 20231014, 64-bit
project-db-1  | 2026-02-10 13:00:00.124 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
project-db-1  | 2026-02-10 13:00:00.234 UTC [1] LOG:  listening on IPv6 address "::", port 5432
project-db-1  | 2026-02-10 13:00:00.456 UTC [1] LOG:  database system is ready to accept connections
project-app-1 | info: Server running on port 3000
project-app-1 | info: Environment: development
project-app-1 | Connected to PostgreSQL database
```

### View App Logs Only

```bash
docker-compose logs app
```

**EXPECTED OUTPUT:**
```
project-app-1  | info: Server running on port 3000
project-app-1  | info: Environment: development
project-app-1  | Connected to PostgreSQL database
project-app-1  | info: ::ffff:127.0.0.1 - - [10/Feb/2026:13:10:00 +0000] "POST /api/auth/register HTTP/1.1" 201 98 "-" "-"
project-app-1  | info: User registered successfully: test@example.com
```

### View Database Logs Only

```bash
docker-compose logs db
```

**EXPECTED OUTPUT:**
```
project-db-1  | 2026-02-10 13:00:00.123 UTC [1] LOG:  starting PostgreSQL 16.1
project-db-1  | 2026-02-10 13:00:00.234 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
project-db-1  | 2026-02-10 13:00:00.456 UTC [1] LOG:  database system is ready to accept connections
```

### Follow Logs in Real-Time

```bash
docker-compose logs -f
```

### View Logs with Timestamps

```bash
docker-compose logs --timestamps
```

---

## 5. PostgreSQL Database Setup

### Default Connection Settings

| Setting | Value |
|---------|-------|
| Host | localhost |
| Port | 5432 |
| Username | postgres |
| Password | postgres |
| Database | spendwise |

### Connect to PostgreSQL Container

```bash
docker exec -it project-db-1 psql -U postgres -d spendwise
```

**Expected Output:**
```
psql (16.1)
Type "help" for help.

spendwise=#
```

### List All Databases

```sql
\l
```

**Expected Output:**
```
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8  | en_US.utf8  |
 spendwise | postgres | UTF8     | en_US.utf8  | en_US.utf8  |
 template0 | postgres | UTF8     | en_US.utf8  | en_US.utf8  |
 template1 | postgres | UTF8     | en_US.utf8  | en_US.utf8  |
(4 rows)
```

### List All Tables

```sql
\dt
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

### Describe Users Table

```sql
\d users
```

**Expected Output:**
```
                                    Table "public.users"
    Column     |          Type          |                     Default
---------------+------------------------+------------------------------------------------------
 id            | integer                | generated by default as identity
 email         | character varying(255) | 
 password_hash | character varying(255) | 
 name          | character varying(100) | 
 created_at    | timestamp with time zone | now()
Indexes:
    "users_pkey" PRIMARY KEY, btree (id)
    "users_email_key" UNIQUE, btree (email)
Referenced by:
    TABLE "transactions" CONSTRAINT "transactions_user_id_fkey" FOREIGN KEY (id) REFERENCES users(id)
```

### Describe Transactions Table

```sql
\d transactions
```

**Expected Output:**
```
                                       Table "public.transactions"
    Column     |          Type          |                     Default
---------------+------------------------+------------------------------------------------------
 id            | integer                | generated by default as identity
 user_id       | integer                | 
 type          | character varying(10)  | 
 amount        | numeric(10,2)         | 
 category      | character varying(50)  | 
 description   | character varying(255) | 
 date          | date                   | 
 created_at    | timestamp with time zone | now()
Indexes:
    "transactions_pkey" PRIMARY KEY, btree (id)
    "transactions_user_id_idx" btree (user_id)
Foreign-key constraints:
    "transactions_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id)
```

---

## 6. Database Operations

### Run Migrations

```bash
npm run db:migrate
```

**Expected Output:**
```
Migration completed successfully
```

### View Data in Users Table

```sql
SELECT * FROM users;
```

**Expected Output:**
```
 id |        email        |                     password_hash                     |    name    |          created_at
----+--------------------+---------------------------------------------------+------------+-------------------------------
  1 | john.doe@example.com | $2b$10$abcdefghijklmnopqrstuv                        | John Doe   | 2026-02-10 13:00:00.000Z
(1 row)
```

### View Data in Transactions Table

```sql
SELECT * FROM transactions;
```

**Expected Output:**
```
 id | user_id |   type   | amount | category |   description   |    date    |          created_at
----+---------+----------+--------+----------+---------------+-------------+-------------------------------
  1 |       1 | expense  |  50.00 | Food     | Lunch at rest.. | 2026-02-10 | 2026-02-10 13:00:00.000Z
  2 |       1 | income   | 5000.00| Salary   | Monthly salary | 2026-02-10 | 2026-02-10 13:00:00.000Z
(2 rows)
```

### Count Records

```sql
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM transactions;
```

### Delete All Data (Reset Database)

```sql
DELETE FROM transactions;
DELETE FROM users;
```

### Exit PostgreSQL

```sql
\q
```

---

## 7. Troubleshooting

### Port Already in Use

```bash
# Check what's using port 3000
netstat -ano | findstr :3000

# Kill the process
taskkill /PID <PID> /F
```

### Database Connection Refused

```bash
# Check if PostgreSQL container is running
docker ps | findstr postgres

# Restart the container
docker-compose restart db
```

### Docker Container Won't Start

```bash
# Check container logs
docker-compose logs db

# Remove and recreate
docker-compose down -v
docker-compose up -d
```

### Insufficient Memory

```bash
# Increase Docker Desktop memory to 4GB
# Docker Desktop > Settings > Resources > Memory
```

### Invalid Database URL

```bash
# Verify .env file exists
dir .env

# Check contents
cat .env

# Restart containers
docker-compose down
docker-compose up -d
```

---

## Docker Commands Quick Reference

| Command | Description |
|---------|-------------|
| `docker-compose up -d` | Start all services |
| `docker-compose down` | Stop all services |
| `docker-compose restart` | Restart all services |
| `docker-compose logs` | View all logs |
| `docker-compose logs -f` | Follow logs |
| `docker-compose ps` | List running containers |
| `docker-compose exec app sh` | Shell into app container |
| `docker-compose exec db psql` | Connect to database |
| `docker-compose build --no-cache` | Rebuild images |
| `docker-compose down -v` | Remove volumes (data loss!) |

---

## Screenshots to Take

| Screenshot # | What to Capture | Command |
|-------------|-----------------|---------|
| 1 | Docker version | `docker --version` |
| 2 | Docker Compose version | `docker-compose --version` |
| 3 | Docker running | `docker info` |
| 4 | Services started | `docker-compose up -d` |
| 5 | Containers running | `docker-compose ps` |
| 6 | All logs | `docker-compose logs` |
| 7 | App logs | `docker-compose logs app` |
| 8 | DB logs | `docker-compose logs db` |
| 9 | Health check | `curl http://localhost:3000/health` |
| 10 | Database connection | `docker exec -it project-db-1 psql -U postgres` |
| 11 | List tables | `\dt` in psql |
| 12 | Table structure | `\d users` and `\d transactions` |
| 13 | Sample data | `SELECT * FROM users;` |
| 14 | Transaction data | `SELECT * FROM transactions;` |

---

*Document Version: 1.0*  
*Last Updated: February 10, 2026*
