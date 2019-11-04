variable "environment" {
    description = "The environment for the resource group e.g. Production, Development, Training...."
}
variable "CompanyNamePrefix" {
    description = "Used to build the standard naming convention"
}
variable "VMRGLocation" {
     description = "the Azure location for the resource group metadata"
}
variable "VNetAddressSpace" {
    type = "list"
}
variable "NetworkRGLocation" {}
variable "VMRGTags" {
    type = "map"
    description = "list of tags for the Network Resource Group"
}
variable "WinVirtualMachines" {
    type = "map"
    description = "a nested map of VM instances and their configuration"
}
variable "LinuxVirtualMachines" {
    type = "map"
    description = "a nested map of VM instances and their configuration"
}
variable "Subnets" {
  
}
variable "extensions" {
    type = "map"
    description = "Used to centrally define extensions and their respective properties. To allow for variations on the same extensions for each VM"  
}


