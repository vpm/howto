#!/bin/bash
SRV1CV8_VERSION=${PWD##*/}

dpkg -i libenchant1c2a_1.6.0-11.1+b1_amd64.deb aksusbd_8.43-1_amd64.deb

# hasp localhost
echo "bind_local_only=1" >> /etc/hasplm/hasplm.ini

#
systemctl reenable aksusbd

#
systemctl restart aksusbd


# Stop 1C and RAS service
systemctl stop srv1cv83.service ras1cv83.service

# Uninstall old 1C 
if [ -f /opt/1cv8/x86_64/*/uninstaller-full ] ; then /opt/1cv8/x86_64/*/uninstaller-full --mode unattended; fi
if [ -f /opt/1cv8/x86_64/*/uninstaller-full ] ; then /opt/1cv8/x86_64/*/uninstaller-full --mode unattended; fi
if [ -f /opt/1cv8/x86_64/*/uninstaller-full ] ; then /opt/1cv8/x86_64/*/uninstaller-full --mode unattended; fi

# install 1C server
chmod 755 setup-full-${SRV1CV8_VERSION}-x86_64.run

./setup-full-${SRV1CV8_VERSION}-x86_64.run --mode unattended --enable-components server

# Create 1C Service
cat > /etc/systemd/system/srv1cv83.service << EOF
[Unit]
Description=1C:Enterprise Server 8.3 (${SRV1CV8_VERSION})
Requires=network.target

[Service]
Type=simple
User=usr1cv8
Group=grp1cv8
ExecStart=/opt/1cv8/x86_64/${SRV1CV8_VERSION}/ragent -d /home/usr1cv8/.1cv8/1C/1cv8 -port 1540 -regport 1541 -range 1560:1591 -seclev 0 -pingPeriod 1000 -pingTimeout 5000 -debug -http
PrivateTmp=true
Restart=always
RestartSec=1

[Install]
DefaultInstance=default
WantedBy=multi-user.target

EOF

# Create RAS Service
cat > /etc/systemd/system/ras1cv83.service << EOF
[Unit]
Description=1C:Enterprise Remote Administration Server 8.3 (${SRV1CV8_VERSION})
Requires=network.target

[Service]
Type=simple
User=usr1cv8
Group=grp1cv8
ExecStart=/opt/1cv8/x86_64/${SRV1CV8_VERSION}/ras cluster
PrivateTmp=true
Restart=always
RestartSec=1

[Install]
WantedBy=multi-user.target
EOF


#
systemctl daemon-reload 

#
systemctl reenable srv1cv83 ras1cv83

#
systemctl restart srv1cv83 ras1cv83
