
#!/bin/bash

while getopts u:e:s: flag
do
    case "${flag}" in
        u) user=${OPTARG};;
        e) masaaktif=${OPTARG};;
        s) sni=${OPTARG};;
    esac
done

source /var/lib/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi

CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json)

if [[ -n  "$CLIENT_EXISTS"  ]]; then echo "err"; exit 0; fi


uuid=$(cat /proc/sys/kernel/random/uuid)
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
asu=`cat<<EOF
     {
      "add": "${domain}", 
      "host": "${sni}", 
      "aid": 0, 
      "path": "/vmess", 
      "net": "ws", 
      "ps": "${user}", 
      "tls": "tls", 
      "type": "none", 
      "port": "443", 
      "v": "2", 
      "id": "${uuid}"
}
EOF`
ask=`cat<<EOF
     {
     "tls": "none",
     "v": "2", 
     "host": "${domain}",
     "type": "", 
     "ps": "${user}", 
     "port": 80, 
     "net": "ws", 
     "id": "${uuid}", 
     "path": "/vmess", 
     "add": "${sni}", 
     "aid": 0
}
EOF`

vmesslink1="vmess://$(echo $asu | base64 -w 0)"
vmesslink2="vmess://$(echo $ask | base64 -w 0)"

systemctl restart xray > /dev/null 2>&1
service cron restart > /dev/null 2>&1
result=`cat<<EOF
      {
      "Host":"${domain}",
      "User":"${user}",
      "UUID":"${uuid}",
      "PortTLS":"443",
      "NoneTLS":"80",
      "Vmess":"WS",
      "Path":"/vmess",
      "LinkTLS":"${vmesslink1}",
      "LinknoneTLS":"${vmesslink2}",
      "ExpiredOn":"$exp"
}
EOF`

echo $result | tee -a /etc/log-create-user.log;
