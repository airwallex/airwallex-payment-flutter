#!/bin/bash

echo "AVD is running now."
adb devices

# Change directory to example
echo "Attempting to change directory to example"

cd example

# Install dependencies
flutter pub get

# Run the integration tests
echo "Running Flutter Drive Test"
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/plugin_payment_card_ui_test.dart -d emulator-5554

#kill $check_pid
echo "All tests completed successfully."
exit 0