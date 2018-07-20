vpnip=0.0.0.0
netname=eth0
vpnport="1198/udp"
vpnname="tun0"
localnet=$localnet
sudo ufw --force reset
sudo ufw default deny outgoing
sudo ufw default deny incoming
sudo ufw allow in from $vpnip to any
sudo ufw allow out from any to $vpnip
sudo ufw allow out on $vpnname from any
sudo ufw allow in on $vpnname from any
sudo ufw allow 53
sudo ufw allow in from $localnet to any
sudo ufw allow out from any to $localnet
sudo ufw allow in on $netname from $localnet
sudo ufw allow out on $netname from $localnet
sudo ufw allow in on $netname to $localnet
sudo ufw allow out on $netname to $localnet
sudo ufw allow from 127.0.0.1
sudo ufw allow 22
sudo ufw allow out $vpnport
sudo ufw disable
sudo ufw --force enable
sudo systemctl start openvpn
sudo systemctl enable openvpn
sudo systemctl start transmission-daemon
sudo systemctl enable transmission-daemon
./port_forwarding.sh
