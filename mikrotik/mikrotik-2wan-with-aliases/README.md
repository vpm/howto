Mikrotik RouterOS 7 have 2 wan interfases (ether1, ether2) with 2 ip on each
10.100.100.100,10.100.100.111 on ether1
10.200.200.200, 10.200.200.222 on ether2.
Private network interface ether3 and ip address 10.255.255.1 netmask 255.255.255.0,
mail server has lan ip 10.255.255.55

![Alt text](mikrotik-2wan-with-aliases-schema.png?raw=true "IP Address list")

Interfaces ip configuration
```
/ip address
add address=10.100.100.100/24 interface=ether1 network=10.100.100.0
add address=10.200.200.200/24 interface=ether2 network=10.200.200.0
add address=10.100.100.111/24 interface=ether1 network=10.100.100.0
add address=10.200.200.222/24 interface=ether2 network=10.200.200.0
add address=10.255.255.1/24 interface=bridge-lan network=10.255.255.0
```
![Alt text](mikrotik-2wan-with-aliases-ip-adddress-list.png?raw=true "IP Address list")

Add routing tables for all interfaces
```
/routing table
add disabled=no fib name=rtab-ether1
add disabled=no fib name=rtab-ether2
add disabled=no fib name=rtab-ether1-alias1
add disabled=no fib name=rtab-ether2-alias1
```
![Alt text](mikrotik-2wan-with-aliases-routing-tables.png?raw=true "Routing tables")

Create routing table. Add route for eatch alias with distance more then default routes whithout pref source and set pref source ip alias for each
```
/ip route
add check-gateway=ping disabled=no distance=1 dst-address=0.0.0.0/0 gateway=10.100.100.1 pref-src="" routing-table=main scope=30 suppress-hw-offload=no target-scope=10
add disabled=no distance=2 dst-address=0.0.0.0/0 gateway=10.200.200.1 pref-src="" routing-table=main scope=30 suppress-hw-offload=no target-scope=10
add disabled=no distance=255 dst-address=0.0.0.0/0 gateway=10.100.100.1 pref-src=10.100.100.111 routing-table=rtab-ether1-alias1 scope=30 suppress-hw-offload=no target-scope=10
add disabled=no distance=255 dst-address=0.0.0.0/0 gateway=10.200.200.1 pref-src=10.200.200.222 routing-table=rtab-ether2-alias1 scope=30 suppress-hw-offload=no target-scope=10
```
![Alt text](mikrotik7-2wan-with-aliases-ip-route-list.png?raw=true "IP Route list")

Mark traffic from 10.255.255.55
```
/ip firewall mangle
add action=mark-connection chain=prerouting connection-mark=no-mark dst-address=10.100.100.111 in-interface=ether1 new-connection-mark=conection-ether1-alias1 passthrough=yes
add action=mark-connection chain=prerouting connection-mark=no-mark dst-address=10.200.200.222 in-interface=ether2 new-connection-mark=conection-ether2-alias1 passthrough=yes
add action=mark-routing chain=prerouting connection-mark=conection-ether1-alias1 in-interface=!ether1 new-routing-mark=rtab-ether1-alias1 passthrough=yes src-address=10.255.255.55
add action=mark-routing chain=prerouting connection-mark=conection-ether2-alias1 in-interface=!ether2 new-routing-mark=rtab-ether2-alias1 passthrough=yes src-address=10.255.255.55
add action=mark-routing chain=output connection-mark=conection-ether1-alias1 new-routing-mark=rtab-ether1-alias1 passthrough=yes src-address=10.255.255.55
add action=mark-routing chain=output connection-mark=conection-ether2-alias1 new-routing-mark=rtab-ether2-alias1 passthrough=yes src-address=10.255.255.55
```

Mark other traffic from local network 10.255.255.0/24 via ether1 and ether2
```
/ip firewall mangle
add action=mark-connection chain=prerouting connection-mark=no-mark dst-address=10.100.100.100 in-interface=ether1 new-connection-mark=conection-ether1 passthrough=yes
add action=mark-connection chain=prerouting connection-mark=no-mark dst-address=10.200.200.200 in-interface=ether2 new-connection-mark=conection-ether2 passthrough=yes
add action=mark-routing chain=prerouting connection-mark=conection-ether1 in-interface=!ether1 new-routing-mark=rtab-ether1 passthrough=yes src-address=10.255.255.0/24
add action=mark-routing chain=prerouting connection-mark=conection-ether2 in-interface=!ether2 new-routing-mark=rtab-ether2 passthrough=yes src-address=10.255.255.0/24
add action=mark-routing chain=output connection-mark=conection-ether1 new-routing-mark=rtab-ether1 passthrough=yes src-address=10.255.255.0/24
add action=mark-routing chain=output connection-mark=conection-ether2 new-routing-mark=rtab-ether2 passthrough=yes src-address=10.255.255.0/24
```
![Alt text](mikrotik7-2wan-with-aliases-ip-firewall-mangle.png?raw=true "IP Firewall Mangle")

First rules for incoming traffic from wan to mail-server 10.255.255.55 ports 25,80,443,587
```
/ip firewall nat
add action=dst-nat chain=dstnat comment="smtp mail" dst-address=10.100.100.111 dst-port=25,80,443,587 in-interface=ether1 protocol=tcp to-addresses=10.255.255.55
add action=dst-nat chain=dstnat comment="smtp mail" dst-address=10.200.200.222 dst-port=25,80,443,587 in-interface=ether2 protocol=tcp to-addresses=10.255.255.55
```

NAT outgoing traffic from 10.255.255.55 via ether1 alias and ether2 alias
```
/ip firewall nat 
add action=src-nat chain=srcnat out-interface=ether1 src-address=10.255.255.55 to-addresses=10.100.100.111
add action=src-nat chain=srcnat out-interface=ether2 src-address=10.255.255.55 to-addresses=10.200.200.222
```

NAT others outgoing traffic from local network 10.255.255.0/24 via ether1 and ether2
```
/ip firewall nat
add action=src-nat chain=srcnat out-interface=ether1 src-address=10.255.255.0/24 to-addresses=10.100.100.100
add action=src-nat chain=srcnat out-interface=ether2 src-address=10.255.255.0/24 to-addresses=10.200.200.200
```
![Alt text](mikrotik-2wan-with-aliases-ip-firewall-nat.png?raw=true "IP Firewall Nat")


For check, you can ping host and see connections tracking in
```
/ip/firewall/connections
```
![Alt text](mikrotik-2wan-with-aliases-ip-firewall-connections.png?raw=true "IP Firewall Connections")
