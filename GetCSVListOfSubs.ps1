 <#
.SYNOPSIS
    This is a helper function for the IaaS extension.  It will get a CSV list of subscription names in single quotes.  
.DESCRIPTION
    Enumerates each subscription in a tenant with a single quote CSV list for input into the IaaS extension registration.
    This makes it easy to modify the list in scenarios where you want most, but perhaps not all subscriptions registered.

    Prerequisites for the full registration process:
    - Should have the Azure RM Powershell module installed.
    - The user account running the script should have "Microsoft.SqlVirtualMachine/register/action" RBAC access over the subscriptions.
    - The user account running the script should have "Microsoft.Features/providers/features/register/action" RBAC access over the subscriptions.

.EXAMPLE  
    To output a list of subscriptions, simply run this powershell script.


    PS C:\MyScripts\GetCSVListOfSubs.ps1
    
#>

    $ListOfSubs = ""
    $subInAcc = Get-AzureRmSubscription
    Write-Output ""
    Write-Output ""
    Write-Output ""
    Write-Output "CSV List of subscriptions:"
    write-output "--------------------------"
    ForEach($sub in $subInAcc) 
       {

            $subName = $sub | Select-Object -ExpandProperty Name
            $ListOfSubs = $ListOfSubs + "'" + $subName.Trim() + "', "
            
       }
    Write-Host $ListOfSubs.Substring(0,$ListOfSubs.Length-2)
    Write-Output ""
    Write-Output ""
