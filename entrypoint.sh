#!/bin/bash

user=$1
uid=$2
gid=$3

groupadd --gid $gid $user
useradd -m --uid $uid --gid $gid $user

openvpn --daemon --ping-restart 60 --config /etc/openvpn/config.ovpn
su $user -c deluged
su $user -c deluge-web
