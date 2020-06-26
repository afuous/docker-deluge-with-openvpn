#!/bin/bash

user=$1
uid=$2
gid=$3

groupadd --gid $gid $user
useradd -m --uid $uid --gid $gid $user

# https://github.com/kylemanna/docker-openvpn/issues/39#issuecomment-100984364
# https://github.com/kylemanna/docker-openvpn/blob/master/bin/ovpn_run#L57-L60
mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
	    mknod /dev/net/tun c 10 200
fi

startip="$(curl https://api.ipify.org/)"
while true; do
	openvpn --config /etc/openvpn/config.ovpn > /tmp/openvpnoutput &
	openvpnpid=$!
	sleep 2
	if [ ! "$(cat /tmp/openvpnoutput | tail -n 1 | grep 'UDP link remote')" ]; then
		sleep 10
		newip="$(curl https://api.ipify.org/)"
		curlexitcode=$?
		if [ $curlexitcode == 0 ] && [ "$newip" != "$startip" ]; then
			break
		fi
	fi
	kill $openvpnpid
done

su $user -c deluged
su $user -c deluge-web
