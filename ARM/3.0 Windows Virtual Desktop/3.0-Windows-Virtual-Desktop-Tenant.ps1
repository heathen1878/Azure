<#
    .SYNOPSIS
        This script is used to start the deployment of a Windows Virtual Desktop tenant. 

    .DESCRIPTION
        Reference: https://docs.microsoft.com/en-gb/azure/virtual-desktop/tenant-setup-azure-active-directory
        Creates the following prerequisite configurations:
            1. Prompts for global admin privileges


    .PARAMETER FILE
        This script requires a file name and path e.g. .\2.0-Storage-Account-File-Shares.ps1 `
        -ParameterFile ..\..\CustomerData\1.0-Landing-Zone\1.0-Landing-Zone-resource-Groups.json

    .NOTES
        Version:        0.0.0.1
        Author:         Dom Clayton
        Creation Date:  05/02/2020 

    .EXAMPLE
        Set-ExecutionPolicy Bypass -Scope Process -Force;.\2.0-Storage-Account-File-Shares.ps1 `
        -ParameterFile ..\..\CustomerData\1.0-Landing-Zone\1.0-Landing-Zone-resource-Groups.json
      
#>
<#
Open the WVD server application for AAD consent. 
#>
Start-Process "Chrome.exe" "https://login.microsoftonline.com/common/adminconsent?client_id=5a0aa725-4958-4b0c-80a9-34562e23f3b7&redirect_uri=https%3A%2F%2Frdweb.wvd.microsoft.com%2FRDWeb%2FConsentCallback"

Start-Sleep -Verbose 60

<#
Open the WVD client application for AAD consent. 
#>
Start-Process "Chrome.exe" "https://login.microsoftonline.com/common/adminconsent?client_id=fa4345a4-a730-4230-84a8-7d9651b86739&redirect_uri=https%3A%2F%2Frdweb.wvd.microsoft.com%2FRDWeb%2FConsentCallback"


<#
Connect to Azure RM with a global admin
#>
Connect-AzAccount | Out-Null


