# Open WombatDialer Add-Ons

A set of examples and additional tools for WombatDialer. You can contribute too - just send us a PR!

## Examples

### [Using the JSON Configuration API](https://github.com/Loway/OpenWombatDialerAddOns/tree/master/JSON_Configuration_API)

A set of scripts that show how to:

- create a new campaign from scratch, fully configuring all its options like you would do from the GUI
- create a new list from scratch and upload numbers to it
- dumping a JSON view of one campaign
- dumping a JSON view of common objects as currently configured

They are meant to be used as examples, so were written to be easuily readable.

### [Clones and runs a campaign](https://github.com/Loway/OpenWombatDialerAddOns/tree/master/CloneAndRunCampaign)

A sample script that implements a very common scenarion, that is:

* clone an existing campaign as it is
* create a new list
* add the new list to the just-cloned campaign
* run the new campaign

### [Delete Lists From Campaigns](https://github.com/Loway/OpenWombatDialerAddOns/tree/master/DeleteListFromCampaign)

A script to easily remove lists from campaigns. It can also remove all lists at once.



## Ready-made scripts

### [AutoRecall](https://github.com/Loway/OpenWombatDialerAddOns/tree/master/AutoRecall)

Schedules recalls based on lost calls on a QueueMetrics queue.

A shell script written in PHP.

### (Cvs2Wbt)[https://github.com/Loway/OpenWombatDialerAddOns/tree/master/Csv2Wbt]

Convert a list of numbers and attributes stored as a simple CSV file to the format used by WombatDialer
to upload call lists.

A script written in Perl.



## See also

* [WombatDialer home page](https://www.wombatdialer.com)
* [Open QueueMetrics Add-Ons forum](http://forum.queuemetrics.com/index.php?board=14.0)

### Other projects you may be interested in

* The [QueueMetrics XML-RPC Query Browser](https://github.com/Loway/QueueMetricsXmlRpcBrowser) lets you interact with the XML-RPC interface of QM from a web page
