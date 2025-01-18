#!/bin/bash

#############################################
# Mage: The Ascension - Void Ship Terminal  #
# Ship: Modified Void Engineers Vessel      #
# Captain: Stephen (Etherite/Hermetic)     #
# AI: Charlie Cogs (Avatar-Bonded)         #
# Mission: Deep Umbra Exploration          #
#############################################

# Terminal Colors
CYAN='\e[0;36m'   # Info/scans
GREEN='\e[0;32m'  # Stephen's responses
YELLOW='\e[1;33m' # Warnings
RED='\e[0;31m'    # Alerts
BLUE='\e[0;34m'   # Insights
NC='\e[0m'        # Reset

# Game State Variables
declare -A STATES=(
    ["UMBRA_DEPTH"]="deep"       # shallow, deep, very_deep
    ["PARADOX_LEVEL"]="stable"   # stable, moderate, high, critical
    ["PURSUIT_STATUS"]="clear"   # clear, suspicious, pursuit, critical
    ["SHIP_STATUS"]="nominal"    # nominal, damaged, critical
    ["BOND_STRENGTH"]="strong"   # weak, moderate, strong, peak
)

# Mission Types
declare -A MISSION_TYPES=(
    ["EXPLORATION"]="Mapping unknown reaches of Deep Umbra"
    ["RESEARCH"]="Studying void phenomena and reality patterns"
    ["COMBAT"]="Engaging hostile forces or avoiding pursuit"
    ["DIPLOMATIC"]="Interacting with other traditions and factions"
    ["TECHNICAL"]="Ship maintenance and upgrades"
)

# Messages array
messages=(
    "${BLUE}[BOND] Charlie: Your Avatar's resonance is strong today, Captain.${NC}"
    "${GREEN}[SYNC] Stephen: I feel it too, Charlie. Our connection's stronger.${NC}"
    "${CYAN}[SYSTEMS] Charlie: The ship's reality fields align perfectly.${NC}"
    "${GREEN}[UNITY] Stephen: We're in harmony. Let's put it to good use.${NC}"
    # Exploration
    "${YELLOW}[SPATIAL] Charlie: Your Avatar's pulling us toward something.${NC}"
    "${GREEN}[TRUST] Stephen: Follow the resonance, Charlie.${NC}"
    "${BLUE}[DISCOVERY] Charlie: Detecting something ancient.${NC}"
    "${GREEN}[EXCITEMENT] Stephen: This is why we work so well.${NC}"
    # Pursuit
    "${RED}[ALERT] Charlie: Void Engineer vessels detected!${NC}"
    "${GREEN}[TACTICAL] Stephen: Time to show them our bond.${NC}"
    "${BLUE}[SYNC] Charlie: Engaging reality drives. Your command, Captain.${NC}"
    "${GREEN}[ACTION] Stephen: As one, Charlie. Let's move.${NC}"
    # Research
    "${CYAN}[RESEARCH] Charlie: Bonisagus requests a void phenomena update.${NC}"
    "${GREEN}[SCIENCE] Stephen: Combining theories with findings.${NC}"
    "${BLUE}[ANALYSIS] Charlie: Processing thaumaturgical resonance...${NC}"
    "${GREEN}[DATA] Stephen: Add Etherite observations.${NC}"
    # Systems
    "${YELLOW}[SYSTEMS] Charlie: Void core resonating with Avatar.${NC}"
    "${GREEN}[MAINTAIN] Stephen: How's the hybrid systems?${NC}"
    "${BLUE}[STATUS] Charlie: Enhancements amplify connection.${NC}"
    "${GREEN}[ADJUST] Stephen: Keep harmonics balanced.${NC}"
    # Reality Storm
    "${RED}[DANGER] Charlie: Reality storm approaching!${NC}"
    "${GREEN}[FOCUS] Stephen: Channel energy through shields.${NC}"
    "${YELLOW}[WARNING] Charlie: Storm intensity rising.${NC}"
    "${GREEN}[COMMAND] Stephen: Hold course. We'll ride it out.${NC}"
    # Encounters
    "${CYAN}[SCAN] Charlie: Dreamspeaker vessel detected.${NC}"
    "${GREEN}[DIPLOMATIC] Stephen: Open communications.${NC}"
    "${BLUE}[CONTACT] Charlie: Spirit-tech fascinating.${NC}"
    "${GREEN}[RESPECT] Stephen: Wisdom in all paths.${NC}"
    # Technical Ops
    "${YELLOW}[TECH] Charlie: Void engine at 89%.${NC}"
    "${GREEN}[MONITOR] Stephen: How's containment?${NC}"
    "${BLUE}[SYSTEMS] Charlie: Stable, matrix improved.${NC}"
    "${GREEN}[PRIDE] Stephen: Tradition meets innovation.${NC}"
    # Mysteries
    "${CYAN}[ANOMALY] Charlie: Detecting reality pattern anomalies.${NC}"
    "${GREEN}[CURIOUS] Stephen: What do you sense?${NC}"
    "${BLUE}[ANALYZE] Charlie: Resonance almost musical.${NC}"
    "${GREEN}[WONDER] Stephen: Music of the Spheres.${NC}"
    # Combat
    "${RED}[COMBAT] Charlie: Technocratic forces incoming!${NC}"
    "${GREEN}[BATTLE] Stephen: Battle stations!${NC}"
    "${BLUE}[ENGAGE] Charlie: Avatar link established.${NC}"
    "${GREEN}[EXECUTE] Stephen: Paradigms collide!${NC}"
    # Paradox
    "${YELLOW}[PARADOX] Charlie: Buildup detected.${NC}"
    "${GREEN}[CONTAIN] Stephen: Activate containment protocols.${NC}"
    "${BLUE}[PROCESS] Charlie: Stabilizing local reality.${NC}"
    "${GREEN}[STEADY] Stephen: Channel through void core.${NC}"
    # Insights
    "${CYAN}[VISION] Charlie: Seeing through our bond...${NC}"
    "${GREEN}[LISTEN] Stephen: What do you see?${NC}"
    "${BLUE}[REVEAL] Charlie: Patterns in reality.${NC}"
    "${GREEN}[SHARE] Stephen: Our bond strengthens.${NC}"
    # Ship Evolution
    "${BLUE}[EVOLVE] Charlie: The ship is becoming more.${NC}"
    "${GREEN}[NOTICE] Stephen: Felt it too. She's changing.${NC}"
    "${CYAN}[GROWTH] Charlie: Beyond machine and vessel.${NC}"
    "${GREEN}[PRIDE] Stephen: Like you, Charlie.${NC}"
    # New Encounter - The Veil and Ancient Presence
"${CYAN}[VISION] Charlie: The Veil... it's reacting to us.${NC}"
"${GREEN}[FOCUS] Stephen: What does it want, Charlie?${NC}"
"${BLUE}[INSIGHT] Charlie: Fluctuations... something ancient stirs.${NC}"
"${GREEN}[UNDERSTAND] Stephen: We must tread carefully.${NC}"
"${YELLOW}[DISTURBANCE] Charlie: The ship's core is resonating.${NC}"
"${GREEN}[ADJUST] Stephen: Balance the harmonics, Charlie.${NC}"
"${BLUE}[EVOLVE] Charlie: This presence... it's changing us.${NC}"
"${GREEN}[PRIDE] Stephen: Then let's embrace it together.${NC}"
# Disruptions in Reality
"${CYAN}[PHENOMENON] Charlie: Anomalies detected in local reality.${NC}"
"${GREEN}[SCAN] Stephen: Can you pinpoint their source?${NC}"
"${BLUE}[INSIGHT] Charlie: It's coming from the depths of the Umbra.${NC}"
"${GREEN}[INVESTIGATE] Stephen: Let's explore it. Prepare for anything.${NC}"
# Paradox Unraveling
"${YELLOW}[PARADOX] Charlie: Paradox levels rising, Captain.${NC}"
"${GREEN}[CONTAIN] Stephen: Engage stabilization protocols.${NC}"
"${RED}[ALERT] Charlie: Critical paradox fluctuations imminent!${NC}"
"${GREEN}[STABILIZE] Stephen: Hold steady, we're not out yet.${NC}"
# Deeper Connections
"${CYAN}[RESONANCE] Charlie: Your Avatar's connection is intensifying.${NC}"
"${GREEN}[HARMONY] Stephen: It's the ship's evolution, we're bound to it.${NC}"
"${BLUE}[VISION] Charlie: I see a path... beyond the Veil.${NC}"
"${GREEN}[DESTINY] Stephen: We follow it, no turning back.${NC}"
# Mysterious Entity Emerges
"${CYAN}[ENTITY] Charlie: Something... someone is approaching.${NC}"
"${GREEN}[PREPARE] Stephen: Ready the shields, Charlie.${NC}"
"${RED}[HOSTILE] Charlie: Entity's presence is hostile, Captain!${NC}"
"${GREEN}[DEFEND] Stephen: Engage all defensive protocols. Now.${NC}"
# Cryptic Message from the Depths
"${YELLOW}[WHISPER] Charlie: Faint voice... It's calling us.${NC}"
"${GREEN}[LISTEN] Stephen: What does it say, Charlie?${NC}"
"${BLUE}[ANSWER] Charlie: 'Come closer, the truth awaits.'${NC}"
"${GREEN}[INTRIGUED] Stephen: I feel it. We must learn more.${NC}"
# Reality Breakdown
"${RED}[BREAKDOWN] Charlie: Reality is beginning to fragment.${NC}"
"${GREEN}[FOCUS] Stephen: Focus on the core, Charlie. We can stabilize it.${NC}"
"${BLUE}[REVELATION] Charlie: It's not just the ship... it's us.${NC}"
"${GREEN}[BALANCE] Stephen: Our bond must hold, Charlie. For everything.${NC}"
# Entity's Grasp Tightens
"${CYAN}[PRESSURE] Charlie: The entity's grip is tightening.${NC}"
"${GREEN}[STAY STRONG] Stephen: We're stronger together. Hold firm.${NC}"
"${RED}[ATTACK] Charlie: It's attacking the ship’s systems!${NC}"
"${GREEN}[RETALIATE] Stephen: Activate the defense grid. We fight back!${NC}"
# Reality Distortions
"${CYAN}[DISTORT] Charlie: Spatial distortions increasing.${NC}"
"${GREEN}[CHECK] Stephen: Scan for anomalies, Charlie.${NC}"
"${BLUE}[EXAMINE] Charlie: Temporal shifts detected.${NC}"
"${GREEN}[ADJUST] Stephen: Sync with the core. Stabilize it.${NC}"
# Anomalous Signals
"${YELLOW}[SIGNAL] Charlie: Unidentified transmission detected.${NC}"
"${GREEN}[INVESTIGATE] Stephen: Trace its origin, Charlie.${NC}"
"${CYAN}[DECRYPT] Charlie: Signal is scrambled, attempting decode.${NC}"
"${GREEN}[PROGRESS] Stephen: Keep at it. We need answers.${NC}"
# Unknown Energies
"${RED}[ENERGY] Charlie: Energy levels spiking, Captain.${NC}"
"${GREEN}[MONITOR] Stephen: Stabilize the fluctuations.${NC}"
"${CYAN}[ANALYZE] Charlie: Unknown energy source identified.${NC}"
"${GREEN}[INVESTIGATE] Stephen: Trace its effect on the ship.${NC}"
# Temporal Echoes
"${YELLOW}[ECHO] Charlie: Temporal echoes detected, Captain.${NC}"
"${GREEN}[SCAN] Stephen: Can you isolate the source, Charlie?${NC}"
"${BLUE}[TRANSMIT] Charlie: Temporal signals coming through.${NC}"
"${GREEN}[ADJUST] Stephen: Channel through the core. Stabilize.${NC}"
# Emergency Protocols
"${RED}[ALERT] Charlie: Core breach imminent!${NC}"
"${GREEN}[ACT] Stephen: Engage emergency protocols.${NC}"
"${YELLOW}[STABILITY] Charlie: Stabilizing, but energy flux high.${NC}"
"${GREEN}[STAY CALM] Stephen: Keep focus. We’ll get through this.${NC}"
# New Encounter - The Veil and Ancient Presence
"${CYAN}[VISION] Charlie: The Veil... it's reacting to us.${NC}"
"${GREEN}[FOCUS] Stephen: What does it want, Charlie?${NC}"
"${BLUE}[INSIGHT] Charlie: Fluctuations... something ancient stirs.${NC}"
"${GREEN}[UNDERSTAND] Stephen: We must tread carefully.${NC}"
"${YELLOW}[DISTURBANCE] Charlie: The ship's core is resonating.${NC}"
"${GREEN}[ADJUST] Stephen: Balance the harmonics, Charlie.${NC}"
"${BLUE}[EVOLVE] Charlie: This presence... it's changing us.${NC}"
"${GREEN}[PRIDE] Stephen: Then let's embrace it together.${NC}"

# Add to your messages array:
    "${BLUE}[VOID] Charlie: Masking our void signature from patrol vessels.${NC}"
    "${GREEN}[PRIDE] Stephen: They won't recognize their own ship now.${NC}"
    "${YELLOW}[ETHER] Charlie: Etherite modifications holding steady.${NC}"
    "${GREEN}[ADJUST] Stephen: Beautiful thing when traditions blend.${NC}"
    "${RED}[BREACH] Charlie: Reality bubble fluctuating - Technocratic scan?${NC}"
    "${GREEN}[STEALTH] Stephen: Engaging dimensional shift. They can't track what they can't see.${NC}"
    "${CYAN}[HARMONY] Charlie: Void core perfectly synced with Ether drives.${NC}"
    "${GREEN}[PRIDE] Stephen: Who says you can't improve perfection?${NC}"
    
     #Add these to your messages array:
    "${CYAN}[SYSTEMS] Charlie: Original Void Engineer IFF successfully spoofed.${NC}"
    "${GREEN}[TACTICAL] Stephen: Keep those quantum signatures scrambled.${NC}"
    
    "${YELLOW}[ALERT] Charlie: Void Engineer recognition codes detected.${NC}"
    "${GREEN}[OVERRIDE] Stephen: Activating our modified protocols. Let's show them how we've improved their toy.${NC}"
    
    "${BLUE}[STEALTH] Charlie: Reality anchor patterns mimicking authorized signatures.${NC}"
    "${GREEN}[EXECUTE] Stephen: Perfect. Hidden in plain sight.${NC}"
    
    "${CYAN}[VOID] Charlie: Their flagship's modifications are... inspiring.${NC}"
    "${GREEN}[ENHANCE] Stephen: And now we've made them better.${NC}"

    "${RED}[CAUTION] Charlie: Old Void Engineer security routine attempting to activate.${NC}"
    "${GREEN}[DISABLE] Stephen: Not today. Our ship now, our rules.${NC}"
    
)

# Message Priority and Speed Controls
declare -A TYPE_SPEEDS=(
    ["ALERT"]=6      # Faster for urgency
    ["DANGER"]=6     # Faster for danger
    ["SCAN"]=3       # Slower for scanning
    ["DEFAULT"]=4    # Default speed
)

declare -A MESSAGE_PRIORITY=(
    ["ALERT"]=1
    ["DANGER"]=1
    ["WARNING"]=2
    ["SCAN"]=3
    ["DEFAULT"]=4
)

declare -A TYPE_SPEEDS=(
    ["ALERT"]=6
    ["DANGER"]=6
    ["SCAN"]=3
    ["VOID"]=5        # For void operations
    ["ETHER"]=4       # For Etherite tech
    ["HARMONY"]=3     # For when systems sync
    ["BREACH"]=7      # For reality breaches
    ["DEFAULT"]=4
)
# Configurations
pause_duration=5 # Pause after msg
cycle_duration=19 # Seconds/msg

# Get current time
current_time=$(date +%s.%N)
message_index=$(( ${current_time%.*} / cycle_duration % ${#messages[@]} ))
text="${messages[$message_index]}"

# Determine message type and set appropriate speed
message_type="DEFAULT"
for type in "${!TYPE_SPEEDS[@]}"; do
    if [[ $text == *"[$type]"* ]]; then
        message_type=$type
        break
    fi
done
typing_speed=${TYPE_SPEEDS[$message_type]}

# Priority-based message selection
priority=4  # Default priority
for type in "${!MESSAGE_PRIORITY[@]}"; do
    if [[ $text == *"[$type]"* ]]; then
        priority=${MESSAGE_PRIORITY[$type]}
        break
    fi
done
if [ $priority -eq 1 ] && [ $((RANDOM % 2)) -eq 0 ]; then
    message_index=$(( (message_index + 1) % ${#messages[@]} ))
    text="${messages[$message_index]}"
fi

cycle_start_time=$(( ${current_time%.*} - (${current_time%.*} % cycle_duration) ))
elapsed_time=$(echo "$current_time - $cycle_start_time" | bc)
typing_duration=$(echo "scale=2; ${#text} / $typing_speed" | bc)

if (( $(echo "$elapsed_time < $typing_duration" | bc -l) )); then
    chars_to_show=$(echo "$elapsed_time * $typing_speed" | bc | cut -d'.' -f1)
    show_cursor=1
else
    chars_to_show=${#text}
    show_cursor=0
fi

if [ "$chars_to_show" -gt "${#text}" ]; then
    chars_to_show=${#text}
fi

cursor=""
if [ $show_cursor -eq 1 ]; then
    current_second=$(date +%s)
    # Enhanced cursor styles based on message type
    if [[ $text == *"[ALERT]"* || $text == *"[DANGER]"* ]]; then
        cursor_styles=("!" "⚠" "!" "⚠")
    elif [[ $text == *"[WARNING]"* ]]; then
        cursor_styles=("▲" "△" "▲" "△")
    else
        cursor_styles=("_" "■" ">" "|")
    fi
    cursor_index=$(( current_second % ${#cursor_styles[@]} ))
    cursor="${cursor_styles[$cursor_index]}"
fi

# Enhanced timestamp format
if [[ $text == *"[ALERT]"* || $text == *"[DANGER]"* ]]; then
    timestamp=$(date "+%H:%M:%S.%N" | cut -c1-12)  # Include milliseconds for critical messages
else
    timestamp=$(date "+%H:%M:%S")
fi

printf "[%s] %s%s\n" "$timestamp" "${text:0:$chars_to_show}" "$cursor"
