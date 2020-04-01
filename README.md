# Deluge with OpenVPN in Docker

Torrent privately without messing up network settings.

## OpenVPN Setup

Put all relevant OpenVPN configuration files in `etc-openvpn`, which is mounted as a volume to `/etc/openvpn` in the container. Put the main OpenVPN configuration file in `etc-openvpn/config.ovpn`. For example with Mullvad VPN, download OpenVPN configuration files from the Mullvad website and extract to `etc-openvpn`. Then run

```
mv mullvad_*-*.conf config.ovpn
sed -i 's/^ca mullvad_ca.crt$/ca \/etc\/openvpn\/mullvad_ca.crt/' config.ovpn
sed -i 's/^auth_user_pass mullvad_userpass.txt$/auth_user_pass \/etc\/openvpn\/mullvad_userpass.txt/' config.ovpn
chmod +x update-resolv-conf
```

## Usage

Build the image with `build`. To run the container, use `run <downloads location>`. For example, `./run ~/Downloads`. Access the web UI at `http://localhost:8112/`. Stop the container with `stop`, and get a shell in the container with `getshell` in case something goes wrong.

## Permissions

Make sure `run` is executed as the user that you want to have ownership over the downloads directory. The scripts create a user in the container corresponding to the user executing `run` and deluged is executed by that user.
