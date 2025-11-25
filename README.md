# Radio player

A simple bash script to play your favorite internet radio stations from command line.

Built as a wrapper around the [mpv](https://mpv.io) media player.


## Requirements
- mpv - The free, open source, and cross-platform media player.
- fzf - The command line fuzzy-finder to handle interactive menu.
- figlet - To print the radio station name with a bit of ascii art

You must install them before using the `radio` player script.
```bash
# Ubuntu/Debian
sudo apt install mpv fzf figlet

# macOS
brew install mpv fzf figlet

# Arch Linux
sudo pacman -S mpv fzf figlet
```

## Quick start (local)
Run without installation from the project directory:

```bash
chmod +x radio.sh
./radio.sh
```
Make sure `.config/favorite_radio_stations.csv` exists in your project folder.


## Installation
```bash
make install
```
This will:
- Copy the `radio` script in `/usr/local/bin`
- Copy the config file to `~/.config/favorite_radio_stations.csv`


## Usage
```bash
# This will show the interactive menu
radio 

# This will play the KEXP radio station listed in your config/favorite_radio_stations.csv file
radio KEXP

# Show help
radio -h
```

The script displays the ICY title of the song currently playing, when it is available for the stream.


## Configuration
Edit `config/favorite_radio_stations.csv` to add/remove yuor favorite listenings.
Please follow the csv format file `name;url` (semicolon separated).

```csv
KEXP;https://kexp.streamguys1.com/kexp160.aac
```


## Uninstall
```bash
make uninstall
```
Remove both the script and the config file.


## Status
```bash
make status
```
Check the installation status.