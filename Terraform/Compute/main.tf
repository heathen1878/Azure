# backend
terraform {
    backend "azurerm" {
        storage_account_name = "${var.storage_account}"
        container_name = "${var.container_name}"
        key = "${var.terraform_state_filename}"
        access_key = "${var.storage_account_accesskey}"
    }
}

# Providers
provider "azurerm" {
    version = "~> 1.34"

    # consume variables passed through from main.tf
    subscription_id = "${var.subscription_id}"
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
    tenant_id = "${var.tenant_id}"
}

module "NetworkRG" {
    source = "../Modules/ResourceGroup"
    ResourceGroupName = "${var.My_NetworkRGName}"
    Location = "${var.My_NetworkRGLocation}"
    Tags = "${var.My_NetworkRGTags}"
}
/*
module "NSGsRG" {
    source = "../modules/ResourceGroups"
    ResourceGroupName = ""
    Location = ""
    Tags = ""
}

module "StorageRG" {
    source = "../modules/ResourceGroups"
    ResourceGroupName = ""
    Location = ""
    Tags = ""
}

module "VMRG" {
    source = "../modules/ResourceGroups"
    ResourceGroupName = ""
    Location = ""
    Tags = ""
}
*/
