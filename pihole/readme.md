# Wireguard + Pihole = :heart:

 This directory contains set commandlines and tools to set up a server with the following features:

* Pihole for ad blocking
* Route all traffic through Wireguard. See [Wireguard](./wireguard.md).
* Cloudflare DNS over HTTPS (client -> server -> CloudFlare)
* LetsEcrypt SSL cert
* lighttpd to serve HTTPS pihole admin site
* Certbot for auto cert renewal. See [Cert Renewal](./cert-renewal.md).
