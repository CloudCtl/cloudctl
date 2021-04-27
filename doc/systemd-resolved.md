## On systems with a dnsmasq/systemd-resolved unit consuming port 53

```
cp /etc/systemd/resolved.conf /etc/systemd/resolved.conf.bak
```
```
cat <<EOF | tee /etc/systemd/resolved.conf
[Resolve]
DNS=8.8.8.8
DNSStubListener=no
EOF
```
```
mkdir /run/systemd/resolve
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
```
```
systemctl stop dnsmasq
systemctl disable dnsmasq
pkill -KILL dnsmasq
systemctl restart systemd-resolved.service
```
```
cat /etc/resolv.conf
netstat -tulpn | grep ':53 '
```

### Now you are ready to deploy cloudctl
