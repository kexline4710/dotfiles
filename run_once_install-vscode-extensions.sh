#!/bin/sh
# Install VS Code extensions (runs once on first apply)

set -e

if ! command -v code >/dev/null 2>&1; then
  echo "VS Code CLI not found, skipping extension install."
  exit 0
fi

echo "Installing VS Code extensions..."

extensions="
  anthropic.claude-code
  docker.docker
  eriklynd.json-tools
  esbenp.prettier-vscode
  mechatroner.rainbow-csv
  ms-azuretools.vscode-containers
  ms-azuretools.vscode-docker
  ms-vscode.vscode-typescript-next
  prisma.prisma
  vscodevim.vim
"

for ext in $extensions; do
  code --install-extension "$ext" --force
done

echo "VS Code extensions installed."
