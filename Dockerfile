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
COPY ./scripts/monitor.sh /usr/local/bin/monitor.sh

# Copy the entrypoint script and execute that
RUN chmod +x /usr/local/bin/monitor.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/monitor.sh"]
