#!/bin/bash

echo "AVD is running now."
adb devices

# Change directory to example
echo "Attempting to change directory to example"
if [ -d "example" ]; then
  cd example
else
  echo "Directory 'example' does not exist!"
  exit 1
fi

# Run the integration tests
echo "Running Flutter Drive Test"
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/plugin_payment_ui_test.dart

exit 0