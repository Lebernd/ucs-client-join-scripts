# Become root
sudo bash <<"EOF"

echo '*;*;*;Al0000-2400;audio,cdrom,dialout,floppy,plugdev,adm' \
   >>/etc/security/group.conf

cat >>/usr/share/pam-configs/local_groups <<__EOF__
Name: activate /etc/security/group.conf
Default: yes
Priority: 900
Auth-Type: Primary
Auth:
    required    pam_group.so use_first_pass
__EOF__

DEBIAN_FRONTEND=noninteractive pam-auth-update --force

EOF
