# Flask Chrome Forwarder

This project is a Flask web server that monitors a Chrome instance using the remote debugging protocol. When a user accesses the `/lobby` endpoint, it checks the currently open URL in Chrome and returns it if it matches a specified pattern.

## Project Structure

```
flask-chrome-forwarder
├── src
│   ├── app.py
│   ├── config.py
│   └── requirements.txt
├── README.md
└── .gitignore
```

## Installation

### Quick Install (Ubuntu/Debian)

Run this single command to install everything:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/jer-tav/ad-lobby-rfid/main/install.sh)
```

Or, if you have the repository cloned locally:

```bash
bash install.sh
```

**To install and set up as a systemd service:**

```bash
bash install.sh service
```

This will automatically create and enable a systemd user service that starts on boot.

### Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/jer-tav/flask-chrome-forwarder.git
   cd flask-chrome-forwarder
   ```

2. Create a virtual environment (optional but recommended):
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```

3. Install the required dependencies:
   ```bash
   pip install -r flask-chrome-forwarder/requirements.txt
   ```

## Usage

### Running Directly

1. Start Chrome with remote debugging enabled:
   ```bash
   google-chrome --remote-debugging-port=9222
   ```

2. Activate the virtual environment and start the Flask application:
   ```bash
   source .venv/bin/activate
   python flask-chrome-forwarder/src/app.py
   ```

3. Access the `/lobby` endpoint:
   ```bash
   curl http://localhost:5000/lobby
   ```

### Running as a System Service (systemd)

If you installed with the `service` flag, the service is already set up and enabled. Otherwise, you can install it anytime by running:

```bash
bash install.sh service
```

**Managing the service:**

```bash
# Start the service
systemctl --user start flask-chrome-forwarder

# Check the status
systemctl --user status flask-chrome-forwarder

# View logs
journalctl --user -u flask-chrome-forwarder -f

# Stop the service
systemctl --user stop flask-chrome-forwarder

# Disable auto-start (but keep it available)
systemctl --user disable flask-chrome-forwarder
```

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