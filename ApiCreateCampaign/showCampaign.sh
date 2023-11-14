#! /bin/bash

# Creates a campaign on WombatDialer.
#
# It expects an existing Trunk and an EndPoint


WOMBAT=http://127.0.0.1:8080/wombat
AUTH="--user demoadmin:demo"


CAMPAIGN=ABCD




CURLDATA="curl -s ${AUTH} -H 'Content-Type: text/json; charset=utf-8' "


function title() {
	echo
	echo ===========================
	echo $1
	echo ===========================
}


CAMPAIGNID=$($CURLDATA -X POST "${WOMBAT}/api/edit/campaign/?mode=L&query=${CAMPAIGN}" | jq '.results[0].campaignId')
echo "Campaign ${CAMPAIGN} has id: ${CAMPAIGNID}"

title "Basic definition"

$CURLDATA -X POST "${WOMBAT}/api/edit/campaign/?mode=L&query=${CAMPAIGN}" | jq '.results[0]'

title "Trunks"


$CURLDATA -X POST "${WOMBAT}/api/edit/campaign/trunk/?mode=L&parent=${CAMPAIGNID}" | jq '.results'


title "EndPoints"

$CURLDATA -X POST "${WOMBAT}/api/edit/campaign/ep/?mode=L&parent=${CAMPAIGNID}" | jq '.results'


title "Lists"

$CURLDATA -X POST "${WOMBAT}/api/edit/campaign/list/?mode=L&parent=${CAMPAIGNID}" | jq '.results'


title "Reschedule Rules"

$CURLDATA -X POST "${WOMBAT}/api/edit/campaign/reschedule/?mode=L&parent=${CAMPAIGNID}" | jq '.results'


title "Disposition Rules"

$CURLDATA -X POST "${WOMBAT}/api/edit/campaign/disposition/?mode=L&parent=${CAMPAIGNID}" | jq '.results'


title "Opening Hours"

$CURLDATA -X POST "${WOMBAT}/api/edit/campaign/oh/?mode=L&parent=${CAMPAIGNID}" | jq '.results'

