###########################################
###### Confluent Platform Components ######
###########################################

resource "azurerm_network_interface" "nic" {
  count                     = var.instance_count["vms"] >= 1 ? var.instance_count["vms"] : 0
  name                      = "${var.prefix}-server-${count.index}-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id
  tags     = var.tags

  ip_configuration {
    name                          = "${var.prefix}-server-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip[count.index].id
  }
}

resource "azurerm_virtual_machine" "vm" {
  count                 = var.instance_count["vms"] >= 1 ? var.instance_count["vms"] : 0
  name                  = "${var.prefix}-server-${count.index}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  vm_size               = "Standard_DS3_v2"
  delete_os_disk_on_termination = true
  tags                  = var.tags

  storage_os_disk {
    name              = "${var.prefix}-server-${count.index}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 100
  }

  storage_image_reference {
    publisher = "Canonical"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    offer     = "UbuntuServer"
    sku       = lookup(var.sku, var.location)
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.prefix}-server-${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = data.template_file.ATMFraudDetection_bootstrap.rendered
  }                                                                                                                                                                                                                                                                                                                                 

  os_profile_linux_config {
    disable_password_authentication = false
  }
}