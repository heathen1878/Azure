######################################################################################################################
# GOVERNANCE
######################################################################################################################
/* 
Policy for checking tagging compliance
*/
data "azurerm_policy_definition" "RequireTagsOnRG" {
    display_name = "Require tag and its value on resource groups"
    depends_on = ["azurerm_resource_group.NetworkRG"]
}

/* 
Policy assignment for checking tagging compliance
*/
resource "azurerm_policy_assignment" "MandatoryTagPolicy" {
    for_each = "${var.tags}"
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

/*
Policy assignment for defining allowed resources
*/
data "azurerm_policy_definition" "AllowedResourceTypes" {
    display_name = "Allowed resource types"
    depends_on = ["azurerm_resource_group.NetworkRG"]
}

resource "azurerm_policy_assignment" "AllowedResources" {
    name = "Resource types allowed in ${azurerm_resource_group.NetworkRG.name}"
    scope = "${azurerm_resource_group.NetworkRG.id}"
    policy_definition_id = "${data.azurerm_policy_definition.AllowedResourceTypes.id}"
    description = "Defines what resource types can be created within the resource group: ${azurerm_resource_group.NetworkRG.name}"
    display_name = "Resource types allowed in ${azurerm_resource_group.NetworkRG.name}"

    parameters = <<PARAMETERS
{
    "listOfResourceTypesAllowed": {
        "value": ["Microsoft.Network/networkWatchers","Microsoft.Network/networkWatchers/*","Microsoft.Authorization/locks","Microsoft.Authorization/policyAssignments","Microsoft.Authorization/roleAssignments","Microsoft.Network/networkInterfaces","Microsoft.Network/networkSecurityGroups","Microsoft.Network/networkSecurityGroups/securityRules","Microsoft.Network/azureFirewalls","Microsoft.Network/loadBalancers","Microsoft.Network/vpnGateways","Microsoft.Network/virtualNetworks","Microsoft.Network/virtualNetworks/subnets","Microsoft.Network/publicIPAddresses","Microsoft.Network/virtualNetworkGateways","Microsoft.Resource/checkPolicyCompliance"]
    }
}
PARAMETERS

    depends_on = ["azurerm_resource_group.NetworkRG"]

}

/*
Policy assignment for defining allowed locations
*/
data "azurerm_policy_definition" "AllowedLocations" {
    
    display_name = "Allowed locations"
    
    depends_on = ["azurerm_resource_group.NetworkRG"]

}
resource "azurerm_policy_assignment" "AllowedLocations" {
    name = "Resources can be deployed in ${var.location}"
    scope = "${azurerm_resource_group.NetworkRG.id}"
    policy_definition_id = "${data.azurerm_policy_definition.AllowedLocations.id}"
    description = "Defines the location: ${var.location} resource can be deployed in."
    display_name = "Resources can be deployed in ${var.location}"

    parameters = <<PARAMETERS
{
    "listOfAllowedLocations": {
        "value": ["${var.location}"]
    }
}
PARAMETERS

    depends_on = ["azurerm_resource_group.NetworkRG"]

}

######################################################################################################################
# RBAC - RBAC is applied at the subscription level. 
######################################################################################################################

######################################################################################################################
# END OF GOVERNANCE
######################################################################################################################


######################################################################################################################
# RESOURCES
######################################################################################################################
/* Resource Group for networking */
resource "azurerm_resource_group" "NetworkRG" {
    name = "${upper(var.companyNamePrefix)}-${upper(var.location)}-${upper(var.environment)}-NETWORK-RG"
    location = "${var.location}"
    tags = "${var.tags}"
}

/* Network watcher resource for VM network troubleshooting */
resource "azurerm_network_watcher" "NetworkWatcher" {
    name = "${upper(var.companyNamePrefix)}-${upper(var.location)}-${upper(var.environment)}-NW"
    location = "${azurerm_resource_group.NetworkRG.location}"
    resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
    depends_on = ["azurerm_resource_group.NetworkRG"]
}

/* Create the hub virtual network */
resource "azurerm_virtual_network" "hub" {
    name = "${upper(var.companyNamePrefix)}-${upper(var.location)}-${upper(var.environment)}-VNET-HUB"
    resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
    location = "${azurerm_resource_group.NetworkRG.location}"
    address_space = "${var.vNETs.hub.addressSpace}"
    dns_servers = "${var.vNETs.hub.dnsServers}"
    depends_on = ["azurerm_resource_group.NetworkRG"]
}

resource "azurerm_subnet" "hub_subnets" {
    for_each = "${var.vNETs.hub.subnets}"
    name = "${each.key}"
    resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
    virtual_network_name = "${azurerm_virtual_network.hub.name}"
    address_prefix = "${each.value}"
    depends_on = ["azurerm_virtual_network.hub"]
}

/* Create spoke virtual networks */
resource "azurerm_virtual_network" "spokes" {
    for_each = "${var.spokes}"
    name = "${upper(var.companyNamePrefix)}-${upper(var.location)}-${upper(var.environment)}-VNET-${upper(each.key)}"
    resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
    location = "${azurerm_resource_group.NetworkRG.location}"
    address_space = "${each.value.addressSpace}"
    dns_servers = "${each.value.dnsServers}"
    depends_on = ["azurerm_resource_group.NetworkRG"]
}

resource "azurerm_subnet" "spoke_subnets" {
    for_each = {
        for mySubnet in local.subnet_temp: "${mySubnet.net}.${mySubnet.range}.${mySubnet.subnet}" => mySubnet
    }
    name = "${each.value.subnet}"
    resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
    virtual_network_name = "${upper(var.companyNamePrefix)}-${upper(var.location)}-${upper(var.environment)}-VNET-${upper(each.value.net)}"
    address_prefix = "${each.value.range}"
    depends_on = ["azurerm_virtual_network.spokes"]
}

/* Create a public IP address for the VPN gateway  */
resource "azurerm_public_ip" "publicIPAddress" {
    name = "${azurerm_virtual_network.hub.name}-PIP-1"
    resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
    location = "${azurerm_resource_group.NetworkRG.location}"
    allocation_method = "Dynamic"
}
/* Create a VPN gateway and assign the public IP address and gateway subnet previously created */
resource "azurerm_virtual_network_gateway" "VNetGateway" {
    name = "${upper(var.companyNamePrefix)}-${upper(var.location)}-${upper(var.environment)}-GW"
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
        subnet_id = "${azurerm_subnet.hub_subnets["GatewaySubnet"].id}"
    }

    vpn_client_configuration {
        address_space = [ "${var.vpnClientAddressSpace}" ]
        vpn_client_protocols = ["SSTP"]
        root_certificate {
            name = "Root-Certificate"
            public_cert_data = "${var.publicCertData}"
        }
    }
    
    depends_on = ["azurerm_virtual_network.hub"]
}
######################################################################################################################
# END OF RESOURCES
######################################################################################################################