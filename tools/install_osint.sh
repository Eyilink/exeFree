#!/bin/bash

set -e
echo "[+] Installing OSINT tools..."
mkdir -p ~/tools && cd ~/tools

sudo apt update && sudo apt install -y git python3 python3-pip golang nmap rustscan chromium-browser

echo "[+] Cloning Bbot..."
git clone https://github.com/blacklanternsecurity/bbot.git
cd bbot && go install ./... && cd ..

echo "[+] Cloning OneForAll..."
git clone https://github.com/shmilylty/OneForAll.git
cd OneForAll && go install ./... && cd ..

echo "[+] Cloning Amass..."
git clone https://github.com/owasp-amass/amass.git
cd amass && go install ./... && cd ..

echo "[+] Cloning Subfinder..."
git clone https://github.com/projectdiscovery/subfinder.git
cd subfinder && go install ./... && cd ..

echo "[+] Cloning DnsRecon..."
git clone https://github.com/darkoperator/dnsrecon.git
cd dnsrecon && pip3 install -r requirements.txt && cd ..

echo "[+] Cloning Pastos..."
git clone https://github.com/carlospolop/Pastos.git
cd Pastos && pip3 install -r requirements.txt && cd ..

echo "[+] Cloning favihash.py..."
git clone https://github.com/m4ll0k/BBTz.git
# (Optional) Setup for favihash.py

echo "[+] Cloning linkedin2username..."
git clone https://github.com/initstring/linkedin2username.git
cd linkedin2username && pip3 install -r requirements.txt && cd ..

echo "[+] Cloning httpx..."
git clone https://github.com/projectdiscovery/httpx.git
cd httpx && go install ./... && cd ..

echo "[+] Cloning Naabu..."
git clone https://github.com/projectdiscovery/naabu.git
cd naabu && go install ./... && cd ..

echo "[+] Cloning GoWitness..."
git clone https://github.com/sensepost/gowitness.git
cd gowitness && go install && cd ..

echo "[+] All tools installed in ~/tools"
