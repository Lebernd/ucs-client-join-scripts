# Become root
sudo bash <<"EOF"

. /etc/univention/ucr_master

# Download the SSL certificate
# schon gemacht
#mkdir -p /etc/univention/ssl/ucsCA/
#wget -O /etc/univention/ssl/ucsCA/CAcert.pem \
#    http://${ldap_master}/ucs-root-ca.crt

# Create an account and save the password
# Modify account - hostname = <opensuseleap> 

password="$(tr -dc A-Za-z0-9_ </dev/urandom | head -c20)"
ssh -n root@${ldap_master} udm computers/linux modify \
    --dn "cn=<opensuseleap>,cn=computers,${ldap_base}" \
    --position "cn=computers,${ldap_base}" \
    --set password="${password}" 

printf '%s' "$password" >/etc/openldap/ldap.secret
chmod 0400 /etc/openldap/ldap.secret

# Create ldap.conf
cat >/etc/openldap/ldap.conf <<__EOF__
TLS_CACERT /etc/univention/ssl/ucsCA/CAcert.pem
URI ldap://$ldap_master:7389
BASE $ldap_base
__EOF__

EOF

