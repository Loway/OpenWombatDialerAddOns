#! /bin/bash

# Creates a list on WombatDialer and adds three numbers to it with attributes.
# It then prints the set of numbers that were added and their attributes
# 
# It checks tha the list does not exist before creating it.

# API Access - edit as proper

WOMBAT=http://127.0.0.1:8080/wombat
AUTH="--user demoadmin:demo"

# Name of list to create
LIST=MYLIST


#
# Some tooling
#

CURLGET="curl -s -X GET  "
CURLPOST="curl ${AUTH}  -X POST "
CURLDATA="curl -s ${AUTH}  -X POST "


function title() {
	echo
	echo =================================================
	echo ==  $1
	echo =================================================
}

function bye() {
	echo 
	echo ERROR: $1
	echo
	exit 1
}


#
# Check if such list exists, and abort if it does.
#

LISTID=$($CURLDATA "${WOMBAT}/api/edit/list/?mode=L&query=${LIST}" \
          | jq "[ .results[] | select( .name == \"${LIST}\" ) ] | .[0].listId")

[ "${LISTID}" != "null" ] && bye "List $LIST exist with an ID of $LISTID"


#
# Now it creates a list and we get its id
#

$CURLPOST "${WOMBAT}/api/edit/list/?mode=E" \
--data-urlencode data@- <<EOF

{
  "listId": null,
  "name": "${LIST}",
  "isHidden": false,
  "securityKey": ""
}

EOF


LISTID=$($CURLDATA "${WOMBAT}/api/edit/list/?mode=L&query=${LIST}" \
          | jq "[ .results[] | select( .name == \"${LIST}\" ) ] | .[0].listId")

[ "${LISTID}" = "null" ] && bye "List $LIST does not exist"

echo "List $LIST created with an ID of $LISTID"

#
# Now we add numbers and attributes. This way we can even edit them.
#

title "Adding numbers via configuration"


$CURLPOST "${WOMBAT}/api/edit/list/record/?mode=E&parent=${LISTID}" \
--data-urlencode data@- <<EOF

{
    "callId" : null,
    "number" : "100",
    "listId": {
    	"listId": ${LISTID}
    },
    "attributes" : [ {
      "isInput" : true,
      "attrName" : "SURNAME",
      "attrValue" : "Doe"
    }, {
      "isInput" : true,
      "attrName" : "NAME",
      "attrValue" : "John"
    } ]
  }

EOF



#
# An easier way would be using this other service that lets
# you push multiple numbers at once

title "Adding numbers via direct service"


$CURLGET "${WOMBAT}/api/lists/?op=addToList&list=${LIST}&numbers=1234,AA:bb,CC:dd%7C5678,XX:yy"


title "Listing all numbers on list ${LIST}"

$CURLDATA "${WOMBAT}/api/edit/list/record/?mode=L&parent=${LISTID}" \
   | jq '.results | map({Id: .callId , Number: .number, Attributes: .attributesAsString})' \
   | jq -r '(.[0] | keys_unsorted) as $keys | $keys, map([.[ $keys[] ]])[] | @tsv' \
   | column -t 


