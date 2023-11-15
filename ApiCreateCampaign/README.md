# Use the configuration API

This repo contains a set of scripts tha are meant to show how the 
JSON configuration APIs are meant to be used.

Using the configuration API, you can do everything that you can do from the 
GUI, though it may take some getting started with. This repo is meant
to fill the gap.

The code in this repo was written to maximise readability, so 
it usually won't properly encode names, won't check error codes, 
and uses `jq` to work with the JSON results.

These scripts area meant to be read, so you need to edit them to set names,
credentials, etc.


## showConfiguration.sh

This scripts conects to Wombat and, through the JSON configuration API,
shows all objects configured - basically everything but campaigns - in 
their JSOM format.

It shows:

- PBXs
- Trunks and EndPoints
- Lists
- Opening Hours

## showCampaign.sh 

This script is to be run like:

	./showCampaign.sh ABC

And it will display the campaign in its entirety, namely:

- Its general configuration
- Trunks
- EndPoints
- Reschedule Rules
- Disposition Rules
- Opening Hours

This script will help you when creating a new campaign, because the best thing you can do is to create manually 
a campaign configured as you want it to be, dump it using this script, and then using the `createCampaign.sh` script
to create a new one.

## createList.sh

This script will create a new list (after checking that one with the same name does not exist), upload one number
with two attributes through the JSON configuration API, upload two numbers at once with their attributes through 
the  basic API,
and will then dump the new list and all its numbers.


## createCampaign.sh

This script creates a new campaign from scratch. It expects an existing trunk and end-point, and two lists to be used one as a nomrla list and the other as a black-list.

It will create a new campaign, associate it with the trunk and the EP, add the two lists with theri respective roles, and create
reschedule rules and disposition rules.

The campaign is not started - but could be started at any time by using the API call:

		http://127.0.0.1:8080/wombat/api/campaigns/?op=start&campaign=ABC

In order to create your own, it is always better to create it nmanually, dump it with `showCampaign.sh` and then 
use the generated structures to see how fields must be set in your own campaign.



