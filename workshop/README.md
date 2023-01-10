# SQL IaaS Extension workshop

## Goals

| **Goal**              | *Description*                                    |
| ----------------------------- | --------------------------------------------------------------------- |
| **What will you learn**       | *The benefits of enabling the SQL Server IaaS extension on your virtual machines* |
| **Duration**                  | *Two hours*                                                                |
| **Microsoft Cloud Topics taught**                  | *Azure, Azure SQL Server on VM*                                                                |
| **Slides** | [Powerpoint](BenefitsofSQLVMIaaSextension.pptx) 

## SQL Server IaaS Extension

<img style="float: right;" src="./images/SQL Iaas 1.png">

## Video

Overview video regarding the benefits of the SQL Server IaaS Extension [available here](https://www.youtube.com/watch?v=KUlpjoeFipk).

## What workshop attendees will learn

The SQL Server IaaS Agent extension allows for integration with the Azure portal and unlocks a number of feature benefits for SQL Server on Azure VMs:

Feature benefits: The extension unlocks a number of automation feature benefits, such as portal management, license flexibility, automated backup, automated patching and more. See Feature benefits later in this article for details.

Compliance: The extension offers a simplified method to fulfill the requirement of notifying Microsoft that the Azure Hybrid Benefit has been enabled as is specified in the product terms. This process negates needing to manage licensing registration forms for each resource.

Free: The extension in all three manageability modes is completely free. There is no additional cost associated with the extension, or with changing management modes.

Simplified license management: The extension simplifies SQL Server license management, and allows you to quickly identify SQL Server VMs with the Azure Hybrid Benefit enabled using the Azure portal, PowerShell or the Azure CLI.

### Benefits overview

<img style="float: right;" src="./images/SQL Iaas 2.png">

### Options for enabling the extension

<img style="float: right;" src="./images/SQL Iaas 3.png">

PowerShell scripts can be found [here](./solution)

## Workshop Tutorial Steps

1. Download the PowerPoint presentation from [here](BenefitsofSQLVMIaaSextension.pptx).
2. Get familiar with the advantages of the SQL Server IaaS Extension.
3. Download and become familiar with the scripts [here](./solution).
4. Open a new browser tab and then go to your Azure portal by copying this [link](https://portal.azure.com).

## Links

Microsoft documentation for SQL Server IaaS Extension [available here](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/sql-server-iaas-agent-extension-automate-management?view=azuresql&tabs=azure-powershell)

Migrate on-prem SQL Server to Azure VM using Azure Data Studio [click here](https://learn.microsoft.com/en-us/azure/dms/tutorial-sql-server-to-virtual-machine-online-ads)

What is SQL Server IaaS Agent Video on Data Exposed [here](https://techcommunity.microsoft.com/t5/video-hub/azure-sql-vm-what-is-sql-server-iaas-agent-extension-ep-2-data/ba-p/2617227)

Baseline Powershell modules to create your own custom code and deeper dives can be found [here](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/sql-agent-extension-manually-register-single-vm?view=azuresql&tabs=powershell)  or just use the prebuilt scripts for a much easier interface.

SQL Server Privacy Statement for the IaaS extension agent [here](https://learn.microsoft.com/en-us/sql/sql-server/sql-server-privacy?view=sql-server-ver16#non-personal-data)





[Code of Conduct](../CODE_OF_CONDUCT.md)

