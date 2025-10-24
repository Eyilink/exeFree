#!/bin/bash

set -e

echo "[*] Updating system and installing dependencies..."
sudo apt update && sudo apt install -y \
    git python3 python3-pip build-essential libssl-dev libffi-dev \
    python3-dev python3-venv unzip wget curl make gcc \
    smbclient rpcbind snmp ntpdate\
    ldap-utils net-tools proxychains4 krb5-user nfs-common freerdp2-x11 dh-autoreconf

# sudo echo "mibs :" > /etc/snmp/snmp.conf
sudo chown -hR exefree:exefree /opt/

echo "[*] Creating tools directory..."
if [ -d /opt/tools ]; then
        cd /opt/tools
    else
        sudo mkdir -p /opt/tools && cd /opt/tools
fi


echo "[*] Installing Impacket..."
git clone https://github.com/fortra/impacket.git
cp /opt/tools/impacket_setup.py /opt/tools/impacket/setup.py
cd impacket && uv tool install . --python 3.11
cd /opt/tools/impacket/examples && sudo wget https://raw.githubusercontent.com/AlmondOffSec/PassTheCert/refs/heads/main/Python/passthecert.py
export PATH="$PATH:/opt/tools/impacket/examples"
sudo chmod +x /opt/tools/impacket/examples/*
# pip install pycryptodome --break-system-packages
cd /opt/tools

echo "[*] Installing Netexec (replacement of CrackMapExec)..."
git clone https://github.com/Pennyw0rth/NetExec.git
cd NetExec && uv tool install . && cd /opt/tools

echo "[*] Installing Responder..."
git clone https://github.com/lgandx/Responder.git
cd Responder &&  sudo chown -hR exefree:exefree /usr/local && uv pip install -r requirements.txt --system --break-system-packages && cd /opt/tools
echo 'alias responder.py="sudo python3 /opt/tools/Responder/Responder.py"' >> /home/exefree/.zshrc
cd /opt/tools

echo "[*] Installing bloodhound.py..."
uv tool install bloodhound-ce
echo 'alias bloodhound.py="bloodhound-ce-python"' >> /home/exefree/.zshrc

echo "[*] Installing enum4linux-ng..."
git clone https://github.com/cddmp/enum4linux-ng.git && cd enum4linux-ng &&  sudo chown -hR exefree:exefree /usr/local && uv pip install -r requirements.txt --system --break-system-packages
echo 'alias enum4linux-ng="sudo python3 /opt/tools/enum4linux-ng/enum4linux-ng.py"' >> /home/exefree/.zshrc


echo "[*] Installing smbmap..."
uv tool install smbmap

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
if [ -d /opt/scripts ]; then
        cd /opt/scripts
    else
        mkdir -p /opt/scripts && cd /opt/scripts
fi
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEAS.bat
wget https://github.com/peass-ng/PEASS-ng/releases/download/20250801-03e73bf3/winPEASany.exe
wget https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.7/LaZagne.exe
wget https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/refs/heads/master/Recon/PowerView.ps1
wget https://github.com/samratashok/ADModule/raw/refs/heads/master/Microsoft.ActiveDirectory.Management.dll
wget https://github.com/SnaffCon/Snaffler/releases/download/1.0.212/Snaffler.exe
#wget https://raw.githubusercontent.com/itm4n/PrivescCheck/refs/heads/master/PrivescCheck.ps1
wget https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/refs/heads/master/Rubeus.exe
wget https://github.com/ParrotSec/mimikatz/raw/refs/heads/master/Win32/mimikatz.exe
wget https://github.com/SpecterOps/SharpHound/releases/download/v2.6.7/SharpHound_v2.6.7_windows_x86.zip
wget https://github.com/Kevin-Robertson/Inveigh/releases/download/v2.0.11/Inveigh-net3.5-v2.0.11.zip
uv tool install pypykatz --python 3.12
uv tool install lsassy --python 3.12
uv tool install certipy-ad --python 3.12
uv tool install coercer --python 3.12
uv tool install updog

echo "[*] Installing PrivescCheck (Windows)..."
git clone https://github.com/itm4n/PrivescCheck.git

echo "[*] Installing chisel..."
wget https://github.com/jpillora/chisel/releases/download/v1.9.1/chisel_1.9.1_linux_amd64.gz
gunzip chisel_1.9.1_linux_amd64.gz
sudo chmod +x chisel_1.9.1_linux_amd64
mv chisel_1.9.1_linux_amd64 chisel
echo 'alias chisel="/opt/scripts/chisel"' >> /home/exefree/.zshrc

echo "[*] Installing ligolo-ng..."
git clone https://github.com/nicocha30/ligolo-ng.git
cd ligolo-ng/ && /usr/local/go/bin/go build -o agent cmd/agent/main.go && /usr/local/go/bin/go build -o proxy cmd/proxy/main.go && cd /opt/tools
echo 'alias ligolo-agent="/opt/scripts/ligolo-ng/agent"
alias ligolo-proxy="/opt/scripts/ligolo-ng/proxy"
' >> /home/exefree/.zshrc

echo "[*] Installing metasploit..."
cd /opt/tools
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
   chmod 755 msfinstall && \
   ./msfinstall
echo 'alias msfconsole="/opt/metasploit-framework/bin/msfconsole"
alias msfvenom="/opt/metasploit-framework/bin/msfvenom"
' >> /home/exefree/.zshrc

echo "[*] Installing faketime"
cd /opt/tools && git clone https://github.com/wolfcw/libfaketime.git && cd libfaketime && sudo make install && cd /opt/tools

echo 'sync_time() {
  if [ -z "$1" ]; then
    echo "Usage: sync_time <ntp_server_ip>"
    echo "Example: sync_time 1.1.1.1"
    return 1
  fi

  offset=$(ntpdate -q "$1" 2>/dev/null | grep -oP "(?<=\+)\d+(?=\.)")
  if [ -z "$offset" ]; then
    echo "Failed to get offset from NTP server"
    return 1
  fi

  # Round the offset to the nearest second
  rounded_offset=$(printf "%.0f" "$offset")
  if [ "$rounded_offset" -ge 0 ]; then
    faketime_str="${rounded_offset} seconds"
  else
    faketime_str="${rounded_offset} seconds"
  fi

  echo "Starting zsh with faketime offset: $faketime_str"
  /usr/local/bin/faketime "$faketime_str" zsh
}' >> /home/exefree/.zshrc


echo "[*] Installing Evil-Winrm..."
sudo gem install evil-winrm

echo "[*] Installing John the ripper"
cd /opt/tools
git clone https://github.com/openwall/john.git && cd john/src && ./configure && make
wget -O /opt/tools/john/run/keepass2john.py https://raw.githubusercontent.com/ivanmrsulja/keepass2john/refs/heads/master/keepass2john.py
export PATH="$PATH:/opt/tools/john/run"
sudo chmod +x /opt/tools/john/run/*

echo "Installing rlwrap"
git clone https://github.com/hanslub42/rlwrap.git && cd rlwrap/ && autoreconf --install && ./configure && make && sudo make install

echo "[*] All tools installed in ~/tools"
