# Providers
provider "azuread" {
    version = "~> 0.3"

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