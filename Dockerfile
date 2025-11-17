FROM alpine:3.22.2

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thechef3179"

# Install necessary packages
RUN apk --no-cache add curl bash inotify-tools && \
    rm -rf /var/cache/apk/*

# Create a temporary directory to hold the script
RUN mkdir -p /tmp/scripts
COPY ./scripts/entrypoint.sh /tmp/scripts/entrypoint.sh

# Copy the entrypoint script and execute that
RUN cp /tmp/scripts/entrypoint.sh /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# # Command to run the monitoring script
# CMD ["/usr/local/bin/monitor.sh"]

