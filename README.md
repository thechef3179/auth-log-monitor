## Docker Image: `auth-log-monitor`

This Docker image monitors the `auth.log` file (typically found on Ubuntu and Debian systems) for SSH login attempts (successful and failed). It parses the log entries, extracts relevant information (timestamp, IP address, username, status), and sends a webhook request to a specified URL with this information. This allows for real-time monitoring and alerting based on SSH activity.

**Key Features:**

*   **Log Monitoring:** Continuously tails the `auth.log` file.
*   **SSH Event Detection:**  Specifically targets and parses SSH login attempts.
*   **Webhook Integration:** Sends a JSON payload to a configurable webhook URL upon detection of an SSH event.
*   **Lightweight:** Based on a minimal base image for efficient resource utilization.
*   **Configurable:** The webhook URL is configured through an environment variable.
*   **Suitable for Ubuntu/Debian:** Designed to work with systems using standard syslog/auth.log format.



**How it Works:**

The container runs a script that continuously reads the `auth.log` file.  The script uses regular expressions to identify SSH login attempts (both successful and failed). Upon detecting an event, it creates a JSON payload containing:

*   `timestamp`: Timestamp of the login attempt.
*   `ip_address`: IP address of the connecting host.
*   `username`: Username used for the login attempt.
*   `status`:  "success" or "failed".
*   `message`: The original log message.

This JSON payload is then sent as a POST request to the configured webhook URL.



**Environment Variables:**

*   **`WEBHOOK_URL`**: (Required) The URL to which the webhook requests should be sent.  This is the only configuration needed.

**Image Tag:** `thechef3179/auth-log-monitor:latest` 

**Example Usage:**

**1. Docker Run:**

```bash
docker run -d \
  --name authlog-monitor \
  -v /var/log/auth.log:/var/log/auth.log:ro \
  -e WEBHOOK_URL="https://your-webhook-endpoint.com/ssh-events" \
  thechef3179/auth-log-monitor:latest
```

**Explanation:**

*   `-d`: Runs the container in detached mode (background).
*   `--name authlog-monitor`:  Assigns a name to the container.
*   `-v /var/log/auth.log:/var/log/auth.log:ro`:  Mounts the host's `auth.log` file into the container. **Crucially, adjust the host path if your `auth.log` file is in a different location.**
*   `-e WEBHOOK_URL="https://your-webhook-endpoint.com/ssh-events"`: Sets the `WEBHOOK_URL` environment variable to your webhook endpoint.  Replace this with your actual URL.
*   `thechef3179/auth-log-monitor:latest`: Specifies the Docker image to use.



**2. Docker Compose (Recommended):**

```yaml
services:
  authlog-monitor:
    image: thechef3179/auth-log-monitor:latest
    container_name: authlog-monitor
    volumes:
      - /var/log/auth.log:/var/log/auth.log:ro
    environment:
      - WEBHOOK_URL=https://your-webhook-endpoint.com/ssh-events
    restart: unless-stopped
```

To start the service with Docker Compose, run:

```bash
docker compose up -d
```

**Important Considerations:**

*   **Log File Path:**  Ensure the volume mount path (`/var/log/auth.log`) correctly reflects the location of your `auth.log` file on the host system.  This is the most common point of failure. (for systems that use journal system like Arch Linux, this will container will not work at the moment).
*   **Permissions:** The container process needs read access to the mounted `auth.log` file. Ensure the file permissions on the host allow this.
*   **Webhook Endpoint:**  Verify that your webhook endpoint is reachable from the host machine where the container is running.  Firewall rules or network configurations might need to be adjusted.
*   **Log Rotation:** Be aware of your system's `logrotate` configuration.  If the `auth.log` file is rotated frequently, the container might miss events if it doesn't handle the file rotation gracefully.  (The current implementation should handle log rotation reasonably well, but testing is recommended.)
*   **Security:**  Treat the `WEBHOOK_URL` as a sensitive value and avoid exposing it in public repositories.

**Future Enhancements:**

*   Support for different log formats.
*   Configuration options for the webhook request (e.g., headers, authentication).
*   Error handling and logging within the container.
*   More robust log rotation handling.
*   Configurable regular expressions for more flexible event detection.
