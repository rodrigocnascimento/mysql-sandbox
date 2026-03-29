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
- **Performance Schema**: Configured and enabled by default

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