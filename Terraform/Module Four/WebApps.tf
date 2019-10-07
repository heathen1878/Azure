# resources

resource "azurerm_resource_group" "WebApps" {
    name = "DJC-NE-TRAIN-IT-APP-INT-RG"
    location = "${var.Location}"
    tags = "${var.WebAppTags}"
}

resource "random_string" "WebAppRandomGen" {
    length = 8
    lower = true
    number = true
    upper = false
    special = false 
}

resource "azurerm_app_service_plan" "WebAppPlan" {
    name = "DJC-NE-TRAIN-IT-WEBAPP-ASP"
    resource_group_name = "${azurerm_resource_group.WebApps.name}"
    location = "${azurerm_resource_group.WebApps.location}"
    tags = "${azurerm_resource_group.WebApps.tags}"

    kind = "Windows"
    sku {
        tier = "Standard"
        size = "S1"
    }
}

resource "azurerm_app_service" "WebApp" {
    name = "DJC-NE-TRAIN-IT-WEBAPP-${random_string.WebAppRandomGen.result}"
    location = "${azurerm_resource_group.WebApps.location}"
    resource_group_name = "${azurerm_resource_group.WebApps.name}"
    tags = "${azurerm_resource_group.WebApps.tags}"

    app_service_plan_id = "${azurerm_app_service_plan.WebAppPlan.id}"
}
