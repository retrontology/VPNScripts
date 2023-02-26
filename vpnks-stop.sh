sudo systemctl stop transmission-daemon
sudo systemctl disable transmission-daemon
sudo systemctl stop openvpn-client@Sweden
sudo systemctl disable openvpn-client@Sweden
sudo ufw --force reset
sudo ufw default allow incoming
sudo ufw default allow outgoing
sudo ufw disable
sudo ufw --force enable
