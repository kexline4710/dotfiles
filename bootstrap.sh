#!/bin/sh
# Bootstrap a new Mac: installs Xcode CLT and chezmoi, then applies dotfiles.
# Usage: sh -c "$(curl -fsLS raw.githubusercontent.com/YOUR_GITHUB_USERNAME/dotfiles/main/bootstrap.sh)"

set -e

# Prompt for GitHub username
printf "GitHub username: "
read -r GITHUB_USERNAME

# Prompt for name and email for chezmoi config
printf "Full name: "
read -r USER_NAME

printf "Email address: "
read -r USER_EMAIL

# Install Xcode Command Line Tools (required by git, which chezmoi needs to clone the repo)
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Waiting for Xcode Command Line Tools to finish installing..."
  until xcode-select -p >/dev/null 2>&1; do
    sleep 5
  done
  echo "Xcode Command Line Tools installed."
fi

# Install Homebrew if not present
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Create chezmoi config before init so templates have access to name and email
mkdir -p "$HOME/.config/chezmoi"
cat > "$HOME/.config/chezmoi/chezmoi.toml" << EOF
[data]
  name = "$USER_NAME"
  email = "$USER_EMAIL"
EOF

# Install chezmoi and clone the dotfiles repo (without applying yet)
sh -c "$(curl -fsLS get.chezmoi.io)" -- init apply "$GITHUB_USERNAME"