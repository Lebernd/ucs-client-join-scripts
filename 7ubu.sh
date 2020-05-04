# Become root
sudo bash <<"EOF"

. /etc/univention/ucr_master

# Install required packages
DEBIAN_FRONTEND=noninteractive apt-get install -y heimdal-clients ntpdate

# Default krb5.conf
cat >/etc/krb5.conf <<__EOF__
[libdefaults]
    default_realm = $kerberos_realm
    kdc_timesync = 1
    ccache_type = 4
    forwardable = true
    proxiable = true
    default_tkt_enctypes = arcfour-hmac-md5 des-cbc-md5 des3-hmac-sha1 des-cbc-crc des-cbc-md4 des3-cbc-sha1 aes128-cts-hmac-sha1-96 aes256-cts-hmac-sha1-96
    permitted_enctypes = des3-hmac-sha1 des-cbc-crc des-cbc-md4 des-cbc-md5 des3-cbc-sha1 arcfour-hmac-md5 aes128-cts-hmac-sha1-96 aes256-cts-hmac-sha1-96
    allow_weak_crypto=true

[realms]
$kerberos_realm = {
   kdc = $master_ip $ldap_master
   admin_server = $master_ip $ldap_master
   kpasswd_server = $master_ip $ldap_master
}
__EOF__

# Synchronize the time with the UCS system
ntpdate -bu $ldap_master

# Test Kerberos: kinit will ask you for a ticket and the SSH login to the master should work with ticket authentication:
kinit Administrator
ssh -n Administrator@$ldap_master ls /etc/univention

# Destroy the kerberos ticket
kdestroy

EOF
