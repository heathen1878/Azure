variable "policyScope" {
    description = "The Scope at which the Policy Assignment should be applied, which must be a Resource ID"
}

variable "tagName" {
    type = "string"
    default = "Name"
}

variable "tagValue" {
    type = "string"
    default = "Value"
}