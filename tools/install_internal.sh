#!/bin/bash

set -e

echo "[*] Updating system and installing dependencies..."
sudo apt update && sudo apt install -y \
    git python3 python3-pip build-essential libssl-dev libffi-dev \
    python3-dev python3-venv unzip wget curl make gcc \
    smbclient rpcbind snmp \
    ldap-utils net-tools proxychains4

# sudo echo "mibs :" > /etc/snmp/snmp.conf

echo "[*] Creating tools directory..."
if [ -d /opt/tools]; then
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
sudo git clone https://github.com/fortra/impacket.git
cd impacket && pip3 --break-system-packages install . && cd ..

echo "[*] Installing Netexec (replacement of CrackMapExec)..."
sudo git clone https://github.com/Pennyw0rth/NetExec.git
cd NetExec && pip3 --break-system-packages install . && cd ..

echo "[*] Installing Responder..."
sudo git clone https://github.com/lgandx/Responder.git

echo "[*] Installing enum4linux-ng..."
sudo git clone https://github.com/cddmp/enum4linux-ng.git

echo "[*] Installing smbmap..."
sudo git clone https://github.com/ShawnDEvans/smbmap.git
cd smbmap && pip3 --break-system-packages install -r requirements.txt && cd ..

echo "[*] Installing hashcat..."
sudo apt install -y hashcat

echo "[*] Installing kerbrute..."
sudo wget https://github.com/ropnop/kerbrute/releases/latest/download/kerbrute_linux_amd64
sudo chmod +x kerbrute_linux_amd64
sudo mv kerbrute_linux_amd64 kerbrute

echo "[*] Installing snmpwalk..."
sudo apt install -y snmp

echo "[*] Downloading linPEAS and winPEAS..."
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEAS.bat

echo "[*] Installing PrivescCheck (Windows)..."
git clone https://github.com/itm4n/PrivescCheck.git

echo "[*] Installing chisel..."
wget https://github.com/jpillora/chisel/releases/download/v1.9.1/chisel_1.9.1_linux_amd64.gz
gunzip chisel_1.9.1_linux_amd64.gz
chmod +x chisel_1.9.1_linux_amd64
mv chisel_1.9.1_linux_amd64 chisel

echo "[*] Installing ligolo-ng..."
git clone https://github.com/nicocha30/ligolo-ng.git
cd ligolo-ng/agent && make build && cd ../..

echo "[*] Installing metasploit..."
sudo apt install -y curl gnupg2 build-essential libssl-dev libreadline-dev zlib1g-dev libpq-dev libsqlite3-dev git ruby-full && \
    sudo git clone https://github.com/rapid7/metasploit-framework /opt/tools/metasploit-framework && \
    cd /opt/tools/metasploit-framework && \
    sudo gem install bundler && \
    sudo bundle install

echo "[*] All tools installed in ~/tools"
