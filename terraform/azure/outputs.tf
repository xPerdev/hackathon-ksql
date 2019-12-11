###########################################
################# Outputs #################
###########################################

output "ip" {
    value = [azurerm_public_ip.publicip.*.ip_address]
}

output "os_sku" {
    value = lookup(var.sku, var.location)
}