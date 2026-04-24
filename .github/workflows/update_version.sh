#!/bin/bash
# fail if any commands fails
set -e
# make pipelines' return status equal the last command to exit with a non-zero status, or zero if all commands exit successfully
set -o pipefail

# Cross-platform in-place sed (BSD sed on macOS requires an explicit backup extension)
sedi() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}

# Update version in pubspec.yaml
sedi "s/^version: .*$/version: $VERSION/" pubspec.yaml

# Debugging to confirm change
echo "Updated pubspec.yaml:"
cat pubspec.yaml

# Update CHANGELOG.md
if [ -n "$RELEASE_NOTES" ]; then
  # Use provided release notes
  echo -e "## $VERSION\n\n$RELEASE_NOTES\n" | cat - CHANGELOG.md > temp && mv temp CHANGELOG.md
  echo "Updated CHANGELOG.md with provided release notes"
else
  # If no release notes provided, append a generic message
  echo -e "## $VERSION\n\n- No release notes provided\n" | cat - CHANGELOG.md > temp && mv temp CHANGELOG.md
fi

# Update dependency version in code block in README.md, README-zh.md, GUIDE.md and GUIDE-zh.md
sedi "s/airwallex_payment_flutter: [0-9]\+\.[0-9]\+\.[0-9]\+/airwallex_payment_flutter: $VERSION/" README.md
sedi "s/airwallex_payment_flutter: [0-9]\+\.[0-9]\+\.[0-9]\+/airwallex_payment_flutter: $VERSION/" README-zh.md
sedi "s/airwallex_payment_flutter: \^[0-9]\+\.[0-9]\+\.[0-9]\+/airwallex_payment_flutter: ^$VERSION/" GUIDE.md
sedi "s/airwallex_payment_flutter: \^[0-9]\+\.[0-9]\+\.[0-9]\+/airwallex_payment_flutter: ^$VERSION/" GUIDE-zh.md

echo "Updated dependency version in README.md, README-zh.md, GUIDE.md and GUIDE-zh.md"

# Update frameworkVersion in native files
sedi "s/\"frameworkVersion\" to \"[0-9]\+\.[0-9]\+\.[0-9]\+\"/\"frameworkVersion\" to \"$VERSION\"/" android/src/main/kotlin/com/example/airwallex_payment_flutter/AirwallexPaymentSdkModule.kt
sedi "s/\"frameworkVersion\": \"[0-9]\+\.[0-9]\+\.[0-9]\+\"/\"frameworkVersion\": \"$VERSION\"/" ios/Classes/AirwallexSdk.swift

echo "Updated frameworkVersion in AirwallexPaymentSdkModule.kt and AirwallexSdk.swift"
