# Become root
sudo bash <<"EOF"

# Set the IP address of the UCS DC Master, 192.168.0.3 in this example
export MASTER_IP=192.168.x.y

# mkdir /etc/univention
ssh -n root@${MASTER_IP} 'ucr shell | grep -v ^hostname=' >/etc/univention/ucr_master
echo "master_ip=${MASTER_IP}" >>/etc/univention/ucr_master
chmod 660 /etc/univention/ucr_master
. /etc/univention/ucr_master

echo "${MASTER_IP} ${ldap_master}" >>/etc/hosts

EOF
