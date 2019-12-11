###########################################
################# Azure ###################
###########################################

provider "azurerm" {
    version = "~>1.38.0"
    subscription_id = var.azure_subscription_id
    tenant_id       = var.azure_tenant_id
}