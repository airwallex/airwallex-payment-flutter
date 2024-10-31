#!/bin/bash

echo "AVD is running now."
adb devices

# Change directory to example
if [ -d "example" ]; then
  cd example
else
  echo "Directory 'example' does not exist!"
  exit 1
fi

# Install dependencies
flutter pub get

# Run each test file
for test_file in integration_test/*.dart; do
  echo "Running Flutter Drive Test for $test_file"

  if ! flutter drive --driver=test_driver/integration_test.dart --target=$test_file --no-build; then
    echo "Error occurred during testing $test_file"
    exit 1
  fi

  echo "Finished testing $test_file"
done

# Handle process cleanup last, errors here will not affect script exit status
set +e
pkill -9 -f emulator
pkill -9 -f flutter
pkill -9 -f dart
set -e

echo "All tests completed successfully."