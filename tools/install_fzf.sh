#!/bin/zsh

# sudo git clone https://github.com/danielmiessler/SecLists /opt/SecLists

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

echo '# Search interactively in wordlists using fzf
fzf-wordlist() {
  local wordlist
  wordlist=$(find /opt/SecLists -type f -name "*.txt" | fzf --prompt="Choose a wordlist: ")
  [ -n "$wordlist" ] && cat "$wordlist" | fzf --prompt="Search word: "
}
' >> ~/.zshrc
