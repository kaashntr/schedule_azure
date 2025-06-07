output "app_public_ip" {
    value = azurerm_public_ip.app_public_ip.ip_address
}
output "app_private_ip" {
    value = azurerm_network_interface.app_nic.private_ip_addresses
}