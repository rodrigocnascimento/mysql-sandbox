.PHONY: help up down restart logs status clean rebuild up-all down-all

help:
	@echo "MySQL Docker - Gerenciador de Bancos de Dados"
	@echo ""
	@echo "Uso: make <comando> DB=<banco>"
	@echo ""
	@echo "Bancos disponíveis: sakila, rh-testdb"
	@echo ""
	@echo "Comandos disponíveis:"
	@echo "  make up DB=<banco>       - Inicia um banco"
	@echo "  make down DB=<banco>     - Para um banco"
	@echo "  make restart DB=<banco>  - Reinicia um banco"
	@echo "  make logs DB=<banco>     - Mostra logs de um banco"
	@echo "  make status              - Mostra status dos containers"
	@echo "  make clean               - Remove containers e volumes de todos"
	@echo "  make clean-sakila        - Remove container e volume do Sakila"
	@echo "  make clean-rh-testdb     - Remove container e volume do RH TestDB"
	@echo "  make up-all              - Inicia todos os bancos"
	@echo "  make down-all            - Para todos os bancos"
	@echo ""
	@echo "Exemplos:"
	@echo "  make up DB=sakila"
	@echo "  make up DB=rh-testdb"
	@echo "  make logs DB=sakila"
	@echo ""

up:
	@if [ "$(DB)" = "sakila" ]; then \
		docker compose -f docker-compose.sakila.yml up -d; \
		echo "Aguardando Sakila estar pronto..."; \
		sleep 15; \
		docker compose -f docker-compose.sakila.yml ps; \
	elif [ "$(DB)" = "rh-testdb" ]; then \
		docker compose -f docker-compose.rh-testdb.yml up -d; \
		echo "Aguardando RH TestDB estar pronto (pode levar ~60s)..."; \
		sleep 30; \
		docker compose -f docker-compose.rh-testdb.yml ps; \
	else \
		echo "Banco inválido. Use: make up DB=sakila ou make up DB=rh-testdb"; \
		exit 1; \
	fi

down:
	@if [ "$(DB)" = "sakila" ]; then \
		docker compose -f docker-compose.sakila.yml down; \
	elif [ "$(DB)" = "rh-testdb" ]; then \
		docker compose -f docker-compose.rh-testdb.yml down; \
	else \
		echo "Banco inválido. Use: make down DB=sakila ou make down DB=rh-testdb"; \
		exit 1; \
	fi

restart: down up

logs:
	@if [ "$(DB)" = "sakila" ]; then \
		docker compose -f docker-compose.sakila.yml logs -f; \
	elif [ "$(DB)" = "rh-testdb" ]; then \
		docker compose -f docker-compose.rh-testdb.yml logs -f; \
	else \
		echo "Banco inválido. Use: make logs DB=sakila ou make logs DB=rh-testdb"; \
		exit 1; \
	fi

up-all:
	docker compose -f docker-compose.sakila.yml up -d
	@echo "Aguardando Sakila..."
	@sleep 15
	docker compose -f docker-compose.rh-testdb.yml up -d
	@echo "Aguardando RH TestDB (pode levar ~60s)..."
	@sleep 30
	@docker compose -f docker-compose.sakila.yml ps
	@docker compose -f docker-compose.rh-testdb.yml ps

down-all:
	docker compose -f docker-compose.sakila.yml down
	docker compose -f docker-compose.rh-testdb.yml down

status:
	@echo "=== Containers Ativos ==="
	@docker ps --filter "name=sakila" --filter "name=rh-testdb" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

clean:
	docker compose -f docker-compose.sakila.yml down -v 2>/dev/null || true
	docker compose -f docker-compose.rh-testdb.yml down -v 2>/dev/null || true
	@echo "Todos os containers e volumes foram removidos"

clean-sakila:
	docker compose -f docker-compose.sakila.yml down -v
	@echo "Sakila removido"

clean-rh-testdb:
	docker compose -f docker-compose.rh-testdb.yml down -v
	@echo "RH TestDB removido"

rebuild:
	@if [ "$(DB)" = "sakila" ]; then \
		docker compose -f docker-compose.sakila.yml build --no-cache; \
		docker compose -f docker-compose.sakila.yml up -d; \
	elif [ "$(DB)" = "rh-testdb" ]; then \
		docker compose -f docker-compose.rh-testdb.yml build --no-cache; \
		docker compose -f docker-compose.rh-testdb.yml up -d; \
	else \
		echo "Banco inválido. Use: make rebuild DB=sakila ou make rebuild DB=rh-testdb"; \
		exit 1; \
	fi
