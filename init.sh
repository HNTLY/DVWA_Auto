##init.sh

##Force no internet
#nmcli networking off

##Check for internet connection
wget -q --spider http://google.com
if [ $? -eq 0 ]; then
    echo "Online"
    echo -e "---- Starting Network scans ---- \n "
    /bin/bash ~/Documents/DVWA/scripts/scanInit.sh
else
    echo "No network connection"
    echo "quitting"
    exit
fi


