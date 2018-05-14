### Notes-CISCO switch  
  
```bash
# enables privileged EXEC mode(enter your password if prompted) 
Switch> en
```  
#### Some show command  
```bash
# show all the interface
Switch# show int br
Switch# show int
Switch# show bgp
Switch# show ip route
Switch# show cdp neighbors
```
#### Convert a port into a routed port
```bash
#affects only a single port of a L3 Switch
#makes the port into a routed port and you can apply an IP address directly to the port 
#and can't be assigned to a certain VLAN, as its now a routed port not a switched port
# get into the configuration terminal
Switch# conf t
# set an ip address to an interface
Switch(config)# int [interface]
Switch(config)# no switchport
```
#### Set ip address to an interface    
```bash
# get into the configuration terminal
Switch# conf t
# set an ip address to an interface
Switch(config)# int [interface]
Switch(config-if)# ip add [ip.addr.you.want] [the.mask.of.ip]
# no shutdown
Switch(config-if)# no shut
Switch(config-if)# end
```
#### Write to start-up configuration
```bash
#`do wr` works in configure mode of console and `wr` works in normal console window
Switch(config)# do wr
#or
Switch# wr
```
#### Set up OSPF  
```bash
Switch(config)# router ospf [process-id]
#Defines an interface on which OSPF runs and defines the area ID for that interface
Switch(config-router)# network [ip-address] [wildcard-mask] area [area-id] 
#for example
Switch(config)# router ospf 1
Switch(config-router)# network 10.0.0.0 0.0.0.7 area 0
Switch(config-router)# network 13.0.0.0 0.0.255.255 area 0
```

#### Set CDP (for cisco devices, use CDP instead of LLDP)  
```bash
Switch(config)# no cdp log mismatch duplex
Switch(config)# cdp timer 30
Switch(config)# cdp holdtime 120
```
#### Set up route map(for example)
```bash
#community-list
Switch(config)# ip community-list 20 deny 7000:10
Switch(config)# ip community-list 20 permit
#route-map
Switch(config)# route-map FROM-9000 permit 10
#set 'tag'
Switch(config-if)# set community 9000:10
Switch(config-if)# exit
Switch(config)# route-map TO-9000 permit 30
#only allow traffic with the 'tag'(see community-list above)
Switch(config-if)# match community 20
```
#### Set up bgp  
```bash
#example: `router bgp 8000`
Switch(config)# router bgp [ASname]
Switch(config-router)# no synchronization
Switch(config-router)# bgp log-neighbor-changes
#claim what you have
Switch(config-router)# network [ip.addr.you.want] mask [the.mask.of.ip]
#other ip in the same AS
Switch(config-router)# neighbor [another.ip.addr.xx] remote-as [AS name]
Switch(config-router)# neighbor [another.ip.addr.xx] send-community
#other ip in the other AS
Switch(config-router)# neighbor [another.ip.addr.xxx] remote-as [other AS name]
Switch(config-router)# neighbor [another.ip.addr.xxx] next-hop-self
Switch(config-router)# neighbor [another.ip.addr.xxx] send-community
#set route-map
Switch(config-router)# neighbor [another.ip.addr.xxx] route-map TO-9000 out
Switch(config-router)# neighbor [another.ip.addr.xxx] route-map FROM-9000 in
```
