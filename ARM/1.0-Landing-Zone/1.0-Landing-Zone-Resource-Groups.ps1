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

<#####################################################################################################################
FUNCTIONS
#####################################################################################################################>
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
        [string[]]
        $resourceGroupLocation,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]
        $policyDefRGTags,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]
        $policyDefLocations,
        [Parameter(Mandatory=$true)]
        [PSCustomObject]
        $policyDefResourceTypes
    )

    # default tags
    [hashtable]$resourceGroupTags = @{
        applicationName = $applicationName
        costCenter = $costCenter
        department = $department
        description  = $description
        technicalContact = $technicalContact
    }


    [hashtable]$ResourceGroupAllowedLocations = @{'listOfAllowedLocations'=$resourceGroupLocation}

    [hashtable]$NetworkGroupResourceTypes = @{
        listOfResourceTypesAllowed = "Microsoft.Network/networkWatchers",
        "Microsoft.Network/networkWatchers/*",
        "Microsoft.Authorization/locks",
        "Microsoft.Authorization/policyAssignments",
        "Microsoft.Authorization/roleAssignments",
        "Microsoft.Network/networkInterfaces",
        "Microsoft.Network/networkSecurityGroups",
        "Microsoft.Network/networkSecurityGroups/securityRules",
        "Microsoft.Network/azureFirewalls",
        "Microsoft.Network/loadBalancers",
        "Microsoft.Network/vpnGateways",
        "Microsoft.Network/virtualNetworks",
        "Microsoft.Network/virtualNetworks/subnets",
        "Microsoft.Network/publicIPAddresses",
        "Microsoft.Network/virtualNetworkGateways",
        "Microsoft.Resource/checkPolicyCompliance"
    }

    [hashtable]$ComputeGroupResourceTypes = @{
        listOfResourceTypesAllowed = "Microsoft.Authorization/locks",
        "Microsoft.Authorization/policyAssignments",
        "Microsoft.Authorization/roleAssignments",
        "Microsoft.Compute/availabilitySets",
        "Microsoft.Compute/virtualMachines",
        "Microsoft.Compute/virtualMachines/*",
        "Microsoft.Compute/virtualMachineScaleSets",
        "Microsoft.Compute/virtualMachineScaleSets/extensions",
        "Microsoft.Compute/virtualMachineScaleSets/virtualMachines"
    }

    [hashtable]$StorageGroupResourceTypes = @{
        listOfResourceTypesAllowed = "Microsoft.Authorization/locks",
        "Microsoft.Authorization/policyAssignments",
        "Microsoft.Authorization/roleAssignments",
        "Microsoft.Storage/locations",
        "Microsoft.Storage/locations/*",
        "Microsoft.Storage/storageAccounts",
        "Microsoft.Storage/storageAccounts/*",
        "Microsoft.Storage/operations",
        "Microsoft.Storage/checkNameAvailability",
        "Microsoft.Storage/usage"
    }
    

    # Validate the location variable
    $AzureLocations = Get-AzLocation
    if ($resourceGroupLocation[0] -in ($AzureLocations).Location -or $resourceGroupLocation[0] -in ($AzureLocations).DisplayName){

        Write-verbose "$resourceGroupLocation is valid" -verbose

    } Else {
        Write-verbose "$resourceGroupLocation is not valid" -verbose
        Break
    }
    
    # Create a resource group from the variables above, if it doesn't already exist.
    Try {

        Get-AzResourceGroup -Name $resourceGroupName -ErrorAction Stop | Out-Null
        Write-Warning "$resourceGroupName already exists"

    }
    Catch {

            # Resource group doesn't exist, create it.
            New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation[0] -Tag $resourceGroupTags | Out-Null
    
    }

    Try {
        Get-AzPolicyAssignment -Name "Require_$($key)_Tag_On_Resource_Groups" -ErrorAction Stop -Scope (Get-AzResourceGroup -Name $resourceGroupName).ResourceId
        Write-Warning "Policy: RequireTagOnResourceGroups on $resourceGroupName already exists"
    }
    Catch {
        
        foreach ($key in $resourceGroupTags.keys){

            $TagPolicy = '{"tagName" : {"value" :"' +  $key + '"},"tagValue" : {"value":"' +  $resourceGroupTags[$key] + '"}}'
            New-AzPolicyAssignment -Name "Require_$($key)_Tag_On_Resource_Groups" -DisplayName "Require $key tag on resource groups" -Scope (Get-AzResourceGroup -Name $resourceGroupName).ResourceId -PolicyDefinition $policyDefRGTags -PolicyParameter $TagPolicy | Out-Null
        
        }

    }
    
    Try {
        Get-AzPolicyAssignment -Name "ResourceGroupAllowedLocations" -ErrorAction Stop -Scope (Get-AzResourceGroup -Name $resourceGroupName).ResourceId
        Write-Warning "Policy: ResourceGroupAllowedLocations on $resourceGroupName already exists"
    }
    Catch {
        New-AzPolicyAssignment -Name "ResourceGroupAllowedLocations" -DisplayName "Allowed Locations within Resource Group" -Scope (Get-AzResourceGroup -Name $resourceGroupName).ResourceId -PolicyDefinition $policyDefLocations -PolicyParameterObject $ResourceGroupAllowedLocations | Out-Null
    }

    Switch ($resourceGroupName.Split('-')[3]){
        Network 
        {
            Try {
                Get-AzPolicyAssignment -Name 'NetworkResourceGroupAllowedResourceTypes' -ErrorAction Stop -Scope (Get-AzResourceGroup -Name $resourceGroupName).ResourceId
                Write-Warning "Policy: NetworkResourceGroupAllowedResourceTypes on $resourceGroupName already exists"
            }
            Catch {
                New-AzPolicyAssignment -Name 'NetworkResourceGroupAllowedResourceTypes' -DisplayName 'Allowed resource types within the Network Resource Group' -Scope (Get-AzResourceGroup -Name $resourceGroupName).ResourceId -PolicyDefinition $policyDefResourceTypes -PolicyParameterObject $NetworkGroupResourceTypes | Out-Null
            }
        }
        Compute
        {
            Try {
                Get-AzPolicyAssignment -Name 'ComputeResourceGroupAllowedResourceTypes' -ErrorAction Stop -Scope (Get-AzResourceGroup -Name $resourceGroupName).ResourceId
                Write-Warning "Policy: ComputeResourceGroupAllowedResourceTypes on $resourceGroupName already exists"
            }
            Catch {
                New-AzPolicyAssignment -Name 'ComputeResourceGroupAllowedResourceTypes' -DisplayName 'Allowed resource types within the Compute Resource Group' -Scope (Get-AzResourceGroup -Name $resourceGroupName).ResourceId -PolicyDefinition $policyDefResourceTypes -PolicyParameterObject $ComputeGroupResourceTypes | Out-Null
            }
        }
        Storage
        {
            Try {
                Get-AzPolicyAssignment -Name 'StorageResourceGroupAllowedResourceTypes' -ErrorAction Stop -Scope (Get-AzResourceGroup -Name $resourceGroupName).ResourceId
                Write-Warning "Policy: StorageResourceGroupAllowedResourceTypes on $resourceGroupName already exists"
            }
            Catch {
                New-AzPolicyAssignment -Name 'StorageResourceGroupAllowedResourceTypes' -DisplayName 'Allowed resource types within the Storage Resource Group' -Scope (Get-AzResourceGroup -Name $resourceGroupName).ResourceId -PolicyDefinition $policyDefResourceTypes -PolicyParameterObject $StorageGroupResourceTypes  | Out-Null
            }
        }
        SharedServices
        {

        }
    }

}

<#####################################################################################################################
END OF FUNCTIONS
#####################################################################################################################>

<######################################################################################################################
GOVERNANCE
######################################################################################################################>
<#
Connect to Azure RM
#>
Connect-AzAccount | Out-Null

<#
Policy for checking tagging compliance
#>
$TagsOnRGs = Get-AzPolicyDefinition | Where-Object {$_.Properties.DisplayName -eq 'Require tag and its value on resource groups'}

<#
Policy assignment for defining allowed resources
#>
$AllowedResources = Get-AzPolicyDefinition | Where-Object {$_.Properties.DisplayName -eq 'Allowed resource types'}

<#
Policy assignment for defining allowed locations
#>
$AllowedLocations = Get-AzPolicyDefinition | Where-Object {$_.Properties.DisplayName -eq 'Allowed locations'}

<#####################################################################################################################
RBAC
#####################################################################################################################>
<#####################################################################################################################
END OF GOVERNANCE
######################################################################################################################>


######################################################################################################################
# RESOURCES
######################################################################################################################
<#
Import resource group configurations
#>
$Config = @{
    Configuration = $ParameterFile
}

# Import scheduling configuration from the external json file
$ResourceGroups = Get-Content -Path $config.Configuration -Raw | ConvertFrom-Json

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
        -resourceGroupLocation $ResourceGroups.Location `
        -policyDefRGTags $TagsOnRGs `
        -policyDefLocations $AllowedLocations `
        -policyDefResourceTypes $AllowedResources

}

<#
Deploy the Azure Resource Management Template.
#>
$Name = (-Join("1.0-Landing-Zone-",(Get-Date).Day,"-",(Get-Date).Month,"-",(Get-Date).Year,"-",(Get-Date).Hour,(Get-Date).Minute))
New-AzResourceGroupDeployment -Name $Name -ResourceGroupName (-Join($ResourceGroups.Company_Prefix,"-",(-join($ResourceGroups.Location.Split(" ")).ToUpper()),"-",$ResourceGroups.Environment.ToUpper(),"-NETWORK-RG")) `
-TemplateFile .\1.0-Landing-Zone.json -TemplateParameterFile ..\..\CustomerData\1.0-Landing-Zone\1.0-Landing-Zone.parameters.json

New-AzResourceGroupDeployment -Name $Name -ResourceGroupName (-Join($ResourceGroups.Company_Prefix,"-",(-join($ResourceGroups.Location.Split(" ")).ToUpper()),"-",$ResourceGroups.Environment.ToUpper(),"-STORAGE-RG")) `
-TemplateFile .\1.0.2.0-Landing-Zone-Log-Analytics-Storage.json -Company_Prefix $ResourceGroups.Company_Prefix -Environment $ResourceGroups.Environment 


<#####################################################################################################################
END OF RESOURCES
#####################################################################################################################>

Disconnect-AzAccount | Out-Null