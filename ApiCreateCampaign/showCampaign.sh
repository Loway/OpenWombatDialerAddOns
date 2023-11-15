#! /bin/bash

# Prints a WombatDialer campaign, as seen from the JSON API.

WOMBAT=http://127.0.0.1:8080/wombat
AUTH="--user demoadmin:demo"

CAMPAIGN=$1




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

[ -z "${CAMPAIGN}"  ] && bye "Usage: $0 name-of-campaign"


CAMPAIGNID=$($CURLDATA "${WOMBAT}/api/edit/campaign/?mode=L&query=${CAMPAIGN}" | jq ".results[] | select( .name == \"${CAMPAIGN}\" ) | .campaignId")
echo "Campaign ${CAMPAIGN} has id: ${CAMPAIGNID}"

[ "${CAMPAIGNID}" = "null" ] && bye "Could not find the right campaign"



title "Basic definition"

$CURLDATA "${WOMBAT}/api/edit/campaign/?mode=L&query=${CAMPAIGN}" | jq '.results[0]'

title "Trunks"


$CURLDATA "${WOMBAT}/api/edit/campaign/trunk/?mode=L&parent=${CAMPAIGNID}" | jq '.results'


title "EndPoints"

$CURLDATA "${WOMBAT}/api/edit/campaign/ep/?mode=L&parent=${CAMPAIGNID}" | jq '.results'


title "Lists"

$CURLDATA "${WOMBAT}/api/edit/campaign/list/?mode=L&parent=${CAMPAIGNID}" | jq '.results'


title "Reschedule Rules"

$CURLDATA "${WOMBAT}/api/edit/campaign/reschedule/?mode=L&parent=${CAMPAIGNID}" | jq '.results'


title "Disposition Rules"

$CURLDATA "${WOMBAT}/api/edit/campaign/disposition/?mode=L&parent=${CAMPAIGNID}" | jq '.results'


title "Opening Hours"

$CURLDATA "${WOMBAT}/api/edit/campaign/oh/?mode=L&parent=${CAMPAIGNID}" | jq '.results'

