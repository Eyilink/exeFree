sudo apt install -y gdb
sudo apt install -y gcc-multilib g++-multilib libc6-dev-i386

echo "set disassembly intel" > /home/exefree/.gdbinit 

# source ~/.gdbinit

echo 'alias gdb="gdb -q"
alias gcc="gcc -m32 -g"
' >> /home/exefree/.zshrc

# source ~/.zshrc