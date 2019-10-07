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
resource "azurerm_resource_group" "CoreNetworkingRG" {
    name = "DJC-NE-TRAIN-IT-NET-INT-RG"
    location = "${var.Location}"
    tags = "${var.NSGTags}"
}