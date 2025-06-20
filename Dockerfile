FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
  python3 python3-pip git curl wget \
  nmap netcat-traditional zsh vim tmux sudo unzip \
  ninja-build gettext cmake build-essential libpcap-dev \
  x11-apps \
  libx11-6 libxtst6 libxrender1 libxi6 \
  && apt clean

RUN apt update && apt install -y wget gnupg && \
    wget -O /etc/apt/trusted.gpg.d/adoptium.asc https://packages.adoptium.net/artifactory/api/gpg/key/public && \
    echo "deb https://packages.adoptium.net/artifactory/deb bookworm main" > /etc/apt/sources.list.d/adoptium.list && \
    apt update && apt install -y temurin-21-jdk

# RUN apt-get update && apt-get install -y \
#     fuse \
#     wget \
#     && wget https://github.com/rfjakob/gocryptfs/releases/download/v2.5.4/gocryptfs_v2.5.4_linux-static_amd64.tar.gz \
#     && tar -C /usr/local/bin -xzf gocryptfs_v2.5.4_linux-static_amd64.tar.gz \
#     && rm gocryptfs_v2.5.4_linux-static_amd64.tar.gz \
#     && chmod +x /usr/local/bin/gocryptfs

# Installer les outils de base
RUN pip3 install --break-system-packages pipx && pipx ensurepath

# Cloner et installer des outils
#RUN git clone https://github.com/danielmiessler/SecLists /opt/SecLists

# Créer un utilisateur non root
RUN useradd -ms /bin/zsh exefree && \
    echo "exefree:exefree" | chpasswd && \
    echo "exefree ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER exefree
WORKDIR /workspace

# Copy the tools directory into the image
COPY tools /opt/tools
COPY resources /opt/resources

# Install Go from tarball
RUN sudo tar -C /usr/local -xzf /opt/resources/go1.24.4.linux-amd64.tar.gz && \
    mkdir -p /home/exefree/go/bin

ENV PATH=/usr/local/go/bin:/home/exefree/go/bin:$PATH

RUN echo 'zsh-newuser-install() { :; }' >> /home/exefree/.zshrc && \
    touch /home/exefree/.zshenv /home/exefree/.zsh_history && \
    sudo chown -R exefree:exefree /home/exefree

ENV ZSH_DISABLE_COMPFIX=true

# Make sure scripts are executable (optional, but good practice)
RUN sudo chmod +x /opt/tools/*.sh
# RUN sudo /opt/tools/install.sh
# RUN /opt/tools/customize_shell.sh
# RUN /opt/tools/install_nvim.sh
# RUN /opt/tools/install_fzf.sh
# RUN sudo /opt/tools/install_web.sh
RUN /opt/tools/install_internal.sh
# Run the Neovim install script as root (or switch to non-root user later)
COPY entrypoint.sh /entrypoint.sh
RUN sudo chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
