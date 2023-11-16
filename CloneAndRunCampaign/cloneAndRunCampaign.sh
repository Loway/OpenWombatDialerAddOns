#! /bin/bash

WBT="http://127.0.0.1:8080/WombatDialer"
USERAUTH=demoadmin:demo
TMPL=TEMPLATE
NEWC=NEWCAMPAIGN-$$
NEWL=$NEWC-list
FNAM=run$$

echo "$FNAM - Cloning campaign $TMPL into $NEWC "
curl -sS "$WBT/api/campaigns/?op=clone&campaign=$TMPL&newcampaign=$NEWC" -o ${FNAM}_clone.json 

echo "$FNAM - Creating new list $NEWL and adding number 1000 and 1001 to it"
curl -sS  "$WBT/api/lists/?op=addToList&list=${NEWL}&numbers=1000,AA:bb,CC:dd|1001,XX:yy" -o ${FNAM}_newlist.json 

#  Find the ID of our new campaign 
echo "$FNAM - Finding the ID of new campaign $NEWC"
curl -sS   --user $USERAUTH -X POST "$WBT/api/edit/campaign/?mode=L&query=$NEWC" -o ${FNAM}_query_camp.json
NEWCID=$(cat ${FNAM}_query_camp.json | jq '.results[0].campaignId')
echo "$FNAM - Campaign $NEWC has ID $NEWCID"

# Find the ID of our new list
echo "$FNAM - Finding the ID of new list $NEWL"
curl -sS   --user $USERAUTH -X POST "$WBT/api/edit/list/?mode=L&query=$NEWL" -o ${FNAM}_query_list.json
NEWLID=$(cat ${FNAM}_query_list.json | jq '.results[0].listId')
echo "$FNAM - List $NEWL has ID $NEWLID"

# Now we associate our new list to our new campaign
# a "CALL_LIST" is a normal list; a "BLACK_LIST" is a blacklist
echo "$FNAM - Now adding list $NEWL to campaign $NEWC"

cat << EOF > ${FNAM}_associate_object.json
{
    "campaignId" : $NEWCID,
    "idx" : "1",
    "cl" : {
      "listId" : $NEWLID
    },
    "complete" : false,
    "highwater" : "",
    "clType" : "CALL_LIST"
}
EOF

curl  -sS   --user $USERAUTH -X POST --data-urlencode data@${FNAM}_associate_object.json \
      "$WBT/api/edit/campaign/list/?mode=E&parent=$NEWCID" -o ${FNAM}_associated_lists.json

echo "$FNAM - Here are the lists for $NEWC"
cat ${FNAM}_associated_lists.json | jq -r '.results[] | [.campaignId, .idx, .cl.name, .clType] | @csv'


# Start the campaign now
echo "$FNAM - Now starting $NEWC"
curl  -sS  "$WBT/api/campaigns/?op=start&campaign=$NEWC" -o ${FNAM}_start.json 

# prints all running campaigns
# we wait a minute so the new campaign has a chance to start
sleep 3
echo "$FNAM - Active campaigns:"
curl  -sS  --user demoadmin:demo -X POST "$WBT/api/live/runs/" -o ${FNAM}_live_runs.json
cat ${FNAM}_live_runs.json | jq -r '.result.campaigns[] | [.name, .state] | @csv'


