#======================================================
# VARIABLE
#======================================================

NOTE = \033[1;33m
DONE = \033[0m

USER          = jpaul
WORDPRESS_VOL = /home/${USER}/data/wordpress
MARIADB_VOL   = /home/${USER}/data/mariadb
DOMAIN        = ${USER}.42.fr

#=======================================================
# COMMAND
#=======================================================

.PHONY: 
	convert host volume c_volume group 
	build run stop clean status
	setup revol re reset 

setup: convert host volume group
revol: volume c_volume
re   : clean build run
reset: revol re

# SETUP VM
#-------------------------------------------------------------

# Only applicable if using VM in Windows
convert:
	@echo "$(NOTE)Convert script(CRLF) to Unix(LF)$(DONE)"
	@echo "$(NOTE)================================$(DONE)"
	find . -type f -name '*.sh' -exec dos2unix {} \;

host:
	@echo "$(NOTE)Add $(DOMAIN) to /etc/host$(DONE)"
	@echo "$(NOTE)==========================$(DONE)"
	@if ! grep -q "$(DOMAIN)" /etc/hosts; then \
		echo "127.0.0.1 $(DOMAIN)" |  tee -a /etc/hosts; \
	fi

volume:
	@echo "$(NOTE)Creating data-folder for mounting$(DONE)"
	@echo "$(NOTE)=================================$(DONE)"
	sudo mkdir -p $(WORDPRESS_VOL)
	sudo mkdir -p $(MARIADB_VOL)
	sudo chmod 777 $(WORDPRESS_VOL)
	sudo chmod 777 $(MARIADB_VOL)

c_volume:
	@echo "$(NOTE)Delete data-folder$(DONE)"
	@echo "$(NOTE)==================$(DONE)"
	sudo rm -rf "$(WORDPRESS_VOL)" "$(MARIADB_VOL)"

group:
	@echo "$(NOTE)=> Upgrade docker privilege$(DONE)"
	@echo "$(NOTE)===========================$(DONE)"
	@{ \
		getent group docker >/dev/null || sudo groupadd docker; \
		if ! id -nG "$$USER" | grep -qw docker; then \
			sudo usermod -aG $$USER; \
			echo "Upgraded docker privilege"; \
		else \
			echo "Docker is already in group"; \
		fi; \
	}

# COMMANDS FOR DOCKER
#--------------------------------------------------------------

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

status:
	@echo "$(NOTE)=== Container Status ===$(DONE)"
	@docker ps
	@echo "\n$(NOTE)=== Docker Images ===$(DONE)"
	@docker images
	@echo "\n$(NOTE)=== Docker Volumes ===$(DONE)"
	@docker volume ls
	@echo "\n$(NOTE)=== Docker Networks ===$(DONE)"
	@docker network ls

