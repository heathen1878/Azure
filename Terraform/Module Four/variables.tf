# Variables
variable "My_Subscription_Id" {
  
}
variable "My_Client_Id" {
  
}
variable "My_Client_Secret" {
  
}
variable "My_Tenant_Id" {
}
variable "CoreNetworkingTags" {
    type = "map"
    default = {
        Environment = "Training" 
        MaintenanceWindows = ""
        ExpirationDate = ""
        TimeWindow = ""
        Department = ""
        ApplicationName = "Networking"
        CostCenter = "IT"
        Description = "Resource group for core networking"
        TechnicalContact = "Cloud Engineering"
        DataClassification = "Internal Use Only"
        RegulatoryCompliance = ""
    }
}

variable "NSGTags" {
    type = "map"
    default = {
        Environment = "Training" 
        MaintenanceWindows = ""
        ExpirationDate = ""
        TimeWindow = ""
        Department = ""
        ApplicationName = "Security"
        CostCenter = "IT"
        Description = "Resource group for security configuration"
        TechnicalContact = "Cloud Engineering"
        DataClassification = "Internal Use Only"
        RegulatoryCompliance = ""
    }
}

variable "WebAppTags" {
    type = "map"
    default = {
        Environment = "Training" 
        MaintenanceWindows = ""
        ExpirationDate = ""
        TimeWindow = ""
        Department = ""
        ApplicationName = "Web"
        CostCenter = "IT"
        Description = "Resource group for Web Applications"
        TechnicalContact = "Cloud Engineering"
        DataClassification = "Internal Use Only"
        RegulatoryCompliance = ""
    }
}

variable "Location" {
    description = "Default Azure Region"
    default = "North Europe"
}

variable "WebAppLocations" {
    default = ["northeurope","westeurope","uksouth","westuk"]  
}