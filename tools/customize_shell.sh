#!/bin/zsh

#touch ~/.zshrc ~/.zshenv ~/.zsh_history
# echo 'autoload -Uz compinit
# compinit' >> ~/.zshrc
# echo "DISABLE_AUTO_UPDATE=\"true\"" >> ~/.zshrc
# echo "ZSH_DISABLE_COMPFIX=true" >> ~/.zshrc
# echo "unsetopt zle" >> ~/.zshenv
# echo "zsh-newuser-install() { :; }" >> ~/.zshrc  # disables the wizard

# #chsh -s $(which zsh)

# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# # Syntax highlighting
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
#   $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# # Autosuggestions
# git clone https://github.com/zsh-users/zsh-autosuggestions.git \
#   $ZSH_CUSTOM/plugins/zsh-autosuggestions

# echo 'plugins=(git sudo z history zsh-autosuggestions zsh-syntax-highlighting)' >> ~/.zshrc
sudo apt install zsh-syntax-highlighting
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
sudo apt install zsh-autosuggestions
echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc

echo 'alias la="ls -la"
alias gs="git status"
alias ..="cd .."
alias vim="nvim"
' >> ~/.zshrc

echo 'export PATH=$PATH:/usr/local/go/bin:/home/exefree/go/bin' >> ~/.zshrc
echo 'export GO111MODULE=on' >> ~/.zshrc

echo "PROMPT='%F{magenta}[%n@%m]%f - %F{blue}%~%f  '" >> ~/.zshrc

echo "autoload -Uz compinit && compinit" >> ~/.zshrc
echo "autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '%b'" >> ~/.zshrc

# source ~/.zshrc