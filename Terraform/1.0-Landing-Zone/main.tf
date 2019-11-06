# Providers
provider "azurerm" {
    version = "~> 1.34"

    # consume variables passed through from tfvars
    subscription_id = "${var.subscription_id}"
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
    tenant_id = "${var.tenant_id}"
}
module "CoreNetworking" {
    source = "../Modules/Networking"
    environment = "${var.environment}"
    companyNamePrefix = "${var.companyNamePrefix}"
    location = "${var.location}"
    tags = "${var.networkTags}"
    vNETs = "${var.vNETs}"
    spokes = "${var.spokes}"
    vpnClientAddressSpace = "${var.vpnClientAddressSpace}"
    publicCertData = "${var.publicCertData}"
}