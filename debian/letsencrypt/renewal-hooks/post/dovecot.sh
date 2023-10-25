#!/bin/bash

install --no-target-directory --mode=600 --owner=dovecot --group=dovecot  /etc/letsencrypt/live/mail.zkr.com.ua/cert.pem /etc/dovecot/private/mail.zkr.com.ua.cert.pem
install --no-target-directory --mode=600 --owner=dovecot --group=dovecot  /etc/letsencrypt/live/mail.zkr.com.ua/privkey.pem /etc/dovecot/private/mail.zkr.com.ua.privkey.pem
systemctl reload dovecot.service
