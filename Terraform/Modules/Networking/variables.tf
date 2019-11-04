variable "environment" {
    description = "The environment for the resource group e.g. Production, Development, Training...."
}
variable "companyNamePrefix" {
    description = "Used to build the standard naming convention"
}
variable "networkRGLocation" {
     description = "the Azure location for the resource group metadata"
}
variable "networkRGTags" {
    type = "map"
    description = "list of tags for the Network Resource Group"
}
variable "vNetAddressSpace" {
    type = "list"
}
variable "vpnClient" {
}
variable "vNetDNSServers" {
    type = "list"
}
variable "addressPrefix" {
    type = "map"
    default = {
        subnet1 = "0.0.0.0/0"
    }
}
variable "publicCertData" {
}
