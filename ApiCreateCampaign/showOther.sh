#! /bin/bash

# 

WOMBAT=http://127.0.0.1:8080/wombat
AUTH="--user demoadmin:demo"




CURLDATA="curl -s ${AUTH} -H 'Content-Type: text/json; charset=utf-8' "


function title() {
	echo
	echo ===========================
	echo $1
	echo ===========================
}


title "PBXs"

$CURLDATA -X POST "${WOMBAT}/api/edit/asterisk/?mode=L" | jq '.results'


title "Trunks"

$CURLDATA -X POST "${WOMBAT}/api/edit/trunk/?mode=L" | jq '.results'


title "EndPoints"

$CURLDATA -X POST "${WOMBAT}/api/edit/ep/?mode=L" | jq '.results'

title "Lists"

$CURLDATA -X POST "${WOMBAT}/api/edit/list/?mode=L" | jq '.results'


title "Opening Hours"

$CURLDATA -X POST "${WOMBAT}/api/edit/oh/?mode=L" | jq '.results'



