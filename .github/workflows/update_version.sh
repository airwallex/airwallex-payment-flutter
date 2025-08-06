#!/bin/bash
# fail if any commands fails
set -e
# make pipelines' return status equal the last command to exit with a non-zero status, or zero if all commands exit successfully
set -o pipefail

# Get the latest Git tag
TAG=$(git describe --tags --abbrev=0)

# Debug information
echo "Current directory: $(pwd)"
echo "Available files:"
ls -l
echo "Latest tag: $TAG"

# Check if the tag is in the format like 1.0.0
if [[ ! "$TAG" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)(-.+)?$ ]]; then
  echo "Error: Tag format is invalid. Expected format '1.0.0'."
  exit 1
fi

# Use the tag as the version
VERSION="$TAG"

# Update version in pubspec.yaml
sed -i "s/^version: .*$/version: $VERSION/" pubspec.yaml

# Debugging to confirm change
echo "Updated pubspec.yaml:"
cat pubspec.yaml

# Update CHANGELOG.md
echo -e "## $VERSION\n\n* Update details...\n" | cat - CHANGELOG.md > temp && mv temp CHANGELOG.md

# Debugging to confirm update
echo "Updated CHANGELOG.md:"
cat CHANGELOG.md