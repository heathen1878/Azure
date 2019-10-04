# Variables
variable "My_Subscription_Id" {
  
}
variable "My_Client_Id" {
  
}
variable "My_Client_Secret" {
  
}
variable "My_Tenant_Id" {
}

variable "RG" {
    default = "djc-ne-training-it-vms-int-RG"
}

variable "location" {
    default = "northeurope"
}

variable "tags" {
    type = "map"
    default = {
        environment = "training"
        source = "terraform"
    }
}

variable "webAppLocations" {
    default = ["northeurope","westeurope","uksouth","westuk"]  
}
