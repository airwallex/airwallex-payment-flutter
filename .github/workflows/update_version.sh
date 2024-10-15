#!/bin/bash

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

# Set local user identity to github-actions[bot]
git config user.email "github-actions[bot]@users.noreply.github.com"
git config user.name "github-actions[bot]"

# Commits and pushes with Github Actions' token
git add pubspec.yaml CHANGELOG.md
git commit -m "Update version to $VERSION" || exit 0 # Do not fail if no changes
git push origin HEAD:main

echo "Updated pubspec.yaml and CHANGELOG.md with version $VERSION"