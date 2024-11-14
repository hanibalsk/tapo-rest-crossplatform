#!/bin/bash

# Check if environment variables are set
if [ -z "$DEVICES_CONFIG_PATH" ] || [ -z "$PORT" ] || [ -z "$AUTH_PASSWORD" ]; then
  echo "One or more environment variables are missing. Please set DEVICES_CONFIG_PATH, PORT, and AUTH_PASSWORD."
  exit 1
fi

# Run tapo-rest with the specified parameters
tapo-rest --devices-config-path "$DEVICES_CONFIG_PATH" --port "$PORT" --auth-password "$AUTH_PASSWORD"
