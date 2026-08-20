#!/usr/bin/env bash
# Bootstrap vim config on a new box. Safe to re-run.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Symlink .vimrc, backing up any existing file first.
if [ -e "$HOME/.vimrc" ] && [ ! -L "$HOME/.vimrc" ]; then
  mv "$HOME/.vimrc" "$HOME/.vimrc.bak.$(date +%s)"
fi
ln -sf "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"

# Install Vundle if missing.
VUNDLE_DIR="$HOME/.vim/bundle/Vundle.vim"
if [ ! -d "$VUNDLE_DIR" ]; then
  git clone --depth 1 https://github.com/VundleVim/Vundle.vim.git "$VUNDLE_DIR"
fi

# Install/update all plugins listed in .vimrc.
vim +PluginInstall +qall

echo "vim config installed."

# Point iTerm2 at the dotfiles copy of its preferences so settings (profiles,
# keybindings, appearance, etc.) stay in sync across machines. iTerm2 must be
# quit and relaunched for this to take effect if it's currently running.
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

echo "iTerm2 pointed at $DOTFILES_DIR/iterm2 for preferences."
echo "Quit and relaunch iTerm2 to pick this up, then in iTerm2 go to"
echo "Preferences > General > Preferences and check 'Save changes automatically'"
echo "so future edits get written back into the dotfiles repo."
