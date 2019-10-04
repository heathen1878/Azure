# Variables
variable "My_Subscription_Id" {
  
}
variable "My_Client_Id" {
  
}
variable "My_Client_Secret" {
  
}
variable "My_Tenant_Id" {
  
}

# Providers
# Azure RM
provider "azurerm" {
    # Locked to version
    version = "~> 1.34"

    # consume variables from terraform.tfvars
    subscription_id = "${var.My_Subscription_Id}"
    client_id = "${var.My_Client_Id}"
    client_secret = "${var.My_Client_Secret}"
    tenant_id = "${var.My_Tenant_Id}"
}

# Resources
resource "azurerm_resource_group" "myRG" {

    name = "myRG"
    location = "northeurope"

    tags = {
        Environment = "Learning"
    }
}

# Output
# output the name of the new resource group
output "resource_group_name" {
    value = "${azurerm_resource_group.myRG.name}"
}
