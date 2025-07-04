variable "resource_group_name" {
  type        = string
}

variable "location" {
  type        = string
  description = "Region Azure"
}

variable "prefix" {
  type        = string
  description = "Resourse's prefix"
}

variable "vnet_address_space" {
  type        = string
  description = "CIDR for Vnet"
}

variable "private_subnet_address_space" {
  type        = string
  description = "CIDR for private subnet"
}
variable "public_subnet_address_space" {
  type        = string
  description = "CIDR for public subnet"
}

variable "bastion_subnet_address_space" {
  type        = string
  description = "CIDR for bastion subnet"
}

variable "db_subnet_address_space" {
  type        = string
  description = "CIDR for db subnet"
}

variable "redis_subnet_address_space" {
  type        = string
  description = "CIDR for redis subnet"
}

# variable "bastion_nsg_id" {
#   type = string
#   description = "Bastion NSG for association"
# }

variable "postgre_nsg_id" {
  type = string
  description = "Postgre NSG for association"
}

variable "redis_nsg_id" {
  type = string
  description = "Redis NSG for association"
}