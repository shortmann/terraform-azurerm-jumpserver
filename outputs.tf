output "vm_name" {
  value = azurerm_virtual_machine.jumpserver.name
}

output "public_fqdn" {
  value = azurerm_public_ip.jumpserver.fqdn
}
