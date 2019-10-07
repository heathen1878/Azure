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
    name = "DJC-${upper(var.WebAppLocations[count.index])}-TRAIN-IT-WEBAPP-ASP"
    count = "${length(var.WebAppLocations)}"
    resource_group_name = "${azurerm_resource_group.WebApps.name}"
    location = "${var.WebAppLocations[count.index]}"
    tags = "${azurerm_resource_group.WebApps.tags}"

    kind = "Windows"
    sku {
        tier = "${var.WebAppConfiguration.tier}"
        size = "${var.WebAppConfiguration.size}"
    }
}

resource "azurerm_app_service" "WebApp" {
    name = "DJC-${upper(var.WebAppLocations[count.index])}-TRAIN-IT-WEBAPP-${random_string.WebAppRandomGen.result}"
    count = "${length(var.WebAppLocations)}"
    location = "${var.WebAppLocations[count.index]}"
    resource_group_name = "${azurerm_resource_group.WebApps.name}"
    tags = "${azurerm_resource_group.WebApps.tags}"

    app_service_plan_id = "${element(azurerm_app_service_plan.WebAppPlan.*.id,count.index)}"
}
