data "azurerm_policy_definition" "TaggingOnRGs" {
    display_name = "Require tag and its value on resource groups"
}

data "azurerm_resource_group" "resourceGroup" {
    name = "${var.policyScope}"
}

resource "azurerm_policy_assignment" "TaggingOnRGs" {
    name = "Require tag and its value on resource groups"
    scope = "${data.azurerm_resource_group.resourceGroup.id}"
    policy_definition_id = "${data.azurerm_policy_definition.TaggingOnRGs.id}"
    description = "Enforces a required tag and its value on resource groups."
    display_name = "Require tag and its value on resource groups"

    parameters = <<PARAMETERS
    {
        "tagName": {
            "value": "${var.tagName}"
        },
        "tagValue": {
            "value": "${var.tagValue}"
        }    
    }
    PARAMETERS
}