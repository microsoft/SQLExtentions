##########################################
PowerShell to turn on VM lightweight mode
##########################################

# List VM's and then Set variables for specific VM
Get-AzVM

$vm = Get-AzVM -Name VM2 -ResourceGroupName VM1_Group

 # Register SQL VM with 'Lightweight' SQL IaaS agent
New-AzSqlVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Location $vm.Location `
 -LicenseType AHUB  -SqlManagementType LightWeight

# Change to fullmode
Update-AzSqlVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName `
    -SqlManagementType Full

# Remove the extension
Remove-AzSqlVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName 