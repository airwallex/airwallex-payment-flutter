#!/bin/bash

# This script creates/updates credentials.json file which is used
# to authorize publisher when publishing packages to pub.dev

# Checking whether the secrets are available as environment variables or not.
if [ -z "${PUB_DEV_PUBLISH_ACCESS_TOKEN}" ]; then
  echo "Missing PUB_DEV_PUBLISH_ACCESS_TOKEN environment variable"
  exit 1
fi

if [ -z "${PUB_DEV_PUBLISH_REFRESH_TOKEN}" ]; then
  echo "Missing PUB_DEV_PUBLISH_REFRESH_TOKEN environment variable"
  exit 1
fi

if [ -z "${PUB_DEV_PUBLISH_TOKEN_ENDPOINT}" ]; then
  echo "Missing PUB_DEV_PUBLISH_TOKEN_ENDPOINT environment variable"
  exit 1
fi

if [ -z "${PUB_DEV_PUBLISH_EXPIRATION}" ]; then
  echo "Missing PUB_DEV_PUBLISH_EXPIRATION environment variable"
  exit 1
fi

# Function to refresh the access token
refresh_access_token() {
  echo "Refreshing access token..."
  response=$(curl -s -X POST "${PUB_DEV_PUBLISH_TOKEN_ENDPOINT}" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "grant_type=refresh_token" \
    -d "refresh_token=${PUB_DEV_PUBLISH_REFRESH_TOKEN}")

  new_access_token=$(echo "$response" | jq -r '.access_token')
  new_expiration=$(echo "$response" | jq -r '.expires_in')

  if [ -z "$new_access_token" ] || [ "$new_access_token" == "null" ]; then
    echo "Failed to refresh access token"
    exit 1
  fi

  # Update the access token and expiration values
  PUB_DEV_PUBLISH_ACCESS_TOKEN="$new_access_token"
  PUB_DEV_PUBLISH_EXPIRATION="$new_expiration"

  echo "Access token refreshed successfully"
}

# Refresh the access token if close to expiration (this logic depends on expiration time; adjust as necessary)
current_time=$(date +%s)
expiration_time=$(($PUB_DEV_PUBLISH_EXPIRATION / 1000)) # assuming expiration is in milliseconds

# If we are within 5 minutes of expiration, refresh
if [ $(($expiration_time - $current_time)) -le 300 ]; then
  refresh_access_token
fi

# Create credentials.json file in a path where Dart expects the credentials
mkdir -p "$HOME/.config/dart"  # Ensure the directory exists
cat <<EOF > "$HOME/.config/dart/pub-credentials.json"
{
  "accessToken":"${PUB_DEV_PUBLISH_ACCESS_TOKEN}",
  "refreshToken":"${PUB_DEV_PUBLISH_REFRESH_TOKEN}",
  "tokenEndpoint":"${PUB_DEV_PUBLISH_TOKEN_ENDPOINT}",
  "scopes":["https://www.googleapis.com/auth/userinfo.email","openid"],
  "expiration":$(($current_time + $PUB_DEV_PUBLISH_EXPIRATION * 1000))
}
EOF

echo "Credentials have been set up successfully"