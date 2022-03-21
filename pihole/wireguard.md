# Wireguard

Port 22 is not exposed to the internet thanks to wireguard. Make sure you're connected to wireguard before using ssh to connect to the pihole server.

## Add a new Wireguard Client

Use these steps when setting up a new client (phone, PC) that will use wireguard as a VPN.

## On the server

```
$ sudo -i
$ cd /etc/wireguard/
$ umask 077
$ name="CLIENT_NAME"
# Ensure a unique number is used here. Check wg0.conf for the last used number assigned in the peer AllowedIPs.
$ number="X"
$ wg genkey | tee "${name}.key" | wg pubkey > "${name}.pub"
$ wg genpsk > "${name}.psk"
$ echo "[Peer]" >> /etc/wireguard/wg0.conf
$ echo "PublicKey = $(cat "${name}.pub")" >> /etc/wireguard/wg0.conf
$ echo "PresharedKey = $(cat "${name}.psk")" >> /etc/wireguard/wg0.conf
$ echo "AllowedIPs = 10.100.0.${number}/32, fd08:4711::${number}/128" >> /etc/wireguard/wg0.conf
$ systemctl restart wg-quick@wg0
$ wg
```

At this point the server configuration is complete. The following optional steps are used to generate a .conf and QR code the client can use for easy set up.
Either scp the .conf file or scan the QR code. Continue these steps right after the previous commands.

```
$ echo "[Interface]" > "${name}.conf"
$ echo "Address = 10.100.0.${number}/32, fd08:4711::${number}/128" >> "${name}.conf"
$ echo "DNS = 10.100.0.1" >> "${name}.conf"
$ echo "PrivateKey = $(cat "${name}.key")" >> "${name}.conf"
$ echo "[Peer]" >> "${name}.conf"
$ echo "AllowedIPs = 10.100.0.1/32, fd08::1/128" >> "${name}.conf"
$ echo "Endpoint = pihole.example.com:47111" >> "${name}.conf"
$ echo "PersistentKeepalive = 25" >> "${name}.conf"
$ echo "PublicKey = $(cat server.pub)" >> "${name}.conf"
$ echo "PresharedKey = $(cat "${name}.psk")" >> "${name}.conf"
$ exit
$ sudo cp /etc/wireguard/CLIENT_NAME.conf ./CLIENT_NAME.conf
$ sudo chown auser:auser ./CLIENT_NAME.conf
# Skip if already installed
$ sudo apt-get install qrencode
$ sudo qrencode -t ansiutf8 -r "/etc/wireguard/CLIENT_NAME.conf"
```

## On the client

scp the .conf file generated above, use the QR code, or manually enter the settings:

```
[Interface]
Address = 10.100.0.X/32, fd08:4711::X/128
DNS = 10.100.0.1
PrivateKey = << Private key from ${name}.key >>

[Peer]
AllowedIPs = 10.100.0.1/32, fd08::1/128
Endpoint = pihole.example.com:47111
PersistentKeepalive = 25
PublicKey = << Public key from server.pub >>
PresharedKey = << Preshared key from ${name}.psk >>
```

# Connecting to the server

Connect to the server via your preferred wireguard client. Then just ssh using your domain (pihole.example.com)
or the IP of the **wireguard interface** (not the internet IP!) of the peer.
From the perspective of the client, the server is the peer with address 10.100.0.1.

# Connecting to other peers

Connect to server via your preferred wireguard client. ssh using the IP of the **wireguard interface** (not the internet IP!) of the peer.


