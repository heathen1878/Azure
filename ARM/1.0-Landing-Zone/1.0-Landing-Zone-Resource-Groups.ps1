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
    
    # Create a resource group from the variables above.
    New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation -Tag $resourceGroupTags
}

<#
Import resource group configurations
#>
$Config = @{
    Configuration = '.\1.0-Landing-Zone-Resource-Groups.json'
}

# Import scheduling configuration from the external json file
$ResourceGroups = Get-Content -Path $config.Configuration -Raw | ConvertFrom-Json

<#
Connect to Azure RM
#>
Connect-AzAccount
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

Disconnect-AzAccount


