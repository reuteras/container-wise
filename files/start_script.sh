#!/bin/sh
#
#  STARTUP SCRIPT FOR WISE
#

# Start the process
cd /opt/arkime/wiseService || exit
node wiseService.js -c /opt/arkime/wiseService/wiseService.ini --webconfig
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Wise: $status"
  exit $status
fi
exec "$@"
