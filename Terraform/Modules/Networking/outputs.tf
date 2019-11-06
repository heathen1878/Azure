
output "RGName" {
  value = "${azurerm_resource_group.NetworkRG}"
}
output "hub_subnets" {
  value = "${azurerm_subnet.hub_subnets}"
}
output "spoke_subnets" {
  value = "${azurerm_subnet.spoke_subnets}"
}

