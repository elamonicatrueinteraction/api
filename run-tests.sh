#!/bin/bash
docker volume create nilus_ci_data
docker network create custom_network
docker-compose up -d pg_gis_testing redis_testing
docker-compose build api_ci_migrations
if [[ $? -ne 0 ]] ; then echo "Error al buildear el componente de migrations"; exit 1 ; fi
docker-compose run api_ci_migrations
if [[ $? -ne 0 ]] ; then echo "Error al correr migrations"; exit 1 ; fi
docker-compose build api_ci
if [[ $? -ne 0 ]] ; then echo "Error al buildear el componente de ci"; exit 1 ; fi
docker-compose run api_ci
if [[ $? -ne 0 ]]
    then echo "Error al correr el ci"
    docker-compose down
    exit 1
fi
docker-compose down