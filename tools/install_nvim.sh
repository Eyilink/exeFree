#!/bin/zsh

set -e

# Update package lists and install neovim
echo "Installing Neovim and dependencies..."
sudo apt install xclip
# Clone and build Neovim
git clone https://github.com/neovim/neovim.git /tmp/nvim
cd /tmp/nvim
git checkout stable
sudo make CMAKE_BUILD_TYPE=Release
sudo make install



# Install pynvim via pip (for python plugin support)
echo "Installing pynvim python package..."
pip3 install --break-system-packages --user pynvim

# Create config directory if it doesn't exist
CONFIG_DIR="$HOME/.config/nvim"
if [ -d "$CONFIG_DIR" ]; then
    echo "Backup existing nvim config..."
    mv "$CONFIG_DIR" "${CONFIG_DIR}.bak.$(date +%s)"
fi
mkdir -p "$HOME/.config"


echo "Cloning your Neovim config repo..."
git clone https://github.com/Eyilink/nvim-easy-conf.git "$CONFIG_DIR"

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim


echo "Neovim installation and configuration completed!"
