# Providers
# Azure RM
provider "azurerm" {
      # Locked to version
    version = "~> 1.34"

    # consume variables from terraform.tfvars
    subscription_id = "${var.My_Subscription_Id}"
    client_id = "${var.My_Client_Id}"
    client_secret = "${var.My_Client_Secret}"
    tenant_id = "${var.My_Tenant_Id}"
}

# Resources
resource "azurerm_resource_group" "NSGs" {
    name = "DJC-NE-TRAIN-IT-NSGs-INT-RG"
    location = "${var.Location}"
    tags = "${var.NSGTags}"
}

resource "azurerm_network_security_group" "DefaultNSGs" {
    name = "DefaultNSG"
    resource_group_name = "${azurerm_resource_group.NSGs.name}"
    location = "${azurerm_resource_group.NSGs.location}"
    tags = "${azurerm_resource_group.NSGs.tags}"
}

resource "azurerm_network_security_rule" "AllowHTTP" {
    name = "AllowHTTP"
    resource_group_name = "${azurerm_resource_group.NSGs.name}"
    network_security_group_name = "${azurerm_network_security_group.DefaultNSGs.name}"

    priority = 1010
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = 80
    destination_address_prefix = "*"
    source_port_range = "*"
    source_address_prefix = "*"
}

resource "azurerm_network_security_rule" "AllowHTTPS" {
    name = "AllowHTTPS"
    resource_group_name = "${azurerm_resource_group.NSGs.name}"
    network_security_group_name = "${azurerm_network_security_group.DefaultNSGs.name}"

    priority = 1011
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = 443
    destination_address_prefix = "*"
    source_port_range = "*"
    source_address_prefix = "*"
}
resource "azurerm_network_security_rule" "AllowMSSQL" {
    name = "AllowMSSQL"
    resource_group_name = "${azurerm_resource_group.NSGs.name}"
    network_security_group_name = "${azurerm_network_security_group.DefaultNSGs.name}"

    priority = 1012
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = 1443
    destination_address_prefix = "*"
    source_port_range = "*"
    source_address_prefix = "*"
}
resource "azurerm_network_security_rule" "AllowRDP" {
    name = "AllowRDP"
    resource_group_name = "${azurerm_resource_group.NSGs.name}"
    network_security_group_name = "${azurerm_network_security_group.DefaultNSGs.name}"

    priority = 1013
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = 3389
    destination_address_prefix = "*"
    source_port_range = "*"
    source_address_prefix = "*"
}

resource "azurerm_network_security_group" "WindowsNicNsg" {
    name = "ApplyToWindowsServers"
    resource_group_name = "${azurerm_resource_group.NSGs.name}"
    location = "${azurerm_resource_group.NSGs.location}"
    tags = "${azurerm_resource_group.NSGs.tags}"

    security_rule {
       name = "AllowRDP"
       priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "Tcp"
        destination_port_range = 3389
        destination_address_prefix = "*"
        source_port_range = "*"
        source_address_prefix = "*"
    }
}