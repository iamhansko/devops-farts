# network_mode: host

Add `net.ipv4.ip_unprivileged_port_start=0` at the end of `/etc/sysctl.conf` and **Reboot**
to support PUID/PGID in network_mode: host