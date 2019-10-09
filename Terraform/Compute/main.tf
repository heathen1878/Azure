# Modules

module "Provider" {
    source = "../modules/provider"  
    My_Subscription_Id = "${var.My_Subscription_Id}"
    My_Client_Id = "${var.My_Client_Id}"
    My_Client_Secret = "${var.My_Client_Secret}"
    My_Tenant_Id = "${var.My_Tenant_Id}"
}

module "TerraformState" {
    source = "../modules/backend"
    storageAccount = "${var.My_Storage_Account}"
    containerName = "${var.My_Container_Name}"
    terraformStateFileName = "${var.My_Terraform_State_FileName}"
    storageAccountAccessKey = "${var.My_Storage_Account_AccessKey}"
}