FROM alpine:3.22.2

# set version label
LABEL maintainer="thechef3179"
ENV SLEEP_TIME=5

# Install necessary packages
RUN apk --no-cache add curl bash inotify-tools && \
    rm -rf /var/cache/apk/*

# Create a temporary directory to hold the script
COPY ./scripts/monitor.sh /usr/local/bin/monitor.sh

# Copy the entrypoint script and execute that
RUN chmod +x /usr/local/bin/monitor.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/monitor.sh"]
