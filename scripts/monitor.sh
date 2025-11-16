#!/bin/sh

# Trap signals for cleanup
trap exit SIGTERM SIGINT

while true; do
    # URL for the webhook
    WEBHOOK_URL="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

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
            curl -X POST -d "${NEW_MESSAGE}" "$WEBHOOK_URL"
            LAST_MESSAGE="$NEW_MESSAGE"  # Update the last message sent
        fi
    done

    sleep 5
done
