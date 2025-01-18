#!/bin/bash
# Configuration for Void Harmonics Script #1
STATEFILE="/tmp/void_harmonics_1"
TIMESTAMP=$(date +%s)
CYCLE=$((TIMESTAMP % 7))
MATRIX_CHARS="╔╗╚╝║═╠╣╦╩╬"

generate_ascii_border() {
    local char1=${MATRIX_CHARS:$((RANDOM % 11)):1}
    local char2=${MATRIX_CHARS:$((RANDOM % 11)):1}
    echo "$char1$char2$char2$char2$char2$char2$char2$char2$char2$char1"
}

glitch_text() {
    local text=$1
    if [ $((RANDOM % 10)) -eq 0 ]; then
        echo "${text//[aeiou]/0}"
    else
        echo "$text"
    fi
}

if [ ! -f "$STATEFILE" ] || [ $((TIMESTAMP % 30)) -eq 0 ]; then
    {
        echo "[VOID] $(glitch_text 'Void Harmonics Terminal v1.0')"
        echo "$(generate_ascii_border)"
        echo "[SCAN] Current Resonance: $(hostname)"
        echo "[SCAN] Void Conduits: $(uname -m)"
        echo "[DATA] Harmonic Collection: $(uname -r)"
        echo "$(generate_ascii_border)"
        
        echo "[PROCESS] $(glitch_text 'Analyzing Void Matrix...')"
        echo "[DATA] Quantum Resonance Status:"
        free -m | grep Mem | awk '{printf "  > Void Memory: %.1f%%\n", $3/$2*100}'
        
        if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
            temp=$(( $(cat /sys/class/thermal/thermal_zone0/temp) / 1000))
            echo "[VOID] Core Resonance: ${temp}°C"
        fi
        
        echo "[DATA] Void Process Matrix:"
        ps aux | grep -E 'systemd|init|cron' | head -n 3 | \
            awk '{printf "  > Harmonic ID: %s | Energy: %.1f%% | %s\n", $2, $3, $11}'
        
        echo "$(generate_ascii_border)"
        
        STATUS_MESSAGES=(
            "Harmonizing void protocols..."
            "Synchronizing resonance arrays..."
            "Optimizing void matrices..."
            "Calibrating harmonic fields..."
            "Scanning void signatures..."
            "Aligning quantum harmonics..."
        )
        
        echo "$(generate_ascii_border)"
        for i in {1..3}; do
            echo "[VOID] $(glitch_text "${STATUS_MESSAGES[$((RANDOM % ${#STATUS_MESSAGES[@]}))]}")"
            sleep 0.1
        done
        
    } > "$STATEFILE"
fi

case $CYCLE in
    0|1)
        head -n $((RANDOM % 7 + 7)) "$STATEFILE"
        ;;
    2|3)
        sed -n "$((RANDOM % 10 + 10)),$((RANDOM % 10 + 20))p" "$STATEFILE"
        ;;
    4|5|6)
        tail -n $((RANDOM % 7 + 7)) "$STATEFILE"
        ;;
esac
