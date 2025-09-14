#!/bin/bash

# Cycles through the background images available

BACKGROUNDS_DIR="$HOME/.config/omarchy/current/theme/backgrounds/"
CURRENT_BACKGROUND_LINK="$HOME/.config/omarchy/current/background"

mapfile -d '' -t BACKGROUNDS < <(find "$BACKGROUNDS_DIR" -type f -print0 | sort -z)
TOTAL=${#BACKGROUNDS[@]}

if [[ $TOTAL -eq 0 ]]; then
  notify-send "No background was found for theme" -t 2000
  pkill -x swaybg
  setsid uwsm app -- swaybg --color '#000000' >/dev/null 2>&1 &
  exit 0
fi

# Determine direction (default: next)
DIRECTION="next"
if [[ "$1" == "prev" ]]; then
  DIRECTION="prev"
fi

# Get current background from symlink
if [[ -L "$CURRENT_BACKGROUND_LINK" ]]; then
  CURRENT_BACKGROUND=$(readlink "$CURRENT_BACKGROUND_LINK")
else
  CURRENT_BACKGROUND=""
fi

# Find current background index
INDEX=-1
for i in "${!BACKGROUNDS[@]}"; do
  if [[ "${BACKGROUNDS[$i]}" == "$CURRENT_BACKGROUND" ]]; then
    INDEX=$i
    break
  fi
done

# Select new background
if [[ $INDEX -eq -1 ]]; then
  NEW_BACKGROUND="${BACKGROUNDS[0]}"
else
  if [[ "$DIRECTION" == "next" ]]; then
    NEW_INDEX=$(((INDEX + 1) % TOTAL))
  else
    NEW_INDEX=$(((INDEX - 1 + TOTAL) % TOTAL))
  fi
  NEW_BACKGROUND="${BACKGROUNDS[$NEW_INDEX]}"
fi

# Set new background symlink
ln -nsf "$NEW_BACKGROUND" "$CURRENT_BACKGROUND_LINK"

# Relaunch swaybg
pkill -x swaybg
setsid uwsm app -- swaybg -i "$CURRENT_BACKGROUND_LINK" -m fill >/dev/null 2>&1 &
