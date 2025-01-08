VOL_PATH_WP := $(HOME)/data/wordpress
VOL_PATH_DB := $(HOME)/data/mariadb
SECRETS_PATH:= ./secrets

# autre methode avec l'env : DB_PSSWD=Nolan123 docker compose -f ./srcs/docker-compose.yml up
all: secret secure-secrets $(VOL_PATH_WP) $(VOL_PATH_DB)
	@docker compose -f ./srcs/docker-compose.yml up -d

$(VOL_PATH_WP):
	@mkdir -p $(VOL_PATH_WP)

$(VOL_PATH_DB):
	@mkdir -p $(VOL_PATH_DB)

secret:
	@mkdir -p ./secrets
	@if [ -d $(HOME)/Documents/credentials/secrets ]; then \
		cp -r $(HOME)/Documents/credentials/secrets/* ./secrets/ || echo "Failed to copy secrets."; \
	else \
		echo "No secrets directory found at $(HOME)/Documents/credentials/secrets."; \
	fi
	@if [ $(HOME)/Documents/credentials/.env ]; then \
		cp -r $(HOME)/Documents/credentials/.env ./srcs/ || echo "Failed to copy .env."; \
	else \
		echo "No .env file found at $(HOME)/Documents/credentials/.env."; \
	fi
	@echo "Secrets and .env copied successfully."

secure-secrets:
	@chmod 600 $(SECRETS_PATH)/db_password $(SECRETS_PATH)/wp_admin_password $(SECRETS_PATH)/wp_user_password
	@chmod 700 $(SECRETS_PATH)
	
down:
	@docker compose -f ./srcs/docker-compose.yml down

clean:
	@docker compose -f ./srcs/docker-compose.yml down --volumes --rmi all

rmsecret:
	@sudo rm -rf ./secrets ./srcs/.env
	@echo "Secrets and .env files removed successfully."

fclean: clean rmsecret
	@sudo chown -R $(USER):$(USER) ~/data/wordpress ~/data/mariadb
	@rm -rf $(VOL_PATH_WP) $(VOL_PATH_DB)

re: fclean all

.PHONY: all re down clean fclean rmsecret secure-secrets



