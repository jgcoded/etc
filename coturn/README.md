# Coturn server with REST API

Editable Text Configuration for a coturn server configured to allow credentials provisioned through a TURN Rest API. The API server used that is set up in the `user.history` file is found here: https://github.com/jgcoded/Rooms

The configuration files here provide:

* Coturn with SSL via LetsEncrypt
* ASP.NET API server managed with systemd
* Nginx with https support proxying requests to the API server

## Manual API deployment steps

Use scp to transfer the files

```
scp bin\Release\net6.0\linux-x64\publish\* turn@p2p.foo.com:/var/www/rooms
```

SSH to the server via Putty or a terminal.

```
sudo systemctl restartstart kestrel-rooms.service
sudo journalctl -fu kestrel-rooms.service --since today
```


## Cert renewal steps

DNS challenge must be used due to the wildcart cert. SSH to the server via Putty or a terminal.

```
sudo certbot -d *.p2p.foo.com --manual --preferred-challenges dns certonly
sudo systemctl restart coturn
sudo systemctl restart kestrel-rooms.service
sudo nginx -t
sudo nginx -s reload
```

References

* https://docs.microsoft.com/en-us/gaming/azure/reference-architectures/stun-turn-server-in-azure
* https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#2004-
* https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/linux-nginx?view=aspnetcore-6.0
