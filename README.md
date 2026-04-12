# kali-linux-mcp

Dockerized Kali Linux MCP server. Clone, `docker compose up`, connect your MCP client — 12 security tools ready to use via AI.

Built on top of [MCP-Kali-Server](https://github.com/Wh0am123/MCP-Kali-Server) by [@Wh0am123](https://github.com/Wh0am123).

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (with Docker Compose)
- [Python 3.10+](https://www.python.org/) (for the MCP client on your host)
- [Git](https://git-scm.com/)

## Quick Start

### 1. Start the server

```bash
git clone https://github.com/sumitroajiprabowo/kali-linux-mcp.git
cd kali-linux-mcp
docker compose up -d --build
```

First build takes a while (downloads Kali image + tools). Verify it's running:

```bash
curl http://127.0.0.1:5050/health
```

Helper script is also available:

```bash
./kali-mcp.sh start    # start server
./kali-mcp.sh stop     # stop server
./kali-mcp.sh status   # check status
./kali-mcp.sh logs     # view logs
```

### 2. Install the MCP client

The client runs on your host machine and bridges MCP protocol to the Docker server.

```bash
git clone https://github.com/Wh0am123/MCP-Kali-Server.git
cd MCP-Kali-Server
python3 -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

Test the client:

```bash
python3 client.py --server http://127.0.0.1:5050
```

### 3. Connect to your MCP client

#### Claude Code

```bash
claude mcp add kali-mcp -- \
  /path/to/MCP-Kali-Server/.venv/bin/python3 \
  /path/to/MCP-Kali-Server/client.py \
  --server http://127.0.0.1:5050
```

Restart Claude Code to load the new MCP server.

#### Claude Desktop

Edit your config file:

- macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "kali-mcp": {
      "command": "python3",
      "args": [
        "/path/to/MCP-Kali-Server/client.py",
        "--server",
        "http://127.0.0.1:5050"
      ]
    }
  }
}
```

#### 5ire

Add an MCP server with the command:

```
python3 /path/to/MCP-Kali-Server/client.py --server http://127.0.0.1:5050
```

#### Other MCP Clients

Any MCP client that supports stdio transport can connect. The command is:

```
python3 /path/to/MCP-Kali-Server/client.py --server http://127.0.0.1:5050
```

## Available Tools

### MCP Functions (dedicated)

| Tool | MCP Function | Description |
|------|-------------|-------------|
| Nmap | `nmap_scan` | Port scanning and service detection |
| Gobuster | `gobuster_scan` | Directory, DNS, and vhost brute-forcing |
| Dirb | `dirb_scan` | Web content discovery |
| Nikto | `nikto_scan` | Web server vulnerability scanning |
| SQLMap | `sqlmap_scan` | SQL injection detection and exploitation |
| Metasploit | `metasploit_run` | Exploit module execution |
| Hydra | `hydra_attack` | Password brute-forcing |
| John the Ripper | `john_crack` | Hash cracking |
| WPScan | `wpscan_analyze` | WordPress vulnerability scanning |
| Enum4linux | `enum4linux_scan` | Windows/Samba enumeration |
| Command | `execute_command` | Run any shell command on Kali |
| Health | `server_health` | Check server and tool status |

### Additional Tools (via `execute_command`)

All tools below are pre-installed and can be used via the `execute_command` MCP function.

**Recon & OSINT:**
Subfinder, Amass, theHarvester, Recon-ng, WhatWeb, Wafw00f, Masscan, DNSRecon, DNSEnum, Fierce

**Web Crawling & Discovery:**
Katana, HTTPx, FFuf, Feroxbuster, Arjun

**Vulnerability Scanning:**
Nuclei, XSSer, Commix, SearchSploit (Exploit-DB)

**Password Attacks:**
Hashcat, Medusa, CeWL, Crunch

**AD / SMB / Network:**
NetExec, Impacket, Evil-WinRM, Responder, SMBClient, SMBMap, BloodHound, LDAPDomainDump, NBTScan, OneSixtyOne, SNMPWalk

**Tunneling & Pivoting:**
Chisel, Ligolo-ng, Proxychains4, Socat

**Post-Exploitation:**
Mimikatz, PowerShell Empire, Weevely

**Reverse Engineering:**
Binwalk, Radare2

**Forensics:**
Foremost, ExifTool, Steghide

**Wireless:**
Aircrack-ng (limited in Docker — no hardware access)

**Networking:**
Ncat, Tcpdump, Tshark, Traceroute, ARP-Scan

## Disclaimer

This project is intended solely for **authorized security testing**, **educational purposes**, and **CTF challenges**. Unauthorized access to systems you do not own or have explicit permission to test is illegal. The authors assume no responsibility for misuse.

## Credits

- [MCP-Kali-Server](https://github.com/Wh0am123/MCP-Kali-Server) by [@Wh0am123](https://github.com/Wh0am123) — the upstream MCP server and client
- [Kali Linux](https://www.kali.org/) — the security-focused Linux distribution

## License

MIT
