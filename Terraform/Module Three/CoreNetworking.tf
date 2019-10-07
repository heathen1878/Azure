# Resources
resource "azurerm_resource_group" "CoreNetworkingRG" {
    name = "DJC-NE-TRAIN-IT-NET-INT-RG"
    location = "${var.Location}"
    tags = "${var.CoreNetworkingTags}"
}

resource "azurerm_public_ip" "publicIPAddress" {
    name = "vpnGatewayPublicIPAddress"
    resource_group_name = "${azurerm_resource_group.CoreNetworkingRG.name}"
    location = "${azurerm_resource_group.CoreNetworkingRG.location}"
    tags = "${azurerm_resource_group.CoreNetworkingRG.tags}"
    allocation_method = "Dynamic"   
}

resource "azurerm_virtual_network" "CoreVNet" {
    name = "Core"
    resource_group_name = "${azurerm_resource_group.CoreNetworkingRG.name}"
    location = "${azurerm_resource_group.CoreNetworkingRG.location}"
    tags = "${azurerm_resource_group.CoreNetworkingRG.tags}"
    address_space = ["10.0.0.0/16"]
    dns_servers = ["8.8.8.8","4.4.4.4"]
}

resource "azurerm_subnet" "Gateway" {
    name = "Gateway"
    resource_group_name = "${azurerm_resource_group.CoreNetworkingRG.name}"
    virtual_network_name = "${azurerm_virtual_network.CoreVNet.name}"
    address_prefix = "10.0.0.0/24"
}

resource "azurerm_subnet" "Training" {
    name = "Training"
    resource_group_name = "${azurerm_resource_group.CoreNetworkingRG.name}"
    virtual_network_name = "${azurerm_virtual_network.CoreVNet.name}"
    address_prefix = "10.0.1.0/24"
}

resource "azurerm_subnet" "Development" {
    name = "Development"
    resource_group_name = "${azurerm_resource_group.CoreNetworkingRG.name}"
    virtual_network_name = "${azurerm_virtual_network.CoreVNet.name}"
    address_prefix = "10.0.2.0/24"
}
    
resource "azurerm_virtual_network_gateway" "CoreVNetGateway" {
    name = "CoreVNetGateway"
    resource_group_name = "${azurerm_resource_group.CoreNetworkingRG.name}"
    location = "${azurerm_resource_group.CoreNetworkingRG.location}"
    tags = "${azurerm_resource_group.CoreNetworkingRG.tags}"
    type = "vpn"
    vpn_type = "RouteBased"
    sku = "Basic"
    enable_bgp = true

    ip_configuration {
        name = "CoreVNetGatewaySubnet"
        public_ip_address_id = "${azurerm_public_ip.publicIPAddress.id}"
        private_ip_address_allocation = "Dynamic"
        subnet_id = "${azurerm_subnet.Gateway.id}"
    }
}


