output "app_nsg_id" {
  value = azurerm_network_security_group.app_nsg.id
}
output "backend_nsg_id" {
  value = azurerm_network_security_group.backend_nsg.id
}
