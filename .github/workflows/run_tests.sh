#!/bin/bash
set -e
# Change directory to example
echo "change directory to example"
cd example

# Install dependencies
#flutter pub get

# Run the integration tests
echo "Running Flutter Drive"
for test_file in integration_test/*.dart
do
  echo "Running Flutter Drive Test for $test_file"
  flutter drive --driver=test_driver/integration_test.dart --target=$test_file
done

adb -s emulator-5554 emu kill

pkill -f emulator || true
pkill -f flutter || true

echo "All tests completed."

exit 0

#echo "All tests completed."