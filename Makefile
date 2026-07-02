# ClawWork Makefile
# Provides shortcuts for common development and deployment tasks.
#
# Usage:
#   make setup          First-time install (Python + Node.js deps)
#   make start          Start dashboard (backend API + frontend) natively
#   make up             Start with Docker Compose
#   make down           Stop Docker Compose services
#   make logs           Tail Docker Compose service logs
#   make build          Build Docker image
#   make clean          Remove build artifacts and logs

.PHONY: setup start stop logs build up down clean help

# ── Convenience shortcuts ──────────────────────────────────────────────────────

## setup: Install Python and Node.js dependencies (first-time only)
setup:
	@bash setup.sh

## start: Start the dashboard (backend API + React frontend) natively
start:
	@bash start_dashboard.sh

## run: Run the test agent with default config
run:
	@bash run_test_agent.sh

# ── Docker Compose ─────────────────────────────────────────────────────────────

## up: Build and start all services with Docker Compose
up:
	docker compose up --build

## up-detach: Start all services in the background
up-detach:
	docker compose up --build -d

## down: Stop and remove Docker Compose containers
down:
	docker compose down

## stop: Stop Docker Compose containers without removing them (Docker only)
stop:
	docker compose stop

## logs: Tail Docker Compose service logs
logs:
	docker compose logs -f

## logs-backend: Tail only the backend logs
logs-backend:
	docker compose logs -f backend

## logs-frontend: Tail only the frontend logs
logs-frontend:
	docker compose logs -f frontend

# ── Build ──────────────────────────────────────────────────────────────────────

## build: Build the Docker image
build:
	docker compose build

## build-frontend: Build the React frontend (produces frontend/dist/)
build-frontend:
	cd frontend && npm run build

# ── Cleanup ────────────────────────────────────────────────────────────────────

## clean: Remove logs, frontend build artifacts
clean:
	rm -rf logs/ frontend/dist/

## clean-all: Also remove frontend node_modules
clean-all: clean
	rm -rf frontend/node_modules/

# ── Help ───────────────────────────────────────────────────────────────────────

## help: Display this help message
help:
	@echo ""
	@echo "ClawWork – available make targets:"
	@echo ""
	@grep -E '^## ' Makefile | sed 's/^## /  /' | column -t -s ':'
	@echo ""
