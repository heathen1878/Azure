######################################################################################################################
# GOVERNANCE
######################################################################################################################
# Governance policies are applied within the Networking Resource group.
######################################################################################################################
# RBAC - RBAC is applied at the subscription level. 
######################################################################################################################
######################################################################################################################
# END OF GOVERNANCE
######################################################################################################################


######################################################################################################################
# RESOURCES
######################################################################################################################
/* 
Resource Group for Network Security Groups
*/
resource "azurerm_network_security_group" "NSG" {
    for_each = "${var.NSGs}"
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.NSGLocation)}-${upper(var.environment)}-${replace(upper(each.value.vnet),"/","-")}-${upper(each.value.subnet)}-NSG"
    location = "${var.NSGLocation}"
    resource_group_name = "${var.RGName.name}"

    dynamic "security_rule" {
        for_each = each.value.rules
        iterator = rule
        content {
            name = "${rule.value.name}"
            priority = "${rule.value.priority}"
            direction = "${rule.value.direction}"
            access = "${rule.value.access}"
            protocol = "${rule.value.protocol}"
            source_port_range = "${rule.value.source_port_range}"
            destination_port_range = "${rule.value.destination_port_range}"
            source_address_prefix = "${rule.value.source_address_prefix}"
            destination_address_prefix = "${rule.value.destination_address_prefix}"
        }   
    }
}
######################################################################################################################
# END OF RESOURCES
######################################################################################################################