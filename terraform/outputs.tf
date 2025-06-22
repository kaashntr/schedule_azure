output "app_private_ip" {
  value = module.app_vm.private_ip
}
output "backend_private_ip" {
  value = module.backend_vm.private_ip
}
output "proxy_private_ip" {
  value = module.proxy_vm.private_ip
}
output "proxy_public_ip" {
  value = azurerm_public_ip.proxy_ip.ip_address
  
}
output "postgre_hostname" {
  value = module.postgres.server_hostname
}
output "redis_private_ip" {
  value = module.redis_vm.private_ip
}
output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}
