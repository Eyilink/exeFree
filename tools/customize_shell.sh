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

# echo 'export PATH="$HOME/.pyenv/bin:$PATH"
# eval "$(pyenv init --path)"
# eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc

#source ~/.zshrc

# Setting up uv for our global zsh
curl -LsSf https://astral.sh/uv/install.sh | sh
uv self update


# VNC display 

echo '
vnc_start() {
   export DISPLAY=:2
   pkill -f '\''Xvfb :2'\'' 2>/dev/null
   pkill -f '\''x11vnc.*5905'\'' 2>/dev/null
   pkill fluxbox 2>/dev/null
   
   Xvfb :2 -screen 0 1280x1024x16 &
   fluxbox &
   x11vnc -display :2 -rfbport 5905 -nopw -forever &
   
   if [ $# -eq 0 ]; then
       wait
   else
       "$@"
   fi
}

vnc_stop() {
   pkill -f '\''Xvfb :2'\''
   pkill -f '\''x11vnc.*5905'\''
   pkill fluxbox
}' >> /home/exefree/.zshrc