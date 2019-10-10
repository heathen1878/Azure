resource "azurerm_resource_group" "NetworkRG" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.NetworkRGLocation)}-${upper(var.environment)}-NETWORK-RG"
    location = "${var.NetworkRGLocation}"
    tags = "${var.NetworkRGTags}"
}

data "azurerm_policy_definition" "RequireTagsOnRG" {
    display_name = "Require tag and its value on resource groups"
    depends_on = ["azurerm_resource_group.NetworkRG"]
}

resource "azurerm_policy_assignment" "MandatoryTagPolicy" {
    for_each = "${var.NetworkRGTags}"
    name = "Require ${each.key} and its value on resource groups"
    scope = "${azurerm_resource_group.NetworkRG.id}"
    policy_definition_id = "${data.azurerm_policy_definition.RequireTagsOnRG.id}"
    description = "Enforces a required tag and its value on resource groups."
    display_name = "Require ${each.key} and its value on resource groups"

    parameters = <<PARAMETERS
    {
        "tagName": {
            "value": "${each.key}"
        },
        "tagValue": {
            "value": "${each.value}"
        }    
    }
    PARAMETERS

    depends_on = ["azurerm_resource_group.NetworkRG"]
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
    name = "GatewaySubnet"
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