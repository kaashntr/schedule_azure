variable "az_subscription_id" {
  type        = string
  
}

variable "resource_group_name" {
  type        = string
  default     = "class-schedule-rg"
}

variable "location" {
  type        = string
  description = "Region Azure"
  default     = "East US"
}

variable "prefix" {
  type        = string
  description = "Resourse's prefix"
}

#Vnet
variable "vnet_address_space" {
  type        = string
  description = "CIDR for Vnet"
}

variable "private_subnet_address_space" {
  type        = string
  description = "CIDR for backend subnet"
}

variable "public_subnet_address_space" {
  type        = string
  description = "CIDR for app subnet"
}

variable "bastion_subnet_address_space" {
  type        = string
  description = "CIDR for bastion subnet"
}

variable "db_subnet_address_space" {
  type        = string
  description = "CIDR for bastion subnet"
}

variable "redis_subnet_address_space" {
  type        = string
  description = "CIDR for bastion subnet"
}

#app_vm
variable "vm_size" {
  type = string
  description = "Type of linux vm"
}

variable "admin_username" {
  type = string
  description = "Username of admin for vm"
}

variable "vm_os_disk_caching" {
  type = string
  description = "Caching method for vm disk"
}

variable "vm_os_disk_storage_account_type" {
  type = string
  description = "Storage account type for vm disk"
}

variable "vm_pub_key_path" {
  type = string
  description = "Path to ssh public key for app vm"
}

#nsg

variable "app_custom_rules" {
  description = "Custom set of security rules using this format"
  type        = list(any)
  default     = []

  # Example:
  # custom_rules = [{
  # name                   = "myssh"
  # priority               = "101"
  # direction              = "Inbound"
  # access                 = "Allow"
  # protocol               = "tcp"
  # source_port_range      = "1234"
  # destination_port_range = "22"
  # description            = "description-myssh"
  #}]
}

variable "backend_custom_rules" {
  description = "Custom set of security rules using this format"
  type        = list(any)
  default     = []
}

variable "proxy_custom_rules" {
  description = "Custom set of security rules using this format"
  type        = list(any)
  default     = []
}

# variable "bastion_custom_rules" {
#   description = "Custom set of security rules using this format"
#   type        = list(any)
#   default     = []
# }

variable "postgre_custom_rules" {
  description = "Custom set of security rules using this format"
  type        = list(any)
  default     = []
}

variable "redis_custom_rules" {
  description = "Custom set of security rules using this format"
  type        = list(any)
  default     = []
}

variable "destination_address_prefix" {
  type    = list(any)
  default = ["*"]

  # Example: ["10.0.3.0/32","10.0.3.128/32"]
}

variable "app_nsg_name" {
  description = "Name of the network security group"
  default     = "app_nsg"
}

variable "backend_nsg_name" {
  description = "Name of the network security group"
  default     = "backend_nsg"
}

variable "proxy_nsg_name" {
  description = "Name of the network security group"
  default     = "proxy_nsg"
}

# variable "bastion_nsg_name" {
#   description = "Name of the network security group"
#   default     = "basstion_nsg"
# }

variable "postgre_nsg_name" {
  description = "Name of the network security group"
  default     = "postgre_nsg"
}

variable "redis_nsg_name" {
  description = "Name of the network security group"
  default     = "redis_nsg"
}
variable "source_address_prefix" {
  type    = list(any)
  default = ["*"]

  # Example: ["10.0.3.0/24"]
}

variable "tags" {
  description = "The tags to associate with your network security group."
  type        = map(string)
  default     = {}
}

variable "use_for_each" {
  description = "Choose wheter to use 'for_each' as iteration technic to generate the rules, defaults to false so we will use 'count' for compatibilty with previous module versions, but prefered method is 'for_each'"
  type        = bool
  default     = false
  nullable    = false
}

variable "postgre_admin_user" {
  type = string
  default = "postgre"
}

variable "postgre_admin_password" {
  type = string
}

variable "postgre_server_name" {
  type = string
  default = "boba-postgre-db"
}

variable "redis_server_name" {
  type = string
  default = "boba-redis-db"
}