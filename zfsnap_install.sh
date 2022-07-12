#!/bin/sh

wget https://raw.githubusercontent.com/zfsnap/zfsnap/master/completion/zfsnap-completion.bash -O /etc/bash_completion.d/zfsnap-completion
wget https://raw.githubusercontent.com/zfsnap/zfsnap/master/man/man8/zfsnap.8 -O /usr/share/man/man8/zfsnap.8

wget https://raw.githubusercontent.com/zfsnap/zfsnap/master/sbin/zfsnap.sh -O /usr/sbin/zfsnap
chmod 755 /usr/sbin/zfsnap

mkdir -p /usr/share/zfsnap/commands
wget https://raw.githubusercontent.com/zfsnap/zfsnap/master/share/zfsnap/core.sh -O /usr/share/zfsnap/core.sh
wget https://raw.githubusercontent.com/zfsnap/zfsnap/master/share/zfsnap/commands/destroy.sh -O /usr/share/zfsnap/commands/destroy.sh
wget https://raw.githubusercontent.com/zfsnap/zfsnap/master/share/zfsnap/commands/recurseback.sh -O  /usr/share/zfsnap/commands/recurseback.sh
wget https://raw.githubusercontent.com/zfsnap/zfsnap/master/share/zfsnap/commands/snapshot.sh -O /usr/share/zfsnap/commands/snapshot.sh
