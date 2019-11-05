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
variable "VMRGTags" {
    description = "Tags required for the networking resource group"
}
variable "WinVirtualMachines" {
    type = "map"
    description = ""
}
variable "LinuxVirtualMachines" {
    type = "map"
    description = ""
}