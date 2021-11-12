#!/bin/bash

[[ -z "${PUPPET_MASTER_PUBLIC_IP}" ]] || echo "PUPPET_MASTER_PUBLIC_IP must be set"
[[ -z "${PUPPET_MASTER_PRIVATE_IP}" ]] || echo "PUPPET_MASTER_PRIVATE_IP must be set"
[[ -z "${PUPPET_AGENT_HOSTNAME}" ]] || echo "PUPPET_AGENT_HOSTNAME must be set"

hostname $PUPPET_AGENT_HOSTNAME
echo "$PUPPET_AGENT_HOSTNAME" >> /etc/hostname
echo $(curl http://169.254.169.254/latest/meta-data/public-ipv4) $PUPPET_AGENT_HOSTNAME >> /etc/hosts
echo $PUPPET_MASTER_PRIVATE_IP puppet >> /etc/hosts
curl -k https://puppet:8140/packages/current/install.bash | sudo bash

echo "Go to https:$PUPPET_MASTER_PUBLIC_IP and sign the certificate"
read  -n 1 -p "Press Enter to Continue" continue

puppet agent -t
cat /tmp/it-works.txt
