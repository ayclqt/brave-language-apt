# Brave language changer for APT-based systems

Automatically set Brave's locale on Linux by injecting `export LANGUAGE` into the Brave launcher script.

## Problem

Sometimes you want to use Brave in a different language than your system locale. This tool allows you to set a specific language for Brave regardless of your system settings by modifying Brave's launch script.

## Features

- Automatically fixes Brave locale after updates via APT hook
- Configurable default language during installation
- Can be run manually with custom language codes
- Backs up original Brave script before modification

## Files

- `fixbrave` - Script that modifies Brave's launcher to set locale
- `install.sh` - Installer that deploys fixbrave and sets up APT hook

> [!NOTE]
> Installing the next update for Brave resets `/opt/brave.com/brave/brave-browser`, so this file install an APT hook to reapply the locale fix automatically after each update.

## Installation

### Quick Install (Recommended)

Using curl to download and run the installer directly:

**Default Language (vi_VN)**
```bash
curl -fsSL https://github.com/ayclqt/brave-language-apt/releases/latest/download/install.sh | sudo bash
```

**Custom Default Language**
```bash
curl -fsSL https://github.com/ayclqt/brave-language-apt/releases/latest/download/install.sh | sudo bash -s <locale_code>
```

For example, to set English (en_US):
```bash
curl -fsSL https://github.com/ayclqt/brave-language-apt/releases/latest/download/install.sh | sudo bash -s en_US
```

### Install from Source

If you prefer to clone the repository and run locally:

```bash
git clone https://github.com/ayclqt/brave-language-apt.git
cd brave-language-apt
chmod +x install.sh
sudo ./install.sh
```

Or with custom language:
```bash
sudo ./install.sh <locale_code>
```

### What the installer does

This will:
1. Copy `fixbrave` to `/usr/local/bin/fixbrave` (downloads from GitHub if not found locally)
2. Set the specified language as default in fixbrave
3. Make fixbrave executable
4. Create APT hook at `/etc/apt/apt.conf.d/99brave-locale`
5. Execute fixbrave once to apply the locale immediately

## Usage

### Automatic (Recommended)

After installation, fixbrave runs automatically whenever Brave is updated via APT.

> [!TIP]
> Test if it works by reinstalling Brave:
```bash
sudo apt update && sudo apt install --reinstall brave-browser
```

### Manual Execution

Run with default language:
```bash
sudo fixbrave
```

Run with custom language:
```bash
sudo fixbrave <locale_code>
```

## How It Works

The `fixbrave` script:
1. Checks if `export LANGUAGE=` already exists in Brave's launcher
2. If not found, backs up the original script
3. Inserts `export LANGUAGE="<locale>"` after the first line (shebang)
4. Brave will now use the specified locale

## Supported Locales

Any valid locale code, such as:
- `vi_VN` - Vietnamese
- `en_US` - English (US)
- `ja_JP` - Japanese
- `zh_CN` - Chinese (Simplified)
- `ko_KR` - Korean
- `th_TH` - Thai

## Uninstallation

```bash
sudo rm /usr/local/bin/fixbrave
sudo rm /etc/apt/apt.conf.d/99brave-locale
```

To restore original Brave script:
```bash
sudo cp /opt/brave.com/brave/brave-browser.old /opt/brave.com/brave/brave-browser
```

## Requirements

- Brave installed at `/opt/brave.com/brave/brave-browser`
- Root/sudo access
- APT package manager (Debian/Ubuntu-based systems)

## License

MIT License

Copyright (c) 2025 ayclqt

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
