######################################################################################################################
# RESOURCES
######################################################################################################################
/* Resource Group for Log Analytics */
resource "azurerm_resource_group" "NetworkRG" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.LARGLocation)}-${upper(var.environment)}-LOGS-RG"
    location = "${var.LARGLocation}"
    tags = "${var.LARGTags}"
}
