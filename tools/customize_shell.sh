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
    display=":2"
    port="5905"
    app_to_run=""

    for arg in "$@"; do
        case "$arg" in
            display=*) display="${arg#*=}" ;;
            port=*) port="${arg#*=}" ;;
            *) app_to_run="$arg" ;;
        esac
    done

    export DISPLAY="${display}"

    pkill -f "Xvfb ${display}" 2>/dev/null
    pkill -f "x11vnc.*${port}" 2>/dev/null
    pkill fluxbox 2>/dev/null

    

    if [ -n "$app_to_run" ]; then
        Xvfb "${display}" -screen 0 1280x1024x16 > /dev/null 2>&1 &
        fluxbox > /dev/null 2>&1 &
        x11vnc -display "${display}" -rfbport "${port}" -nopw -forever > /dev/null 2>&1 &
        "$app_to_run" > /dev/null 2>&1 &
    else
        echo "No application was specified"
    fi
    export DISPLAY=host.docker.internal:0.0
}

vnc_stop() {
   pkill -f '\''Xvfb :2'\''
   pkill -f '\''x11vnc.*5905'\''
   pkill fluxbox
}' >> /home/exefree/.zshrc


echo 'kerbconf() {
   if [ -z "$1" ] || [ -z "$2" ]; then
       echo "Usage: kerbconf <domain> <dc_hostname>"
       echo "Example: kerbconf voleur.htb DC.voleur.htb"
       return 1
   fi
   
   local domain="$1"
   local dc_hostname="$2"
   local realm=$(echo "$domain" | tr '\''[:lower:]'\'' '\''[:upper:]'\'')
   
   echo "=== Kerberos Configuration for $domain ==="
   echo
   echo "1. Add this to /etc/krb5.conf:"
   echo "   sudo tee /etc/krb5.conf << EOF"
   echo "[libdefaults]"
   echo "    default_realm = $realm"
   echo "    dns_lookup_realm = false"
   echo "    dns_lookup_kdc = false"
   echo
   echo "[realms]"
   echo "    $realm = {"
   echo "        kdc = $dc_hostname"
   echo "        admin_server = $dc_hostname"
   echo "    }"
   echo
   echo "[domain_realm]"
   echo "    .$domain = $realm"
   echo "    $domain = $realm"
   echo "EOF"
   echo
   echo "2. Don'\''t forget to add to /etc/hosts:"
   echo "   echo \"<DC_IP> $dc_hostname $domain\" | sudo tee -a /etc/hosts"
   echo
   echo "3. Then authenticate:"
   echo "   kinit <username>@$realm"
   echo
   echo "4. Verify ticket:"
   echo "   klist"
}' >> ~/.zshrc


echo 'HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000
setopt INC_APPEND_HISTORY 
setopt HIST_IGNORE_DUPS' >> ~/.zshrc