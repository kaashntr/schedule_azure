output "private_ip" {
  value = azurerm_network_interface.vm_nic.private_ip_addresses
}
output "resource_id" {
  value = azurerm_linux_virtual_machine.vm.id
}
output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}