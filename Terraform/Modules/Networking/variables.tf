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
    default = {
        maintenanceWindow = ""
        expirationDate = ""
        department = ""
        applicationName = ""
        costCentre = ""
        description = ""
        technicalContact = ""
        dataClassification = ""
        regulatoryCompliance = ""
    } 
}
variable "VNetAddressSpace" {
    type = "list"
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



