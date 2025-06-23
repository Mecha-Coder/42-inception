#======================================================
# VARIABLE
#======================================================

USER             = jpaul
VOLUME_PATH      = /home/${USER}/data
WORDPRESS_VOLUME = $(VOLUME_PATH)/wordpress
MARIADB_VOLUME   = $(VOLUME_PATH)/mariadb
DOMAIN           = ${USER}.42.fr

#=======================================================
# COMAND
#=======================================================

convert:
	@find . -type f \( -name '*.sh' \) -exec sed -i 's/\r$$//' {} +

setup:
	@echo "=== Creating data directories ==="
	@sudo mkdir -p $(WORDPRESS_VOLUME)
	@sudo mkdir -p $(MARIADB_VOLUME)
	@sudo chmod 777 $(WORDPRESS_VOLUME)
	@sudo chmod 777 $(MARIADB_VOLUME)
	@echo "=== Setting up hosts file ==="
	@if ! grep -q "$(DOMAIN)" /etc/hosts; then \
		echo "127.0.0.1 $(DOMAIN)" | sudo tee -a /etc/hosts; \

run:
	@echo "=== Run Docker ==="
	docker compose -f srcs/docker-compose.yml build --no-cache
	docker compose -f srcs/docker-compose.yml up

clean:
	@echo "=== Cleaning up Docker resources ==="
	@if [ -n "$$(docker ps -aq)" ]; then docker stop $$(docker ps -aq); fi
	@if [ -n "$$(docker ps -aq)" ]; then docker rm -f $$(docker ps -aq); fi
	@if [ -n "$$(docker images -q)" ]; then docker rmi -f $$(docker images -q); fi
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm -f $$(docker volume ls -q); fi
	@if [ -n "$$(docker network ls -q | grep -v 'bridge\|host\|none')" ]; then \
		docker network rm $$(docker network ls -q | grep -v 'bridge\|host\|none'); \
	fi

re: clean run

status:
	@echo "=== Container Status ==="
	@docker ps
	@echo "\n=== Docker Images ==="
	@docker images
	@echo "\n=== Docker Volumes ==="
	@docker volume ls
	@echo "\n=== Docker Networks ==="
	@docker network ls

.PHONY: run clean re status