#!/bin/bash

set -e

echo "[*] Updating system and installing dependencies..."
sudo apt update && sudo apt install -y \
    git python3 python3-pip build-essential libssl-dev libffi-dev \
    python3-dev python3-venv unzip wget curl make gcc \
    smbclient rpcbind snmp ntpdate\
    ldap-utils net-tools proxychains4

# sudo echo "mibs :" > /etc/snmp/snmp.conf

echo "[*] Creating tools directory..."
if [ -d /opt/tools ]; then
        cd /opt/tools
    else
        sudo mkdir -p /opt/tools && cd /opt/tools
fi

# echo "[*] Installing Neo4j..."
# wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/neo4j.gpg
# echo "deb [signed-by=/usr/share/keyrings/neo4j.gpg] https://debian.neo4j.com stable 4.4" | sudo tee /etc/apt/sources.list.d/neo4j.list
# sudo apt update && sudo apt install -y neo4j

# cd ~/tools
# wget https://github.com/SpecterOps/bloodhound-cli/releases/latest/download/bloodhound-cli-linux-amd64.tar.gz
# tar -xvzf bloodhound-cli-linux-amd64.tar.gz
# ./bloodhound-cli install

echo "[*] Installing Impacket..."
git clone https://github.com/fortra/impacket.git
cd impacket && pip3 install . --break-system-packages && cd /opt/tools

echo "[*] Installing Netexec (replacement of CrackMapExec)..."
git clone https://github.com/Pennyw0rth/NetExec.git
cd NetExec && pip3 install . --break-system-packages && cd /opt/tools

echo "[*] Installing Responder..."
git clone https://github.com/lgandx/Responder.git
cd Responder && sudo pip3 install -r requirements.txt --break-system-packages && cd /opt/tools
echo 'alias responder.py="sudo python3 /opt/tools/Responder/Responder.py"' >> /home/exefree/.zshrc


echo "[*] Installing enum4linux-ng..."
git clone https://github.com/cddmp/enum4linux-ng.git
echo 'alias enum4linux-ng="sudo python3 /opt/tools/enum4linux-ng/enum4linux-ng.py"' >> /home/exefree/.zshrc


echo "[*] Installing smbmap..."
sudo pip3 install smbmap && cd /opt/tools

echo "[*] Installing hashcat..."
sudo apt install -y hashcat

echo "[*] Installing kerbrute..."
wget https://github.com/ropnop/kerbrute/releases/latest/download/kerbrute_linux_amd64
sudo chmod +x kerbrute_linux_amd64
mv kerbrute_linux_amd64 kerbrute
echo 'alias kerbrute="/opt/tools/kerbrute"' >> /home/exefree/.zshrc

echo "[*] Installing snmpwalk..."
sudo apt install -y snmp

echo "[*] Downloading linPEAS and winPEAS..."
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEAS.bat
sudo wget https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.7/LaZagne.exe
sudo wget https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/refs/heads/master/Recon/PowerView.ps1
sudo wget https://github.com/samratashok/ADModule/raw/refs/heads/master/Microsoft.ActiveDirectory.Management.dll
sudo wget https://github.com/SnaffCon/Snaffler/releases/download/1.0.212/Snaffler.exe
sudo wget https://raw.githubusercontent.com/itm4n/PrivescCheck/refs/heads/master/PrivescCheck.ps1
sudo wget https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/refs/heads/master/Rubeus.exe
sudo wget https://github.com/ParrotSec/mimikatz/raw/refs/heads/master/Win32/mimikatz.exe
sudo wget https://github.com/SpecterOps/SharpHound/releases/download/v2.6.7/SharpHound_v2.6.7_windows_x86.zip
sudo wget https://github.com/Kevin-Robertson/Inveigh/releases/download/v2.0.11/Inveigh-net3.5-v2.0.11.zip
sudo pip3 install pypykatz --break-system-packages


echo "[*] Installing PrivescCheck (Windows)..."
git clone https://github.com/itm4n/PrivescCheck.git

echo "[*] Installing chisel..."
wget https://github.com/jpillora/chisel/releases/download/v1.9.1/chisel_1.9.1_linux_amd64.gz
gunzip chisel_1.9.1_linux_amd64.gz
sudo chmod +x chisel_1.9.1_linux_amd64
mv chisel_1.9.1_linux_amd64 chisel
echo 'alias chisel="/opt/tools/chisel"' >> /home/exefree/.zshrc

echo "[*] Installing ligolo-ng..."
git clone https://github.com/nicocha30/ligolo-ng.git
cd ligolo-ng/ && /usr/local/go/bin/go build -o agent cmd/agent/main.go && /usr/local/go/bin/go build -o proxy cmd/proxy/main.go && cd /opt/tools
echo 'alias ligolo-agent="/opt/tools/ligolo-ng/agent"
alias ligolo-proxy="/opt/tools/ligolo-ng/proxy"
' >> /home/exefree/.zshrc

echo "[*] Installing metasploit..."
sudo apt install -y curl gnupg2 build-essential libssl-dev libreadline-dev zlib1g-dev libpq-dev libsqlite3-dev git ruby-full && \
    sudo git clone https://github.com/rapid7/metasploit-framework /opt/tools/metasploit-framework && \
    cd /opt/tools/metasploit-framework && \
    sudo gem install bundler && \
    sudo bundle install
echo 'alias msfconsole="/opt/tools/metasploit-framework/msfconsole"
alias msfvenom="/opt/tools/metasploit-framework/msfvenom"
' >> /home/exefree/.zshrc

echo "[*] Installing faketime"
cd /opt/tools
git clone https://github.com/wolfcw/libfaketime.git
cd libfaketime
sudo make install
echo 'sync_time() {
  if [ -z "$1" ]; then
    echo "Usage: sync_time '<timestamp>'"
    echo "Example: sync_time '2025-07-04 23:03:25'"
    return 1
  fi
  /usr/local/bin/faketime "$1" zsh
}' >> ~/.zshrc

echo "[*] Installing Evil-Winrm..."
sudo gem install evil-winrm

echo "[*] All tools installed in ~/tools"
