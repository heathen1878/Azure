variable "environment" {
    description = "Production, Test, development, Training..."
}
variable "companyNamePrefix" {
    description = "An ancronym of the company name"
}
variable "location" {
    description = "Which Azure region should the deployment use"
}
variable "vNETs" {
    type = "map"
    description = "hub network."
}
variable "spokes" {
    type = "map"
    description = "Spoke networks"
}
variable "tags" {
    description = "Tags required for the networking resource group"
}
variable "publicCertData" {
    description = "The X509 representation of the Root Certificate"
}
variable "vpnClientAddressSpace" {
    description = "The address space assigned to point-to-site clients"  
}
