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

# Trap SIGTERM signal
trap cleanup SIGTERM SIGINT

# if [ $LOG_TYPE == "file" ]; then
while true; do
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
    sleep 5
done
# elif [ "$LOG_TYPE" == "journal" ]; then
#     # Capture initial logs
#     INITIAL_TIME=$(date +%s)
#     journalctl -u sshd --since "0" -o short | grep -E "Accepted .*|Failed .*"
#
#     while true; do
#         # Variable to store the last notification message
#         LAST_MESSAGE=""
#         CURRENT_TIME=$(date +%s)
#         journalctl -u sshd --since "$CURRENT_TIME" -o short | grep -E "Accepted .*|Failed .*" | while read line; do
#             if [ "$line" != "$LAST_MESSAGE" ]; then
#                 send_notification "$line"
#                 LAST_MESSAGE="$line"
#             fi
#         done
#         sleep 5
#     done
# fi
