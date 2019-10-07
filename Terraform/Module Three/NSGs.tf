resource "azurerm_resource_group" "NSGs" {
    name = "DJC-NE-TRAIN-IT-NSGs-INT-RG"
    location = "${var.Location}"
    tags = "${var.NSGTags}"
}

resource "azurerm_network_security_group" "DefaultNSGs" {
    name = "Default NSGs"
    resource_group_name = "${azurerm_network_security_group.DefaultNSGs.name}"
    location = "${azurerm_network_security_group.DefaultNSGs.location}"
    tags = "${azurerm_network_security_group.DefaultNSGs.tags}"
}

resource "azurerm_network_security_rule" "AllowHTTP" {
    name = "Allow HTTP"
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

