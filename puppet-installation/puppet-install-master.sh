#!/bin/bash
[[ -z "${PUPPET_PASS}" ]] || echo "PUPPET_PASS must be set"; exit 1

hostname puppet
echo "puppet" >> /etc/hostname
echo $(curl http://169.254.169.254/latest/meta-data/public-ipv4) puppet >> /etc/hosts
curl -JLO 'https://pm.puppet.com/cgi-bin/download.cgi?dist=ubuntu&rel=18.04&arch=amd64&ver=latest'
tar -xvf puppet-enterprise-2021.4.0-ubuntu-18.04-amd64.tar.gz 
./puppet-enterprise-2021.4.0-ubuntu-18.04-amd64/puppet-enterprise-installer 
puppet infrastructure console_password --password=${PUPPET_PASS}
puppet agent -t
puppet agent -t
cat >>/etc/puppetlabs/code/environments/production/manifests/site.pp <<EOF
file {'/tmp/it-works.txt':
    ensure  => present,
    mode    => '0644',
    content => "It works on ${ipaddress_eth0}!\n",
}
EOF
systemctl reload puppetserver
