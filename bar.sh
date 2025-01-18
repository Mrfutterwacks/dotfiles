#!/bin/bash

# Get system metrics
get_cpu_usage() {
    mpstat 1 1 | awk '/Average:/ {print 100-$NF}' || echo 0
}

# Bar generation matched to wallpaper dimensions
generate_bar() {
    local usage=$1
    local color=$2
    local length=25  # Shortened to match wallpaper bars
    local filled=$((usage * length / 100))
    
    echo -n "\${color $color}"
    for ((i=0; i<length; i++)); do
        if [ $i -lt $filled ]; then
            echo -n "█"
        else
            echo -n " "
        fi
    done
    echo
    echo  # Single line spacing to match wallpaper
}

# Get CPU usage
cpu=$(printf "%.0f" $(get_cpu_usage))

# Generate bars with exact spacing from wallpaper
generate_bar $cpu "00ffff"  # First cyan bar
generate_bar $cpu "ff00ff"  # Middle magenta bar
generate_bar $cpu "00ffff"  # Last cyan bar
