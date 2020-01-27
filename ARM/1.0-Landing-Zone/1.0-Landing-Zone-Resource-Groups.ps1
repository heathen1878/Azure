<#
    .SYNOPSIS
        This script is used to create resource groups in Azure. The script takes input from a configuration file passed on the command line. 

    .DESCRIPTION
        Creates a number of resource groups in Azure based on the parameter file: '1.0-Landing-Zone-Resource-Groups.json'.

    .PARAMETER PARAMETERFILE
        This script requires a file name and path e.g. 
        .\1.0-Landing-Zone-Resource-Groups.ps1 -ParameterFile ..\..\CustomerData\1.0-Landing-Zone\1.0-Landing-Zone-Resource-Groups.json

    .NOTES
        Version:        1.0.0.0
        Author:         Dom Clayton
        Creation Date:  24/01/2020 

    .EXAMPLE
        Set-ExecutionPolicy Bypass -Scope Process -Force;.\1.0-Landing-Zone-Resource-Groups.ps1 `
        -ParameterFile ..\..\CustomerData\1.0-Landing-Zone\1.0-Landing-Zone-Resource-Groups.json
      
#>
<#
Parameter definition for the parameter file
#>
Param(
    [Parameter(Mandatory=$true,Position=1)]
    [string]$ParameterFile
)

Function New-ResourceGroup {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]
        $applicationName,
        [Parameter(Mandatory=$true)]
        [string]
        $costCenter,
        [Parameter(Mandatory=$true)]
        [string]
        $department,
        [Parameter(Mandatory=$false)]
        [string]
        $description,
        [Parameter(Mandatory=$true)]
        [string]
        $technicalContact,
        [Parameter(Mandatory=$true)]
        [string]
        $resourceGroupName,
        [Parameter(Mandatory=$true)]
        [string]
        $resourceGroupLocation
    )

    # default tags
    [hashtable]$resourceGroupTags = @{
        applicationName = $applicationName
        costCenter = $costCenter
        department = $department
        description  = $description
        technicalContact = $technicalContact
    }

    # Validate the location variable
    $AzureLocations = Get-AzLocation
    if ($resourceGroupLocation -in ($AzureLocations).Location -or $resourceGroupLocation -in ($AzureLocations).DisplayName){

        Write-verbose "$resourceGroupLocation is valid" -verbose

    } Else {
        Write-verbose "$resourceGroupLocation is not valid" -verbose
        Break
    }
    
    # Create a resource group from the variables above, if it doesn't already exist.
    If (!(Get-AzResourceGroup -Name $resourceGroupName)){

        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation -Tag $resourceGroupTags

    } Else {

        Write-Warning "$resourceGroupName already exists"

    }
}

<#
Import resource group configurations
#>
$Config = @{
    Configuration = $ParameterFile
}

# Import scheduling configuration from the external json file
$ResourceGroups = Get-Content -Path $config.Configuration -Raw | ConvertFrom-Json

<#
Connect to Azure RM
#>
Connect-AzAccount | Out-Null
<#
Loop through each resource group definition and create it in the Azure subscription.
#>
$ResourceGroups.ResourceGroups | ForEach-Object {

        New-ResourceGroup -applicationName $_.applicationNameTag `
        -costCenter $_.costCenterTag `
        -department $_.departmentTag `
        -description $_.descriptionTag `
        -technicalContact $_.technicalContactTag `
        -resourceGroupName (-join($ResourceGroups.Company_Prefix.ToUpper(),"-",(-join($ResourceGroups.Location.Split(" ")).ToUpper()),"-",$ResourceGroups.Environment.ToUpper(),"-",$_.Name.ToUpper(),"-RG")) `
        -resourceGroupLocation $ResourceGroups.Location

}

Disconnect-AzAccount | Out-Null


