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