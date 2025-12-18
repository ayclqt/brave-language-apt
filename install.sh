#!/bin/bash

# Check if running as root
[ "$EUID" -ne 0 ] && { echo "Please run as root or with sudo"; exit 1; }

LANGUAGE_CODE="${1:-vi_VN}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FIXBRAVE_SOURCE="$SCRIPT_DIR/fixbrave"
FIXBRAVE_DEST="/usr/local/bin/fixbrave"
APT_HOOK_PATH="/etc/apt/apt.conf.d/99brave-locale"
DOWNLOAD_URL="https://github.com/ayclqt/brave-language-apt/releases/latest/download"

echo "Installing fixbrave with default language: $LANGUAGE_CODE"

# Check if fixbrave exists in current directory, else download it
cp "$(dirname "$0")/fixbrave" "$FIXBRAVE_DEST" 2>/dev/null || { echo "fixbrave not found. Downloading..." && curl -fsSL "$DOWNLOAD_URL/fixbrave" -o "$FIXBRAVE_DEST" && echo "Download complete!"; } || { echo "Error: Failed to get fixbrave script"; exit 1; }

# Replace default language code
sed -i "s/LANGUAGE_CODE=\"\${1:-[^}]*}\"/LANGUAGE_CODE=\"\${1:-$LANGUAGE_CODE}\"/" "$FIXBRAVE_DEST"

# Set executable permission
chmod +x "$FIXBRAVE_DEST" && echo "Installed $FIXBRAVE_DEST. Default language: $LANGUAGE_CODE" || { echo "Error: Failed to set executable permission"; exit 1; }

# Create APT hook
echo 'DPkg::Post-Invoke { "fixbrave"; };' > "$APT_HOOK_PATH" && echo "Created APT hook at $APT_HOOK_PATH"

# Executable fixbrave immediately
sudo fixbrave && echo "Initial fixbrave execution completed." || { echo "Error: fixbrave execution failed"; exit 1; }

echo "Installation complete." && echo "The fixbrave script will run automatically after Brave updates." && echo "You can also run manually with custom language: sudo fixbrave <locale_code>"
