
module "PolicyCheckEnvironmentTag" {
    source = "./modules/policies"
    policyScope = "DJC-NE-TRAIN-IT-APP-INT-RG"
    tagName = "Environment"
    tagValue = "Training"
}