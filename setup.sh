#!/bin/bash
install-omnia feed --ssb-caps /run/secrets/caps.json \
        --ssb-external $EXT_IP \
        --keystore /run/secrets \
        --password /run/secrets/password.txt \
        --from $ETH_FROM
chown -R omnia /home/omnia/.ssb/
cat /etc/omnia.conf
