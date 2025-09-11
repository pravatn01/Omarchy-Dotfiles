#!/bin/bash
# Usage: chrome-profile.sh "Profile Name"

PROFILE="$1"
CHROME="google-chrome-beta"

# Check if Chrome Beta is running
if pgrep -x chrome >/dev/null || pgrep -x "chrome-beta" >/dev/null; then
    "$CHROME" --profile-directory="$PROFILE" --new-window &
else
    "$CHROME" --profile-directory="$PROFILE" &
fi
