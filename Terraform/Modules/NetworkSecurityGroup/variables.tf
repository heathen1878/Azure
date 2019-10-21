# variables
variable "environment" {
    description = "The environment for the resource group e.g. Production, Development, Training...."
}
variable "CompanyNamePrefix" {
    description = "Used to build the standard naming convention"
}
variable "VMRGLocation" {
     description = "the Azure location for the resource group metadata"
}
variable "RGName" {
  
}
variable "NSGs" {
  
}