#  This makefile is for developers and is not required to run Cowrie

IMAGENAME = cowrie
TAG = devel
CONTAINERNAME= cowrie

all: build

build: Dockerfile
	docker build -t ${IMAGENAME}:${TAG} .

run: start

start: create-volumes
	docker run -p 2222:2222/tcp \
		   -p 2223:2223/tcp \
		   -v cowrie-etc:/cowrie/cowrie-git/etc \
		   -v cowrie-var:/cowrie/cowrie-git/var \
		   -d \
	           --name ${CONTAINERNAME} ${IMAGENAME}:${TAG}

stop:
	docker stop ${CONTAINERNAME}

rm: stop
	docker rm ${CONTAINERNAME}

clean:
	docker rmi ${IMAGENAME}:${TAG}

shell:
	docker exec -it ${CONTAINERNAME} bash

logs:
	docker logs ${CONTAINERNAME}

ps:
	docker ps -f name=${CONTAINERNAME}

status: ps

ip:
	docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${CONTAINERNAME}

create-volumes:
	docker volume create cowrie-var
	docker volume create cowrie-etc
