# Service
- Support Wildcard
- Stunnel Port: 222,777
- SSH Websocket
- SSH SSL Websocket
- Vmess Websocket TLS / non TLS
- Vless Websocket TLS / non TLS
- Trojan Websocket TLS / non TLS
- Shadowsocks Websocket TLS / non TLS
- Vmess gRPC
- Vless gRPC
- Trojan gRPC
- Shadowsocks gRPC

# Port TLS:
- 443, 2053, 2083, 2087, 2096, 8443
# Port non TLS:
- 80, 8080, 8880, 2052, 2082, 2086 2095

# Link Instalasi

```
sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen curl unzip && wget https://raw.githubusercontent.com/nanotechid/supreme/aio/setup.sh && chmod +x setup.sh && sed -i -e 's/\r$//' setup.sh && screen -S setup ./setup.sh
