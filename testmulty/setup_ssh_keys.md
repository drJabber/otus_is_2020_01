
#node1:
ssh-keygen -t rsa

#/root/.ssh/node2_rsa

#node2: in sshd_config password auth should be ON 
#node1:
ssh-copy-id -i node2_rsa.pub testuser1@node2.local

#initially install keychain on node1, 
#node1:
rpm --import http://wiki.psychotic.ninja/RPM-GPG-KEY-psychotic
rpm -ivh http://packages.psychotic.ninja/7/base/x86_64/psychotic-release-1.0.0-1.el7.psychotic.noarch.rpm
yum --enablerepo-psychotic install keychain

#then
#node1:
keychain $HOME/.ssh/node2_rsa

#node1:
ssh -A -i node2_rsa testuser1@node2.local

#node2
 ssh testuser1@172.16.99.102

