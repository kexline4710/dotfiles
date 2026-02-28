# dotfiles

Personal dotfiles and machine setup managed with [chezmoi](https://chezmoi.io).

## What's included

- **Dotfiles** — `.gitconfig`, `.zshrc`, `.vimrc`, `.tmux.conf`, VS Code `settings.json` and `keybindings.json`
- **Homebrew packages** — CLI tools and GUI apps declared in `.chezmoidata/packages.toml`
- **macOS keyboard settings** — key repeat rate and Caps Lock → Control remapping
- **VS Code extensions** — all extensions installed automatically

---

## Setting up a new machine

### 1. Install chezmoi

```sh
curl -fsLS get.chezmoi.io | sh
```

### 2. Create your local chezmoi config

This file stores your personal details and is **never committed to the repo**. Create it before applying:

```sh
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << EOF
[data]
  name = "Your Name"
  email = "your@email.com"
EOF
```

### 3. Initialise and apply

```sh
chezmoi init https://github.com/kexline4710/dotfiles.git
chezmoi apply
```

This will:
- Copy all dotfiles to their correct locations
- Install Homebrew (if not present) and all packages
- Install Xcode Command Line Tools (if not present)
- Apply macOS keyboard settings
- Install VS Code extensions (if `code` CLI is available)

---

## Running `chezmoi apply` more than once

Most scripts are `run_once_` — chezmoi tracks their checksum and will not re-run them unless the file changes. However, there are two situations where you may need to run `chezmoi apply` a second time:

### VS Code extensions may be skipped on first run

The VS Code extension installer requires the `code` CLI to be on your `$PATH`. The Homebrew cask installs the VS Code app but the `code` CLI is only added to `$PATH` after you:

1. Open VS Code
2. Open the Command Palette (`Cmd+Shift+P`)
3. Run **Shell Command: Install 'code' command in PATH**

Once that's done, re-run `chezmoi apply` to install the extensions:

```sh
chezmoi apply
```

> Note: because `run_once_install-vscode-extensions.sh` already ran (and exited gracefully), chezmoi will not re-run it automatically. Rename or touch the file to force a re-run, or install extensions manually with `code --install-extension <id>`.

### Caps Lock → Control may not apply to new keyboards

The modifier key remap is applied per keyboard. If you connect an external keyboard that was not plugged in when `chezmoi apply` first ran, it won't be remapped automatically. To apply it to a newly connected keyboard, re-run the macOS settings script manually:

```sh
sh ~/.local/share/chezmoi/run_once_macos-settings.sh
```

Then log out and back in for the change to take effect.

---

## Keeping machines in sync

To pull the latest changes and apply them on any machine:

```sh
chezmoi update
```

This is equivalent to `git pull` followed by `chezmoi apply`.

To edit a managed file:

```sh
chezmoi edit ~/.zshrc
chezmoi apply
```

To add a new file to chezmoi:

```sh
chezmoi add ~/.some-new-config
```

---

## Adding or removing packages

Edit `.chezmoidata/packages.toml` to add or remove Homebrew formulae or casks. Because the install script is `run_once_`, changes to the package list will not automatically trigger a re-run. To install newly added packages, run:

```sh
brew install <formula>
# or
brew install --cask <cask>
```

Or force chezmoi to re-run the script by updating its filename.

---

## Not available via Homebrew

The following apps must be installed manually from the Mac App Store:

- **Notability**
