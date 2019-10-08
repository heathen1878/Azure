# Variables
variable "My_Subscription_Id" {
  
}
variable "My_Client_Id" {
  
}
variable "My_Client_Secret" {
  
}
variable "My_Tenant_Id" {
}

variable "tags" {
    type = "map"
    default = {
        Environment = "Training"
    }
}
