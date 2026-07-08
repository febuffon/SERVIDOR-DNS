.PHONY: build up down restart logs shell check clean

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

restart: down up

logs:
	docker compose logs -f

shell:
	docker compose exec unbound sh

check:
	docker compose exec unbound unbound-checkconf /opt/unbound/etc/unbound/unbound.conf

stats:
	docker compose exec unbound unbound-control stats

flush:
	docker compose exec unbound unbound-control flush_zone .

reload:
	docker compose exec unbound unbound-control reload

stop:
	docker compose stop

clean: down
	docker compose down -v
	docker volume rm dns-server_unbound_run dns-server_unbound_cache dns-server_unbound_log 2>/dev/null || true
	docker system prune -f --filter "label=com.docker.compose.project=dns-server"

prod: build up
	@echo "DNS server running on port $(shell grep DNS_PORT .env 2>/dev/null | cut -d= -f2 || echo 53)"
