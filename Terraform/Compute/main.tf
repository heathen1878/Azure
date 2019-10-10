# Providers
provider "azurerm" {
    version = "~> 1.34"

    # consume variables passed through from tfvars
    subscription_id = "${var.subscription_id}"
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
    tenant_id = "${var.tenant_id}"
}

# Build a network
module "CoreNetworking" {
    source = "../Modules/Networking"
    environment = "${var.environment}"
    CompanyNamePrefix = "${var.CompanyNamePrefix}"
    NetworkRGLocation = "${var.NetworkRGLocation}"
    NetworkRGTags = "${var.NetworkRGTags}"
    VNetAddressSpace = "${var.VNetAddressSpace}"
    VNetDNSServers = "${var.VNetDNSServers}"
    AddressPrefix = "${var.AddressPrefix}"
}




