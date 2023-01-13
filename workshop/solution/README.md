## General Overview

In order to un any of the scripts, you need to have one of the two powershell modules for Azure installed (AzureRM or the Az module).

This is the AzureRM module [here](https://learn.microsoft.com/en-us/powershell/azure/azurerm/overview?view=azurermps-6.13.0)

However, the AzureRM is being retired for the Az module which can be found [here:](https://learn.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-9.0.1)

In the spirit of low-friction, all of these scripts support both formats.  If AzureRM is installed, we will use it, if not, we will attempt to install the newer Az module and continue on.

For more information on the module retirement, see this [link](https://learn.microsoft.com/en-us/powershell/azure/migrate-from-azurerm-to-az?view=azps-9.0.1)

#### ALWAYS TEST IN A DEVELOPMENT ENVIRONMENT FIRST!

## LoginToAzure script

This script makes it easy to authenticate to your Azure Account and should be run first before any other scripts are run.  A dialog box will pop up asking for credentials and will be used for the balance of the sessions.  MFA may be required based on your policies

AzureRM will be tested first and if not found, will use AZ module - if AZ module not found, it will install.

Call the script like this:
LoginToAzure.ps1

## GetCSVListofAllSubscriptions script

This script returns a single quote CSV list for input into the IaaS extension registration.  You don't need any parameters.  Just enure you have run the login script above first, then run this one if you have a specific list of subscriptions you want to register.

This makes it easy to modify the list in scenarios where you want most, but perhaps not all subscriptions registered.

Call the script like this:
GetCSVListofAllSubscriptions.ps1

## ResgisterSubscriptionsByCSVList script

Take a list of CSV subscription names (that you can create with the GetCSVListofAllSubscriptions script) passed in as a parameter and call EnableBySubscription with that list for registration (Subscription names are resolved to GUIDs if found).

Register provided subscriptions with Automatic Registration feature. Failed registration information will be stored in RegistrationErrors.csv
file in the current directory where this script is executed. RegistrationErrors.csv will be empty when there are no errors in subscription registration.

Just call the script with a list of subscriptions like this:

.\ResgisterSubscriptionsByCSVList.ps1 'mySub1', 'mysub2', 'my last sub n'

## RegisterAllSubscriptions script
This script will get a list of all subscriptions that the user has access to and attempt to register them with the agent.  No parameters, just run the script.  Again, ensure you have run the login script first.

Just call the script like this:
.\RegisterAllSubscriptions.ps1

## Enable or disable SQL IaaS Extension for an individual VM
This script will list VM's in your subscription and then let you enable or disable the SQL IaaS Extension for an individual VM.

.\EnableSQLExtensionbyVM.ps1
