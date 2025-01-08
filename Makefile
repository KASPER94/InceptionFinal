VOL_PATH_WP := $(HOME)/data/wordpress
VOL_PATH_DB := $(HOME)/data/mariadb
SECRETS_PATH:= ./secrets

# autre methode avec l'env : DB_PSSWD=Nolan123 docker compose -f ./srcs/docker-compose.yml up
all: secure-secrets $(VOL_PATH_WP) $(VOL_PATH_DB)
	@docker compose -f ./srcs/docker-compose.yml up

$(VOL_PATH_WP):
	@mkdir -p $(VOL_PATH_WP)

$(VOL_PATH_DB):
	@mkdir -p $(VOL_PATH_DB)

secure-secrets:
	@chmod 600 $(SECRETS_PATH)/db_password $(SECRETS_PATH)/wp_admin_password $(SECRETS_PATH)/wp_user_password
	@chmod 700 $(SECRETS_PATH)
	
down:
	@docker compose -f ./srcs/docker-compose.yml down

clean:
	@docker compose -f ./srcs/docker-compose.yml down --volumes --rmi all

fclean: clean
	@sudo chown -R $(USER):$(USER) ~/data/wordpress ~/data/mariadb
	@rm -rf $(VOL_PATH_WP) $(VOL_PATH_DB)

re: fclean all

.PHONY: all re down clean fclean



