#!/usr/bin/env python3
import requests
import json
import sys

# Keep your original wind direction mappings
WIND_DIRECTIONS = {
    "N": "1", "NNE": "2", "NE": "3", "ENE": "4",
    "E": "5", "ESE": "6", "SE": "7", "SSE": "8",
    "S": "9", "SSW": ":", "SW": ";", "WSW": "<",
    "W": "=", "WNW": ">", "NW": "?", "NNW": "@",
    "N/A": "-"
}

def get_wind_direction(degrees):
    directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                 "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
    index = round(degrees / (360 / len(directions))) % len(directions)
    return WIND_DIRECTIONS[directions[index]]

def get_wind_symbol():
    try:
        # Use NWS API for Metamora
        headers = {'User-Agent': 'Conky Wind Display (stephen@example.com)'}
        point_url = "https://api.weather.gov/points/40.7844,-89.4309"
        
        response = requests.get(point_url, headers=headers)
        point_data = response.json()
        
        forecast_url = point_data['properties']['forecastHourly']
        response = requests.get(forecast_url, headers=headers)
        forecast_data = response.json()
        
        # Get current wind data
        current_period = forecast_data['properties']['periods'][0]
        wind_direction = current_period['windDirection']
        wind_speed = current_period['windSpeed']
        
        # If running in debug mode, show more info
        if '--debug' in sys.argv:
            print(f"Wind Direction: {wind_direction}")
            print(f"Wind Speed: {wind_speed}")
        
        # Convert cardinal direction to degrees if needed
        if wind_direction in WIND_DIRECTIONS:
            return WIND_DIRECTIONS[wind_direction]
        else:
            # Convert degrees if we get them
            try:
                degrees = float(wind_direction)
                return get_wind_direction(degrees)
            except ValueError:
                return WIND_DIRECTIONS["N/A"]
                
    except Exception as e:
        if '--debug' in sys.argv:
            print(f"Error: {str(e)}")
        return WIND_DIRECTIONS["N/A"]

if __name__ == "__main__":
    print(get_wind_symbol())
