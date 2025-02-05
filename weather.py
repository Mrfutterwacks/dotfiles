#!/usr/bin/env python3
import requests
import json
import logging
import sys
from datetime import datetime

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(message)s')

# Detailed mapping of NWS conditions to weather codes
WEATHER_CODES = {
    "day": {
        "skc": "a",        # Clear sky
        "few": "b",        # Few clouds
        "sct": "c",        # Scattered clouds
        "bkn": "d",        # Broken clouds
        "ovc": "e",        # Overcast
        "rain": "g",       # Rain
        "rain_showers": "j", # Rain showers
        "tsra": "n",       # Thunderstorm
        "wind": "6",       # Windy
        "snow": "o",       # Snow
        "fog": "0",        # Fog
        "default": "a"     # Default to clear sky
    },
    "night": {
        "skc": "A",        # Clear sky
        "few": "B",        # Few clouds
        "sct": "C",        # Scattered clouds
        "bkn": "D",        # Broken clouds
        "ovc": "e",        # Overcast
        "rain": "g",       # Rain
        "rain_showers": "j", # Rain showers
        "tsra": "n",       # Thunderstorm
        "wind": "6",       # Windy
        "snow": "o",       # Snow
        "fog": "0",        # Fog
        "default": "A"     # Default to clear night
    }
}

# Expanded condition mappings for more accurate weather representation
CONDITION_MAPPINGS = {
    # Clear conditions
    "clear": "skc",
    "sunny": "skc",
    "fair": "few",
    
    # Cloudy conditions
    "partly cloudy": "few",
    "mostly sunny": "few",
    "mostly clear": "few",
    "scattered clouds": "sct",
    "partly sunny": "sct",
    "broken": "bkn",
    "mostly cloudy": "bkn",
    "considerable cloudiness": "bkn",
    "overcast": "ovc",
    "cloudy": "ovc",
    
    # Rain conditions
    "light rain": "rain",
    "rain": "rain",
    "heavy rain": "rain",
    "showers": "rain_showers",
    "chance showers": "rain_showers",
    "scattered showers": "rain_showers",
    "drizzle": "rain_showers",
    
    # Thunderstorm conditions
    "thunder": "tsra",
    "thunderstorm": "tsra",
    "thunderstorms": "tsra",
    "chance thunderstorms": "tsra",
    "scattered thunderstorms": "tsra",
    
    # Snow conditions
    "snow": "snow",
    "light snow": "snow",
    "heavy snow": "snow",
    "flurries": "snow",
    "chance snow": "snow",
    
    # Other conditions
    "fog": "fog",
    "haze": "fog",
    "mist": "fog",
    "windy": "wind",
    "breezy": "wind"
}

def get_condition_code(condition_text, is_day):
    """
    Map the NWS condition text to the appropriate weather code
    """
    condition_text = condition_text.lower()
    
    # Check each known condition pattern
    for pattern, code in CONDITION_MAPPINGS.items():
        if pattern in condition_text:
            weather_codes = WEATHER_CODES['day'] if is_day else WEATHER_CODES['night']
            return weather_codes[code]
    
    # If no match found, log it and return default
    logging.warning(f"Unknown condition: {condition_text}")
    return WEATHER_CODES['day' if is_day else 'night']['default']

def get_weather():
    try:
        # Set up headers with a proper user agent
        headers = {
            'User-Agent': 'Conky Weather Display (stephen@example.com)',
            'Accept': 'application/json'
        }
        
        # Get grid coordinates for Metamora, IL
        point_url = "https://api.weather.gov/points/40.7844,-89.4309"
        
        # Get the grid point data
        response = requests.get(point_url, headers=headers, timeout=10)
        response.raise_for_status()  # Raise an exception for bad status codes
        point_data = response.json()
        
        # Get the forecast URL
        forecast_url = point_data['properties']['forecastHourly']
        response = requests.get(forecast_url, headers=headers, timeout=10)
        response.raise_for_status()
        forecast_data = response.json()
        
        # Get current period data
        current_period = forecast_data['properties']['periods'][0]
        
        # Determine if it's day or night
        is_day = current_period.get('isDaytime', True)
        
        # Get the condition text
        condition = current_period['shortForecast']
        
        # Get the appropriate weather character
        weather_char = get_condition_code(condition, is_day)
        
        # Print the weather character for Conky
        print(weather_char)
            
        # Debug output if requested
        if '--debug' in sys.argv:
            print(f"\nDebug Info:")
            print(f"Time of Day: {'Day' if is_day else 'Night'}")
            print(f"Current Conditions: {condition}")
            print(f"Temperature: {current_period['temperature']}°F")
            print(f"Weather Character: {weather_char}")
            
    except requests.exceptions.RequestException as e:
        logging.error(f"Network error: {str(e)}")
        print(WEATHER_CODES['day' if datetime.now().hour >= 6 and datetime.now().hour < 18 else 'night']['default'])
    except Exception as e:
        logging.error(f"Error: {str(e)}")
        print(WEATHER_CODES['day' if datetime.now().hour >= 6 and datetime.now().hour < 18 else 'night']['default'])

if __name__ == "__main__":
    get_weather()
