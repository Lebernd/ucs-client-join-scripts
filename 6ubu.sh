# Become root
sudo bash <<"EOF"

# Add a field for a user name, disable user selection at the login screen
mkdir /etc/lightdm/lightdm.conf.d
cat >>/etc/lightdm/lightdm.conf.d/99-show-manual-userlogin.conf <<__EOF__
[SeatDefaults]
greeter-show-manual-login=true
greeter-hide-users=true
__EOF__

EOF
