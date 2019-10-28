resource "azurerm_resource_group" "WVDRG" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.WVDRGLocation)}-${upper(var.environment)}-WVD-RG"
    location = "${var.WVDRGLocation}"
    tags = "${var.WVDRGTags}"
}

resource "azurerm_resource_group" "WVDINFRARG" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.WVDRGLocation)}-${upper(var.environment)}-WVDINFRA-RG"
    location = "${var.WVDRGLocation}"
    tags = "${var.WVDRGTags}"
}
/*
resource "azurerm_app_service_plan" "WVDMGMTUX" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.WVDRGLocation)}-${upper(var.environment)}-WVDMGMTUX-SP"
    location = "${azurerm_resource_group.WVDINFRARG.location}"
    resource_group_name = "${azurerm_resource_group.WVDINFRARG.name}"

    sku {
        tier = "Standard"
        size = "S1"
        capacity = "0"
    }
}
*/

/*
resource "azurerm_app_service" "WVDMGMTUXAPP" {
    name = "${lower(var.CompanyNamePrefix)}${lower(var.WVDRGLocation)}${lower(var.environment)}wvdmgmt"
    location = "${azurerm_resource_group.WVDINFRARG.location}"
    resource_group_name = "${azurerm_resource_group.WVDINFRARG.name}"
    app_service_plan_id = "${azurerm_app_service_plan.WVDMGMTUX.id}"

    site_config {
        dotnet_framework_version = "v4.0"
        always_on = false
        ftps_state = "AllAllowed"
        managed_pipeline_mode = "Integrated"
        use_32-bit_worker_process = true
        http2_enabled = false
        websockets_enabled = false
        client_affinity_enabled = true
        min_tls_version = "1.2"
    }

    app_settings {
        "WEBSITE_NODE_DEFAULT_VERSION" = "6.9.1"
    }
    depends_on = ["azurerm_app_service_plan.WVDMGMTUX"]
}

resource "azurerm_app_service" "WVDMGMTUXAPI" {
    name = "${lower(var.CompanyNamePrefix)}${lower(var.WVDRGLocation)}${lower(var.environment)}wvdmgmt-api"
    location = "${azurerm_resource_group.WVDINFRARG.location}"
    resource_group_name = "${azurerm_resource_group.WVDINFRARG.name}"
    app_service_plan_id = "${azurerm_app_service_plan.WVDMGMTUX.id}"
    

    site_config {
        dotnet_framework_version = "v4.0"
        always_on = false
        ftps_state = "AllAllowed"
        managed_pipeline_mode = "Integrated"
        use_32-bit_worker_process = true
        http2_enabled = false
        websockets_enabled = false
        client_affinity_enabled = true
        min_tls_version = "1.2"
    }

    app_settings {
        "ApplicationId" = "${var.ApplicationId}"
        "RDBrokerUrl" = "https://rdbroker.wvd.microsoft.com"
        "RedirectURI" = "${MGMTUXAPP.default_site_hostname}"
        "ResourceUrl" = "https://mrs-prod.ame.gbl/mrs-RDInfra-prod"
    }
    depends_on = ["azurerm_app_service_plan.WVDMGMTUXAPP"]
}
*/