#!/bin/sh

# Move monitor.sh to the final location and make it executable
cp /tmp/scripts/monitor.sh /usr/local/bin/monitor.sh && \
chmod +x /usr/local/bin/monitor.sh

# Execute the CMD provided in the Dockerfile
exec "$@"
