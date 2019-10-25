variable "environment" {
    description = "The environment for the resource group e.g. Production, Development, Training...."
}
variable "CompanyNamePrefix" {
    description = "Used to build the standard naming convention"
}
variable "NetworkRGLocation" {
     description = "the Azure location for the resource group metadata"
}
variable "NetworkRGTags" {
    type = "map"
    description = "list of tags for the Network Resource Group"
}
variable "VNetAddressSpace" {
    type = "list"
}
variable "vpnClient" {
}
variable "VNetDNSServers" {
    type = "list"
}
variable "AddressPrefix" {
    type = "map"
    default = {
        subnet1 = "0.0.0.0/0"
    }
}
variable "publicCertData" {
}
variable "publicCertName" {  
}
