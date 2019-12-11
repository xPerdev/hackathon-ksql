
###########################################
################# Azure ###################
###########################################

# Create a new resource group
resource "azurerm_resource_group" "rg" {
    name     = "${var.prefix}-resources"
    location = var.location
    tags     = var.tags
}
