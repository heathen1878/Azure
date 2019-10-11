# Providers
provider "azuread" {
    version = "~> 0.3"

    # consume variables passed through from tfvars
    subscription_id = "${var.subscription_id}"
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
    tenant_id = "${var.tenant_id}"
}
provider "azurerm" {
    version = "~> 1.34"

    # consume variables passed through from tfvars
    subscription_id = "${var.subscription_id}"
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
    tenant_id = "${var.tenant_id}"  
}
resource "azuread_group" "group" {
    for_each = "${toset(var.groups)}"
    name = "${each.value}"
}

/*
module "group_membership_2ndLine" {
    source = "../Modules/GroupMembership"
    group_object = "2ndLine"
    member_object = "3rdLine"
    depends_on = ["${azuread_group.group}"]
}

module "group_membership_1stLine" {
    source = "../Modules/GroupMembership"
    group_object = "1stLine"
    member_object = "2ndLine"
    depends_on = ["${azuread_group.group}"]
}
*/

/* 
Get the subscription Id we are working with
*/
data "azurerm_subscription" "current_subscription" {
}

/*
Get the IDs of the groups we are working with
*/
data "azuread_group" "FirstLine" {
    name = "1stLine"
}

data "azuread_group" "ThirdLine" {
    name = "3rdLine"
}

/*
Grant 1st line the reader role within the Azure subscription
*/
resource "azurerm_role_assignment" "FirstLine_Reader" {
    scope = "${data.azurerm_subscription.current_subscription.id}"
    role_definition_name = "Reader"
    principal_id = "${data.azuread_group.FirstLine.id}"
}

/*
Create a role definition for deleting management locks
*/
resource "azurerm_role_definition" "DeleteManagementLocks" {
    name = "Delete Management Locks"    
    scope = "${data.azurerm_subscription.current_subscription.id}"
    description = "Allows an assignee to delete management locks from a resource group or resource"

    permissions {
        actions = ["Microsoft.Authorization/locks/delete"]
        not_actions = []
    }

    assignable_scopes = ["${data.azurerm_subscription.current_subscription.id}"]
}

/*
Gramt 3rd line the additional rights of deleting management locks
*/
resource "azurerm_role_assignment" "ThirdLine_DeleteManagementLocks" {
    scope = "${data.azurerm_subscription.current_subscription.id}"
    role_definition_id = "${azurerm_role_definition.DeleteManagementLocks.id}"
    principal_id = "${data.azuread_group.ThirdLine.id}"
    depends_on = ["azurerm_role_definition.DeleteManagementLocks"]
}