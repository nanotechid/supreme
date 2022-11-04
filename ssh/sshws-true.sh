#!/bin/bash

portdb=`cat /root/log-install.txt | grep -w "Dropbear" | cut -d: -f2|sed 's/ //g' | cut -f2 -d","`
portdb2=`cat /root/log-install.txt | grep -w "Dropbear" | cut -d: -f2|sed 's/ //g' | cut -f1 -d","`
portsshws=`cat /root/log-install.txt | grep -w "SSH Websocket" | cut -d: -f2 | awk '{print $1}'`
wsssl=`cat /root/log-install.txt | grep -w "SSH SSL Websocket" | cut -d: -f2 | awk '{print $1}'`

tmux new-session -d -s sshws "node /usr/bin/proxy3.js -dport $portdb -mport $portsshws -o /root/sshws.log"
tmux new-session -d -s sshwsssl "node /usr/bin/proxy3.js -dport $portdb -mport 700"
importantfile
