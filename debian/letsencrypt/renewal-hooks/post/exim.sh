#!/bin/bash

install --no-target-directory --mode=600 --owner=Debian-exim --group=Debian-exim  /etc/letsencrypt/live/mail.zkr.com.ua/cert.pem /etc/exim4/mail.zkr.com.ua.cert.pem
install --no-target-directory --mode=600 --owner=Debian-exim --group=Debian-exim  /etc/letsencrypt/live/mail.zkr.com.ua/privkey.pem /etc/exim4/mail.zkr.com.ua.privkey.pem
systemctl reload exim4.service
