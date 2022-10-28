 <#
.SYNOPSIS
    This is a helper script for the IaaS extension.  It will get a CSV list of subscription names in single quotes.  

.DESCRIPTION
    Enumerates each subscription in a tenant with a single quote CSV list for input into the IaaS extension registration.
    This makes it easy to modify the list in scenarios where you want most, but perhaps not all subscriptions registered.

    Prerequisites for the full registration process:
    - Should have the Azure RM Powershell module installed.
    - The user account running the script should have "Microsoft.SqlVirtualMachine/register/action" RBAC access over the subscriptions.
    - The user account running the script should have "Microsoft.Features/providers/features/register/action" RBAC access over the subscriptions.
    - Run 'Connect-AzAccount' to first connect the powershell session to the azure account.

.EXAMPLE  
    To output a list of subscriptions, simply run this powershell script.


    PS C:\MyScripts> .\GetCSVListOfAllSubscriptions.ps1
    
#>
    #Initialize the string
    $ListOfSubs = ""

    if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable))
    {
        #Using the azurerm module
        Write-Host "`nAzureRM is already installed. Registering using AzureRm commands.";
        $subInAcc = Get-AzureRmSubscription
    }
    else 
    {
        # Since AzureRm module is not availavle, we will use Az module.
        Write-Host "`n`nInstalling Az powershell module if not installed already."
        Install-Module -Name Az -AllowClobber -Scope CurrentUser;
        Write-Host ""
        $subInAcc = Get-AzSubscription
    }

    Write-Output "`nCSV List of subscriptions:"
    write-output "--------------------------"
    ForEach($sub in $subInAcc) 
       {
            # Iterate through subs user can see and create a csv list for later modification.
            $subName = $sub.Name.Trim()
            $ListOfSubs = $ListOfSubs + "'" + $subName + "', "
            
       }
    if ($ListOfSubs -gt 3)
        {
            #If we have at least 1 subscription, then write it out for user to modify
            Write-Host ""
            Write-Host $ListOfSubs.Substring(0,$ListOfSubs.Length-2)
        }
    else
        {
            # Let the user know that no subscriptions were found
            Write-Host '`n`nNo subscriptions were found'
        }