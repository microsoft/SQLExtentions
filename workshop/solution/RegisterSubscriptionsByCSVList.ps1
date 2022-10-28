<#

.SYNOPSIS
    Take a list of CSV subscription names passed in as a parameter and call EnableBySubscription with that list for registration (Subscription names are resolved to GUIDs if found).
    Register provided subscriptions with Automatic Registration feature. Failed registration information will be stored in RegistrationErrors.csv
    file in the current directory where this script is executed. RegistrationErrors.csv will be empty when there are no errors in subscription registration.
        
.DESCRIPTION
    Registering each subscription is a two step process:
        -Register subscription to Microsoft.SqlVirtualMachine Resource provider.
        -Register subscription to the Automatic Registration feature.
    Prerequisites:
    - The user account running the script should have "Microsoft.SqlVirtualMachine/register/action" RBAC access over the subscriptions.
    - The user account running the script should have "Microsoft.Features/providers/features/register/action" RBAC access over the subscriptions.
.EXAMPLE  
    To register a set of Subscriptions, just run the script with a CSV list of subscription names.
    
    PS C:\MyScripts > .\RegisterSubscriptionsByCSVList.ps1 'MySubscription1','MySubscription2','MySubscription3','My Subscription Nth'

#>


    # Here we'll be passing in the subscription list parameter as the subscription names in csv format.
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $SubscriptionList
    );

    # Function is used to iterate through subscription list and automatically register.
    function EnableBySubscription ([string[]] $SubscriptionList)
    {
        $FailedRegistration = @{ };

        # Register subscriptionIds to Automatic Registraion.
        # https://docs.microsoft.com/th-th/powershell/azure/install-az-ps?view=azps-3.8.0#install-the-azure-powershell-module.
        # Check if AzureRm is already installed and use that module if it is already available.
        if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
            Write-Host "`n`nAzureRM is already installed. Registering using AzureRm commands";
            foreach ($SubscriptionId in $SubscriptionList) {
                Write-host "`n`n--------------------$SubscriptionId----------------------------`n`n";

                try {
                    Write-Host "Setting powershell context to subscriptionid: $SubscriptionId";
                    $Output = Set-AzureRmContext  -SubscriptionId $SubscriptionId -ErrorAction Stop;

                    Write-Host "Registering subscription($SubscriptionId) to Microsoft.SqlVirtualMachine Resource provider";
                    $Output = Register-AzureRmResourceProvider -ProviderNamespace Microsoft.SqlVirtualMachine -ErrorAction Stop;

                    # Let's do the actual registration.           
                    Write-Host "Registering subscription ($SubscriptionId) for IaaS Extension";
                    $Output = Register-AzureRmProviderFeature -FeatureName BulkRegistration -ProviderNamespace Microsoft.SqlVirtualMachine -ErrorAction Stop;
                }
                Catch {
                    $message = $_.Exception.Message;
                    Write-Error "We failed due to complete $SubscriptionId operation because of the following reason: $message";
                    $tmpmsg = "Error for Subscription " + $SubscriptionId
                    $FailedRegistration.Add($tmpmsg, $message);
                }
            }
        } 
        else {
            # Since AzureRm module is not availavle, we will use Az module.
            Write-Host "Installing Az powershell module if not installed already."
            Install-Module -Name Az -AllowClobber -Scope CurrentUser;

            foreach ($SubscriptionId in $SubscriptionList) {
                Write-host "`n`n--------------------$SubscriptionId----------------------------`n`n"

                try {
                    Write-Host "Setting powershell context to subscriptionid: $SubscriptionId";
                    $Output = Set-AzContext -SubscriptionId $SubscriptionId -ErrorAction Stop;

                    Write-Host "Registering subscription ($SubscriptionId) to Microsoft.SqlVirtualMachine Resource provider";
                    $Output = Register-AzResourceProvider -ProviderNamespace Microsoft.SqlVirtualMachine -ErrorAction Stop;
             
                    # Let's do the actual registration
                    Write-Host "Registering subscription ($SubscriptionId) for IaaS Extension";
                    $Output = Register-AzProviderFeature -FeatureName BulkRegistration -ProviderNamespace Microsoft.SqlVirtualMachine -ErrorAction Stop;
                }
                Catch {
                    $message = $_.Exception.Message;
                    Write-Error "We failed due to complete $SubscriptionId operation because of the following reason: $message";

                    # Store failed subscriptionId and failure reason.
                    $tmpmsg = "Error for Subscription " + $SubscriptionId
                    $FailedRegistration.Add($tmpmsg, $message);
                }
            };
    }

    # Failed subscription registration and its reason will be stored in a csv file(RegistrationErrors.csv) for easy analysis.
    # The file should be available in current directory where this .ps1 is executed
    New-Object -Type PSObject -Property $FailedRegistration | Export-Csv .\RegistrationErrors.csv -NoType
    }

    ###############################################################################################################################################################################
    ###############################################################################################################################################################################

    $subscriptionIdList = [System.Collections.ArrayList]@()

    if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable))
    {
        Write-Host "`n`nAzureRM is already installed. Registering using AzureRm commands";
        #Get the subscription
        $subInAcc = Get-AzureRmSubscription
    }
    else 
    {
        # Since AzureRm module is not availavle, we will use Az module.
        Write-Host "Installing Az powershell module if not installed already."
        Install-Module -Name Az -AllowClobber -Scope CurrentUser;
        Write-Host ""
        $subInAcc = Get-AzSubscription
    }

    Write-Host " "
    Write-Host " "
    # Here we will iterate through each subscription name passed in as a parameter from the command line.
    foreach ($p_subname in $SubscriptionList)
    {   # Now let's iterate through each subscription that the user has access to looking for matches.
        ForEach($sub in $subInAcc) 
        {
            $foundParam = 0
            if ($p_subname.Replace("'","") -eq $sub.Name.Replace("'",""))
            {
                # Great we found a match, now let's create a list of GUIDs for registration
                $tmp1 = $subscriptionIdList.Add($sub.Id)
                Write-Host "Subscription Found: "  $sub.Name " (" $sub.Id ")"
                $foundParam = 1
                break
            }
        }
        if ($foundParam -eq 0)
        {
            # We didn't find a subscription for the name the user passed in, let them know.
            Write-Host "No subscription found: " $p_subname
        }
    }    


    if ($subscriptionIdList.Count -gt 0)
    {
        # We found some valid subscriptions, let's call EnableBySubscription with the GUIDs parameter to start the registration.
        Write-Host ""
        Write-Host "`n`nPress enter to continue with registration or CTRL-C to abort..."
        Read-Host
        EnableBySubscription $subscriptionIdList
        Write-Host ""
    }
    else
    {
        # No valid subscriptions were found, time to end.
        Write-Host ""
        Write-Host "No Valid subscriptions were found to register, exiting."
        Write-Host ""
    }




