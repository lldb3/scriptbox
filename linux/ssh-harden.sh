#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "Please run as root. Stopping"
    exit 1
fi

# https://www.ssh-audit.com/hardening_guides.html

if [[ -f /etc/redhat-release ]]; then
    rm -f /etc/ssh/ssh_host_*
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
    chgrp ssh_keys /etc/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_rsa_key
    chmod g+r /etc/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_rsa_key
    awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe
    mv -f /etc/ssh/moduli.safe /etc/ssh/moduli
    sed -i 's/^HostKey \/etc\/ssh\/ssh_host_ecdsa_key$/\#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/g' /etc/ssh/sshd_config
    cp /etc/crypto-policies/back-ends/opensshserver.config /etc/crypto-policies/back-ends/opensshserver.config.orig
    echo -e "CRYPTO_POLICY='-oCiphers=chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr -oMACs=hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com -oGSSAPIKexAlgorithms=gss-curve25519-sha256- -oKexAlgorithms=curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256 -oHostKeyAlgorithms=ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512 -oPubkeyAcceptedKeyTypes=ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512'" > /etc/crypto-policies/back-ends/opensshserver.config
    systemctl restart sshd.service
elif [[ -f /etc/lsb-release ]]; then
    rm /etc/ssh/ssh_host_*
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
    awk '$5 >= 3071' /etc/ssh/moduli >/etc/ssh/moduli.safe
    mv /etc/ssh/moduli.safe /etc/ssh/moduli
    sed -i 's/^\#HostKey \/etc\/ssh\/ssh_host_\(rsa\|ed25519\)_key$/HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config
    echo -e "\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org,gss-curve25519-sha256-,diffie-hellman-group16-sha512,gss-group16-sha512-,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\nHostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-256-cert-v01@openssh.com" >/etc/ssh/sshd_config.d/ssh-audit_hardening.conf
    service ssh restart
fi
