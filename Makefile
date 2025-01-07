VOL_PATH_WP := $(HOME)/data/wordpress
VOL_PATH_DB := $(HOME)/data/mariadb
SECRETS := db_password wp_admin_password wp_user_password

# Cible par défaut (tout d'abord, création des répertoires et ensuite docker-compose)
all: $(VOL_PATH_WP) $(VOL_PATH_DB)
	@(docker swarm init --advertise-addr 127.0.0.1) || echo "swarn already init"
	docker secret create db_password ./secrets/db_password
	docker secret create wp_admin_password ./secrets/wp_admin_password
	docker secret create wp_user_password ./secrets/wp_user_password
	@docker-compose -f ./srcs/docker-compose.yml up


# secrets: $(SECRETS)

# db_password:
# 	@echo "Nolan123" > ./secrets/db_password
# 	docker secret create db_password ./secrets/db_password

# wp_admin_password:
# 	@echo "Nolan123" > ./secrets/wp_admin_password
# 	docker secret create wp_admin_password ./secrets/wp_admin_password

# wp_user_password:
# 	@echo "Dicaprio123" > ./secrets/wp_user_password
# 	docker secret create wp_user_password ./secrets/wp_user_password

# Crée les répertoires nécessaires pour Wordpress et MariaDB et ajuste les permissions
$(VOL_PATH_WP):
	@mkdir -p $(VOL_PATH_WP)

$(VOL_PATH_DB):
	@mkdir -p $(VOL_PATH_DB)
	
# Arrêter les containers
down:
	@docker-compose -f ./srcs/docker-compose.yml down

# Nettoyer les containers, volumes et images
clean:
	@docker-compose -f ./srcs/docker-compose.yml down --volumes --rmi all

# Supprimer les répertoires de données et tout nettoyer
fclean: clean secrets-clean
	@docker swarm leave --force
	@sudo chown -R $(USER):$(USER) ~/data/wordpress ~/data/mariadb
	@rm -rf $(VOL_PATH_WP) $(VOL_PATH_DB)

secrets-clean:
	@echo "Cleaning up Docker secrets..."
	@for secret in $(SECRETS); do \
		docker secret rm $$secret 2>/dev/null || echo "Secret $$secret does not exist."; \
	done

# Rebuild et redémarrer les containers
re: fclean all

.PHONY: all re down clean fclean secrets-clean



