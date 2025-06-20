run:
	docker compose -f srcs/docker-compose.yml up

clean:
	@if [ -n "$$(docker ps -aq)" ]; then docker stop $$(docker ps -aq); fi
	@if [ -n "$$(docker ps -aq)" ]; then docker rm -f $$(docker ps -aq); fi
	@if [ -n "$$(docker images -q)" ]; then docker rmi -f $$(docker images -q); fi
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm -f $$(docker volume ls -q); fi
	@if [ -n "$$(docker network ls -q | grep -v 'bridge\|host\|none')" ]; then \
		docker network rm $$(docker network ls -q | grep -v 'bridge\|host\|none'); \
	fi

re: clean run

.PHONY: re run clean