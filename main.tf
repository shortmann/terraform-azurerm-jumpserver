# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY jumpserver
# A terraform module which creates a jumpserver
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 0.12.12"
}

resource "azurerm_resource_group" "jumpserver" {
  name     = var.resource_group_name
  location = "${var.location}"
  tags     = "${var.tags}"
}

# Create a public IP for the jumpserver
resource "azurerm_public_ip" "jumpserver" {
  name                    = "${var.name}-jumpserver-public-ip"
  location                = azurerm_resource_group.jumpserver.location
  resource_group_name     = azurerm_resource_group.jumpserver.name
  allocation_method       = "Dynamic"
  domain_name_label       = "${var.public_url}"
  idle_timeout_in_minutes = 30
  tags                    = "${var.tags}"
}

# Create needed nic
resource "azurerm_network_interface" "jumpserver" {
  name                = "${var.name}-jumpserver-nic-0"
  location            = azurerm_resource_group.jumpserver.location
  resource_group_name = azurerm_resource_group.jumpserver.name
  ip_configuration {
    name                          = "${var.name}-jumpserver-ip-0"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpserver.id
  }
  tags = "${var.tags}"
}

# Create the jumpserver
resource "azurerm_virtual_machine" "jumpserver" {
  name                          = "${var.name}-jumpserver"
  location                      = azurerm_resource_group.jumpserver.location
  resource_group_name           = azurerm_resource_group.jumpserver.name
  network_interface_ids         = ["${azurerm_network_interface.jumpserver.id}"]
  vm_size                       = "Standard_B1ms"
  delete_os_disk_on_termination = true
  storage_image_reference {
    publisher = "Openlogic"
    offer     = "CentOS"
    sku       = "7.6"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.name}-jumpserver-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.name}-jumpserver"
    admin_username = "${var.os_user}"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.os_user}/.ssh/authorized_keys"
      key_data = "${file("${var.ssh_key}")}"
    }
  }
  tags = "${var.tags}"
}
