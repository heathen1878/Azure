terraform {
    backend "azurerm" {
        storage_account_name = "${var.storageAccount}"
        container_name = "${var.containerName}"
        key = "${var.terraformStateFileName}"
        access_key = "${var.storageAccountAccessKey}"
    }
}