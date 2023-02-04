locals {
  public_ips = {
    for k, v in var.frontend_ip_configurations :
    k => v if v.public_ip_name != null
  }
}

resource "azurerm_public_ip" "pip" {
  for_each            = local.public_ips
  name                = each.value.public_ip_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.lb_sku == "Basic" ? "Basic" : "Standard"
  allocation_method   = "Static"
  tags                = var.tags
}

resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.lb_sku

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations
    content {
      name                          = frontend_ip_configuration.key
      subnet_id                     = frontend_ip_configuration.value.subnet_id
      private_ip_address_allocation = frontend_ip_configuration.value.public_ip_name == null ? var.private_ip_address_allocation : null
      private_ip_address            = frontend_ip_configuration.value.public_ip_name == null && var.private_ip_address_allocation == "Static" ? var.private_ip_address : null
      public_ip_address_id          = frontend_ip_configuration.value.public_ip_name == null ? null : (azurerm_public_ip.pip)[frontend_ip_configuration.value.public_ip_name].id
      zones                         = var.lb_sku == "Basic" || length(var.zones) == 0 ? null : var.zones
    }
  }
  tags = var.tags
}

# -
# - Load Balancer Backend Address Pool
# -
resource "azurerm_network_interface_backend_address_pool_association" "backend_addresses" { // Not required
  for_each                = local.backend_addresses
  network_interface_id    = each.value.network_interface_id
  ip_configuration_name   = each.value.ip_configuration_name
  backend_address_pool_id = (azurerm_lb_backend_address_pool.address_pool)[each.key].id
}

locals {
  backend_addresses = {
    for k, v in var.backend_address_pools :
    k => v if v.network_interface_id != null
  }
}

resource "azurerm_lb_backend_address_pool" "address_pool" {
  for_each = var.backend_address_pools
  name     = each.key
  # resource_group_name = var.rg_name
  loadbalancer_id = azurerm_lb.lb.id
}

# -
# - Load Balancer Probe
# -
resource "azurerm_lb_probe" "lb_probe" {
  for_each            = var.load_balancer_probes
  name                = each.key
  loadbalancer_id     = azurerm_lb.lb.id
  port                = each.value.probe_port
  protocol            = each.value.probe_protocol
  request_path        = each.value.probe_protocol == "Tcp" ? null : each.value.request_path
  interval_in_seconds = each.value.probe_interval
  number_of_probes    = each.value.probe_unhealthy_threshold
}

# -
# - Load Balancer Rule
# -

resource "azurerm_lb_rule" "rule" {
  for_each                       = var.load_balancer_rules
  name                           = each.key
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = each.value.lb_protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_config_name
  backend_address_pool_ids       = [(azurerm_lb_backend_address_pool.address_pool)[each.value.backend_address_pool_name].id]
  probe_id                       = (azurerm_lb_probe.lb_probe)[each.value.probe_name].id
  load_distribution              = each.value.load_distribution
  idle_timeout_in_minutes        = each.value.idle_timeout_in_minutes
  enable_floating_ip             = each.value.enable_floating_ip
  disable_outbound_snat          = each.value.disable_outbound_snat
  enable_tcp_reset               = each.value.enable_tcp_reset
}