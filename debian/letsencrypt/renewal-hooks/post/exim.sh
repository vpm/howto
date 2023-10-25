#!/bin/bash

install --no-target-directory --mode=600 --owner=Debian-exim --group=Debian-exim  /etc/letsencrypt/live/mail.vpm.net.ua/cert.pem /etc/exim4/mail.vpm.net.ua.cert.pem
install --no-target-directory --mode=600 --owner=Debian-exim --group=Debian-exim  /etc/letsencrypt/live/mail.vpm.net.ua/privkey.pem /etc/exim4/mail.vpm.net.ua.privkey.pem
systemctl reload exim4.service
