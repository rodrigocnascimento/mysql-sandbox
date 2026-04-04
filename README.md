# MySQL Sandbox - Historical Data Sharing

Docker Compose configuration for sharing and accessing historical datasets using MySQL 8.0 containers.

## About This Project

This repository facilitates the sharing of historical and legacy datasets through MySQL containers. Ideal for:
- Testing applications with realistic historical data
- Learning database concepts with actual legacy schemas
- Development and experimentation with time-sensitive data
- Comparing modern applications against historical data patterns

### Available Datasets

| Dataset | Port | Description |
|---------|------|-------------|
| **Historical Sakila** | 3306 | Legacy video rental store data representing business from 2005-2010 |
| **Legacy HR Archive** | 3307 | Historical employee records from 2000-2015 with organizational changes |

### Data Sources

- **Historical Sakila**: Adapted from [LintangWisesa/Sakila_MySQL_Example](https://github.com/LintangWisesa/Sakila_MySQL_Example) with historical timeframes
- **Legacy HR Archive**: Based on [datacharmer/test_db](http://github.com/datacharmer/test_db) representing legacy HR systems

---

## Quick Start

```bash
# Clone the repository
git clone https://github.com/seu-usuario/mysql-sandbox.git
cd mysql-sandbox

# Start a specific dataset
make up DB=sakila
make up DB=rh-testdb

# Start all datasets
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
| `make up DB=<dataset>` | Starts a specific dataset |
| `make up-all` | Starts all datasets |
| `make down DB=<dataset>` | Stops a specific dataset |
| `make down-all` | Stops all datasets |
| `make restart DB=<dataset>` | Restarts a specific dataset |
| `make logs DB=<dataset>` | Shows real-time logs |
| `make status` | Shows container status |
| `make clean` | Removes all containers and volumes |
| `make clean-<dataset>` | Removes a specific dataset |

---

## Examples

```bash
# Start Historical Sakila dataset
make up DB=sakila

# View Legacy HR Archive logs
make logs DB=rh-testdb

# Stop only Historical Sakila
make down DB=sakila

# Clean only Legacy HR Archive
make clean-rh-testdb
```

---

## Connection

### Historical Sakila (port 3306)

```bash
mysql -h localhost -P 3306 -u sakila_user -p sakila
```

### Legacy HR Archive (port 3307)

```bash
mysql -h localhost -P 3307 -u employees_user -p employees
```

---

## Environment Variables

Edit the `.env` file to customize configurations:

```env
# Historical Sakila
SAKILA_MYSQL_ROOT_PASSWORD=root_password
SAKILA_MYSQL_DATABASE=sakila
SAKILA_MYSQL_USER=sakila_user
SAKILA_MYSQL_PASSWORD=sakila_password

# Legacy HR Archive
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
├── docker-compose.sakila.yml   # Compose for Historical Sakila
├── docker-compose.rh-testdb.yml # Compose for Legacy HR Archive
├── sakila/
│   ├── config/
│   │   └── custom.cnf          # MySQL configuration
│   └── init/
│       ├── sakila-schema.sql  # Historical Sakila database schema
│       └── sakila-data.sql    # Historical Sakila database data
└── rh-testdb/
    ├── config/
    │   └── custom.cnf          # MySQL configuration
    └── init/
        └── employees.sql      # Legacy HR Archive schema + data
```

---

## Features

- **Persistent Volumes**: Historical data is maintained between restarts
- **Health Checks**: Automatic availability verification
- **Isolated Networks**: Each dataset in its own configuration
- **UTF8MB4 Charset**: Full support for special characters and legacy encodings
- **MySQL 8.0**: Latest stable MySQL version for accessing historical data
- **Time-zone Configuration**: Properly handles historical timestamps

---

## Usage Notes

These datasets are intended for:
- **Data Sharing**: Providing access to historical datasets for collaborative projects
- **Legacy System Testing**: Testing modern applications against historical data patterns
- **Educational Purposes**: Learning how data structures and business rules have evolved
- **Migration Practice**: Practicing data migration from legacy to modern systems
- **Historical Analysis**: Analyzing business trends over time using consistent datasets

The data represents snapshots from specific time periods and can be used to:
- Test time-based queries and reporting
- Validate data transformation processes
- Study evolution of business domains
- Practice working with legacy data formats

---

## Maintenance

To update or add new historical datasets:
1. Place SQL schema and data files in the appropriate `init/` directory
2. Update the corresponding docker-compose file if needed
3. Update environment variables in `.env.example`
4. Document the time period and source of the data in this README

---

## License

This project provides access to adapted historical datasets. See:
- [Sakila License](https://dev.mysql.com/doc/sakila/en/sakila-license.html)
- [Employees Database License](https://github.com/datacharmer/test_db/blob/master/LICENSE)

Please ensure compliance with original data licenses when using these datasets.