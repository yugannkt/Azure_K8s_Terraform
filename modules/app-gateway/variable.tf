variable "appgw_name" {
  description = "Name of the Application Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "appgw_subnet_id" {
  description = "Subnet ID for Application Gateway"
  type        = string
}

variable "appgw_public_ip_name" {
  description = "Public IP name for Application Gateway"
  type        = string
}
