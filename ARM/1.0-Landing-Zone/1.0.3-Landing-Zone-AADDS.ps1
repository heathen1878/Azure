<#
    .SYNOPSIS
        This script is used to deploy the prerequisite configurations for Azure Active Directory Domain Services. 

    .DESCRIPTION
        Reference: https://docs.microsoft.com/en-us/azure/active-directory-domain-services/template-create-instance
        Creates the following prerequisite configurations:
            1. Registers the Azure AD Domain Services resource provider using the Register-AzResourceProvider cmdlet
            2. Creates an Azure AD service principal using the New-AzureADServicePrincipal cmdlet for Azure AD DS to communicate and authenticate itself
            3. Creates an Azure AD group named AAD DC Administrators using the New-AzureADGroup cmdlet. Users added to this group are then granted permissions 
            to perform administration tasks on the Azure AD DS managed domain.
            4. Add a user to the group using the Add-AzureADGroupMember cmdlet.
            5. Runs the ARM template to deploy Azure Active Directory Domain Services

    .NOTES
        Version:        1.0.0.0
        Author:         Dom Clayton
        Creation Date:  29/01/2020 

    .EXAMPLE
        Set-ExecutionPolicy Bypass -Scope Process -Force;.\1.0.3-Landing-Zone-AADDS.ps1 `
        -ParameterFile ..\..\CustomerData\1.0-Landing-Zone\1.0-Landing-Zone-AADDS.json
      
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
Check whether the Microsoft.AAD Provider is registered.
#>
(Get-AzResourceProvider -ProviderNamespace Microsoft.AAD) | ForEach-Object {

    If (!($_.RegistrationState -ne "Registered")){
        Register-AzResourceProvider -ProviderNamespace $_.ProviderNamespace | Out-Null
        Write-Verbose "Regsitered Microsoft.AAD"   
    }
}
<#
Connect to Azure AD
#>
Connect-AzureAD | Out-Null

<#
Check whether the Azure AD Domain Controller Service principal is already present.
#>
If (!(Get-AzureADServicePrincipal -Filter "AppId eq '2565bd9d-da50-47d4-8b85-4c97f669dc36'")){

    New-AzureADServicePrincipal -AppId "2565bd9d-da50-47d4-8b85-4c97f669dc36" | Out-Null
    Write-Verbose "Service Principal created" -Verbose

} Else {

    Write-Verbose "Service Principal already exists" -Verbose

}

<#
Check whether the Azure AD DC Administrators group exists.
#>
If (!(Get-AzureADGroup -Filter "DisplayName eq 'AAD DC Administrators'")){

    New-AzureADGroup -DisplayName "AAD DC Administrators" `
    -Description "Delegated group to administer Azure AD Domain Services" `
    -SecurityEnabled $true -MailEnabled $false `
    -MailNickName "AADDCAdministrators" | Out-Null
    Write-Verbose "AAD DC Administrators group created" -Verbose

} Else {

    Write-Verbose "AAD DC Administrators group already exists" -Verbose

}
<#
Capture the objectId of the AAD DC Administrators group
#>
$GroupObjectId = (Get-AzureADGroup -Filter "DisplayName eq 'AAD DC Administrators'").ObjectId

<#
Create a menu structure for listing available users
#>
$MenuItems = $(Get-AzureADUser).UserPrincipalName
### Build a hashtable to hold the menu items ###
$Menu = @{}

Write-Host "List of available users" -ForegroundColor Cyan

### Loop through each item and assign a index.
[Int]$IndexNo = 1
$MenuItems | ForEach-Object {
    
    Write-Host "$IndexNo. $_" 
    $Menu.Add($IndexNo,$_)
    $IndexNo ++

}

[Int]$IndexSelection = Read-Host "Choose a user to add to the AAD DC Administrators group"
$Selection = $Menu.Item($IndexSelection)

$UserObjectId = Get-AzureADUser `
  -Filter "UserPrincipalName eq '$Selection'" | `
  Select-Object ObjectId

If ($UserObjectId.ObjectId -In (Get-AzureADGroupMember -ObjectId $GroupObjectId).ObjectId){

    Write-Warning "$($UserObjectId.ObjectId) is already a member of AAD DC Administrators group"

} Else {

    Add-AzureADGroupMember -ObjectId $GroupObjectId -RefObjectId $UserObjectId.ObjectId | Out-Null
    Write-Verbose "Added $($UserObjectId.ObjectId) to $($GroupObjectId)" -Verbose

}
<#
Disconnect from Azure AD
#>
Disconnect-AzureAD

<#
Import resource group configurations
#>
$Config = @{
    Configuration = $ParameterFile
}

# Import scheduling configuration from the external json file
$ResourceGroups = Get-Content -Path $config.Configuration -Raw | ConvertFrom-Json

<#
Check the network and shared services resource group exists
#>
If (Get-AzResourceGroup -Name (-Join($ResourceGroups.Company_Prefix),"-",$ResourceGroups.Location,"-",$ResourceGroups.Environment,"-NETWORK-RG")){

    Write-Verbose "Ready to deploy" -Verbose

}

If (Get-AzResourceGroup -Name (-Join($ResourceGroups.Company_Prefix),"-",$ResourceGroups.Location,"-",$ResourceGroups.Environment,"-SHAREDSERVICES-RG")){

    Write-Verbose "Ready to deploy" -Verbose

}

<#
Deploy the Azure Resource Management Template.
#>
$Name = (-Join("1.0.3-Landing-Zone-AADDS-",(Get-Date).Day,"-",(Get-Date).Month,"-",(Get-Date).Year,"-",(Get-Date).Hour,":",(Get-Date).Minute))
New-AzResourceGroupDeployment -Name $Name -ResourceGroupName XXX-WESTEUROPE-PROD-SHAREDSERVICES-RG -TemplateFile .\1.0.3-Landing-Zone-AADDS.json  -Deploy_AADDS "Yes" -Forest_Name $ResourceGroups.Forest_Name





<#
Disconnect from Azure
#>
Disconnect-AzAccount | Out-Null