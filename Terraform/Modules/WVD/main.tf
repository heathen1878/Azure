resource "azurerm_resource_group" "WVDRG" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.WVDRGLocation)}-${upper(var.environment)}-WVD-RG"
    location = "${var.WVDRGLocation}"
    tags = "${var.WVDRGTags}"
}