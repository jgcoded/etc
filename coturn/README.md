# Coturn server with REST API

Editable Text Configuration for a coturn server configured to allow credentials provisioned through a TURN Rest API. The API server used that is set up in the `user.history` file is found here: https://github.com/jgcoded/Rooms

The configuration files here provide:

* Coturn with SSL via LetsEncrypt
* ASP.NET API server managed with systemd
* Nginx with https support proxying requests to the API server
* Certificate autorenewal

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

Certificate autorenewal was set up with the following command.
An Azure Managed Service Identity is used to allow the processes within the VM to modify the Azure DNS Zone.

```
sudo certbot certonly --deploy-hook "systemctl restart coturn && systemctl restart kestrel-rooms.service && nginx -s reload" --dns-azure-config /home/turn/azure-dns.ini -d *.p2p.foo.com
```

If certbot had an error, run:
```
$ sudo certbot renew --dry-run
$ sudo certbot renew
```


References

* https://docs.microsoft.com/en-us/gaming/azure/reference-architectures/stun-turn-server-in-azure
* https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#2004-
* https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/linux-nginx?view=aspnetcore-6.0
