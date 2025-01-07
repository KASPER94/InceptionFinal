VOL_PATH_WP := $(HOME)/data/wordpress
VOL_PATH_DB := $(HOME)/data/mariadb

# Cible par défaut (tout d'abord, création des répertoires et ensuite docker-compose)
# autre methode avec l'env : DB_PSSWD=Nolan123 docker compose -f ./srcs/docker-compose.yml up
all: $(VOL_PATH_WP) $(VOL_PATH_DB)
	@docker compose -f ./srcs/docker-compose.yml up

# Crée les répertoires nécessaires pour Wordpress et MariaDB et ajuste les permissions
$(VOL_PATH_WP):
	@mkdir -p $(VOL_PATH_WP)

$(VOL_PATH_DB):
	@mkdir -p $(VOL_PATH_DB)
	
# Arrêter les containers
down:
	@docker compose -f ./srcs/docker-compose.yml down

# Nettoyer les containers, volumes et images
clean:
	@docker compose -f ./srcs/docker-compose.yml down --volumes --rmi all

# Supprimer les répertoires de données et tout nettoyer
fclean: clean
	@sudo chown -R $(USER):$(USER) ~/data/wordpress ~/data/mariadb
	@rm -rf $(VOL_PATH_WP) $(VOL_PATH_DB)

# Rebuild et redémarrer les containers
re: fclean all

.PHONY: all re down clean fclean



