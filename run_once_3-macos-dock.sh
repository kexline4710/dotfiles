#!/bin/sh
# Configure macOS Dock settings and layout (runs once on first apply)

set -e

echo "Applying Dock settings..."

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Hide suggested and recent apps in Dock
defaults write com.apple.dock show-recents -bool false

# Set pinned app order
if ! command -v dockutil >/dev/null 2>&1; then
  echo "dockutil not found, skipping Dock layout configuration."
else
  echo "Configuring Dock layout..."

  # Remove all current Dock items
  dockutil --remove all --no-restart

  # Add apps in desired order
  dockutil --add /System/Applications/Finder.app                                          --no-restart
  dockutil --add /System/Applications/System\ Preferences.app                             --no-restart 2>/dev/null \
    || dockutil --add /System/Applications/System\ Settings.app                           --no-restart
  dockutil --add /System/Applications/Calendar.app                                        --no-restart
  dockutil --add "/Applications/1Password.app"                                            --no-restart
  dockutil --add /Applications/Todoist.app                                                --no-restart
  dockutil --add /Applications/Google\ Chrome.app                                         --no-restart
  dockutil --add /Applications/Spark\ Desktop.app                                         --no-restart 2>/dev/null \
    || dockutil --add /Applications/Spark.app                                             --no-restart
  dockutil --add /Applications/iTerm.app                                                  --no-restart
  dockutil --add /Applications/Visual\ Studio\ Code.app                                   --no-restart
  dockutil --add /Applications/Figma.app                                                  --no-restart
  dockutil --add /Applications/ChatGPT.app                                                --no-restart
  dockutil --add /Applications/Slack.app                                                  --no-restart
  dockutil --add /Applications/Microsoft\ Teams.app                                       --no-restart 2>/dev/null \
    || dockutil --add "/Applications/Microsoft Teams (work or school).app"                --no-restart
  dockutil --add /Applications/zoom.us.app                                                --no-restart
  dockutil --add /Applications/Spotify.app                                                --no-restart
  dockutil --add /Applications/Productive\ -\ Habit\ Tracker.app                         --no-restart 2>/dev/null \
    || dockutil --add /Applications/Productive.app                                        --no-restart
  dockutil --add /System/Applications/Messages.app
fi

# Restart the Dock to apply all settings
killall Dock

echo "Dock settings applied."
