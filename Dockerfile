FROM alpine:latest

# Install necessary packages
RUN apk --no-cache add curl bash inotify-tools

# Create a temporary directory to hold the script
RUN mkdir -p /tmp/scripts

# Copy the monitor.sh script from the mounted volume
# COPY ./monitor.sh /tmp/scripts/monitor.sh
COPY ./scripts/* /tmp/scripts/


# Create a directory to hold the entrypoint script
RUN cp /tmp/scripts/entrypoint.sh /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# # Move it to the final location and make it executable
# RUN cp /tmp/scripts/monitor.sh /usr/local/bin/monitor.sh && \
#     chmod +x /usr/local/bin/monitor.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Command to run the monitoring script
CMD ["/usr/local/bin/monitor.sh"]

