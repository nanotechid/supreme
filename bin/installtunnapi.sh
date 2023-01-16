#!/bin/bash
#installer Tunnaapi 

cd

#Install Tunnapi
wget -O /usr/bin/tunnapi https://raw.githubusercontent.com/adipatiarya/supreme/master/bin/tunnapi


#izin permision
chmod +x /usr/bin/tunnapi

#System tunnapi
wget -O /etc/systemd/system/tunnapi.service https://raw.githubusercontent.com/adipatiarya/supreme/master/bin/tunnapi.service && chmod +x /etc/systemd/system/tunnapi.service

#restart service
systemctl daemon-reload

#Enable & Start & Restart 
systemctl enable tunnapi.service
systemctl start tunnapi.service
systemctl restart tunnapi.service


