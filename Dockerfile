FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

# Update and install all security tools + mcp-kali-server
RUN apt-get update && apt-get install -y --no-install-recommends \
    # --- MCP Server ---
    mcp-kali-server \
    # --- Recon & OSINT ---
    nmap \
    masscan \
    subfinder \
    amass \
    theharvester \
    recon-ng \
    whatweb \
    wafw00f \
    dnsrecon \
    dnsenum \
    fierce \
    # --- Web Crawling & Discovery ---
    httpx-toolkit \
    gobuster \
    dirb \
    ffuf \
    feroxbuster \
    arjun \
    # --- Vulnerability Scanning ---
    nikto \
    nuclei \
    wpscan \
    sqlmap \
    xsser \
    commix \
    # --- Exploitation ---
    metasploit-framework \
    exploitdb \
    # --- Password Attacks ---
    hydra \
    john \
    hashcat \
    medusa \
    cewl \
    crunch \
    # --- AD / SMB / Network Attacks ---
    netexec \
    enum4linux \
    impacket-scripts \
    evil-winrm \
    responder \
    smbclient \
    smbmap \
    nbtscan \
    onesixtyone \
    snmp \
    # --- Wireless (limited in Docker) ---
    aircrack-ng \
    # --- Tunneling & Pivoting ---
    chisel \
    proxychains4 \
    socat \
    # --- Post-Exploitation ---
    weevely \
    # --- Reverse Engineering ---
    binwalk \
    radare2 \
    # --- Forensics ---
    foremost \
    exiftool \
    steghide \
    # --- Networking Utilities ---
    curl \
    wget \
    net-tools \
    iputils-ping \
    dnsutils \
    whois \
    netcat-traditional \
    ncat \
    tcpdump \
    tshark \
    traceroute \
    arp-scan \
    # --- Wordlists ---
    seclists \
    wordlists \
    # --- General Utilities ---
    jq \
    python3-pip \
    python3-venv \
    unzip \
    git \
    vim-tiny \
    tmux \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Decompress rockyou.txt wordlist
RUN if [ -f /usr/share/wordlists/rockyou.txt.gz ]; then \
    gunzip /usr/share/wordlists/rockyou.txt.gz; fi

# Patch upstream bug: CommandExecutor rejects list commands but all endpoints pass lists
COPY patch-server.py /tmp/patch-server.py
RUN python3 /tmp/patch-server.py && rm /tmp/patch-server.py

# Install tools not available via apt
RUN pip3 install --break-system-packages \
    ldapdomaindump

# Install Katana (ProjectDiscovery) via pre-built binary
RUN ARCH=$(dpkg --print-architecture) && \
    KATANA_VERSION=$(curl -s https://api.github.com/repos/projectdiscovery/katana/releases/latest | jq -r '.tag_name' | sed 's/^v//') && \
    if [ "$ARCH" = "arm64" ]; then KATANA_ARCH="arm64"; else KATANA_ARCH="amd64"; fi && \
    curl -sL "https://github.com/projectdiscovery/katana/releases/download/v${KATANA_VERSION}/katana_${KATANA_VERSION}_linux_${KATANA_ARCH}.zip" -o /tmp/katana.zip && \
    unzip -o /tmp/katana.zip -d /usr/local/bin katana && \
    chmod +x /usr/local/bin/katana && \
    rm -f /tmp/katana.zip

EXPOSE 5050

ENTRYPOINT ["kali-server-mcp"]
CMD ["--ip", "0.0.0.0", "--port", "5050"]
