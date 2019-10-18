/* Resource Group for virtual machines */
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
        
    }

    os_profile {
        computer_name = "${each.value.computerName}"
        admin_username = "${each.value.OSProfile.adminUsername}"
        admin_password = "${each.value.OSProfile.adminPassword}"   
    }

    os_profile_windows_config {

    }

    depends_on = [azurerm_network_interface.WinPrimary]
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

    depends_on = [azurerm_network_interface.LinuxPrimary]
}