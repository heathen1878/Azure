resource "azurerm_resource_group" "NetworkRG" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.NetworkRGLocation)}-${upper(var.environment)}-NETWORK-RG"
    location = "${var.NetworkRGLocation}"
    tags = "${var.NetworkRGTags}"
}

resource "azurerm_virtual_network" "VNet" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.NetworkRGLocation)}-${upper(var.environment)}-VNET-${replace(upper(var.VNetAddressSpace[0]),"/","-")}"
    resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
    location = "${azurerm_resource_group.NetworkRG.location}"
    address_space = "${var.VNetAddressSpace}"
    dns_servers = "${var.VNetDNSServers}"
}

resource "azurerm_public_ip" "publicIPAddress" {
    name = "${azurerm_virtual_network.VNet.name}-PIP-1"
    resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
    location = "${azurerm_resource_group.NetworkRG.location}"
    allocation_method = "Dynamic"   
}

resource "azurerm_subnet" "Subnet" {
    for_each = "${var.AddressPrefix}"
    name = <<-EOT
%{~ if "${each.key}" != "gateway" ~}
${upper(var.CompanyNamePrefix)}-${upper(var.NetworkRGLocation)}-${upper(var.environment)}-${upper(each.key)}-${replace(upper(each.value),"/","-")}
%{~ else ~}
GatewaySubnet
%{~ endif ~}
EOT
    resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
    virtual_network_name = "${azurerm_virtual_network.VNet.name}"
    address_prefix = "${each.value}"
}
     
  
data "azurerm_subnet" "gateway" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.NetworkRGLocation)}-${upper(var.environment)}-GATEWAY-10.0.1.0-24"
    virtual_network_name = "${upper(var.CompanyNamePrefix)}-${upper(var.NetworkRGLocation)}-${upper(var.environment)}-VNET-${replace(upper(var.VNetAddressSpace[0]),"/","-")}"
    resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
    depends_on = ["azurerm_subnet.Subnet"]
} 

resource "azurerm_virtual_network_gateway" "VNetGateway" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.NetworkRGLocation)}-${upper(var.environment)}-${replace(upper(var.VNetAddressSpace[0]),"/","-")}-GW"
    resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
    location = "${azurerm_resource_group.NetworkRG.location}"
    type = "vpn"
    vpn_type = "RouteBased"
    sku = "Basic"
    enable_bgp = true

    ip_configuration {
        name = "VNetGatewaySubnet"
        public_ip_address_id = "${azurerm_public_ip.publicIPAddress.id}"
        private_ip_address_allocation = "Dynamic"
        subnet_id = "${data.azurerm_subnet.gateway.id}"
    }
    depends_on = ["azurerm_subnet.Subnet"]
}