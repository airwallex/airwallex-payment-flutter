#!/bin/bash
# fail if any commands fails
set -e
# make pipelines' return status equal the last command to exit with a non-zero status, or zero if all commands exit successfully
set -o pipefail

# Update version in pubspec.yaml
sed -i "s/^version: .*$/version: $VERSION/" pubspec.yaml

# Debugging to confirm change
echo "Updated pubspec.yaml:"
cat pubspec.yaml

# Update CHANGELOG.md
if [ -n "$RELEASE_NOTES" ]; then
  # Use provided release notes
  echo -e "## $VERSION\n\n$RELEASE_NOTES\n" | cat - CHANGELOG.md > temp && mv temp CHANGELOG.md
  echo "Updated CHANGELOG.md with provided release notes"
fi

# Update dependency version in code block in README.md and README-zh.md
sed -i "s/airwallex_payment_flutter: [0-9]\+\.[0-9]\+\.[0-9]\+/airwallex_payment_flutter: $VERSION/" README.md
sed -i "s/airwallex_payment_flutter: [0-9]\+\.[0-9]\+\.[0-9]\+/airwallex_payment_flutter: $VERSION/" README-zh.md

echo "Updated dependency version in README.md and README-zh.md"
