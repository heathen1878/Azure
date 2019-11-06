# Variables
variable "subscription_id" {
    description = "Your Azure subscription ID"
}
variable "client_id" {
    description = "Your service prinicpal ID for auth"
}
variable "client_secret" {
    description = "Your service prinicpal password for auth"
}
variable "tenant_id" {
    description = "Your Azure subscription tenant ID"
}
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
    description = "Hub network"
}
variable "spokes" {
    type = "map"
    description = "Spoke networks"
}
variable "networkTags" {
    description = "Tags required for the networking resource group"
}
variable "publicCertData" {
    description = "The X509 representation of the Root Certificate"
}
variable "vpnClientAddressSpace" {
    description = "The address space assigned to point-to-site clients"  
}