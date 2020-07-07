#init.sh --> scanInit.sh

##Variables
##export local IP
#export INIT_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'

#Get all IP's and HTTP ports on network
nmap -T4 -Pn 192.168.40.141/24 | grep -E 'http|([0-9]{1,3}[\.]){3}[0-9]{1,3}' | grep -v https > tmp.txt

#Get HTTP ip address
export INIT_IP=$(cat tmp.txt | grep 'http' -B 1 | grep -Eo '([0-9]{1,3}[\.]){3}[0-9]{1,3}')
#Get HTTP port
HTTP_PORT=$(cat tmp.txt | grep http | sed 's/[^0-9]*//g')

#rm tmp.txt

#HTTP_PORT=80

echo "IP address: $INIT_IP"
echo "HTTP port number: $HTTP_PORT"
export WORD_LIST="/usr/share/dirb/wordlists/common.txt" 

#Create variable for the Login URL using the IP and open port number
export LOGIN_URL=$(gobuster dir -u "$INIT_IP:$HTTP_PORT/DVWA/" -nqelw $WORD_LIST -x php | grep login | grep -o '^\S*')

echo "Full Login URL: $LOGIN_URL"

sleep 3s

#Call next script (Brute Forcing the login page)
/bin/bash ~/Documents/DVWA/scripts/bruteLogin.sh


