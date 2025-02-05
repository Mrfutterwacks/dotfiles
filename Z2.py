#!/usr/bin/env python3
import math
from datetime import datetime
from itertools import combinations
import time
from pathlib import Path
import os

# Original constants
VOID_HOUSES = ("Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", 
               "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces")

VOID_SYMBOLS = {
    'Sun': '${color #8A2BE2}${font Changeling Dingbats:size=9}J${font}',
    'Mercury': '${color #4169E1}${font Changeling Dingbats:size=9}T${font}',
    'Venus': '${color #32CD32}${font Changeling Dingbats:size=9}H${font}',
    'Mars': '${color #FFD700}${font Changeling Dingbats:size=9}P${font}',
    'Jupiter': '${color #FF6347}${font Changeling Dingbats:size=9}O${font}',
    'Saturn': '${color #FF69B4}${font Changeling Dingbats:size=9}K${font}',
    'Uranus': '${color #9370DB}${font Changeling Dingbats:size=9}I${font}',
    'Neptune': '${color #20B2AA}${font Changeling Dingbats:size=9}R${font}'
}

VOID_COLORS = {
    'Sun': '#FF5F1F', 'Mercury': '#E34234', 'Venus': '#FF2400',
    'Mars': '#701C1C', 'Jupiter': '#4A0404', 'Saturn': '#800020',
    'Uranus': '#2B0404', 'Neptune': '#1A0000'
}

# Image cycling system
IMAGE_FILES = [
    'Hermes.png', 'a.png', 'b.png', 'c.png', 'd.png', 'e.png', 
    'f.png', 'g.png', 'h.png', 'i.png', 'j.png', 'k.png', 
    'l.png', 'm.png', 'n.png', 'o.png', 'p.png', 'q.png', 
    'r.png', 's.png'
]
IMAGE_DIR = Path('/home/stephen/.config/conky/images')
INDEX_FILE = '/home/stephen/.cache/conky/image_index.txt'

def get_next_image():
    """Cycle through images with smooth transition."""
    os.makedirs(os.path.dirname(INDEX_FILE), exist_ok=True)
    
    try:
        with open(INDEX_FILE, 'r') as f:
            current_index = int(f.read().strip())
    except (FileNotFoundError, ValueError):
        current_index = -1
    
    # Calculate next index with pre-reset handling
    if current_index >= len(IMAGE_FILES) - 2:
        # Pre-emptively reset to avoid pause
        next_index = 0
    else:
        next_index = current_index + 1
    
    # Write new index
    with open(INDEX_FILE, 'w') as f:
        f.write(str(next_index))
    
    return IMAGE_DIR / IMAGE_FILES[next_index]

def calculate_day(year, month, day, hour):
    return 367 * year - 7 * (year + (month + 9) / 12) / 4 + 275 * month / 9 + day - 730530 + hour / 24

def get_planet(name, d):
    planetary_data = {
        "Sun": {'N': 0.0, 'i': 0.0, 'w': 282.9404 + 4.70935E-5 * d, 'a': 1.000000, 
                'e': 0.016709 - 1.151E-9 * d, 'M': 356.0470 + 0.9856002585 * d},
        "Mercury": {'N': 48.3313 + 3.24587E-5 * d, 'i': 7.0047 + 5.00E-8 * d, 
                   'w': 29.1241 + 1.01444E-5 * d, 'a': 0.387098, 
                   'e': 0.205635 + 5.59E-10 * d, 'M': 168.6562 + 4.0923344368 * d},
        "Venus": {'N': 76.6799 + 2.46590E-5 * d, 'i': 3.3946 + 2.75E-8 * d, 
                 'w': 54.8910 + 1.38374E-5 * d, 'a': 0.723330, 
                 'e': 0.006773 - 1.302E-9 * d, 'M': 48.0052 + 1.6021302244 * d},
        "Mars": {'N': 49.5574 + 2.11081E-5 * d, 'i': 1.8497 - 1.78E-8 * d, 
                'w': 286.5016 + 2.92961E-5 * d, 'a': 1.523688, 
                'e': 0.093405 + 2.516E-9 * d, 'M': 18.6021 + 0.5240207766 * d},
        "Jupiter": {'N': 100.4542 + 2.76854E-5 * d, 'i': 1.3030 - 1.557E-7 * d, 
                   'w': 273.8777 + 1.64505E-5 * d, 'a': 5.20256, 
                   'e': 0.048498 + 4.469E-9 * d, 'M': 19.8950 + 0.0830853001 * d},
        "Saturn": {'N': 113.6634 + 2.38980E-5 * d, 'i': 2.4886 - 1.081E-7 * d, 
                  'w': 339.3939 + 2.97661E-5 * d, 'a': 9.55475, 
                  'e': 0.055546 - 9.499E-9 * d, 'M': 316.9670 + 0.0334442282 * d},
        "Uranus": {'N': 74.0005 + 1.3978E-5 * d, 'i': 0.7733 + 1.9E-8 * d, 
                  'w': 96.6612 + 3.0565E-5 * d, 'a': 19.18171 - 1.55E-8 * d, 
                  'e': 0.047318 + 7.45E-9 * d, 'M': 142.5905 + 0.011725806 * d},
        "Neptune": {'N': 131.7806 + 3.0173E-5 * d, 'i': 1.7700 - 2.55E-7 * d, 
                   'w': 272.8461 - 6.027E-6 * d, 'a': 30.05826 + 3.313E-8 * d, 
                   'e': 0.008606 + 2.15E-9 * d, 'M': 260.2471 + 0.005995147 * d}
    }
    return planetary_data.get(name)

def get_void_sign(longitude):
    return VOID_HOUSES[int(longitude // 30)]

def calc_orbital_elements(planet_name, d):
    planet = get_planet(planet_name, d)
    
    N = math.radians(planet['N'])
    i = math.radians(planet['i'])
    w = math.radians(planet['w'])
    a = planet['a']
    e = planet['e']
    M = math.radians(planet['M'])
    
    E = M + e * math.sin(M) * (1.0 + e * math.cos(M))
    xv = a * (math.cos(E) - e)
    yv = a * (math.sqrt(1.0 - e * e) * math.sin(E))
    
    v = math.atan2(yv, xv)
    r = math.sqrt(xv**2 + yv**2)

    xh = r * (math.cos(N) * math.cos(v + w) - math.sin(N) * math.sin(v + w) * math.cos(i))
    yh = r * (math.sin(N) * math.cos(v + w) + math.cos(N) * math.sin(v + w) * math.cos(i))
    zh = r * (math.sin(v + w) * math.sin(i))

    lonecl = math.atan2(yh, xh)
    latecl = math.atan2(zh, math.sqrt(xh**2 + yh**2))

    return {
        'r': r,
        'v': math.degrees(v),
        'lonecl': math.degrees(lonecl) % 360,
        'latecl': math.degrees(latecl),
        'void_sign': get_void_sign(math.degrees(lonecl) % 360)
    }

def format_void_position(name, position):
    return "${color1 #7600BC}${color " + VOID_COLORS[name] + "}" + VOID_SYMBOLS[name] + " " + f"{position['lonecl']:.2f}° in {position['void_sign']}"

def calculate_void_resonances(positions):
    resonances = []
    for (name1, pos1), (name2, pos2) in combinations(positions.items(), 2):
        angle = abs(pos1['lonecl'] - pos2['lonecl']) % 360
        if angle < 10:
            resonances.append("VOID RESONANCE: " + name1 + " + " + name2)
    return resonances

def format_conky_output(positions, resonances):
    output = []
    
    # Add the current image with new cycling system
    image_path = get_next_image()
    output.append("${image " + str(image_path) + " -p 130,60 -s 80x80}")
    
    for name, pos in positions.items():
        line = format_void_position(name, pos)
        output.append(line)
    
    if resonances:
        output.append("")
        output.append("${color #FF5F1F}VOID ${color #FF2400}RESONANCES ${color #701C1C}DETECTED:")
        for resonance in resonances:
            output.append("${color #4A0404}" + resonance)
    
    return "\n".join(output)

def main():
    now = datetime.utcnow()
    d = calculate_day(now.year, now.month, now.day, now.hour)
    
    planet_names = ['Sun', 'Mercury', 'Venus', 'Mars', 'Jupiter', 'Saturn', 'Uranus', 'Neptune']
    positions = {name: calc_orbital_elements(name, d) for name in planet_names}
    resonances = calculate_void_resonances(positions)
    
    print(format_conky_output(positions, resonances))

if __name__ == "__main__":
    main()
