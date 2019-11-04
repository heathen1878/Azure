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
variable "NetworkRGTags" {}
variable "VNetAddressSpace" {}
variable "VNetDNSServers" {}
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
variable "LARGTags" {
    type = "map"
    description = "list of tags for the Network Resource Group"
}
variable "extensions" {
    type = "map"
    description = "Used to centrally define extensions and their respective properties. To allow for variations on the same extensions for each VM"
    default = {
        DSC = {
            type_handler_extension = "2.9.1.0"
            type = "DSC"
            publisher = "Microsoft.Powershell"
        }
        WinNetworkWatcher = {
            type_handler_extension = "1.4.905.3"
            type = "NetworkWatcherAgentWindows"
            publisher = "Microsoft.Azure.NetworkWatcher"
        }
        LinuxNetworkWatcher = {
            type_handler_extension = "1.4.905.3"
            type = "NetworkWatcherAgentLinux"
            publisher = "Microsoft.Azure.NetworkWatcher"
        }
    }
}