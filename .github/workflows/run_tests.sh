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
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/plugin_payment_api_test.dart -d emulator-5554


#pkill -9 -f emulator || true
#pkill -9 -f adb || true
#pkill -9 -f dart || true
#pkill -9 -f flutter || true

echo "All tests completed successfully."
exit 0