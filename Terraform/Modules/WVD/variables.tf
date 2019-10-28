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
variable "azureADUserPrincipalName" {
}
variable "azureLoginPassword" {
}