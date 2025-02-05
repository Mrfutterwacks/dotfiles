#!/usr/bin/env python3

from PIL import Image
from datetime import datetime

# Load the images
ring_a = Image.open("/home/stephen/.config/conky/images/rings/A.png")
ring_b = Image.open("/home/stephen/.config/conky/images/rings/b.png")

# Get rotation angles
time = datetime.now()
angle_a = time.second * 6  # Clockwise
angle_b = -time.second * 6  # Counter-clockwise

# Rotate and combine
rotated_a = ring_a.rotate(angle_a)
rotated_b = ring_b.rotate(angle_b)

# Stack them with A on top of B
result = Image.new('RGBA', ring_a.size)
result.paste(rotated_b, (0,0))
result.paste(rotated_a, (0,0))

# Save
result.save("/tmp/rings.png")
