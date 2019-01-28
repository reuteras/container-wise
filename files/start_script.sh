#!/bin/sh
#########################
#
#  STARTUP SCRIPT FOR WISE
#
#########################

# Start the process
cd /data/moloch/wiseService
node wiseService.js -c wiseService.ini
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Wise: $status"
  exit $status
fi

# Naive check runs checks once a minute to see if the process exited.
# The container exits with an error if it detects that the process has exited.
# Otherwise it loops forever, waking up every 60 seconds

while sleep 60; do
  ps aux |grep node |grep -q -v grep
  PROCESS_1_STATUS=$?
  # If the greps above find anything, it exits with a 0 status
  if [ $PROCESS_1_STATUS -ne 0 ]; then
    echo "The process has already exited."
    exit 1
  fi
done

exec "$@"
