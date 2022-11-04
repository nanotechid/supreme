#!/bin/bash
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
CEKEXPIRED () {
    today=$(date -d +1day +%Y-%m-%d)
    Exp1=$(curl -sS https://raw.githubusercontent.com/nanotechid/supreme/aio/permission/ip | grep $MYIP | awk '{print $3}')
    if [[ $today < $Exp1 ]]; then
    echo -e "\e[32mSTATUS SCRIPT AKTIF...\e[0m"
    else
    echo -e "\e[31mSCRIPT ANDA EXPIRED!\e[0m";
    echo -e "\e[31mRenew IP letak tempoh banyak kit okay? hehe syg ktk #\e[0m"
    exit 0
fi
}
IZIN=$(curl -sS https://raw.githubusercontent.com/nanotechid/supreme/aio/permission/ip | awk '{print $4}' | grep $MYIP)
if [ $MYIP = $IZIN ]; then
echo -e "\e[32mPermission Accepted...\e[0m"
CEKEXPIRED
else
echo -e "\e[31mPermission Denied!\e[0m";
echo -e "\e[31mDaftar IP dalam github lok sayang okay? mun dah daftar tapi masih juak permission denied refresh dolok website ya hehe. Love you #\e[0m"
exit 0
fi
clear
echo ""
echo ""
echo -e "[ \033[32mInfo\033[0m ] Clear RAM Cache"
echo 1 > /proc/sys/vm/drop_caches
sleep 3
echo -e "[ \033[32mok\033[0m ] Cache cleared"
echo ""
echo "Back to menu in 2 sec "
sleep 2
menu
