FROM debian
RUN apt-get update
RUN apt-get upgrade

RUN apt-get install -y deluged deluge-web openvpn

COPY entrypoint.sh /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
