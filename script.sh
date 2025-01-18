#!/bin/bash
# Combined matrix rain with all effects
CHARS="ABCDEFGHIJKLMNOPQRSTUVWXYZMAGETHEASCENSION"
LENGTH=66
generate_column() {
    local pos="\${goto $1}"
    local color=$2    # Color variation
    local speed=$3    # Speed variation (skip lines)
    local density=$4  # Density variation

    for ((i=0; i<LENGTH; i=i+speed)); do
        if [ $((i % density)) -eq 0 ]; then
            RAND_CHAR=${CHARS:$((RANDOM % ${#CHARS})):1}

            if [ $((RANDOM % 8)) -eq 0 ]; then
                echo -n "$pos\${color white}$RAND_CHAR\${color $color}"
            else
                echo -n "$pos\${color $color}$RAND_CHAR"
            fi
        else
            echo -n "$pos\${color $color} "
        fi
        echo
    done
}
# Set initial color
echo "\${color green}"
# Generate columns with mixed effects:
# Position, Color,  Speed, Density
generate_column 0   green  1  1    # dense, normal speed
generate_column 15  cyan   2  2    # sparse, faster
generate_column 30  green  1  1    # dense, normal speed
generate_column 45  00ffff 2  2    # sparse, faster (bright cyan)
generate_column 60  green  1  1    # dense, normal speed
generate_column 75  cyan   2  2    # sparse, faster
generate_column 90  green  1  1    # dense, normal speed
generate_column 105 00ffff 2  2    # sparse, faster (bright cyan)
# Reset color
echo "\${color}"
