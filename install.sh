#!/bin/bash

# Flask Chrome Forwarder - Ubuntu Installation Script
# Single command installation for Ubuntu
# Usage: install.sh [service]

set -e  # Exit on error

echo "=== Flask Chrome Forwarder Installation ==="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get absolute path
INSTALL_DIR="$(cd "$INSTALL_DIR" 2>/dev/null && pwd)" || {
    echo -e "${RED}Error: Installation directory not found${NC}"
    exit 1
}

# Check if requirements file exists
if [[ ! -f "$INSTALL_DIR/flask-chrome-forwarder/requirements.txt" ]]; then
    echo -e "${RED}Error: flask-chrome-forwarder/requirements.txt not found${NC}"
    echo ""
    echo "This script should be run from the project root directory."
    echo ""
    echo "To install from GitHub:"
    echo "  git clone https://github.com/yourusername/ad-lobby-rfid.git"
    echo "  cd ad-lobby-rfid"
    echo "  bash install.sh"
    exit 1
fi

cd "$INSTALL_DIR"

# Check if running on Ubuntu/Debian
if ! command -v apt-get &> /dev/null; then
    echo -e "${RED}Error: This script requires apt-get (Ubuntu/Debian)${NC}"
    exit 1
fi

# Check for optional service flag
INSTALL_SERVICE=false
if [[ "$1" == "service" ]]; then
    INSTALL_SERVICE=true
fi

echo -e "${YELLOW}Step 1: Updating system packages...${NC}"
sudo apt-get update -qq

echo -e "${YELLOW}Step 2: Installing Python and dependencies...${NC}"
sudo apt-get install -y -qq python3 python3-venv python3-pip

echo -e "${YELLOW}Step 3: Creating Python virtual environment...${NC}"
python3 -m venv .venv

echo -e "${YELLOW}Step 4: Activating virtual environment and installing requirements...${NC}"
source .venv/bin/activate
pip install -q -r flask-chrome-forwarder/requirements.txt

# Function to install systemd service
install_systemd_service() {
    echo -e "${YELLOW}Step 5: Setting up systemd service...${NC}"
    
    # Use the INSTALL_DIR already set at the top
    VENV_PYTHON="$INSTALL_DIR/.venv/bin/python"
    APP_SCRIPT="$INSTALL_DIR/flask-chrome-forwarder/src/app.py"
    SERVICE_DIR="$HOME/.config/systemd/user"
    SERVICE_FILE="$SERVICE_DIR/flask-chrome-forwarder.service"
    
    # Create systemd user config directory if it doesn't exist
    mkdir -p "$SERVICE_DIR"
    
    # Create the service file
    cat > "$SERVICE_FILE" << EOF
[Unit]
Description=Flask Chrome Forwarder
After=network.target

[Service]
Type=simple
WorkingDirectory=$INSTALL_DIR
ExecStart=$VENV_PYTHON $APP_SCRIPT
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
EOF

    # Reload systemd and enable the service
    systemctl --user daemon-reload
    systemctl --user enable flask-chrome-forwarder
    
    echo -e "${GREEN}✓ Service installed!${NC}"
}

if [[ "$INSTALL_SERVICE" == true ]]; then
    install_systemd_service
fi

echo -e "${GREEN}✓ Installation complete!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"

if [[ "$INSTALL_SERVICE" == true ]]; then
    echo "1. Start Chrome with remote debugging:"
    echo "   google-chrome --remote-debugging-port=9222"
    echo ""
    echo "2. Start the service:"
    echo "   systemctl --user start flask-chrome-forwarder"
    echo ""
    echo "3. Check the status:"
    echo "   systemctl --user status flask-chrome-forwarder"
    echo ""
    echo "4. View logs:"
    echo "   journalctl --user -u flask-chrome-forwarder -f"
    echo ""
    echo "5. Manage the service:"
    echo "   systemctl --user restart flask-chrome-forwarder"
    echo "   systemctl --user stop flask-chrome-forwarder"
    echo "   systemctl --user disable flask-chrome-forwarder"
else
    echo "1. Start Chrome with remote debugging:"
    echo "   google-chrome --remote-debugging-port=9222"
    echo ""
    echo "2. Run the Flask application:"
    echo "   source .venv/bin/activate"
    echo "   python flask-chrome-forwarder/src/app.py"
    echo ""
    echo "3. Test the endpoint:"
    echo "   curl http://localhost:5000/lobby"
    echo ""
    echo "To install as a systemd service instead, run:"
    echo "   bash install.sh service"
fi
