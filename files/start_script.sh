#!/bin/sh
#
#  STARTUP SCRIPT FOR WISE
#

# Start the process
cd /data/moloch/wiseService || exit
node wiseService.js -c wiseService.ini
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Wise: $status"
  exit $status
fi
exec "$@"
