# MySQL Sandbox - Example Databases

Docker Compose configuration for Sakila and Employees (HR) example databases with MySQL 8.0.

## About This Project

This project facilitates the setup of two popular MySQL example databases using Docker containers. Ideal for testing, learning, and development.

### Available Databases

| Database | Port | Description |
|----------|------|-------------|
| **Sakila** | 3306 | Sample database of a video rental store (films, actors, customers, rentals) |
| **RH Test DB** | 3307 | Employees database (employees, departments, salaries) |

### Data Sources

- **Sakila**: [LintangWisesa/Sakila_MySQL_Example](https://github.com/LintangWisesa/Sakila_MySQL_Example)
- **Employees**: [datacharmer/test_db](http://github.com/datacharmer/test_db)

---

## Quick Start

```bash
# Clone the repository
git clone https://github.com/seu-usuario/mysql-sandbox.git
cd mysql-sandbox

# Start a specific database
make up DB=sakila
make up DB=rh-testdb

# Start all databases
make up-all

# Check status
make status
```

---

## Prerequisites

- Docker
- Docker Compose
- Make (optional, but recommended)

---

## Commands

| Command | Description |
|---------|-------------|
| `make up DB=<database>` | Starts a specific database |
| `make up-all` | Starts all databases |
| `make down DB=<database>` | Stops a specific database |
| `make down-all` | Stops all databases |
| `make restart DB=<database>` | Restarts a specific database |
| `make logs DB=<database>` | Shows real-time logs |
| `make status` | Shows container status |
| `make clean` | Removes all containers and volumes |
| `make clean-<database>` | Removes a specific database |

### Examples

```bash
# Start Sakila
make up DB=sakila

# View RH TestDB logs
make logs DB=rh-testdb

# Stop only Sakila
make down DB=sakila

# Clean only RH TestDB
make clean-rh-testdb
```

---

## Connection

### Sakila (port 3306)

```bash
mysql -h localhost -P 3306 -u sakila_user -p sakila
```

### RH Test DB (port 3307)

```bash
mysql -h localhost -P 3307 -u employees_user -p employees
```

### Example Usage with External Test API

The RH Test DB in this repository can be used with external projects like the [rh-sakila-test-api](https://github.com/rodrigocnascimento/rh-sakila-test-api) to test SQL query analysis tools like sql-sage. That API is intentionally designed with many performance errors and anti-patterns for experimental purposes:

```bash
# Start the RH Test DB from this repository
make up DB=rh-testdb

# In a separate terminal, clone and set up the test API (separate project)
git clone https://github.com/rodrigocnascimento/rh-sakila-test-api.git
cd rh-sakila-test-api
cp .env.example .env
npm install
npm run dev
```

The API will be available at http://localhost:3000 and provides various endpoints with intentional performance issues (N+1 queries, SELECT *, missing indexes, etc.) to test database analysis tools and understand query performance problems.

**Note**: The rh-sakila-test-api is a separate project and is NOT included in this mysql-sandbox repository. It must be cloned separately to use with this database.

### Environment Variables

Edite o arquivo `.env` para customize as configurações:

```env
# Sakila
SAKILA_MYSQL_ROOT_PASSWORD=root_password
SAKILA_MYSQL_DATABASE=sakila
SAKILA_MYSQL_USER=sakila_user
SAKILA_MYSQL_PASSWORD=sakila_password

# RH Test DB
RH_TESTDB_MYSQL_ROOT_PASSWORD=root_password
RH_TESTDB_MYSQL_DATABASE=employees
RH_TESTDB_MYSQL_USER=employees_user
RH_TESTDB_MYSQL_PASSWORD=employees_password

TZ=America/Sao_Paulo
```

### RH Test DB (port 3307)

```bash
mysql -h localhost -P 3307 -u employees_user -p employees
```

### Environment Variables

Edit the `.env` file to customize configurations:

```env
# Sakila
SAKILA_MYSQL_ROOT_PASSWORD=root_password
SAKILA_MYSQL_DATABASE=sakila
SAKILA_MYSQL_USER=sakila_user
SAKILA_MYSQL_PASSWORD=sakila_password

# RH Test DB
RH_TESTDB_MYSQL_ROOT_PASSWORD=root_password
RH_TESTDB_MYSQL_DATABASE=employees
RH_TESTDB_MYSQL_USER=employees_user
RH_TESTDB_MYSQL_PASSWORD=employees_password

TZ=America/Sao_Paulo
```

---

## Project Structure

```
mysql-sandbox/
├── .env                         # Environment variables
├── .gitignore
├── Makefile                     # Management commands
├── docker-compose.sakila.yml   # Compose for Sakila
├── docker-compose.rh-testdb.yml # Compose for RH TestDB
├── sakila/
│   ├── config/
│   │   └── custom.cnf          # MySQL configuration (Performance Schema)
│   └── init/
│       ├── sakila-schema.sql  # Sakila database schema
│       └── sakila-data.sql    # Sakila database data
└── rh-testdb/
    ├── config/
    │   └── custom.cnf          # MySQL configuration (Performance Schema)
    └── init/
        └── employees.sql      # Employees database schema + data
```

---

## Features

- **Persistent Volumes**: Data is maintained between restarts
- **Health Checks**: Automatic availability verification
- **Isolated Networks**: Each database in its own configuration
- **UTF8MB4 Charset**: Full support for special characters
- **MySQL 8.0**: Latest stable MySQL version
- **Performance Schema**: Configured and enabled by default for query analysis

### Why Performance Schema Configuration?

The Performance Schema is configured with specific settings to enable detailed query analysis:

- `performance_schema=ON`: Enables the Performance Schema
- `performance-schema-instrument=%=ON`: Enables all statement instruments
- `performance-schema-consumer-events-statements-history=ON`: Stores historical statement events
- `performance-schema-consumer-events-statements-history-long=ON`: Stores long historical statement events
- `performance-schema-consumer-events-statements-current=ON`: Stores current statement events

This configuration allows tools like sql-sage to collect and analyze query performance data effectively.

### About the RH Test DB Size

The RH Test DB (Employees database) is intentionally large (~300,000 employees, ~2.8 million salary records) to provide a realistic environment for performance testing. With this volume of data:

- Query performance issues become more pronounced and easier to detect
- Index usage (or lack thereof) has a significant impact on execution time
- Tools like sql-sage can demonstrate their value in identifying slow queries
- Development practices can be tested against production-like data volumes

This makes it ideal for training and experimentation with SQL analysis tools.

### Using with sql-sage and rh-test-api

This database is designed to work seamlessly with the [sql-sage](https://github.com/rodrigocnascimento/sql-sage) tool and [rh-test-api](https://github.com/rodrigocnascimento/rh-test-api) project for comprehensive SQL query analysis training:

1. **Start the database**: `make up DB=rh-testdb`
2. **Run the test API**: Clone and run rh-test-api separately (see below)
3. **Use sql-sage**: Scan the API code, collect queries from Performance Schema, and analyze results

#### Complete Workflow Example:

```bash
# Terminal 1: Start the database
cd mysql-sandbox
make up DB=rh-testdb

# Terminal 2: Start the test API (in separate directory)
git clone https://github.com/rodrigocnascimento/rh-test-api.git
cd rh-test-api
cp .env.example .env
npm install
npm run dev

# Terminal 3: Run sql-sage analysis
# Scan for potential issues in the API code
sql-sage scan ./rh-test-api/src --output scanned.jsonl

# Make some requests to generate queries
curl http://localhost:3000/api/employees-with-salaries
curl "http://localhost:3000/api/employees/search?name=john"

# Collect actual queries from the database
sql-sage collect --source perf-schema \
  --host localhost \
  --port 3307 \
  --user employees_user \
  --password employees_password \
  --database employees \
  --min-time 100 \
  --output collected.jsonl

# Consolidate and analyze
sql-sage consolidate --input scanned.jsonl collected.jsonl --output consolidated.jsonl
sql-sage analyze consolidated.jsonl --model models/
```

This setup provides hands-on experience with:
- Identifying performance issues in code (static analysis)
- Capturing actual query performance (dynamic analysis)
- Comparing predicted vs actual problems
- Learning optimization techniques

---

## Performance Schema

The project comes with [Performance Schema](https://dev.mysql.com/doc/refman/8.0/en/performance-schema.html) automatically configured for query analysis.

### Enabled Configuration

| Parameter | Value |
|-----------|-------|
| `performance_schema` | ON |
| `performance-schema-instrument` | %=ON |
| `performance-schema-consumer-events-statements-history` | ON |
| `performance-schema-consumer-events-statements-history-long` | ON |
| `performance-schema-consumer-events-statements-current` | ON |

### Check Status

```sql
-- Check if it's active
SHOW VARIABLES LIKE 'performance_schema';

-- Check active consumers
SELECT * FROM performance_schema.setup_consumers;

-- Check instruments
SELECT name, enabled 
FROM performance_schema.setup_instruments 
WHERE name LIKE 'statement/%' 
LIMIT 10;
```

### Useful Queries for Analysis

```sql
-- Slowest queries aggregated by digest
SELECT 
  DIGEST AS id,
  DIGEST_TEXT AS query,
  ROUND(SUM_TIMER_WAIT / 1000000000, 2) AS executionTimeMs,
  COUNT_STAR AS executions,
  SCHEMA_NAME AS `database`
FROM performance_schema.events_statements_summary_by_digest
WHERE DIGEST_TEXT IS NOT NULL
  AND SCHEMA_NAME IS NOT NULL
ORDER BY SUM_TIMER_WAIT DESC
LIMIT 100;

-- Query history
SELECT * FROM performance_schema.events_statements_history LIMIT 100;

-- Currently executing queries
SELECT * FROM performance_schema.events_statements_current;
```

---

## License

This project uses the Sakila (LGPL) and Employees (LGPL) sample databases. See:
- [Sakila License](https://dev.mysql.com/doc/sakila/en/sakila-license.html)
- [Employees Database License](https://github.com/datacharmer/test_db/blob/master/LICENSE)