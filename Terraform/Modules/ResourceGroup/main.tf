resource "azurerm_resource_group" "ResourceGroup" {
    name = "${var.ResourceGroupName}"
    location = "${var.Location}"
    tags = "${var.Tags}"
}