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

.PHONY: setup convert host folder group build run stop clean fclean status    

# SETUP FOR FRESH VM
#---------------------

setup: setup_message convert host folder group

setup_message:
	@echo "$(NOTE)Setup for brand new VM$(DONE)"
	@echo "$(NOTE)======================$(DONE)"

convert:
	@echo "$(NOTE)=> Convert script(CRLF) to Unix(LF)$(DONE)"
	find . -type f -name '*.sh' -exec dos2unix {} \;

host:
	@echo "$(NOTE)=> Add $(DOMAIN) to /etc/host$(DONE)"
	@if ! grep -q "$(DOMAIN)" /etc/hosts; then \
		echo "127.0.0.1 $(DOMAIN)" |  tee -a /etc/hosts; \
	fi

folder:
	@echo "$(NOTE)=> Creating data-folder for mounting$(DONE)"
	sudo mkdir -p $(WORDPRESS_VOLUME)
	sudo mkdir -p $(MARIADB_VOLUME)
	sudo chmod 777 $(WORDPRESS_VOLUME)
	sudo chmod 777 $(MARIADB_VOLUME)

group:
	@echo "$(NOTE)=> Upgrade docker privilege$(DONE)"
	@{ \
		getent group docker >/dev/null || sudo groupadd docker; \
		if ! id -nG "$$USER" | grep -qw docker; then \
			sudo usermod -aG $$USER; \
			echo "Upgraded docker privilege"; \
		else \
			echo "Docker is already in group"; \
		fi; \
	}

# COMMANDS FOR EVAL
#-------------------

build:
	@echo "$(NOTE)Build Container$(DONE)"
	@echo "$(NOTE)===============$(DONE)"
	docker compose -f ./srcs/docker-compose.yml build --no-cache

run:
	docker compose -f ./srcs/docker-compose.yml up

stop:
	docker compose -f ./srcs/docker-compose.yml down

clean:
	@echo "$(NOTE)Wipe docker$(DONE)"
	@echo "$(NOTE)===========$(DONE)"
	@docker ps -qa | xargs -r docker stop || true; \
	docker ps -qa | xargs -r docker rm || true; \
	docker images -qa | xargs -r docker rmi -f || true; \
	docker volume ls -q | xargs -r docker volume rm || true; \
	docker network ls -q | grep -v 'bridge\|host\|none' | xargs -r docker network rm || true

fclean: clean
	@echo "$(NOTE)Delete data-folder$(DONE)"
	@echo "$(NOTE)==================$(DONE)"
	sudo rm -rf "$(WORDPRESS_VOLUME)" "$(MARIADB_VOLUME)"

status:
	@echo "$(NOTE)=== Container Status ===$(DONE)"
	@ docker ps
	@echo "\n$(NOTE)=== Docker Images ===$(DONE)"
	@ docker images
	@echo "\n$(NOTE)=== Docker Volumes ===$(DONE)"
	@ docker volume ls
	@echo "\n$(NOTE)=== Docker Networks ===$(DONE)"
	@ docker network ls

