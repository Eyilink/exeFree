#!/bin/bash

set -e

echo "[*] Updating system and installing dependencies..."
sudo apt update && sudo apt install -y \
    git python3 python3-pip build-essential libssl-dev libffi-dev \
    python3-dev python3-venv unzip wget curl make gcc \
    smbclient rpcbind snmp snmp-mibs-downloader \
    ldap-utils net-tools proxychains4

echo "[*] Creating tools directory..."
mkdir -p ~/tools && cd ~/tools

echo "[*] Installing BloodHound (neo4j & BloodHound GUI)..."
sudo apt install -y neo4j bloodhound

echo "[*] Installing SharpHound..."
mkdir -p Sharphound && cd Sharphound
wget https://github.com/BloodHoundAD/SharpHound/releases/latest/download/SharpHound.exe
cd ..

echo "[*] Installing Impacket..."
git clone https://github.com/fortra/impacket.git
cd impacket && pip3 install . && cd ..

echo "[*] Installing Netexec (replacement of CrackMapExec)..."
git clone https://github.com/Pennyw0rth/NetExec.git
cd NetExec && pip3 install . && cd ..

echo "[*] Installing Responder..."
git clone https://github.com/lgandx/Responder.git

echo "[*] Installing enum4linux-ng..."
git clone https://github.com/cddmp/enum4linux-ng.git

echo "[*] Installing smbmap..."
git clone https://github.com/ShawnDEvans/smbmap.git
cd smbmap && pip3 install -r requirements.txt && cd ..

echo "[*] Installing hashcat..."
sudo apt install -y hashcat

echo "[*] Installing kerbrute..."
wget https://github.com/ropnop/kerbrute/releases/latest/download/kerbrute_linux_amd64
chmod +x kerbrute_linux_amd64
mv kerbrute_linux_amd64 kerbrute

echo "[*] Installing snmpwalk..."
sudo apt install -y snmp

echo "[*] Downloading linPEAS and winPEAS..."
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEAS.bat

echo "[*] Installing PrivescCheck (Windows)..."
git clone https://github.com/itm4n/PrivescCheck.git

echo "[*] Installing chisel..."
wget https://github.com/jpillora/chisel/releases/latest/download/chisel_linux_amd64.gz
gunzip chisel_linux_amd64.gz
chmod +x chisel_linux_amd64
mv chisel_linux_amd64 chisel

echo "[*] Installing ligolo-ng..."
git clone https://github.com/nicocha30/ligolo-ng.git
cd ligolo-ng/agent && make build && cd ../..

echo "[*] All tools installed in ~/tools"
