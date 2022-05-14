# Coturn server with REST API

Editable Text Configuration for a coturn server configured to allow credentials provisioned through a TURN Rest API. The API server used that is set up in the `user.history` file is found here: https://github.com/jgcoded/Rooms

The configuration files here provide:

* Coturn with SSL via LetsEncrypt
* ASP.NET API server managed with systemd
* Nginx with https support proxying requests to the API server

References

* https://docs.microsoft.com/en-us/gaming/azure/reference-architectures/stun-turn-server-in-azure
* https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#2004-
* https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/linux-nginx?view=aspnetcore-6.0
