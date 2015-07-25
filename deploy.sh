#!/bin/bash

echo "Deploying Shruti"

echo "Updating docker images"
docker pull postgres:9.4
docker pull omie/shruti-flyway
docker pull omie/shruti
docker pull omie/shruti-client
docker pull omie/ivona-service
docker pull omie/provider-bbc
docker pull omie/provider-hn
docker pull omie/provider-reddit


# have to start postgres first, to be able to detect that its up
# before starting other containers
# See https://github.com/docker/docker/issues/7445
# to know more

# name of postgres container matters in docker-compose.yml
# if you change it here, make sure to change it in other places too
echo "Starting postgres"
docker run --name shruti_postgres_ext -d -v `pwd`/data:/var/lib/postgresql/data -p 5432:5432 postgres:9.4

sleep 5

echo "Waiting for postgres to come up"
# Wait for database to get available
POSTGRES_LOOPS="10"
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=5432

#wait for postgres
i=0
while ! nc $POSTGRES_HOST $POSTGRES_PORT >/dev/null 2>&1 < /dev/null; do
  i=`expr $i + 1`
  if [ $i -ge $POSTGRES_LOOPS ]; then
    echo "$(date) - ${POSTGRES_HOST}:${POSTGRES_PORT} still not reachable, giving up"
    exit 1
  fi
  echo "$(date) - waiting for ${POSTGRES_HOST}:${POSTGRES_PORT}..."
  sleep 1
done

# migrate database
docker run --rm -v `pwd`/sql:/flyway/sql/ --link shruti_postgres_ext:shruti_postgres_ext omie/shruti-flyway

docker-compose up -d

docker ps

echo "Visit http://localhost:9576/"


