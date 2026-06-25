Utilize NetworkManager-dispatcher(8) to automatically generate "forward-addr" lines from nameserver information provided by a DHCP server.

After installation, place the following in a suitable Unbound configuration:

```
forward-zone:
  name: .
  include: "/run/NetworkManager/unbound-forwarders.conf"
```

Rationale: I use Unbound on localhost to work with split horizon DNS, but sometimes need to connect with public networks requiring the use of their own nameservers to resolve captive portals.
