# Create the tun device path if required
mkdir -p /dev/net
mknod /dev/net/tun c 10 200 # TODO write an explination as to why this is needed


echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

# Wait 5s for the daemon to start and then run tailscale up to configure
echo "Starting Tailscale client in 5 seconds with routes ${ADVERTISE_ROUTES}"
/bin/sh -c "sleep 5; /usr/bin/tailscale up --accept-routes --advertise-routes=${ADVERTISE_ROUTES}" &
exec /usr/sbin/tailscaled --state=/tailscale/tailscaled.state
