# Variables
variable "CoreNetworkingTags" {
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

variable "NSGTags" {
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

variable "Location" {
    description = "Default Azure Region"
    default = "North Europe"
}


  