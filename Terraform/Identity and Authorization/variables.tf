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
variable "groups" {
    description = "Groups required for RBAC"
}





