# MySQL Sandbox - Bancos de Exemplo

Configuração Docker com Docker Compose para bancos de dados Sakila e Employees (RH), com MySQL 8.0.

## Sobre Este Projeto

Este projeto facilita a configuração de dois bancos de dados exemplo populares para MySQL usando containers Docker. Ideal para testes, aprendizado e desenvolvimento.

### Bancos Disponíveis

| Banco | Porta | Descrição |
|-------|-------|-----------|
| **Sakila** | 3306 | Banco de exemplo de locadora (films, actors, customers, rentals) |
| **RH Test DB** | 3307 | Banco de Employees (funcionários, departamentos, salários) |

### Origem dos Dados

- **Sakila**: [LintangWisesa/Sakila_MySQL_Example](https://github.com/LintangWisesa/Sakila_MySQL_Example)
- **Employees**: [datacharmer/test_db](http://github.com/datacharmer/test_db)

---

## Quick Start

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/mysql-sandbox.git
cd mysql-sandbox

# Iniciar um banco específico
make up DB=sakila
make up DB=rh-testdb

# Iniciar todos os bancos
make up-all

# Ver status
make status
```

---

## Pré-requisitos

- Docker
- Docker Compose
- Make (opcional, mas recomendado)

---

## Comandos

| Comando | Descrição |
|---------|------------|
| `make up DB=<banco>` | Inicia um banco específico |
| `make up-all` | Inicia todos os bancos |
| `make down DB=<banco>` | Para um banco específico |
| `make down-all` | Para todos os bancos |
| `make restart DB=<banco>` | Reinicia um banco |
| `make logs DB=<banco>` | Mostra logs em tempo real |
| `make status` | Mostra status dos containers |
| `make clean` | Remove todos os containers e volumes |
| `make clean-<banco>` | Remove um banco específico |

### Exemplos

```bash
# Iniciar Sakila
make up DB=sakila

# Ver logs do RH TestDB
make logs DB=rh-testdb

# Parar apenas o Sakila
make down DB=sakila

# Limpar apenas o RH TestDB
make clean-rh-testdb
```

---

## Conexão

### Sakila (porta 3306)

```bash
mysql -h localhost -P 3306 -u sakila_user -p sakila
```

### RH Test DB (porta 3307)

```bash
mysql -h localhost -P 3307 -u employees_user -p employees
```

### Variáveis de Ambiente

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

---

## Estrutura do Projeto

```
mysql-sandbox/
├── .env                         # Variáveis de ambiente
├── .gitignore
├── Makefile                     # Comandos de gerenciamento
├── docker-compose.sakila.yml   # Compose para Sakila
├── docker-compose.rh-testdb.yml # Compose para RH TestDB
├── sakila/
│   ├── config/
│   │   └── custom.cnf          # Configurações MySQL (Performance Schema)
│   └── init/
│       ├── sakila-schema.sql  # Schema do banco Sakila
│       └── sakila-data.sql    # Dados do banco Sakila
└── rh-testdb/
    ├── config/
    │   └── custom.cnf          # Configurações MySQL (Performance Schema)
    └── init/
        └── employees.sql      # Schema + dados do banco Employees
```

---

## Características

- **Volumes persistentes**: Dados são mantidos entre reinicializações
- **Health checks**: Verificação automática de disponibilidade
- **Redes isoladas**: Cada banco em sua própria configuração
- **Charset UTF8MB4**: Suporte completo a caracteres especiais
- **MySQL 8.0**: Última versão estável do MySQL
- **Performance Schema**: Configurado e ativado por padrão

---

## Performance Schema

O projeto já vem com o [Performance Schema](https://dev.mysql.com/doc/refman/8.0/en/performance-schema.html) configurado automaticamente para análise de queries.

### Configuração Ativada

| Parâmetro | Valor |
|-----------|-------|
| `performance_schema` | ON |
| `performance-schema-instrument` | %=ON |
| `performance-schema-consumer-events-statements-history` | ON |
| `performance-schema-consumer-events-statements-history-long` | ON |
| `performance-schema-consumer-events-statements-current` | ON |

### Verificar Status

```sql
-- Verificar se está ativo
SHOW VARIABLES LIKE 'performance_schema';

-- Verificar consumers ativos
SELECT * FROM performance_schema.setup_consumers;

-- Verificar instrumentos
SELECT name, enabled 
FROM performance_schema.setup_instruments 
WHERE name LIKE 'statement/%' 
LIMIT 10;
```

### Queries Úteis para Análise

```sql
-- Queries mais lentas agregadas por digest
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

-- Histórico de queries
SELECT * FROM performance_schema.events_statements_history LIMIT 100;

-- Queries em execução
SELECT * FROM performance_schema.events_statements_current;
```

---

## Licença

Este projeto usa os bancos de dados Sakila (LGPL) e Employees (LGPL). See:
- [Sakila License](https://dev.mysql.com/doc/sakila/en/sakila-license.html)
- [Employees Database License](https://github.com/datacharmer/test_db/blob/master/LICENSE)
