### Notes-CISCO switch  
  
#### Some basic commands  
```bash
# Enables privileged EXEC mode(enter your password if prompted) 
Switch> en
# Get into configuration terminal
Switch# conf t
# Get out of configuration terminal
Switch(config-if)# exit
Switch(config-if)# end
```
#### Some "show" commands  
```bash
# Show all the interfaces
Switch# show int br
Switch# show int
Switch# show bgp
Switch# show ip route
Switch# show cdp neighbors
```
#### Convert a port into a routed port
```bash
# Affects only a single port of a L3 Switch
# Makes the port into a routed port 
#   then you can apply an IP address directly to the port 
#   but can't be assigned to a certain VLAN 
#   as it's now a routed port not a switched port
# Set an ip address to an interface
Switch(config)# int [interface]
Switch(config-if)# no switchport
```
#### Set IP address to an interface    
```bash
# Set an IP address to an interface
Switch(config)# int [interface]
Switch(config-if)# ip add [ip.addr.you.want] [the.mask.of.ip]
# No shutdown
Switch(config-if)# no shut
```
#### Write current configuration to start-up configuration
```bash
# "do wr" works in configure mode of console 
#   and "wr" works in normal console window
Switch(config)# do wr
#or
Switch# wr
```
#### Set up OSPF  
```bash
Switch(config)# router ospf [process-id]
# Defines an interface on which OSPF runs
#   and defines the area ID for that interface
Switch(config-router)# network [ip-address] [wildcard-mask] area [area-id] 
# Example
Switch(config)# router ospf 1
Switch(config-router)# network 10.0.0.0 0.0.0.7 area 0
Switch(config-router)# network 13.0.0.0 0.0.255.255 area 0
```

#### Set up CDP (for cisco devices, use CDP instead of LLDP)  
```bash
Switch(config)# no cdp log mismatch duplex
Switch(config)# cdp timer 30
Switch(config)# cdp holdtime 120
```
#### Set up route map (example)
```bash
# Community-list 20, deny traffic with "tag" "7000:10"
Switch(config)# ip community-list 20 deny 7000:10
Switch(config)# ip community-list 20 permit
```
```bash
# Used in BGP below
# Two route-map: FROM-9000 and TO-9000
#   FROM-9000: set a tag, TO-9000: obey rules of "community-list 20"
# Route-map
Switch(config)# route-map FROM-9000 permit 10
# Set 'tag'
Switch(config-if)# set community 9000:10
Switch(config)# route-map TO-9000 permit 30
# Only allows traffic that "community-list 20" allows (see above)
Switch(config-if)# match community 20
```
#### Set up BGP (example)  
```bash
Switch(config)# router bgp 8000
Switch(config-router)# no synchronization
Switch(config-router)# bgp log-neighbor-changes
# Claim what you have
Switch(config-router)# network 13.0.0.0 mask 255.255.0.0
# Other IPs in the same AS
Switch(config-router)# neighbor 10.0.0.2 remote-as 8000
Switch(config-router)# neighbor 10.0.0.2 send-community
#other IPs in the other AS
Switch(config-router)# neighbor 197.0.0.2 remote-as 9000
Switch(config-router)# neighbor 197.0.0.2 next-hop-self
Switch(config-router)# neighbor 197.0.0.2 send-community
#set route-map for outbound and inbound traffic
Switch(config-router)# neighbor 197.0.0.2 route-map TO-9000 out
Switch(config-router)# neighbor 197.0.0.2 route-map FROM-9000 in
```
