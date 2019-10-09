# Variables
variable "My_Subscription_Id" {
    description = "Your Azure subscription ID"
}
variable "My_Client_Id" {
    description = "Your service prinicpal ID for auth"
}
variable "My_Client_Secret" {
    description = "Your service prinicpal password for auth"
}
variable "My_Tenant_Id" {
    description = "Your Azure subscription tenant ID"
}

variable "My_Storage_Account" {
    description = "the storage account name for holding Terraform state"
}

variable "My_Container_Name" {
    description = "the storage account container for holding terraform state"
}

variable "My_Terraform_State_FileName" {
    description = "the terraform state file name"
}

variable "My_Storage_Account_AccessKey" {
    description = "the storage account access key for the storage account which contains Terraform state"
}

variable "My_NetworkRGName" { 
    description = "The name of your Resource Group for Network components e.g. <company identifier>-<Cloud Region>-<environment>-<team>-<purpose>-<internal/external>-RG"
}

variable "My_NetworkRGLocation" {
    description = "the Azure location for the resource group metadata"
}

variable "My_NetworkRGTags" {
    type = "map"
    description = "list of tags for the Network Resource Group"
    default = {
        environment = ""
        maintenanceWindow = ""
        expirationDate = ""
        timeWindow = ""
        department = ""
        applicationName = ""
        costCentre = ""
        description = ""
        technicalContact = ""
        dataClassification = ""
        regulatoryCompliance = ""
    }
}








