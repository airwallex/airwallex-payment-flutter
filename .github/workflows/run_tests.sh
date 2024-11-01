#!/bin/bash

set -e
set -x

echo "AVD is running now."
adb devices

# Change directory to example
echo "Attempting to change directory to example"
if [ -d "example" ]; then
  cd example
  ls -al  # This is for debugging to ensure we're in the correct directory
else
  echo "Directory 'example' does not exist!"
  exit 1
fi

# Install dependencies
flutter pub get

# Run the integration tests
echo "Running Flutter Drive Test"
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/plugin_payment_card_ui_test.dart -d emulator-5554

# Check if any lingering processes are running
echo "Checking for lingering processes..."
ps aux | grep emulator
ps aux | grep flutter
ps aux | grep dart
ps aux | grep adb

echo "All tests and processes should be completed successfully."
exit 0