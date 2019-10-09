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
variable "storage_account" {
    description = "the storage account name for holding Terraform state"
}
variable "container_name" {
    description = "the storage account container for holding terraform state"
}
variable "terraform_state_filename" {
    description = "the terraform state file name"
}
variable "storage_account_accesskey" {
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
        department = ""
        applicationName = ""
        costCentre = ""
        description = ""
        technicalContact = ""
        dataClassification = ""
        regulatoryCompliance = ""
    }
}

/*timeWindow = ""*/







