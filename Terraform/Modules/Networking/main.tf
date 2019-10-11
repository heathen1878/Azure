/* Resource Group for networking */
resource "azurerm_resource_group" "NetworkRG" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.NetworkRGLocation)}-${upper(var.environment)}-NETWORK-RG"
    location = "${var.NetworkRGLocation}"
    tags = "${var.NetworkRGTags}"
}

/* GOVERNANCE */
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
            "value": [ "Microsoft.Authorization/locks","Microsoft.Authorization/policyAssignments","Microsoft.Authorization/roleAssignments","Microsoft.Network/networkInterfaces","Microsoft.Network/networkSecurityGroups","Microsoft.Network/networkSecurityGroups/securityRules","Microsoft.Network/azureFirewalls","Microsoft.Network/loadBalancers","Microsoft.Network/vpnGateways","Microsoft.Network/virtualNetworks","Microsoft.Network/virtualNetworks/subnets","Microsoft.Network/publicIPAddresses","Microsoft.Network/virtualNetworkGateways","Microsoft.Resource/checkPolicyCompliance" ]
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
    name = "Resources can be deployed in ${var.NetworkRGLocation}"
    scope = "${azurerm_resource_group.NetworkRG.id}"
    policy_definition_id = "${data.azurerm_policy_definition.AllowedLocations.id}"
    description = "Defines the location: ${var.NetworkRGLocation} resource can be deployed in."
    display_name = "Resources can be deployed in ${var.NetworkRGLocation}"

    parameters = <<PARAMETERS
    {
        "listOfAllowedLocations": {
            "value": ["${var.NetworkRGLocation}"]
        }
    }
    PARAMETERS

    depends_on = ["azurerm_resource_group.NetworkRG"]
}

/* RBAC */
/*
RBAC is applied at the subscription level. 
*/


/* Management Locks */
/*
Should be the last configuration applied.
*/
resource "azurerm_management_lock" "read_only" {
    name = "${azurerm_resource_group.NetworkRG.name}-readonly"
    scope = "${azurerm_resource_group.NetworkRG.id}"
    lock_level = "ReadOnly"
    notes = "${azurerm_resource_group.NetworkRG.name} is read only"

    depends_on = ["azurerm_virtual_network_gateway.VNetGateway"]
}
/*
END OF GOVERNANCE
*/
/* RESOURCES */
/* Create a virtual network */
resource "azurerm_virtual_network" "VNet" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.NetworkRGLocation)}-${upper(var.environment)}-VNET-${replace(upper(var.VNetAddressSpace[0]),"/","-")}"
    resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
    location = "${azurerm_resource_group.NetworkRG.location}"
    address_space = "${var.VNetAddressSpace}"
    dns_servers = "${var.VNetDNSServers}"
}

/* Create a public IP address for the VPN gateway */
resource "azurerm_public_ip" "publicIPAddress" {
    name = "${azurerm_virtual_network.VNet.name}-PIP-1"
    resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
    location = "${azurerm_resource_group.NetworkRG.location}"
    allocation_method = "Dynamic"   
}

/* Create a number of subnets as per the address prefix variable */
resource "azurerm_subnet" "Subnet" {
    for_each = "${var.AddressPrefix}"
    name =<<-EOT
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

/* Get the Gateway Subnet id */     
data "azurerm_subnet" "gateway" {
    name = "GatewaySubnet"
    virtual_network_name = "${upper(var.CompanyNamePrefix)}-${upper(var.NetworkRGLocation)}-${upper(var.environment)}-VNET-${replace(upper(var.VNetAddressSpace[0]),"/","-")}"
    resource_group_name = "${azurerm_resource_group.NetworkRG.name}"
    depends_on = ["azurerm_subnet.Subnet"]
} 

/* Create a VPN gateway and assign the public IP address and gateway subnet previously created */
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