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
variable "CompanyNamePrefix" {
    description = "An ancronym of the company name"
}
variable "Location" {
    description = "Which Azure region should the deployment use"
}
variable "NetworkRGTags" {
    description = "Tags required for the networking resource group"
}
variable "VNetAddressSpace" {
    description = "the address space used by the virtual network e.g. 10.0.0.0/16"
}
variable "VNetDNSServers" {
    description = "The DNS servers for the virtual network e.g if an Active Directory forest is being deployed, define those IP addresses"
}
variable "AddressPrefix" {
    description = "a map of subnets; there must be a subnet named gateway for the VPN Gateway"
}
variable "vpnClientAddressSpace" {
    description = "The address space used for Point-to-Site VPN clients"
}
variable "publicCertData" {
    description = "The X509 representation of the Root Certificate"
}
