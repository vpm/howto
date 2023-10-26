#!/bin/bash
syncthing_uid=888
syncthing_version=1.25

# create user syncthing for daemon
groupadd --gid ${syncthing_uid} --system syncthing; useradd -c syncthing --system --no-log-init --skel /dev/null --create-home --home-dir /var/lib/syncthing --shell /usr/sbin/nologin syncthing --gid ${syncthing_uid} --uid ${syncthing_uid}

# download syncthing archive
wget https://github.com/syncthing/syncthing/releases/download/v${syncthing_version}/syncthing-linux-amd64-v${syncthing_version}.tar.gz

# extract syncthing binary
tar -xvf syncthing-linux-amd64-v${syncthing_version}.tar.gz --strip-components=1 -C /var/lib/syncthing syncthing-linux-amd64-v${syncthing_version}/syncthing

# change owner for syncthing binary
chown syncthing /var/lib/syncthing/syncthing; chgrp syncthing /var/lib/syncthing/syncthing; 

# create syncthing.service
cat > /etc/systemd/system/syncthing.service << EOF
[Unit]
Description=Syncthing - Open Source Continuous File Synchronization
After=network.target

[Service]
User=syncthing
ExecStart=/var/lib/syncthing/syncthing serve --no-default-folder --no-browser --no-restart --logflags=0
Environment=GOMAXPROCS=2
Restart=on-failure
RestartSec=5
SuccessExitStatus=3 4
RestartForceExitStatus=3 4

# Hardening
ProtectSystem=full
PrivateTmp=true
SystemCallArchitectures=native
MemoryDenyWriteExecute=true
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF

# enable and run syncthing.service
systemctl daemon-reload; systemctl reenable syncthing.service; systemctl restart syncthing.service
