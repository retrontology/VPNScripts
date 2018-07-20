vpnadd="sweden.privateinternetaccess.com"
ovpnconf="/etc/openvpn/PIA.conf"
vpnks="/home/user/scripts/vpnks-start.sh"
readarray vpnips <<< $(dig +short $vpnadd)
vpnip=${vpnips[((RANDOM % ${#vpnips[@]}))]}
vpnip=$(echo $vpnip | tr -d '\r')
if [[ $vpnip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
then
  sed -i "s/vpnip=.*/vpnip=$vpnip/" 
  sudo sed -i "s/remote\ .*/remote\ $vpnip\ 1198/" $ovpnconf
  echo "VPN IP changed to "$vpnip
else
  echo "ERROR: Could not parse an IP"
fi
