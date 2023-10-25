#!/bin/bash

install --no-target-directory --mode=600 --owner=dovecot --group=dovecot  /etc/letsencrypt/live/mail.vpm.net.ua/cert.pem /etc/dovecot/private/mail.vpm.net.ua.cert.pem
install --no-target-directory --mode=600 --owner=dovecot --group=dovecot  /etc/letsencrypt/live/mail.vpm.net.ua/privkey.pem /etc/dovecot/private/mail.vpm.net.ua.privkey.pem
systemctl reload dovecot.service
