#!/bin/bash
# Start Glava with --desktop
glava --desktop &

# Wait for Glava to start (adjust the sleep time if necessary)
sleep 2

# Get the window ID of Glava
window_id=$(xdotool search --name Glava)

# Calculate the position for top-center
screen_width=1920
window_width=800
x_position=$(( (screen_width / 2) - (window_width / 2) ))

# Move the window to the top-center
xdotool windowmove $window_id $x_position 0