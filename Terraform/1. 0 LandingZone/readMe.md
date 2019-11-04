# Landing Zone
The landing zone builds the following:

* Network resource group
* Virtual Network
* Subnets as defined within the AddressPrefix variable *
* VPN Gateway
* Policies
  * Only allows network based resources to be deployed
  * Only allowed network based resources to be deployed within the specified region
  * Checks tags exist as per those defined within customerVars.tfvars

> There must be a subnet named 'gateway' for the VPN Gateway to work correctly

The input parameters for the landing zone should be defined using a private copy of customerVars.tfvars

A service principal should be created in Azure AD and Terraform State should be hosted in an Azure Storage account.

[Service Principal setup](https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_secret.html)

[Terraform Remote State setup](https://www.terraform.io/docs/backends/types/azurerm.html)