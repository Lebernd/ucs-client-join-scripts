# Become root
sudo bash <<"EOF"

. /etc/univention/ucr_master

# Install SSSD based configuration
# DEBIAN_FRONTEND=noninteractive apt-get -y install sssd libnss-sss libpam-sss libsss-sudo

# Create sssd.conf
cat >/etc/sssd/sssd.conf <<__EOF__
[sssd]
config_file_version = 2
reconnection_retries = 3
sbus_timeout = 30
services = nss, pam, sudo
domains = $kerberos_realm

[nss]
reconnection_retries = 3

[pam]
reconnection_retries = 3

[domain/$kerberos_realm]
auth_provider = krb5
krb5_kdcip = ${master_ip}
krb5_realm = ${kerberos_realm}
krb5_server = ${ldap_master}
krb5_kpasswd = ${ldap_master}
id_provider = ldap
ldap_uri = ldap://${ldap_master}:7389
ldap_search_base = ${ldap_base}
ldap_tls_reqcert = never
ldap_tls_cacert = /etc/univention/ssl/ucsCA/CAcert.pem
cache_credentials = true
enumerate = true
ldap_default_bind_dn = cn=$(hostname),cn=computers,${ldap_base}
ldap_default_authtok_type = password
ldap_default_authtok = $(cat /etc/openldap/ldap.secret)
__EOF__
chmod 600 /etc/sssd/sssd.conf

# Install auth-client-config
### für suse ändern auch oben
# DEBIAN_FRONTEND=noninteractive apt-get -y install auth-client-config


# Restart sssd
service sssd restart

EOF
