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
resource "azurerm_resource_group" "djc-ne-training-it-vms-int-RG" {

    name = "${var.RG}"
    location = "${var.location}"
    tags = "${var.tags}"
}

resource "azurerm_storage_account" "djcnetrainingvmsint0" {
    name = "djcne${var.tags["environment"]}vmsint0"
    resource_group_name = "${azurerm_resource_group.djc-ne-training-it-vms-int-RG.name}"
    location = "${azurerm_resource_group.djc-ne-training-it-vms-int-RG.location}"
    account_tier = "standard"
    account_replication_type = "LRS"
    tags = "${azurerm_resource_group.djc-ne-training-it-vms-int-RG.tags}"
}

# Output
# output the name of the new resource group
output "resource_group_name" {
    value = "${azurerm_resource_group.djc-ne-training-it-vms-int-RG.name}"
}

output "locations" {
  value = "${length(var.webAppLocations)}"
}


