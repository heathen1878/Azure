######################################################################################################################
# RESOURCES
######################################################################################################################
/* Resource Group for Log Analytics */
resource "azurerm_resource_group" "LogAnalyticsRG" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.LARGLocation)}-${upper(var.environment)}-LOGS-RG"
    location = "${var.LARGLocation}"
    tags = "${var.LARGTags}"
}

resource "azurerm_log_analytics_workspace" "LogAnalyticsWS" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.LARGLocation)}-${upper(var.environment)}-LOGS-WS"
    location = "${azurerm_resource_group.LogAnalyticsRG.location}"
    resource_group_name = "${azurerm_resource_group.LogAnalyticsRG.name}"
    sku = "PerGB2018"
}

