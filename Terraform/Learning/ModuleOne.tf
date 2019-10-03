########################
# Variables
########################
variable "ARM_SUBSCRIPTION_ID" {}
variable "ARM_CLIENT_ID" {}
variable "ARM_CLIENT_SECRET" {}
variable "ARM_TENANT_ID" {}

########################
# Provider
########################

provider "azurerm" {
    version = "~> 1.34"

    subscription_id = "${var.ARM_SUBSCRIPTION_ID}"
    client_id = "${var.ARM_CLIENT_ID}"
    client_secret = "${var.ARM_CLIENT_SECRET}"
    tenant_id = "${var.ARM_TENANT_ID}"

}
resource "azurerm_resource_group" "myRg" {
    name = "myRG"
    location = "northeurope"
}


