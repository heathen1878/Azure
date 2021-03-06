######################################################################################################################
# GOVERNANCE
######################################################################################################################
/* 
Policy for checking tagging compliance
*/
data "azurerm_policy_definition" "RequireTagsOnRG" {
    display_name = "Require tag and its value on resource groups"
    depends_on = ["azurerm_resource_group.WVDRG"]
}

/* 
Policy assignment for checking tagging compliance
*/
resource "azurerm_policy_assignment" "MandatoryTagPolicy" {
    for_each = "${var.WVDRGTags}"
    name = "Require ${each.key} and its value on resource groups"
    scope = "${azurerm_resource_group.WVDRG.id}"
    policy_definition_id = "${data.azurerm_policy_definition.RequireTagsOnRG.id}"
    description = "Enforces a required tag and its value on resource groups."
    display_name = "Require ${each.key} and its value on resource groups"

    parameters =<<PARAMETERS
{
"tagName": {
    "value": "${each.key}"
},
"tagValue": {
    "value": "${each.value}"
}    
}
PARAMETERS

    depends_on = ["azurerm_resource_group.WVDRG"]
}

/*
Policy assignment for defining allowed resources
*/
data "azurerm_policy_definition" "AllowedResourceTypes" {
    display_name = "Allowed resource types"
    depends_on = ["azurerm_resource_group.WVDRG"]
}

/*
Policy assignment for defining allowed locations
*/
data "azurerm_policy_definition" "AllowedLocations" {
    
    display_name = "Allowed locations"
    
    depends_on = ["azurerm_resource_group.WVDRG"]

}
resource "azurerm_policy_assignment" "AllowedLocations" {
    name = "Resources can be deployed in ${var.WVDRGLocation}"
    scope = "${azurerm_resource_group.WVDRG.id}"
    policy_definition_id = "${data.azurerm_policy_definition.AllowedLocations.id}"
    description = "Defines the location: ${var.WVDRGLocation} resource can be deployed in."
    display_name = "Resources can be deployed in ${var.WVDRGLocation}"

    parameters =<<PARAMETERS
{
"listOfAllowedLocations": {
    "value": ["${var.WVDRGLocation}"]
}
}
PARAMETERS

    depends_on = ["azurerm_resource_group.WVDRG"]
}
######################################################################################################################
# RBAC - RBAC is applied at the subscription level. 
######################################################################################################################
######################################################################################################################
# END OF GOVERNANCE
######################################################################################################################


######################################################################################################################
# RESOURCES
######################################################################################################################
resource "azurerm_resource_group" "WVDRG" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.WVDRGLocation)}-${upper(var.environment)}-WVD-RG"
    location = "${var.WVDRGLocation}"
    tags = "${var.WVDRGTags}"
}

resource "azurerm_resource_group" "WVDINFRARG" {
    name = "${upper(var.CompanyNamePrefix)}-${upper(var.WVDRGLocation)}-${upper(var.environment)}-WVDINFRA-RG"
    location = "${var.WVDRGLocation}"
    tags = "${var.WVDRGTags}"
}

resource "azurerm_template_deployment" "WVD" {
    name = "WVD"
    resource_group_name = "${azurerm_resource_group.WVDINFRARG.name}"
    template_body = <<DEPLOY
    {
        "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
        "contentVersion": "1.0",
        "parameters": {
            "RDBrokerURL": {
                "defaultValue": "https://rdbroker.wvd.microsoft.com",
                "type": "string",
                "metadata": {
                    "description": "RDBroker URL of the infrastructure. Ex: https://rdbroker.wvd.microsoft.com"
                }
            },
            "ResourceURL": {
                "defaultValue": "https://mrs-prod.ame.gbl/mrs-RDInfra-prod",
                "type": "string",
                "metadata": {
                    "description": "The resourceURL defining the Windows Virtual Desktop enterprise appplication."
                }
            },
            "AzureADUserPrincipalName": {
                "type": "string",
                "metadata": {
                    "description": "An Azure AD user who has permissions to create resources (and a resource group, if chosen) in the Azure subscription. This can be accomplished by providing a user with a Contributor role in the Azure subscription"
                }
            },
            "AzureLoginPassword": {
                "type": "securestring",
                "metadata": {
                    "description": "The password that corresponds to the AzureADUserPrincipalName."
                }
            },
            "ApplicationName": {
                "type": "string",
                "metadata": {
                    "description": "Enter a unique name--without spaces--for your management UX app. This will be used to generate a unique DNS name for the public IP address of the web app and will be used for the app registration in Azure AD."
                }
            },
            "_artifactsLocation": {
                "type": "string",
                "metadata": {
                    "description": "The base URI where artifacts required by this template are located."
                },
                "defaultValue": "https://raw.githubusercontent.com/Azure/RDS-Templates/master/wvd-templates/wvd-management-ux/deploy/"
            },
            "_artifactsLocationSasToken": {
                "type": "securestring",
                "metadata": {
                    "description": "The sasToken required to access _artifactsLocation when they're located in a storage account with private access."
                },
                "defaultValue": ""
            }
        },
        "variables": {
            "uniquestr": "[uniqueString(resourceGroup().id, deployment().name)]",
            "accountName": "[concat('wvdsaas-autoAccount','-',variables('uniquestr'))]",
            "credentialName": "ManagementUXDeploy",
            "runbookName": "[concat('msftsaasbook','-',variables('uniquestr'))]",
            "webAPIAppName": "[concat(parameters('ApplicationName'),'-API')]",
            "hostingPlanName": "[concat(parameters('ApplicationName'),'-SP')]",
            "serviceplansku": "S1",
            "workerSize": "0",
            "scriptUri": "[concat(parameters('_artifactsLocation'),'scripts/New-WVDMgmtSetup.ps1')]",
            "fileURI": "[concat(parameters('_artifactsLocation'),'scripts/msft-wvd-saas-offering.zip')]",
            "sku": "Free",
            "automationVariables": [
                {
                    "name": "subscriptionid",
                    "value": "[concat('\"',subscription().subscriptionId,'\"')]"
                },
                {
                    "name": "webApp",
                    "value": "[concat('\"',parameters('ApplicationName'),'\"')]"
                },
                {
                    "name": "apiApp",
                    "value": "[concat('\"',variables('webAPIAppName'),'\"')]"
                },
                {
                    "name": "resourceGroupName",
                    "value": "[concat('\"',resourceGroup().name,'\"')]"
                },
                {
                    "name": "Location",
                    "value": "[concat('\"',resourceGroup().location,'\"')]"
                },
                {   
                    "name": "RDBrokerURL",
                    "value": "[concat('\"',parameters('RDBrokerURL'),'\"')]"
                },
                {
                    "name": "ResourceURL",
                    "value": "[concat('\"',parameters('ResourceURL'),'\"')]"
                },
                {
                    "name": "accountName",
                    "value": "[concat('\"',variables('accountName'),'\"')]"
                },
                {
                    "name": "fileURI",
                    "value": "[concat('\"',variables('fileURI'),'\"')]"
                }
            ],
            "uniqueBase": "[toLower(uniquestring(parameters('ApplicationName'), resourceGroup().id, deployment().name,variables('accountName')))]",
            "newGuid": "[guid(variables('uniqueBase'))]"
        },
        "resources": [
            {
                "type": "Microsoft.Web/serverfarms",
                "sku": {
                    "name": "[variables('serviceplansku')]",
                    "capacity": "[variables('workerSize')]"
                },
                "name": "[variables('hostingPlanName')]",
                "apiVersion": "2016-03-01",
                "location": "[resourceGroup().location]",
                "properties": {
                    "name": "[variables('hostingPlanName')]"
                }
            },
            {
                "type": "Microsoft.Web/sites",
                "name": "[parameters('ApplicationName')]",
                "kind": "app",
                "apiVersion": "2016-03-01",
                "location": "[resourceGroup().location]",
                "properties": {
                    "serverFarmId": "[variables('hostingPlanName')]"
                },
                "dependsOn": [
                    "[resourceId('Microsoft.Web/serverfarms', variables('hostingPlanName'))]"
                ]
            },
            {
                "type": "Microsoft.Web/sites",
                "name": "[variables('webAPIAppName')]",
                "kind": "api",
                "apiVersion": "2016-03-01",
                "location": "[resourceGroup().location]",
                "properties": {
                    "serverFarmId": "[variables('hostingPlanName')]"
                },
                "dependsOn": [
                    "[resourceId('Microsoft.Web/serverfarms', variables('hostingPlanName'))]"
                ]
            },
            {
                "type": "Microsoft.Automation/automationAccounts/variables",
                "name": "[concat(variables('accountname'), '/', variables('automationVariables')[copyIndex()].name)]",
                "apiVersion": "2015-10-31",
                "copy": {
                    "name": "variableLoop",
                    "count": "[length(variables('automationVariables'))]"
                },
                "tags": {},
                "properties": {
                    "value": "[variables('automationVariables')[copyIndex()].value]"
                },
                "dependsOn": [
                    "[resourceId('Microsoft.Automation/automationAccounts', variables('accountname'))]",
                    "[resourceId('Microsoft.Web/Sites', parameters('ApplicationName'))]",
                    "[resourceId('Microsoft.Web/serverfarms', variables('hostingPlanName'))]",
                    "[resourceId('Microsoft.Web/Sites', variables('webAPIAppName'))]"
                ]
            },
            {
                "type": "Microsoft.Automation/automationAccounts",
                "name": "[variables('accountName')]",
                "apiVersion": "2015-01-01-preview",
                "location": "[resourceGroup().location]",
                "tags": {},
                "dependsOn": [
                    "[resourceId('Microsoft.Web/Sites', parameters('ApplicationName'))]",
                    "[resourceId('Microsoft.Web/serverfarms', variables('hostingPlanName'))]",
                    "[resourceId('Microsoft.Web/Sites', variables('webAPIAppName'))]"
                ],
                "properties": {
                    "sku": {
                        "name": "[variables('sku')]"
                    }
                },
                "resources": [
                    {
                        "type": "runbooks",
                        "name": "[variables('runbookName')]",
                        "apiVersion": "2015-01-01-preview",
                        "location": "[resourceGroup().location]",
                        "tags": {},
                        "properties": {
                            "runbookType": "PowerShell",
                            "logProgress": "false",
                            "logVerbose": "false",
                            "publishContentLink": {
                                "uri": "[variables('scriptUri')]",
                                "version": "1.0.0.0"
                            }
                        },
                        "dependsOn": [
                            "[concat('Microsoft.Automation/automationAccounts/', variables('accountName'))]",
                            "[resourceId('Microsoft.Web/Sites', parameters('ApplicationName'))]",
                            "[resourceId('Microsoft.Web/serverfarms', variables('hostingPlanName'))]",
                            "[resourceId('Microsoft.Web/Sites', variables('webAPIAppName'))]"
                        ]
                    },
                    {
                        "type": "credentials",
                        "name": "[variables('credentialName')]",
                        "apiVersion": "2015-01-01-preview",
                        "location": "[resourceGroup().location]",
                        "tags": {},
                        "properties": {
                            "userName": "[parameters('AzureADUserPrincipalName')]",
                            "password": "[parameters('AzureLoginPassword')]"
                        },
                        "dependsOn": [
                            "[concat('Microsoft.Automation/automationAccounts/', variables('accountName'))]",
                            "[resourceId('Microsoft.Web/Sites', parameters('ApplicationName'))]",
                            "[resourceId('Microsoft.Web/serverfarms', variables('hostingPlanName'))]",
                            "[resourceId('Microsoft.Web/Sites', variables('webAPIAppName'))]"
                        ]
                    },
                    {
                        "type": "jobs",
                        "name": "[variables('newGuid')]",
                        "apiVersion": "2015-01-01-preview",
                        "location": "[resourceGroup().location]",
                        "tags": {
                            "key": "value"
                        },
                        "properties": {
                            "runbook": {
                                "name": "[variables('runbookName')]"
                            }
                        },
                        "dependsOn": [
                            "[concat('Microsoft.Automation/automationAccounts/', variables('accountName'))]",
                            "[concat('Microsoft.Automation/automationAccounts/', variables('accountName'), '/runbooks/',variables('runbookName'))]",
                            "[resourceId('Microsoft.Web/Sites', parameters('ApplicationName'))]",
                            "[resourceId('Microsoft.Web/serverfarms', variables('hostingPlanName'))]",
                            "[resourceId('Microsoft.Web/Sites', variables('webAPIAppName'))]"
                        ]
                    }   
                ]
            }
        ],
        "outputs": {}
    }
    DEPLOY

    parameters = {
        "AzureADUserPrincipalName" = "${var.azureADUserPrincipalName}"
        "AzureLoginPassword" = "${var.azureLoginPassword}"
        "ApplicationName" = "${lower(var.CompanyNamePrefix)}${lower(var.WVDRGLocation)}${lower(var.environment)}wvdmgmt"
    }

    deployment_mode = "Incremental"

}
######################################################################################################################
# END OF RESOURCES
######################################################################################################################