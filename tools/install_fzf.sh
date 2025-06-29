#!/bin/zsh

# sudo git clone https://github.com/danielmiessler/SecLists /opt/SecLists

sudo mkdir -p /opt/SecLists
cd /opt/SecLists

# Subdomains
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top5000.txt
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top20000.txt

# Raft directories
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-small-directories.txt
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-medium-directories.txt
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-large-directories.txt

# Directory listings
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-listing-small.txt
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-listing-medium.txt
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-listing-large.txt

# Web extensions
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/web-extensions.txt
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/web-extensions-big.txt

# Burp parameters
wget https://raw.githubusercontent.com/danielmiessler/SecLists/refs/heads/master/Discovery/Web-Content/burp-parameter-names.txt

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

echo '# Search interactively in wordlists using fzf
fzf-wordlist() {
  local wordlist
  wordlist=$(find /opt/SecLists -type f -name "*.txt" | fzf --prompt="Choose a wordlist: ")
  [ -n "$wordlist" ] && cat "$wordlist" | fzf --prompt="Search word: "
}
' >> ~/.zshrc
