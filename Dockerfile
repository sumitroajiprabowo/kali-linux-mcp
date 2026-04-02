FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

# Update and install core security tools + mcp-kali-server
RUN apt-get update && apt-get install -y --no-install-recommends \
    mcp-kali-server \
    nmap \
    sqlmap \
    gobuster \
    nikto \
    hydra \
    john \
    dirb \
    enum4linux \
    wpscan \
    metasploit-framework \
    curl \
    wget \
    net-tools \
    iputils-ping \
    dnsutils \
    whois \
    netcat-traditional \
    seclists \
    wordlists \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 5050

ENTRYPOINT ["kali-server-mcp"]
CMD ["--ip", "0.0.0.0", "--port", "5050"]
