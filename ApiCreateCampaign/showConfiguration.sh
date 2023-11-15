#! /bin/bash

# Prints information about the current WomabtDialer objects that 
# is not linked to a campaign.

WOMBAT=http://127.0.0.1:8080/wombat
AUTH="--user demoadmin:demo"




CURLDATA="curl -s ${AUTH} -X POST -H 'Content-Type: text/json; charset=utf-8' "

function title() {
	echo
	echo ==============================
	echo ==  $1
	echo ==============================
}

function bye() {
	echo 
	echo ERROR: $1
	echo
	exit 1
}


title "PBXs"

$CURLDATA "${WOMBAT}/api/edit/asterisk/?mode=L" | jq '.results'


title "Trunks"

$CURLDATA "${WOMBAT}/api/edit/trunk/?mode=L" | jq '.results'


title "EndPoints"

$CURLDATA "${WOMBAT}/api/edit/ep/?mode=L" | jq '.results'

title "Lists"

$CURLDATA "${WOMBAT}/api/edit/list/?mode=L" | jq '.results'


title "Opening Hours"

$CURLDATA "${WOMBAT}/api/edit/oh/?mode=L" | jq '.results'



