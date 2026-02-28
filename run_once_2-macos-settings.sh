#!/bin/sh
# Configure macOS keyboard settings (runs once on first apply)

set -e

echo "Applying macOS keyboard settings..."

# Key repeat rate: fastest possible (1 = 15ms, below UI minimum of 2)
defaults write NSGlobalDomain KeyRepeat -int 1

# Delay until repeat: Short (25 = 375ms, second shortest in System Settings)
defaults write NSGlobalDomain InitialKeyRepeat -int 25

# Remap Caps Lock to Control for all connected keyboards
# Modifier key values: HIDKeyboardModifierMappingSrc 0 = Caps Lock, HIDKeyboardModifierMappingDst 2 = Control
remap_entry='<array><dict><key>HIDKeyboardModifierMappingDst</key><integer>2</integer><key>HIDKeyboardModifierMappingSrc</key><integer>0</integer></dict></array>'

# Get all keyboard modifier mapping keys currently registered and apply to each
for keyboard_id in $(defaults read -g | grep -o 'com\.apple\.keyboard\.modifiermapping\.[0-9-]*' | sort -u); do
  defaults write -g "$keyboard_id" -array \
    '<dict><key>HIDKeyboardModifierMappingDst</key><integer>2</integer><key>HIDKeyboardModifierMappingSrc</key><integer>0</integer></dict>'
done

# Also apply to the built-in keyboard catch-all key used by some macOS versions
defaults write -g "com.apple.keyboard.modifiermapping.-1--1-0" -array \
  '<dict><key>HIDKeyboardModifierMappingDst</key><integer>2</integer><key>HIDKeyboardModifierMappingSrc</key><integer>0</integer></dict>'

echo "Keyboard settings applied. Please log out and back in for all changes to take effect."
