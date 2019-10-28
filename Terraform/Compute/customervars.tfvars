# global configuration data
CompanyNamePrefix = ""
environment = ""

# Networking specific configuration data
Location = ""
# The tags below are mandatory. Feel free to add additional tag too.
NetworkRGTags = {
    department = ""
    applicationName = ""
    costCenter = ""
    technicalContact = ""
}
VNetAddressSpace = [""]
VNetDNSServers = [""]
AddressPrefix = {
    gateway = "" /* there must be a gateway subnet for the VPN gateway to be built*/
    AzureFirewallSubnet = ""
    Infra = ""
    WVD = ""
}
vpnClient = "" /* must be address space outside of the VNet.*/
publicCertName = "" /* name of cert with no spaces */
publicCertData = "" /* certificate */

# Virtual machine specific configuration data
# The tags below are mandatory. Feel free to add additional tag too.
VMRGTags = {
    department = ""
    applicationName = ""
    costCenter = ""
    technicalContact = ""
}

/* 
obtain the following information from the Azure CLI.
az vm image list
*/

WinVirtualMachines = {
    VM1 = {
        computerName = ""
        subnet = ""
        vmsize = ""
        ipaddress = ""
        Image = {
            publisher = ""
            offer = ""
            sku = ""
            version = ""
        }
        OSStorage = {
            name = ""
            caching = ""
            createOption = ""
            diskType = ""
        }
        OSProfile = {
            adminUsername = ""
            adminPassword = ""
        }
        DataStorage = {
            Disk01 = {
                name = ""
                caching = ""
                diskSize = ""
                lun = ""
                diskType = ""
            }            
        }
    } /*
    VM2 = {

    } */
}
LinuxVirtualMachines = {
}

NSGs = {
    NSG1 = {
        vnet = ""
        subnet = ""
        rules = {
            rule1 = {
                name = ""
                priority = ""
                direction = ""
                access = ""
                protocol = ""
                source_port_range = "*"
                destination_port_range = ""
                source_address_prefix = ""
                destination_address_prefix = "*"
            } /*
            rule2  = {
            } */
        }
    }
    NSG2 = {
        vnet = ""
        subnet = ""
        rules = {
            rule1 = {
                name = ""
                priority = ""
                direction = ""
                access = ""
                protocol = ""
                source_port_range = "*"
                destination_port_range = ""
                source_address_prefix = ""
                destination_address_prefix = "*"
            }/*
            rule2 = {
            }*/
        }
    }
}

/* WVD */
WVDRGTags = {
    department = ""
    applicationName = ""
    costCenter = ""
    technicalContact = ""
}