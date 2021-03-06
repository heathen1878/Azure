locals {
    subnet_temp = flatten([
        for key, value in var.spokes: [
            for subname, subvalue in value.subnets: {
                net = key
                subnet = subname
                range = subvalue
            }
        ] if value.subnets != ""
    ])
}

locals {
    peering_temp = flatten([
        for key, value in var.spokes: {
            vNet = key
        }
    if value.Peer !=0
    ])
}