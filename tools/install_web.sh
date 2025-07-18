#!/bin/zsh

set -e

export GO111MODULE=on
export PATH=/usr/local/go/bin:/home/exefree/go/bin:$PATH

echo "[*] Updating system..."
sudo apt update && sudo apt install -y \
  git curl wget unzip zip python3-pip \
  ffuf whatweb gobuster nmap hydra medusa cewl \
  build-essential libssl-dev zlib1g-dev libffi-dev \
  python3-dev libcurl4-openssl-dev libxml2-dev libxslt1-dev \
  chromium firefox-esr x11-apps xauth net-tools

sudo apt install -y --no-install-recommends \
  libgl1-mesa-glx \
  libgl1-mesa-dri \
  libegl1-mesa \
  libx11-xcb1 \
  libxcb-glx0 \
  libpci3

sudo ldconfig

echo "[*] Installing Burp Suite Community (.jar version)..."
echo -e '#!/bin/bash\njava -jar /opt/resources/burpsuite_community_v2025.5.3.jar' > /usr/local/bin/burp
chmod +x /usr/local/bin/burp


echo "[*] Installing sqlmap..."
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git /opt/sqlmap
ln -s /opt/sqlmap/sqlmap.py /usr/local/bin/sqlmap

echo "[*] Installing hakrawler..."
go install github.com/hakluke/hakrawler@latest

echo "[*] Installing naabu..."
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

echo "[*] Installing testssl.sh..."
git clone https://github.com/drwetter/testssl.sh.git /opt/testssl.sh
ln -s /opt/testssl.sh/testssl.sh /usr/local/bin/testssl


echo "[*] Installing Firefox extensions (Wappalyzer & PwnFox)..."
# Download and prepare them, manual install unless using Firefox automation

echo "[*] Installing Naabu"
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

echo "[*] Installing Feroxbuster"
curl -sL https://raw.githubusercontent.com/epi052/feroxbuster/main/install-nix.sh | bash -s /usr/local/bin
# echo "[*] Installing Postman..."
# sudo tar -xzf /opt/resources/postman-linux-x64.tar.gz -C /opt
# sudo ln -s /opt/Postman/Postman /usr/local/bin/postman

echo "[*] Installation complete!"
