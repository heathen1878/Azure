
output "RGName" {
  value = "${azurerm_resource_group.NetworkRG}"
}
output "Subnets" {
  value = "${azurerm_subnet.subnets}"
}