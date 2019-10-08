data "azurerm_policy_definition" "TaggingOnRGs" {
    display_name = "Require tag and its value on resource groups"
}

data "azurerm_resource_group" "resourceGroup" {
    name = "${var.policyScope}"
}

resource "azurerm_policy_assignment" "TaggingOnRGs" {
    name = "Ensure-RGs-have-tags-in-place"
    scope = "${data.azurerm_resource_group.resourceGroup.id}"
    policy_definition_id = "${data.azurerm_policy_definition.TaggingOnRGs.id}"
    description = "Ensures mandatory tags are in place for RGs"
    display_name = "Ensure RG has tags"

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