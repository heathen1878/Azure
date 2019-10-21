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
variable "NetworkRGLocation" {}
variable "NetworkRGTags" {}
variable "VNetAddressSpace" {}
variable "VNetDNSServers" {}
variable "AddressPrefix" {}
variable "VMRGLocation" {}
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
