import requests
import re
from flask import Flask
from config import REMOTE_DEBUGGING_PORT, URL_PATTERN

app = Flask(__name__)

CHROME_DEBUG_PORT = 9222

def get_current_url_from_chrome():
    """Fetch the current URL from Chrome remote debugging protocol"""
    try:
        # Get list of open tabs from Chrome DevTools Protocol
        response = requests.get(f'http://localhost:{CHROME_DEBUG_PORT}/json')
        tabs = response.json()
        
        # Return the URL of the first active tab
        if tabs:
            return tabs[0].get('url')
    except requests.exceptions.RequestException as e:
        print(f"Error connecting to Chrome: {e}")
    
    return None

@app.route('/lobby', methods=['GET'])
def lobby():
    current_url = get_current_url_from_chrome()
    
    if not current_url:
        return "Could not retrieve URL from Chrome.", 503
    
    if re.match(URL_PATTERN, current_url):
        return {"url": current_url, "matched": True}, 200
    
    return {"url": current_url, "matched": False}, 200

if __name__ == '__main__':
    app.run(port=REMOTE_DEBUGGING_PORT)