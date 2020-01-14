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
    $AzureLocations = Get-AzureRmLocation
    if ($resourceGroupLocation -in ($AzureLocations).Location -or $resourceGroupLocation -in ($AzureLocations).DisplayName){

        Write-verbose "$resourceGroupLocation is valid" -verbose

    } Else {
        Write-verbose "$resourceGroupLocation is not valid" -verbose
        Break
    }
    
    # Create a resource group from the variables above.
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation -Tag $resourceGroupTags
}