#!/bin/sh

# Function to handle termination signals
cleanup() {
    # echo "Received termination signal. Exiting..."
    exit 0
}

# Function to send a notification
send_notification() {
    local log_entry="$1"
    curl -X POST -d "${log_entry}" "$WEBHOOK_URL"
}

# if [ $LOG_TYPE == "file" ]; then
while true; do
    # Trap SIGTERM signal
    trap cleanup SIGTERM SIGINT

    # Variable to store the last notification message
    LAST_MESSAGE=""

    # Monitor auth.log using inotifywait
    inotifywait -m /var/log/auth.log -e modify |
    while read path action file; do
        # Get the latest log entry that matches the criteria
        NEW_MESSAGE=$(grep -E "Accepted .*|Failed .*" "$path$file" | tail -n 1)

        # Check if NEW_MESSAGE exists and is different from LAST_MESSAGE
        if [ -n "$NEW_MESSAGE" ] && [ "$NEW_MESSAGE" != "$LAST_MESSAGE" ]; then
            # echo "$NEW_MESSAGE"
            send_notification "$NEW_MESSAGE"
            LAST_MESSAGE="$NEW_MESSAGE"  # Update the last message sent
        fi
    done
    sleep $SLEEP_TIME
done
