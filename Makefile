# Container orchestration tool (docker-compose or podman-compose)
COMPOSE?=docker-compose

.PHONY: setup run test clean help db-up db-down db-logs db-shell

help:
	@echo "Available commands:"
	@echo "  setup    - Set up the project environment and start database"
	@echo "  run      - Run the application"
	@echo "  test     - Run tests"
	@echo "  clean    - Clean up temporary files and stop containers"
	@echo "  db-up    - Start the PostgreSQL database"
	@echo "  db-down  - Stop the PostgreSQL database"
	@echo "  db-logs  - Show database logs"
	@echo "  db-shell - Connect to the database shell"
	@echo "  help     - Show this help message"

setup:
	@echo "Setting up the project..."
	@echo "Starting PostgreSQL database..."
	@$(COMPOSE) up -d
	@while ! $(COMPOSE) exec postgres pg_isready -U messaging_user -d messaging_service > /dev/null 2>&1; do \
		echo "PostgreSQL is not yet ready, waiting..."; \
		sleep 1; \
	done
	@echo "Database ready, setting up application..."
	@mix deps.get
	@mix ecto.migrate
	@mix run priv/repo/seeds.exs
	@echo "Setup complete!"

run:
	@echo "Running the application..."
	@./bin/start.sh

# NOTE(grant): We need to be running the server already, so we probably
# don't want to start the database again
test:
	@echo "Running tests..."
	@./bin/test.sh

clean:
	@echo "Cleaning up..."
	@echo "Stopping and removing containers..."
	@$(COMPOSE) down -v
	@echo "Removing any temporary files..."
	@rm -rf *.log *.tmp

db-up:
	@echo "Starting PostgreSQL database..."
	@$(COMPOSE) up -d

db-down:
	@echo "Stopping PostgreSQL database..."
	@$(COMPOSE) down

db-logs:
	@echo "Showing database logs..."
	@$(COMPOSE) logs -f postgres

db-shell:
	@echo "Connecting to database shell..."
	@$(COMPOSE) exec postgres psql -U messaging_user -d messaging_service
