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

# Initialize a variable to track errors
error_occurred=false

# Run each test file
for test_file in integration_test/*.dart; do
  echo "Running Flutter Drive Test for $test_file"

  # Use a subshell and capture the exit status
  if ! (flutter drive --driver=test_driver/integration_test.dart --target=$test_file --no-build); then
    echo "Error occurred during testing $test_file"
    error_occurred=true
  fi

  echo "Finished testing $test_file"
done

# Conditionally kill processes only if error occurs, to see if it affects the outcome
if [ "$error_occurred" = true ]; then
  pkill -9 -f emulator || true
  pkill -9 -f flutter || true
  pkill -9 -f dart || true
fi

# Check if any errors occurred and exit with the appropriate status
if [ "$error_occurred" = true ]; then
  echo "One or more tests failed."
  exit 1
fi

echo "All tests completed successfully."
exit 0