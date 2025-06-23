NOTE = \033[1;33m
DONE = \033[0m

#======================================================
# VARIABLE
#======================================================

USER             = jpaul
VOLUME_PATH      = /home/${USER}/data
WORDPRESS_VOLUME = $(VOLUME_PATH)/wordpress
MARIADB_VOLUME   = $(VOLUME_PATH)/mariadb
DOMAIN           = ${USER}.42.fr

#=======================================================
# COMMAND
#=======================================================

convert:
	@echo "$(NOTE)=== Convert script(CRLF) to Unix(LF)===$(DONE)"
	@find . -type f \( -name '*.sh' \) -exec sed -i 's/\r$$//' {} +

setup:
	@echo "$(NOTE)=== Creating data directories ===$(DONE)"
	@sudo mkdir -p $(WORDPRESS_VOLUME)
	@sudo mkdir -p $(MARIADB_VOLUME)
	@sudo chmod 777 $(WORDPRESS_VOLUME)
	@sudo chmod 777 $(MARIADB_VOLUME)
	@echo "$(NOTE)=== Setting up hosts file ===$(DONE)"
	@if ! grep -q "$(DOMAIN)" /etc/hosts; then \
		echo "127.0.0.1 $(DOMAIN)" | sudo tee -a /etc/hosts; \
	fi

run:
	@echo "$(NOTE)=== Run Docker ===$(DONE)"
	@sudo docker compose -f srcs/docker-compose.yml build --no-cache
	@sudo docker compose -f srcs/docker-compose.yml up

clean:
	@echo "$(NOTE)=== Cleaning up Docker resources ===$(DONE)"
	@if [ -n "$$(sudo docker ps -aq)" ]; then sudo docker stop $$(sudo docker ps -aq); fi
	@if [ -n "$$(sudo docker ps -aq)" ]; then sudo docker rm -f $$(sudo docker ps -aq); fi
	@if [ -n "$$(sudo docker images -q)" ]; then sudo docker rmi -f $$(sudo docker images -q); fi
	@if [ -n "$$(sudo docker volume ls -q)" ]; then sudo docker volume rm -f $$(sudo docker volume ls -q); fi
	@if [ -n "$$(sudo docker network ls -q | grep -v 'bridge\|host\|none')" ]; then \
		sudo docker network rm $$(sudo docker network ls -q | grep -v 'bridge\|host\|none'); \
	fi

re: clean run

status:
	@echo "$(NOTE)=== Container Status ===$(DONE)"
	@sudo docker ps
	@echo "\n$(NOTE)=== Docker Images ===$(DONE)"
	@sudo docker images
	@echo "\n$(NOTE)=== Docker Volumes ===$(DONE)"
	@sudo docker volume ls
	@echo "\n$(NOTE)=== Docker Networks ===$(DONE)"
	@sudo docker network ls

.PHONY: run clean re status convert setup
