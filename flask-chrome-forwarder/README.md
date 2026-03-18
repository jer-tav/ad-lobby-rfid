# Flask Chrome Forwarder

This project is a Flask web server that monitors a Chrome instance using the remote debugging protocol. When a user accesses the `/lobby` endpoint, it checks the currently open URL in Chrome and returns it if it matches a specified pattern.

## Project Structure

```
flask-chrome-forwarder
├── src
│   ├── app.py
│   ├── chrome_debugger.py
│   ├── config.py
│   └── requirements.txt
├── README.md
└── .gitignore
```

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/flask-chrome-forwarder.git
   cd flask-chrome-forwarder
   ```

2. Create a virtual environment (optional but recommended):
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows use `venv\Scripts\activate`
   ```

3. Install the required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Usage

1. Start Chrome with remote debugging enabled:
   ```bash
   google-chrome --remote-debugging-port=9222
   ```

2. Start the Flask application:
   ```bash
   python src/app.py
   ```

3. Access the `/lobby` endpoint:
   ```bash
   curl http://localhost:5000/lobby
   ```

   The endpoint will return the current Chrome URL if it matches the pattern defined in `config.py`.

## Configuration

Edit `src/config.py` to customize:
- `remote_debugging_port` - Chrome remote debugging port (default: 9222)
- `url_pattern` - Regex pattern to match URLs (default: AutoDarts lobby URLs)

Example response:
```json
{
  "url": "https://play.autodarts.io/lobbies/019d0272-16dd-7aa1-a2c3-201980878bbe",
  "matched": true
}
```

## License

This project is licensed under the MIT License.