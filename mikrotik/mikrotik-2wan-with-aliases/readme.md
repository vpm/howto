Mikrotik have 2 wan interfases (ether1, ether2) with 2 ip on each 10.100.100.100,10.100.100.111 on ether1 and 10.200.200.200, 10.200.200.222 on ether2.
Private network interface ether3 and ip address 10.255.255.1 netmask 255.255.255.0 , mail server has lan ip 10.255.255.55
 
for check, you can ping host and see connect tracking in /ip/firewall/connections

network schema:
-----------------      ------------------------------------------------------------------------------------
primary inet     |    |                                mikrotik gateway                                    |     ----------------------
10.100.100.1/24) | -> | (ether1 10.100.100.100/24; ether1-alias1 10.100.100.111/24)                        |    | mail server          |
-----------------     |                                                              (ether3 10.255.255.1) | -> | (eth0 10.255.255.55) |
-----------------     |                                                                                    |     ----------------------
secondary inet   |    |                                                                                    |
10.200.200.1/24) | -> | (ether2 10.200.200.200/24; ether2-alias1 10.200.200.222/24)                        |
-----------------      -------------------------------------------------------------------------------------
