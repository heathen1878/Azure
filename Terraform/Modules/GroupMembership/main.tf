/* 
Get the resource Id for the group we are working on
*/
data "azuread_group" "group_object" {
    name = "${var.group_object}"
}
/*
Get the resource Id for the member we are working on.
*/

data "azuread_group" "member_object" {
    name = "${var.member_object}"
}
/*
These resources do not seem to work with the current Terraform AzureAD provider
resource "azuread_group_member" "group_membership" {
    group_object_id = "${data.azuread_group.group_object.id}"
    member_object_id = "${data.azuread_group.member_object.id}"
}

resource "azuread_group" "group_membership" {
    name = "${data.azuread_group.group_object.id}"
    members = [ "${data.azuread_group.member_object.id}" ]
}
*/

