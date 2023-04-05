#!/usr/bin/env bash

main() {
  echo "Launching docker containers and sending them to the background"
  # Start the Docker container in detached mode
  {
    docker-compose down
    docker-compose up -d
  }

  # Wait for the container to start up
  sleep 5

  echo "Installing Dependencies"
  # Run the database migration
  npm i || {
    kill $(jobs -p)
    exit 1
  }

  echo "Running database migrations"
  # Run the database migration
  npm run migration:dev || {
    kill $(jobs -p)
    exit 1
  }

  echo "Seeding database"
  # Run the database migration
  npm run import:dev -- --flush || {
    kill $(jobs -p)
    exit 1
  }

  echo "Running API server"
  # Start the application
  npm run start:dev

}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]] ; then
  main
fi