#!/usr/bin/env bash

set -o errexit

# Load environment variables from .env.dev if present
if [ -f .env.dev ]; then
  echo "Loading environment variables from .env.dev"
  export $(grep -v '^#' .env.dev | xargs)
fi

mix local.hex --force
mix local.rebar --force

MIX_ENV=prod mix deps.get
MIX_ENV=prod mix compile

# Optional: build frontend assets
# MIX_ENV=prod mix assets.deploy
