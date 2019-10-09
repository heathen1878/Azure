
module "PolicyCheckEnvironmentTag1" {
    source = "./modules/policies"
    policyScope = "DJC-NE-TRAIN-IT-APP-INT-RG"
    tagName = "Environment"
    tagValue = "Training"
}

module "PolicyCheckEnvironmentTag2" {
    source = "./modules/policies"
    policyScope = "DJC-NE-TRAIN-IT-NET-INT-RG"
    tagName = "Environment"
    tagValue = "Training"
}

module "PolicyCheckEnvironmentTag3" {
    source = "./modules/policies"
    policyScope = "DJC-NE-TRAIN-IT-NSGs-INT-RG"
    tagName = "Environment"
    tagValue = "Training"
}

module "PolicyCheckEnvironmentTag4" {
    source = "./modules/policies"
    policyScope = "DJC-NE-TRAIN-TFSTATE"
    tagName = "Environment"
    tagValue = "Training"
}

