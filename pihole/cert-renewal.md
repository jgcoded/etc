Certificate autorenewal was set up with the following command. Port 80 must be kept open.

```
sudo certbot certonly --standalone --preferred-challenges http --deploy-hook "/home/piuser/certbot-deploy-hook.sh" -d pihole.example.com
```


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

