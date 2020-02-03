<#
    .SYNOPSIS
        This script is used to deploy the File Storage, Storage Accounts.

    .DESCRIPTION
        Reference: 
        Creates the following prerequisite configurations:
            1. A storage Account resource group exists.

    .PARAMETER FILE
        This script requires a file name and path e.g. .\2.0-Storage-Account-File-Shares.ps1 `
        -ParameterFile ..\..\CustomerData\1.0-Landing-Zone\1.0-Landing-Zone-resource-Groups.json

    .NOTES
        Version:        0.0.0.1
        Author:         Dom Clayton
        Creation Date:  03/02/2020 

    .EXAMPLE
        Set-ExecutionPolicy Bypass -Scope Process -Force;.\2.0-Storage-Account-File-Shares.ps1 `
        -ParameterFile ..\..\CustomerData\1.0-Landing-Zone\1.0-Landing-Zone-resource-Groups.json
      
#>
<#
Parameter definition for the parameter file
#>
Param(
    [Parameter(Mandatory=$true,Position=1)]
    [string]$ParameterFile
)

<#
Connect to Azure RM
#>
Connect-AzAccount | Out-Null

<#
Import resource group configurations
#>
$Config = @{
    Configuration = $ParameterFile
}

# Import scheduling configuration from the external json file
$ResourceGroups = Get-Content -Path $config.Configuration -Raw | ConvertFrom-Json

<#
Check the storage resource group exists
#>
If (Get-AzResourceGroup -Name (-Join($ResourceGroups.Company_Prefix,"-",(-join($ResourceGroups.Location.Split(" ")).ToUpper()),"-",$ResourceGroups.Environment.ToUpper(),"-STORAGE-RG"))){

    Write-Verbose "Ready to deploy" -Verbose

}

<#
Deploy the Azure Resource Management Template.
#>
$Name = (-Join("2.0-Storage-Account-File-Shares-",(Get-Date).Day,"-",(Get-Date).Month,"-",(Get-Date).Year,"-",(Get-Date).Hour,(Get-Date).Minute))
New-AzResourceGroupDeployment -Name $Name -ResourceGroupName (-Join($ResourceGroups.Company_Prefix,"-",(-join($ResourceGroups.Location.Split(" ")).ToUpper()),"-",$ResourceGroups.Environment.ToUpper(),"-STORAGEs-RG")) `
-TemplateFile .\2.0-Storage-Account-File-Shares.json -Company_Prefix $ResourceGroups.Company_Prefix -Environment $ResourceGroups.Environment `
-TemplateParameterFile ..\..\CustomerData\2.0-Storage\2.0-Storage-Account-File-Shares.parameters.json

<#
Disconnect from Azure
#>
Disconnect-AzAccount | Out-Null