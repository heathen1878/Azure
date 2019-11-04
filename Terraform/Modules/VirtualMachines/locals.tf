locals {
    #Produces list of maps, with key vm_name and extension for each vm=extension combo.
    #https://www.terraform.io/docs/configuration/functions/flatten.html
    ext_temp = flatten([
        for key, value in var.WinVirtualMachines: [
            for ext in value.extensions: {
                vm_name = key
                extension = ext
            }
        ] if value.extensions != ""
    ])
}