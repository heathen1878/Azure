resource "azurerm_resource_group" "LogAnalytics" {
    name = "DJC-NE-TRAIN-IT-LOGS-INT-RG"
    location = "northeurope"
    tags = "${var.tags}" 
}

resource "azurerm_log_analytics_workspace" "LogAnalyticsWS" {
    name = "DJC-NE-TRAIN-IT-LAWS"
    location = "${azurerm_resource_group.LogAnalytics.location}"
    resource_group_name = "${azurerm_resource_group.LogAnalytics.name}"
    sku = "PerGB2018"
}

