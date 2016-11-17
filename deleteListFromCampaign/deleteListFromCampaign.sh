#!/bin/bash

####################################
#
# Delete a list from a campaign
#
# Author: Kevin Ravasi
#
# Date: 17/11/16
#
####################################



####################################
#
# SETTINGS
#
####################################


LISTNAME="$1"
CAMPAIGNSEARCHNAME="$2"
IPADDR="10.10.5.169"
PORT="8080"
USERNAME="robots"
PASSWORD="password"
WOMBATPATH="wombat"
BASEURL="http://$IPADDR:$PORT/$WOMBATPATH"
CURL="curl -s --user $USERNAME:$PASSWORD -X POST"


####################################
#
# Delete function
#
####################################

function deleteList {
	
	if [ "$1" == "\*" ]; then
		for((i=0; i<$NUMBEROFRESULTS; i++))
		do
			tmpfile=$(mktemp /tmp/deleteListFromCampaign.XXXXXX)
			NAME=$(echo $LINKEDLISTS | jq --arg listname "$1" --arg i "$i" '.["results"]|.[$i|tonumber]|.["cl"]|.["name"]')
			echo $LINKEDLISTS | jq --arg i "$i" '.["results"]|.[$i|tonumber]'>>$tmpfile
			echo "deleting list: $NAME from campaign with ID: $2"
			date +%Y/%m/%d-%H:%M:%S>>deleteListFromCampaign.log
			$CURL -i --data-urlencode data@$tmpfile "$BASEURL/api/edit/campaign/list/" --data-urlencode "mode=D" --data-urlencode "parent=$2">>deleteListFromCampaign.log 
			rm "$tmpfile"
		done
	else
		for((i=0; i<$NUMBEROFRESULTS; i++))
		do
			tmpfile=$(mktemp /tmp/deleteListFromCampaign.XXXXXX)
			NAME="$1"
			NAME="${NAME%\"}"
			NAME="${NAME#\"}"
			echo $LINKEDLISTS | jq --arg listname "$NAME" --arg i "$i" '.["results"]|.[$i|tonumber]|select(.["cl"].name==$listname)'>>$tmpfile
			date +%Y/%m/%d-%H:%M:%S>>deleteListFromCampaign.log
			$CURL -i --data-urlencode data@$tmpfile "$BASEURL/api/edit/campaign/list/" --data-urlencode "mode=D" --data-urlencode "parent=$2">>deleteListFromCampaign.log 
			rm "$tmpfile"
		done
			echo "deleting list: $1 from campaign: $2"
	fi
}

####################################
#
# Script
#
####################################

CAMPAIGNSEARCH=$($CURL "$BASEURL/api/edit/campaign/" --data-urlencode "query=$CAMPAIGNSEARCHNAME")
NUMBEROFRESULTS=$(echo $CAMPAIGNSEARCH | jq '.["results"]|length')

if [ $NUMBEROFRESULTS = 1 ]; then
	CAMPAIGNNAME[0]=$(echo $CAMPAIGNSEARCH | jq '.["results"]|.[0]|.["name"]')
    choice=0
elif [ $NUMBEROFRESULTS = 0 ]; then
	echo no campaigns found!
	exit
else

	for ((i=0; i<$NUMBEROFRESULTS; i++))
	do
	   CAMPAIGNNAME[$i]=$(echo $CAMPAIGNSEARCH | jq --arg i "$i" '.["results"]|.[$i|tonumber]|.["name"]')
	   echo $(($i+1))")" ${CAMPAIGNNAME[i]}
	done
 	
	read -p "Choose the number of the selected campaign: " choice

	choice=$((choice-1))

	if [[ $((choice)) != $choice ]]; then
    	echo "Not just a number!"
    	exit
	elif [ $choice -ge $NUMBEROFRESULTS ] || [ $choice -lt 0 ]; then
		echo "Invalid choice!"
		exit
	else
		echo "You chose " ${CAMPAIGNNAME[$choice]}
	fi

fi


CAMPAIGNID=$(echo $CAMPAIGNSEARCH |  jq --arg userchoice "$choice" '.["results"]|.[$userchoice|tonumber]|.["campaignId"]')
LINKEDLISTS=$($CURL "$BASEURL/api/edit/campaign/list/" --data-urlencode "parent=$CAMPAIGNID")
NUMBEROFRESULTS=$(echo $LINKEDLISTS | jq '.["results"]|length')

if [ -z $LISTNAME ]; then
	if [ $NUMBEROFRESULTS -ge 1 ]; then
		for ((i=0; i<$NUMBEROFRESULTS; i++))
		do
		   LISTNAMES[$i]=$(echo $LINKEDLISTS | jq --arg i "$i" '.["results"]|.[$i|tonumber]|.["cl"]|.["name"]')
		   echo $((i+1))")" ${LISTNAMES[i]}
		done
	 	
		read -p "Choose the number of the selected list: " choice

		choice=$((choice-1))

		if [[ $((choice)) != $choice ]]; then
	    	echo "Not a valid number!"
	    	exit
		elif [ $choice -ge $NUMBEROFRESULTS ] || [ $choice -lt 0 ]; then
			echo "Invalid choice!"
			exit
		else
			LISTNAME=${LISTNAMES[$choice]}
           	
		fi
	else
		echo "no lists found!"
		exit
	fi
fi

	deleteList "$LISTNAME" "$CAMPAIGNID"

date +%Y/%m/%d-%H:%M:%S>>deleteListFromCampaign.log
$CURL -i --data-urlencode data@$tmpfile "$BASEURL/api/edit/campaign/list/" --data-urlencode "mode=D" --data-urlencode "parent=$CAMPAIGNID">>deleteListFromCampaign.log 

