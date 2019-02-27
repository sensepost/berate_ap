# Berate_ap 
[Create_ap](https://github.com/oblique/create_ap) has been modified to run EAP networks and [hostapd-mana](https://github.com/sensepost/hostapd-mana) with multiple options

## Setup
This script requires hostapd-mana to be in the path.

This may be done by adding the binary to your path directly:
```
export PATH="$PATH:/path/to/hostapd-mana"
```
To make this permanent you may add to your shells .rc file

or you may link hostapd-mana into a directory that is within your path
```
cd /usr/bin
sudo ln -s /path/to/hostapd-mana hostapd-mana
```

## Attacks

Run Mana to trick users into connecting to your access point. The eap users file is not passed so that the default mana eap user file is used: 

    berate_ap --eap --mana wlan0 eth0 MyAccessPoint 
    
Mana WPE attacks are no longer done by default when using `--mana` and have to be enabled seperatly:

    berate_ap --eap --mana-wpe wlan0 eth0 MyAccessPoint
    
Other Mana WPE options avaliable are `--mana-eapsuccess` and `--mana-eaptls`, the location of the credout file is by default `/tmp/hostapd.credout` but may be specified with `--mana-credout <file>` (Preferable to use full path). More information on these may be found in the [Hostapd-mana wiki](https://github.com/sensepost/hostapd-mana/wiki/MANA-EAP-Options-(aka-WPE)).

Run Mana in loud mode to show devices every access point seen by Mana:

    berate_ap --eap --mana --mana-loud wlan0 eth0 MyAccessPoint 

Run Mana and bridge the network connection to your ethernet address: 

    berate_ap --eap --mana -m bridge wlan0 eth0 MyAccessPoint 

Run Mana and be stingy by not providing any upstream Internet access:

    berate_ap --eap --mana -n wlan0 MyAccessPoint  

<!--Run Mana and host one of each network type to catch as many people as possible.

    berate_ap --trifecta --mana wlan0 eth0 MyAccessPoint -->

## More Convincing Certificate

When running your Rogue AP users may be presented with your certificate when authenticating, it is in your interest to make your certificate look as similar to the legitimate APs as possible. When running a EAP access point `berate_ap` will ask you to fill in fields to generate the certificate to be used, try input sensible values. 
To get the values of the certificate in use by the legitimate AP use [this script](https://gist.github.com/singe/40bda2a1772aaf4903515cc4e436afe5) to extract the certificate from a packet capture: 
```
./extract_EAP.sh -r <capture file>
```
or interface in monitor mode:
```
airmon-ng start <interface> <channel>
./extract_EAP.sh -i <interface>
```
you may then view the certificate with:
```
openssl x509 -text -inform der -in <capturedcert>.der
```
Which will allow you to see the values set in the cert so that with berate you may generate a more appealing looking AP.

## Features
* Create an AP (Access Point) at any channel.
* Choose one of the following encryptions: WPA, WPA2, WPA/WPA2, Open (no encryption).
* Support for Enterprise setups
* Hide your SSID.
* Disable communication between clients (client isolation).
* IEEE 802.11n & 802.11ac support
* Internet sharing methods: NATed or Bridged or None (no Internet sharing).
* Choose the AP Gateway IP (only for 'NATed' and 'None' Internet sharing methods).
* You can create an AP with the same interface you are getting your Internet connection.
* You can pass your SSID and password through pipe or through arguments (see examples).


## Dependencies
### General
* bash (to run this script)
* util-linux (for getopt)
* procps or procps-ng
* hostapd
* iproute2
* iw
* iwconfig (you only need this if 'iw' can not recognize your adapter)
* haveged (optional)

### For 'NATed' or 'None' Internet sharing method
* dnsmasq
* iptables


## Installation
### Generic
    git clone https://github.com/sensepost/berate_ap

## Examples
### No passphrase (open network):
    berate_ap wlan0 eth0 MyAccessPoint

### WPA + WPA2 passphrase:
    berate_ap wlan0 eth0 MyAccessPoint MyPassPhrase

### AP without Internet sharing:
    berate_ap -n wlan0 MyAccessPoint MyPassPhrase

### Bridged Internet sharing:
    berate_ap -m bridge wlan0 eth0 MyAccessPoint MyPassPhrase

### Bridged Internet sharing (pre-configured bridge interface):
    berate_ap -m bridge wlan0 br0 MyAccessPoint MyPassPhrase

### Internet sharing from the same WiFi interface:
    berate_ap wlan0 wlan0 MyAccessPoint MyPassPhrase

### Choose a different WiFi adapter driver
    berate_ap --driver rtl871xdrv wlan0 eth0 MyAccessPoint MyPassPhrase

### No passphrase (open network) using pipe:
    echo -e "MyAccessPoint" | berate_ap wlan0 eth0

### WPA + WPA2 passphrase using pipe:
    echo -e "MyAccessPoint\nMyPassPhrase" | berate_ap wlan0 eth0

### Enable IEEE 802.11n
    berate_ap --ieee80211n --ht_capab '[HT40+]' wlan0 eth0 MyAccessPoint MyPassPhrase

### Client Isolation:
    berate_ap --isolate-clients wlan0 eth0 MyAccessPoint MyPassPhrase

### Enterprise Network built-in RADIUS
    berate_ap --eap --eap-user-file /tmp/users.eap_hosts --eap-cert-path /tmp/certificates wlan0 eth0 MyAccessPoint 

### Enterprise Network Remote RADIUS
    berate_ap --eap --radius-server 192.168.1.1:1812 --radius-secret=P@ssw0rd wlan0 eth0 MyAccessPoint

## Systemd service
Using the persistent [systemd](https://wiki.archlinux.org/index.php/systemd#Basic_systemctl_usage) service
### Start service immediately:
    systemctl start create_ap

### Start on boot:
    systemctl enable create_ap


## License
FreeBSD
