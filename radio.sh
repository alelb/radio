#!/usr/bin/env bash
set -e
set -u
set -o pipefail

# CSV file, with radio stations (name;url)
# Search first in current directory, then in home
if [ -f ".config/favorite_radio_stations.csv" ]; then
  CSV_FILE=".config/favorite_radio_stations.csv"
elif [ -f "$HOME/.config/favorite_radio_stations.csv" ]; then
  CSV_FILE="$HOME/.config/favorite_radio_stations.csv"
else
  echo "Error: favorite_radio_stations.csv not found" >&2
  echo "Expected locations:" >&2
  echo "  - .config/favorite_radio_stations.csv (local)" >&2
  echo "  - $HOME/.config/favorite_radio_stations.csv (installed)" >&2
  exit 1
fi

# fn to show help
show_help() {
  echo "Usage: $(basename "$0") [radio_name]"
  echo ""
  echo "If a radio name is not provided, it will show an interactive menu list."
  echo "Config file: $CSV_FILE"
  exit 0
}

# fn to get the radio url
get_url() {
  local name="$1"
  awk -F';' -v name="$name" '$1 == name {print $2; exit}' "$CSV_FILE"
}

GREEN='\033[0;32m'
NC='\033[0m' # No Color

print_ascii_art() {
    local text_to_print="$1"
    local FONT="doom" 

    echo -e "${GREEN}"
    figlet -f "$FONT" "$text_to_print"
    echo -e "${NC}"
}

# fn to play the radio
play_radio() {
  local name="$1"
  local url="$2"
  print_ascii_art "$name"
  exec mpv --really-quiet --log-file=/dev/stderr "$url" 2>&1 | grep --line-buffered -E 'icy-name|icy-title|icy-genre'
}

# fn to show an interactive menu
show_menu() {
  # Check if fzf is installed
  if ! command -v fzf &> /dev/null; then
    echo "Error: fzf is not installed." >&2
    echo "Please install it to use this bash radio wrapper." >&2
    echo "" >&2
    echo "Available radio stations:" >&2
    awk -F';' '{print $1}' "$CSV_FILE" | sort
    exit 1
  fi
  
  # show menu with fzf
  local selected
  selected=$(awk -F';' '{print $1}' "$CSV_FILE" | sort | fzf --prompt="Select a radio station: " --height=40% --border --reverse)
  
  if [ -n "$selected" ]; then
    local url
    url=$(get_url "$selected")
    if [ -n "$url" ]; then
      play_radio "$selected" "$url"
    else
      echo "Error: impossible to find url for $selected" >&2
      exit 1
    fi
  else
    echo "No selection" >&2
    exit 1
  fi
}

# Main
if [ $# -eq 0 ]; then
  # no args: show the interactive menu
  show_menu
elif [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  show_help
else
  # provided args: searching for the radio
  radio_name="$*"
  url=$(get_url "$radio_name")
  
  if [ -n "$url" ]; then
    play_radio "$radio_name" "$url"
  else
    echo "Radio '$radio_name' not found." >&2
    echo "" >&2
    echo "Available radio:" >&2
    awk -F';' '{print $1}' "$CSV_FILE" | sort
    echo "" >&2
    echo "Execute without args to view the interactive menu." >&2
    exit 1
  fi
fi