#!/bin/bash

# Workspace navigation with limits (1–5 only)

direction=$1
current=$(hyprctl activeworkspace -j | jq -r '.id')

if [[ "$direction" == "next" ]]; then
    if [[ $current -lt 5 ]]; then
        next=$((current + 1))
        hyprctl dispatch workspace $next
    fi
elif [[ "$direction" == "prev" ]]; then
    if [[ $current -gt 1 ]]; then
        next=$((current - 1))
        hyprctl dispatch workspace $next
    fi
fi
