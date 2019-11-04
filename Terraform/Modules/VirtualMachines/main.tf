######################################################################################################################
# GOVERNANCE
######################################################################################################################
/* 
Policy for checking tagging compliance
*/
data "azurerm_policy_definition" "RequireTagsOnRG" {
    display_name = "Require tag and its value on resource groups"
    depends_on = ["azurerm_resource_group.VMRG"]
}
/* 
Policy assignment for checking tagging compliance
*/
resource "azurerm_policy_assignment" "MandatoryTagPolicy" {
    for_each = "${var.VMRGTags}"
    name = "Require ${each.key} and its value on resource groups"
    scope = "${azurerm_resource_group.VMRG.id}"
    policy_definition_id = "${data.azurerm_policy_definition.RequireTagsOnRG.id}"
    description = "Enforces a required tag and its value on resource groups."
    display_name = "Require ${each.key} and its value on resource groups"

    parameters =<<PARAMETERS
{"tagName": {"value":"${each.key}"},"tagValue":{"value":"${each.value}"}}
PARAMETERS

    depends_on = ["azurerm_resource_group.VMRG"]
}
/*
Policy assignment for defining allowed resources
*/
data "azurerm_policy_definition" "AllowedResourceTypes" {
    display_name = "Allowed resource types"
    depends_on = ["azurerm_resource_group.VMRG"]
}
/*
Policy assignment for defining allowed locations
*/
data "azurerm_policy_definition" "AllowedLocations" {
    
    display_name = "Allowed locations"
    
    depends_on = ["azurerm_resource_group.VMRG"]

}
resource "azurerm_policy_assignment" "AllowedLocations" {
    name = "Resources can be deployed in ${var.VMRGLocation}"
    scope = "${azurerm_resource_group.VMRG.id}"
    policy_definition_id = "${data.azurerm_policy_definition.AllowedLocations.id}"
    description = "Defines the location: ${var.VMRGLocation} resource can be deployed in."
    display_name = "Resources can be deployed in ${var.VMRGLocation}"

    parameters =<<PARAMETERS
{"listOfAllowedLocations":{"value":["${var.VMRGLocation}\n"]}}
PARAMETERS

    depends_on = ["azurerm_resource_group.VMRG"]
}
######################################################################################################################
# RBAC - RBAC is applied at the subscription level. 
######################################################################################################################
######################################################################################################################
# END OF GOVERNANCE
######################################################################################################################


######################################################################################################################
# RESOURCES
######################################################################################################################
/* 
Resource Group for virtual machines
*/
resource "azurerm_resource_group" "VMRG" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.VMRGLocation)}-${upper(var.environment)}-VM-RG"
    location = "${var.VMRGLocation}"
    tags = "${var.VMRGTags}"
}

resource "azurerm_network_interface" "WinPrimary" {
    for_each = "${var.WinVirtualMachines}"
    name = "${each.value.computerName}-NIC"
    location = "${azurerm_resource_group.VMRG.location}"
    resource_group_name = "${azurerm_resource_group.VMRG.name}"

    ip_configuration {
        name = "${each.value.computerName}-ipconfig"
        subnet_id = "${var.Subnets[each.value.subnet].id}"
        private_ip_address_allocation = "Static"
        private_ip_address = "${each.value.ipaddress}"
    }
}

resource "azurerm_network_interface" "LinuxPrimary" {
    for_each = "${var.LinuxVirtualMachines}"
    name = "${each.value.computerName}-NIC"
    location = "${azurerm_resource_group.VMRG.location}"
    resource_group_name = "${azurerm_resource_group.VMRG.name}"

    ip_configuration {
        name = "${each.value.computerName}-ipconfig"
        subnet_id = "${var.Subnets[each.value.subnet].id}"
        private_ip_address_allocation = "Static"
        private_ip_address = "${each.value.ipaddress}"
    }
}

resource "azurerm_virtual_machine" "WindowsVM" {
    for_each = "${var.WinVirtualMachines}"
    name = "${each.value.computerName}"
    location = "${azurerm_resource_group.VMRG.location}"
    resource_group_name = "${azurerm_resource_group.VMRG.name}"
    network_interface_ids = ["${azurerm_network_interface.WinPrimary[each.key].id}"]
    vm_size = "${each.value.vmsize}"

    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true

    storage_image_reference {
        publisher = "${each.value.Image.publisher}"
        offer = "${each.value.Image.offer}"
        sku = "${each.value.Image.sku}"
        version = "${each.value.Image.version}"
    }

    storage_os_disk {
        name = "${each.value.computerName}-${each.value.OSStorage.name}"
        create_option = "${each.value.OSStorage.createOption}"
        caching = "${each.value.OSStorage.caching}"
        os_type = "Windows"
        managed_disk_type = "${each.value.OSStorage.diskType}"
    }

    dynamic "storage_data_disk" {
        for_each = each.value.DataStorage
        iterator = disk
        content { 
            name = "${each.value.computerName}-${disk.value.name}"
            create_option = "empty"
            caching = "${disk.value.caching}"
            lun = "${disk.value.lun}"
            managed_disk_type = "${disk.value.diskType}"
            disk_size_gb = "${disk.value.diskSize}"
        }
    }

    os_profile {
        computer_name = "${each.value.computerName}"
        admin_username = "${each.value.OSProfile.adminUsername}"
        admin_password = "${each.value.OSProfile.adminPassword}"   
    }

    os_profile_windows_config {
        provision_vm_agent = true
    }

    depends_on = ["azurerm_network_interface.WinPrimary"]
}

resource "azurerm_virtual_machine" "linuxVM" {
    for_each = "${var.LinuxVirtualMachines}"
    name = "${each.value.computerName}"
    location = "${azurerm_resource_group.VMRG.location}"
    resource_group_name = "${azurerm_resource_group.VMRG.name}"
    network_interface_ids = ["${azurerm_network_interface.LinuxPrimary[each.key].id}"]
    vm_size = "${each.value.vmsize}"

    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true

    storage_image_reference {
        publisher = "${each.value.Image.publisher}"
        offer = "${each.value.Image.offer}"
        sku = "${each.value.Image.sku}"
        version = "${each.value.Image.version}"
    }

    storage_os_disk {
        name = "${each.value.computerName}-${each.value.OSStorage.name}"
        create_option = "${each.value.OSStorage.createOption}"
        caching = "${each.value.OSStorage.caching}"    
        os_type = "Linux"
        managed_disk_type = "${each.value.OSStorage.diskType}"
    }
    
    dynamic "storage_data_disk" {
        for_each = each.value.DataStorage
        iterator = disk
        content { 
            name = "${each.value.computerName}-${disk.value.name}"
            create_option = "empty"
            caching = "${disk.value.caching}"
            lun = "${disk.value.lun}"
            managed_disk_type = "${disk.value.diskType}"
            disk_size_gb = "${disk.value.diskSize}"
        }
    }

    os_profile {
        computer_name = "${each.value.computerName}"
        admin_username = "${each.value.OSProfile.adminUsername}"
        admin_password = "${each.value.OSProfile.adminPassword}"   
    }

    /* For testing only, must use SSH keys for production */
    os_profile_linux_config {
        disable_password_authentication = false
    }

    depends_on = ["azurerm_network_interface.LinuxPrimary"]
}
resource "azurerm_virtual_machine_extension" "extensions" {
    for_each = {
        for myExtensions in local.ext_temp : "${myExtensions.vm_name}.${myExtensions.extension}" => myExtensions
    }
    name                 = "${each.value.extension}"
    location             = "${azurerm_resource_group.VMRG.location}"
    resource_group_name  = "${azurerm_resource_group.VMRG.name}"
    virtual_machine_name = "${each.value.vm_name}"
    publisher            = "${(lookup(var.extensions, each.value.extension)).publisher}"
    type                 = "${(lookup(var.extensions, each.value.extension)).type}"
    type_handler_version = "${(lookup(var.extensions, each.value.extension)).type_handler_extension}"
    depends_on = ["azurerm_virtual_machine.WindowsVM"]
}


######################################################################################################################
# END OF RESOURCES
######################################################################################################################