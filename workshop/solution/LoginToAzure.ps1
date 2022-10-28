 <#
.SYNOPSIS
    This script makes it easy to authenticate to your Azure Account and should be run first before any other scripts are run.
    AzureRM will be tested first and if not found, will use AZ module - if AZ module not found, it will install.

.DESCRIPTION
    A dialog box will pop up asking for credentials and will be used for the balance of the sessions.

    Prerequisites:
        None, but may require MFA based on your organizations policies.


.EXAMPLE  
    To output a list of subscriptions, simply run this powershell script.


    PS C:\MyScripts> .\AzureLogin.ps1
    
#>

    if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable))
    {
            Write-Host ""
            Write-Host "AzureRM is already installed. Registering using AzureRm commands";
            Write-Host ""
            Write-Host "Please login to your account which have access to the subscriptions you want to update"
            Write-Host ""

            #User may already be logged in, but force a re-login in case another account needs to be used.
            $Output = Connect-AzureRmAccount -ErrorAction Stop;
            if ((Get-AzurermContext | Select Account) -ne $null)
            {
                Write-Host "Login Successful"
            }
    }
    else 
    {
        # Since AzureRm module is not availavle, we will use Az module.
        Write-Host ""
        Write-Host "Installing Az powershell module if not installed already."
        Install-Module -Name Az -AllowClobber -Scope CurrentUser;
        
        Write-Host ""
        #User may already be logged in, but force a re-login in case another account needs to be used.
        Write-Host "Please login to your account which have access to the subscriptions you want to update";
        $Output = Connect-AzAccount -ErrorAction Stop;
        Write-Host ""
        if ((Get-AzContext | Select Account) -ne $null)
        {
            Write-Host "Login Successful"
        }
    }