Mikrotik have 2 wan interfases (ether1, ether2) with 2 ip on each 10.100.100.100,10.100.100.111 on ether1 and 10.200.200.200, 10.200.200.222 on ether2.
Private network interface ether3 and ip address 10.255.255.1 netmask 255.255.255.0 , mail server has lan ip 10.255.255.55
 
![Alt text](mikrotik-2wan-with-aliases-ip-adddress-list.png?raw=true "IP Address list")

![Alt text](mikrotik-2wan-with-aliases-routing-tables.png?raw=true "Routing tables")

![Alt text](mikrotik-2wan-with-aliases-ip-route-list.png?raw=true "IP Route list")

![Alt text](mikrotik-2wan-with-aliases-ip-firewall-mangle.png?raw=true "IP Firewall Mangle")

![Alt text](mikrotik-2wan-with-aliases-ip-firewall-nat.png?raw=true "IP Firewall Nat")






For check, you can ping host and see connect tracking in /ip/firewall/connections
![Alt text](mikrotik-2wan-with-aliases-ip-firewall-connections.png?raw=true "IP Firewall Connections")
