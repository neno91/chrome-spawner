# multi-chrome

Launch multiple isolated Chrome instances with fresh profiles and auto-arrange them in a grid. Supports Windows and macOS.

## Why?

Testing multi-user scenarios, comparing sessions, or debugging auth flows often requires multiple browser instances that don't share cookies, cache, or login state. This script does that in one click.

## Features

- Opens any number of Chrome windows, each with its own temporary profile
- No shared cookies, cache, or session data between instances
- Skips Chrome's first-run welcome screen and search engine picker
- Auto-arranges all windows in a grid layout on your screen

## Usage

### Windows

Double-click `multi-chrome.bat` or run from terminal:
multi-chrome.bat



You'll be prompted for:

Enter address: https://example.com
How many browsers to open? 4



### macOS

chmod +x multi-chrome.sh
./multi-chrome.sh



Same prompts as above.

## Requirements

- Google Chrome installed in the default location
- **Windows:** PowerShell (included with Windows)
- **macOS:** No additional dependencies

## How It Works

1. Creates a unique temporary profile directory for each instance
2. Launches Chrome with `--user-data-dir` pointing to that directory, ensuring full isolation
3. Waits for browsers to start
4. Calculates a grid layout and repositions all windows to fill the screen

## Grid Layout Examples

| Count | Layout |
|-------|--------|
| 2     | 2x1    |
| 4     | 2x2    |
| 6     | 3x2    |
| 9     | 3x3    |

## License

MIT
