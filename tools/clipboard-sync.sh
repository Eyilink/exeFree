#!/bin/bash
# clipboard-sync.sh
CLIPBOARD_FILE="/workspace/.clipboard"
LAST_MODIFIED=""

while true; do
    if [ -f "$CLIPBOARD_FILE" ]; then
        CURRENT_MODIFIED=$(stat -c %Y "$CLIPBOARD_FILE" 2>/dev/null)
        
        if [ "$CURRENT_MODIFIED" != "$LAST_MODIFIED" ]; then
            # Update container clipboard
            cat "$CLIPBOARD_FILE" | xclip -selection clipboard
            # echo "Clipboard synced from host: $(date)"
            LAST_MODIFIED="$CURRENT_MODIFIED"
        fi
    fi
    sleep 1
done