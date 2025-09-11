#!/bin/bash
# Usage: set-brightness.sh <value 0-100>

BRIGHTNESS="${1:-50}"  # default to 50 if no argument
# Clamp value between 0 and 100
if (( BRIGHTNESS < 0 )); then BRIGHTNESS=0; fi
if (( BRIGHTNESS > 100 )); then BRIGHTNESS=100; fi

# Set brightness for display 1
ddcutil --display 1 setvcp 10 "$BRIGHTNESS"
