
Certbot should be able to automatically renew the certs. If certbot had an error, run:

```
$ sudo certbot renew --dry-run
$ sudo certbot renew
```

If for some reason port 80 is in use by process, run this command to find out what is bound to port 80:

```
$ sudo lsof -i -P -n | grep LISTEN
```

Lighttpd should be binding to port 8080 (per the lighttpd external.conf in this repo). If it is causing issues, run:
```
$ sudo service lighttpd stop
```

The only manual steps that must be run after a certbot cert renewal:

```
$ sudo cat /etc/letsencrypt/live/pihole.example.com/privkey.pem /etc/letsencrypt/live/pihole.example.com/cert.pem | sudo tee /etc/letsencrypt/live/pihole.example.com/combined.pem
$ sudo service lighttpd restart
```
