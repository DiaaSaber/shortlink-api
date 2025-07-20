#!/bin/bash
set -e


# 1. Remove a potentially pre-existing server.pid for Rails.
echo "Removing old server.pid if it exists..."
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# If running the rails server then create or migrate existing database
if [ "$1" = "rails" ] && [ "$2" = "server" ]; then
  echo "Preparing database..."
  bundle exec rails db:prepare
fi
# 
echo "Starting main process: $@"
exec "$@"
