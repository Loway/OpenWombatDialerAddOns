#! /bin/bash

# Creates a campaign on WombatDialer.
#
# It expects an existing Trunk and an EndPoint


WOMBAT=http://127.0.0.1:8080/wombat
AUTH="--user demoadmin:demo"

TRUNK=tk
ENDPOINT=ph

LIST=BF2
BLKLIST=BLK

CAMPAIGN=ABCD



# GET

CURLPOST="curl ${AUTH}  -X POST "
CURLDATA="curl -s ${AUTH} -H 'Content-Type: text/json; charset=utf-8' "


function title() {
	echo
	echo ===========================
	echo $1
	echo ===========================
}


#
# Finding existing entities, as defined above
#


title "Finding existing resources"

echo -n "Searching for trunk: ${TRUNK}"
TRUNKID=$($CURLDATA -X POST "${WOMBAT}/api/edit/trunk/?mode=L&query=${TRUNK}" | jq '.results[0].trunkId')
echo "  ... found with id: ${TRUNKID}"


echo -n "Searching for endpoint: ${ENDPOINT}"
EPID=$($CURLDATA -X POST "${WOMBAT}/api/edit/ep/?mode=L&query=${ENDPOINT}" | jq '.results[0].epId')
echo "  ... found with id: ${EPID}"


echo -n "Searching for list: ${LIST}"
LISTID=$($CURLDATA -X POST "${WOMBAT}/api/edit/list/?mode=L&query=${LIST}" | jq '.results[0].listId')
echo "  ... found with id: ${LISTID}"


echo -n "Searching for list: ${BLKLIST}"
BLKLISTID=$($CURLDATA -X POST "${WOMBAT}/api/edit/list/?mode=L&query=${BLKLIST}" | jq '.results[0].listId')
echo "  ... found with id: ${BLKLISTID}"




#
# Creates a campaign
#

title "Creating campaign"


$CURLPOST "${WOMBAT}/api/edit/campaign/?mode=E" \
--data-urlencode data@- <<EOF

{
    "campaignId" : null,
    "name" : "${CAMPAIGN}",
    "priority" : 10,
    "pace" : "RUNNABLE",
    "dial_timeout" : 30000,
    "dial_clid" : "",
    "dial_account" : "",
    "dial_pres" : "",
    "addlLogging": "QM_COMPATIBLE",
    "pauseWhenFinished" : 1,
    "timeStartHr" : "000000",
    "timeEndHr" : "235959",
    "timeDow" : "1234567",
    "maxCallLength" : 0,
    "batchSize" : 100,
    "httpNotify" : "",
    "loggingAlias" : "",
    "securityKey" : "",
    "autopause" : false,
    "agentClid" : "",
    "emailAddresses" : "",
    "emailEvents" : "NO",
    "initialBoostFactor" : 1.0,
    "initialPredictiveModel" : "OFF",
    "amdTracking" : "OFF",
    "amdParams" : "",
    "amdAudioFile" : "",
    "amdFaxFile" : "",
    "campaignVars" : "",
    "loggingQmVars": "ATTR1 ATTR2"
}


EOF


CAMPAIGNID=$($CURLDATA -X POST "${WOMBAT}/api/edit/campaign/?mode=L&query=${CAMPAIGN}" | jq '.results[0].campaignId')
echo "New campaign ${CAMPAIGN} has id: ${CAMPAIGNID}"


# Add reschedule rules


title "Setting reschedule rules"


echo Adding RR for NOANSWER 

$CURLPOST "${WOMBAT}/api/edit/campaign/reschedule/?mode=E&parent=${CAMPAIGNID}" \
--data-urlencode data@- <<EOF
{
    "rescheduleRuleId" : null,
    "status" : "RS_NOANSWER",
    "statusExt" : "",
    "maxAttempts" : 1,
    "retryAfterS" : 120,
    "mode" : "FIXED",
    "campaignId" : -1
}

EOF


echo Adding RR for BUSY

$CURLPOST "${WOMBAT}/api/edit/campaign/reschedule/?mode=E&parent=${CAMPAIGNID}" \
--data-urlencode data@- <<'EOF'
{
    "rescheduleRuleId" : null,
    "status" : "RS_BUSY",
    "statusExt" : "",
    "maxAttempts" : 2,
    "retryAfterS" : 300,
    "mode" : "FIXED",
    "campaignId" : -1
}

EOF


echo Adding a disposition rule to reschedule call on a new campaign


$CURLPOST "${WOMBAT}/api/edit/campaign/disposition/?mode=E&parent=${CAMPAIGNID}" \
--data-urlencode data@- <<'EOF'

 {
    "onState": "RS_BUSY",
    "onExtState": "",
    "withRetriesPending": 0,
    "verb": "RESCHEDULE",
    "destination": "new_campaign",
    "text": "",
    "deferSec": 30,
    "varMode": "ALL",
    "addlVars": "",
    "campaignId": -1
  }
EOF

title "Linking existing resources"


echo "Linking trunk ${TRUNK} [id: ${TRUNKID}] to campaign ${CAMPAIGN} [id: ${CAMPAIGNID}]"
$CURLPOST "${WOMBAT}/api/edit/campaign/trunk/?mode=E&parent=${CAMPAIGNID}" \
--data-urlencode data@- <<EOF
{
    "campaignId" : -1,
    "trunkId": {
    	"trunkId": ${TRUNKID}
    }
}

EOF

echo "Linking endpoint ${ENDPOINT} [id: ${EPID}] to campaign ${CAMPAIGN} [id: ${CAMPAIGNID}]"
$CURLPOST "${WOMBAT}/api/edit/campaign/ep/?mode=E&parent=${CAMPAIGNID}" \
--data-urlencode data@- <<EOF
{
    "campaignId" : -1,
    "epId": {
    	"epId": ${EPID}
    }
}

EOF


echo "Linking white list ${LIST} [id: ${LISTID}] to campaign ${CAMPAIGN} [id: ${CAMPAIGNID}]"
$CURLPOST "${WOMBAT}/api/edit/campaign/list/?mode=E&parent=${CAMPAIGNID}" \
--data-urlencode data@- <<EOF
{
	"campaignId": -1,
	"cl": {
		"listId": ${LISTID}
	},
	"complete": false,
	"highwater": "",
	"clType": "CALL_LIST"
}

EOF



echo "Linking black list ${BLKLIST} [id: ${BLKLISTID}] to campaign ${CAMPAIGN} [id: ${CAMPAIGNID}]"
$CURLPOST "${WOMBAT}/api/edit/campaign/list/?mode=E&parent=${CAMPAIGNID}" \
--data-urlencode data@- <<EOF
{
	"campaignId": -1,
	"cl": {
		"listId": ${BLKLISTID}
	},
	"complete": false,
	"highwater": "",
	"clType": "BLACK_LIST"
}

EOF

