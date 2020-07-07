#bruteLogin.sh --> vulnId.sh
#bruteForce.sh --> vulnId.sh

##Variables
#export URL="http://192.168.40.145/DVWA/vulnerabilities"
WORD_LIST="/usr/share/dirb/wordlists/common.txt"
EXT="/DVWA/vulnerabilities"
COUNT=$COUNT
#export COUNT=$COUNT
export DVWA_USER=$USER
export DVWA_PASS=$PASS
export LOGIN_URL=$LOGIN_URL
export IP=$IP

case $COUNT in 
	1)	
        #dirb on DVWA home page to find brute vulnerability directory
        echo -e "\n---- Finding brute force directory ----\n"        
	export BRUTE_DIR="http://"$IP$EXT$(gobuster dir -u 'http://'$IP$EXT -w $WORD_LIST | grep '/brute ' | grep -o '^\S*')        
	echo -e "Directory with brute vulnerability: $BRUTE_DIR"
        sleep 5s
        /bin/bash ~/Documents/DVWA/scripts/bruteForce.sh
        ;;
        2)
	#find sqli vulnerability directory
        echo -e "\n---- Finding SQL injection directory ----\n"        
	export SQLI_DIR="http://"$IP$EXT$(gobuster dir -u 'http://'$IP$EXT -w $WORD_LIST | grep '/sqli ' | grep -o '^\S*')
        echo -e "Directory with sqli vulnerability: $SQLI_DIR \n"
        sleep 5s
        /bin/bash ~/Documents/DVWA/scripts/sqli.sh
        ;; 
        3) 
        rm tmp.txt
	rm dvwa.cookie
	;;
        *)
esac
