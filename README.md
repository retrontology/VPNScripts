# Retrontology's VPN Killswitch Scripts

### Description
These are a collection of bash scripts to use the Private Internet Access OpenVPN based VPN with a systemd based linux system. They also modify firewall rules (via `ufw`) to channel traffic solely through the VPN interface to prevent leaking information.

Note: These have been retired in favor of the fork of the Private Internet Access Wireguard based scripts located here: https://github.com/retrontology/manual-connections

### Requirements
- `jq`
- `openvpn`
- `ufw`
- `dig`
- `systemd` (optional)

### Setup
1. Download the `.ovpn` file collection you wish to use from https://helpdesk.privateinternetaccess.com/kb/articles/where-can-i-find-your-ovpn-files
2. Extract the archive and rename all the `.ovpn` files with the `.conf` extension:
    ```
    for i in *.ovpn; do mv "$i" "${i%%ovpn}conf"; done
    ```
3. Copy all the `.conf` files from the step above to the `/etc/openvpn/client/` directory
4. Note down the configuration file you wish to use for further setup

---

## `vpnks-start.sh`

### Description
The script that starts the VPN connection, enables the firewall to prevent leaks, and start up systemd services you want to channel through the VPN.

### Setup
1. Change the variables at the beginning of the script to reflect your setup
2. Modify the `systemctl` commands to start the services you want to run through the VPN (optional)
3. Modify the `systemctl <start/enable> openvpn-client@<config>` lines to use the config you've picked out
4. Comment or remove the `./port_forwarding.sh` line if you don't want to use port forwarding for Transmission

### Usage
```
./vpnks-start.sh
```

---

## `port_forwarding.sh`

### Description
A script that requests port forwarding from PIA and configures Transmission to use the forwarded port

### Setup
Change the variables at the beginning of the script to reflect your Transmission setup

### Usage
```
./port_forwarding.sh
```

---

## `vpnks-stop.sh`

### Description
The script that stops the VPN connection, tears down the firewall, and stops the sytemd services you want to channel through the VPN.

### Setup
1. Modify the `systemctl` commands to stop the services you want to run through the VPN (optional)
2. Modify the `systemctl <stop/disable> openvpn-client@<config>` lines to use the config you've picked out

### Usage
```
./vpnks-stop.sh
```

---

## `vpnks-change.sh`

### Description
This is a script designed to change the VPN server you are connecting to within the same region. It's handy for when the server you are currently using is bogged down with traffic from other people.

### Setup
1. Change the `vpnadd` variable to the url of the region you want: `<region>.privateinternetaccess.com`
2. Change the `ovpnconf` variable to the `.conf` file you set up for the previous scripts
3. Change the `vpnks` variable to the location of the `vpnks-start.sh` script

### Usage
```
./vpnks-change.sh
```

---

## `vpnks-restart.sh`

### Description
A simple script that calls, in order:
1. `vpnks-change.sh`
2. `vpnks-stop.sh`
3. `vpnks-start.sh`

It's useful for a restart function of a systemd service

### Setup
Ensure the scripts are set to the proper location

### Usage
```
./vpnks-change.sh
```
