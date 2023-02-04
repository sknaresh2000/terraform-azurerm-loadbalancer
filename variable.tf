variable "rg_name" {
  type        = string
  description = "The name of the Resource Group in which to create the Load Balancer"
  default     = ""
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "The name of the Resource Group in which to create the Load Balancer"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
}

variable "lb_name" {
  type        = string
  description = "Name of the load balancer"
}

variable "lb_sku" {
  type        = string
  description = "SKU of the load balancer"
  default     = "Basic"
}

variable "frontend_ip_configurations" {
  type = map(object({
    subnet_id      = string
    public_ip_name = string
  }))
  description = "Name of the load balancer"
}

variable "backend_address_pools" {
  type = map(object({
    network_interface_id  = string
    ip_configuration_name = string
  }))
  description = "Name of the backend address pool"
}

variable "load_balancer_rules" {
  type = map(object({
    probe_name                = string
    frontend_ip_config_name   = string
    backend_address_pool_name = string
    lb_protocol               = string
    frontend_port             = number
    backend_port              = number
    enable_floating_ip        = bool
    disable_outbound_snat     = bool
    enable_tcp_reset          = bool
    load_distribution         = string
    idle_timeout_in_minutes   = number
  }))
  description = "Map containing load balancer rules"
  default     = {}
}

variable "load_balancer_probes" {
  type = map(object({
    backend_address_pool_name = string
    probe_port                = number
    probe_protocol            = string
    request_path              = string
    probe_interval            = number
    probe_unhealthy_threshold = number
  }))
  description = "Map containing load balancer probes"
  default     = {}
}

variable "zones" {
  type        = list(string)
  description = "A list of Availability Zones which the Load Balancer's IP Addresses should be created in"
  default     = []
}

variable "private_ip_address_allocation" {
  type        = string
  description = "The allocation method for the Private IP Address used by this Load Balancer. Possible values as Dynamic and Static"
  default     = "Static"
}

variable "private_ip_address" {
  type        = string
  description = "Private IP Address to assign to the Load Balancer. The last one and first four IPs in any range are reserved and cannot be manually assigned."
  default     = null
}