variable "environment" {
    description = "The environment for the resource group e.g. Production, Development, Training...."
}
variable "CompanyNamePrefix" {
    description = "Used to build the standard naming convention"
}
variable "WVDRGLocation" {
     description = "the Azure location for the resource group metadata"
}
variable "WVDRGTags" {
    type = "map"
    description = "list of tags for the Network Resource Group"
}
variable "RDBrokerURL" {
    type = "string"
    description = "RDBroker URL of the infrastructure"
    default = "https://rdbroker.wvd.microsoft.com"
}
variable "ResourceURL" {
    type = "string"
    description = "The resourceURL defining the Windows Virtual Desktop enterprise appplication"
    default = "https://mrs-prod.ame.gbl/mrs-RDInfra-prod"  
}
variable "AzureADUserPrincipalName" {
    type = "string"
    description = "An Azure AD user who has permissions to create resources (and a resource group, if chosen) in the Azure subscription. This can be accomplished by providing a user with a Contributor role in the Azure subscription"  
}
variable "AzureLoginPassword" {
    type = ""
    description = "The password that corresponds to the AzureADUserPrincipalName"
}
variable "_artifactsLocation" {
    type = "string"
    description = "The base URI where artifacts required by this template are located"
    default = "https://raw.githubusercontent.com/Azure/RDS-Templates/master/wvd-templates/wvd-management-ux/deploy/"
}






