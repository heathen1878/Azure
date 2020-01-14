# Variables
variable "subscription_id" {
    description = "Your Azure subscription ID"
}
variable "client_id" {
    description = "Your service prinicpal ID for auth"
}
variable "client_secret" {
    description = "Your service prinicpal password for auth"
}
variable "tenant_id" {
    description = "Your Azure subscription tenant ID"
}
variable "environment" {}
variable "CompanyNamePrefix" {}
variable "Location" {}
variable "AddressPrefix" {}
variable "vpnClient" {}
variable "VMRGTags" {}
variable "WinVirtualMachines" {
    type = "map"
}
variable "LinuxVirtualMachines" {
    type = "map"
}
variable "NSGs" {
    type = "map"
}
variable "WVDRGTags" {
    type = "map"
    description = "list of tags for the Network Resource Group"
}
variable "publicCertData" {
}
variable "publicCertName" { 
}
variable "azureADUserPrincipalName" {
}
variable "azureLoginPassword" {
}