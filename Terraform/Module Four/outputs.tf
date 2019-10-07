# Outputs
output "WebAppUrl" {
    description = "Url for WebApp"
    value = "${azurerm_app_service.WebApp.*.default_site_hostname}"
}
