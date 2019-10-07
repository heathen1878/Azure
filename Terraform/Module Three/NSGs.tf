# Resources
resource "azurerm_resource_group" "NSGs" {
    name = "DJC-NE-TRAIN-IT-NSGs-INT-RG"
    location = "${var.Location}"
    tags = "${var.NSGTags}"
}

resource "azurerm_network_security_group" "DefaultNSGs" {
    name = "DJC-NE-TRAIN-DEFAULT-NSG"
    resource_group_name = "${azurerm_resource_group.NSGs.name}"
    location = "${azurerm_resource_group.NSGs.location}"
    tags = "${azurerm_resource_group.NSGs.tags}"
}

resource "azurerm_network_security_rule" "AllowHTTP" {
    name = "ALLOW-IN-EXT-HTTP"
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
    name = "ALLOW-IN-EXT-HTTPS"
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
    name = "ALLOW-IN-EXT-MSSQL"
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
    name = "ALLOW-IN-EXT-RDP"
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
    name = "DJC-NE-TRAIN-WINDOWSSERVERS-NSG"
    resource_group_name = "${azurerm_resource_group.NSGs.name}"
    location = "${azurerm_resource_group.NSGs.location}"
    tags = "${azurerm_resource_group.NSGs.tags}"

    security_rule {
       name = "ALLOW-IN-EXT-RDP"
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