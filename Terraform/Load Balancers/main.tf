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
    NetworkRGLocation = "${var.Location}"
    NetworkRGTags = "${var.NetworkRGTags}"
    VNetAddressSpace = "${var.VNetAddressSpace}"
    VNetDNSServers = "${var.VNetDNSServers}"
    AddressPrefix = "${var.AddressPrefix}"
    vpnClient = "${var.vpnClient}"
    publicCertName = "${var.publicCertName}"
    publicCertData = "${var.publicCertData}"
}

module "VirtualMachines" {
    source = "../Modules/VirtualMachines"
    environment = "${var.environment}"
    CompanyNamePrefix = "${var.CompanyNamePrefix}"
    NetworkRGLocation = "${var.Location}"
    VMRGLocation = "${var.Location}"
    VMRGTags = "${var.VMRGTags}"
    VNetAddressSpace = "${var.VNetAddressSpace}"
    WinVirtualMachines = "${var.WinVirtualMachines}"
    LinuxVirtualMachines = "${var.LinuxVirtualMachines}"
    Subnets = "${module.CoreNetworking.Subnets}"
}
