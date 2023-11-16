# Using WombatDialer's JSON configuration API

This repo contains a set of scripts tha are meant to show how to
use the JSON configuration APIs.

Using the configuration API, you can do everything that you can do from the 
GUI, though it may take some effort getting started with it, because you have to get 
all field names right. This repo is meant to fill the gap.

The code in this repo was written to maximise readability, so 
it usually won't properly encode names, won't check error codes, 
and uses `jq` to work with the JSON results. 

These scripts are meant to be **read and understood**, so you need to edit them to set names,
credentials, etc.


## showConfiguration.sh

This scripts conects to Wombat and, through the JSON configuration API,
shows all objects configured - basically everything but campaigns - in 
their JSON format.

It shows:

- PBXs
- Trunks and EndPoints
- Lists
- Opening Hours

This way you can see the list of fields involved and their identifiers.

## showCampaign.sh 

This script is to be run like:

	./showCampaign.sh ABC

And it will display the selected campaign in its entirety as a series of JSON objects, namely:

- Its general configuration
- Trunks
- EndPoints
- Reschedule Rules
- Disposition Rules
- Opening Hours

This script will help you when creating a new campaign, because the best thing you can do is to create manually 
a campaign configured as you want it to be, dump it using this script so you can see all the field names
and positions, and then edit the `createCampaign.sh` script
to create a new one.




## createList.sh

This script will create a new list (after checking that one with the same name does not exist), upload one number
with two attributes through the JSON configuration API, upload two numbers at once with their attributes through 
the  basic API,
and will then dump the new list and all its numbers.


## createCampaign.sh

This script creates a new campaign from scratch. It expects an existing trunk and end-point, and two lists to be used as a normal list and a black-list.

It will create a new campaign, associate it with the trunk and the EP, add each of the two lists with their respective roles, and create
some sample reschedule rules and disposition rules.

The campaign is not started - but could be started at any time by using the API call:

	http://127.0.0.1:8080/wombat/api/campaigns/?op=start&campaign=ABC

Or from the Live page of your dialer.

In order to create your own campaign, it is always better to create it manually, dump it with `showCampaign.sh` and then 
use the generated structures to see how fields must be set in your own campaign.

## See also

- The JSON configuration API: https://docs.loway.ch/WombatDialer/100_APIs.html#JSONAPI
- The general HTTP API: https://docs.loway.ch/WombatDialer/100_APIs.html#HTTPCONTROL

