# Clones and run a WombatDialer campaign

The script expects a sample campaign called "TEMPLATE", that will be cloned to a new campaign
called "NEWCAMPAIGN-1234". A new list called "NEWCAMPAIGN-1234-list" will be created
and numbers 1001 and 1001 will be added to it. Then the new list will be added to the
campaign just cloned, and the campaign will be started.

*Notable things*


* Wherever possible, the script uses the "simpler" control API; but it also shows how
  to use the full configuration API to associate a call list to a campaign.
* The scripts queries and prints out results from WombatDialer by running
  JSON services.
* The scripts stores all results into intermediate files that, by design, are 
  not deleted so you can inspect the results.

*Improvements*

The script assumes that all list and campaign names are unique and does not
check for them to be non-existent.

In order to run this in production, you will want to make sure that there are
no errors returned.



