resource "azurerm_resource_group" "WVDRG" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.VMRGLocation)}-${upper(var.environment)}-WVD-RG"
    location = "${var.WVDRGLocation}"
    tags = "${var.WVDRGTags}"
}