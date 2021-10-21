# Notes-XRDP  
Test environment  
```
Server: xrdp
Client: Remmina
```
---
## Cannot start i3wm   
Add following before other exec command in /etc/xrdp/startwm.sh
```
test -x /usr/bin/i3 && exec /usr/bin/i3
```
---
## Cannot change resolution on-the-fly
This is a feature introduced in xrdp v0.9.16, which may not be available in some distribution

