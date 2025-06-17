chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k

echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' > ~/.zshrc

source ~/.zshrc

echo 'plugins=(git sudo z history zsh-autosuggestions zsh-syntax-highlighting)' >> ~/.zshrc

# Syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git \
  $ZSH_CUSTOM/plugins/zsh-autosuggestions

echo 'alias la='"ls -la"'
alias gs='git status'
alias ..='cd ..'
alias vim='nvim'
' >> ~/.zshrc

echo 'export PATH=$PATH:/usr/local/go/bin:/home/exefree/go/bin' >> ~/.zshrc
echo 'export GO111MODULE=on' >> ~/.zshrc

source ~/.zshrc