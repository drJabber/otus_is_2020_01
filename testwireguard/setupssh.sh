#!/bin/sh
useradd -m testuser1

echo -e "testtest\ntesttest" | passwd testuser1

echo enable psychotic repo
rpm --import http://wiki.psychotic.ninja/RPM-GPG-KEY-psychotic

echo install psychotic package
rpm -ivh http://packages.psychotic.ninja/7/base/x86_64/RPMS/psychotic-release-1.0.0-1.el7.psychotic.noarch.rpm

echo install keychain package using yum command
yum --enablerepo=psychotic -y install keychain

echo download wireguard repo
curl -Lo /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wirguard-epel-7.repo

echo yum makecahe
yum makecache

echo install -y release
yum install -y epel-release

echo install wireguard packages
yum install -y dkms wireguard-dkms wireguard-tools

echo install mc
yum  install -y mc

