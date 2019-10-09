resource "azurerm_resource_group" "${var.ResourceGroupName}" {
    name = "${var.ResourceGroupName}"
    location = "${var.Location}"
    tags = "${var.Tags}"
}