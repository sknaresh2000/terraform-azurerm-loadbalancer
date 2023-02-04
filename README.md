## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_lb.lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.address_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_probe.lb_probe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_network_interface_backend_address_pool_association.backend_addresses](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_public_ip.pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_address_pools"></a> [backend\_address\_pools](#input\_backend\_address\_pools) | Name of the backend address pool | <pre>map(object({<br>    network_interface_id  = string<br>    ip_configuration_name = string<br>  }))</pre> | n/a | yes |
| <a name="input_frontend_ip_configurations"></a> [frontend\_ip\_configurations](#input\_frontend\_ip\_configurations) | Name of the load balancer | <pre>map(object({<br>    subnet_id      = string<br>    public_ip_name = string<br>  }))</pre> | n/a | yes |
| <a name="input_lb_name"></a> [lb\_name](#input\_lb\_name) | Name of the load balancer | `string` | n/a | yes |
| <a name="input_lb_sku"></a> [lb\_sku](#input\_lb\_sku) | SKU of the load balancer | `string` | `"Basic"` | no |
| <a name="input_load_balancer_probes"></a> [load\_balancer\_probes](#input\_load\_balancer\_probes) | Map containing load balancer probes | <pre>map(object({<br>    backend_address_pool_name = string<br>    probe_port                = number<br>    probe_protocol            = string<br>    request_path              = string<br>    probe_interval            = number<br>    probe_unhealthy_threshold = number<br>  }))</pre> | `{}` | no |
| <a name="input_load_balancer_rules"></a> [load\_balancer\_rules](#input\_load\_balancer\_rules) | Map containing load balancer rules | <pre>map(object({<br>    probe_name                = string<br>    frontend_ip_config_name   = string<br>    backend_address_pool_name = string<br>    lb_protocol               = string<br>    frontend_port             = number<br>    backend_port              = number<br>    enable_floating_ip        = bool<br>    disable_outbound_snat     = bool<br>    enable_tcp_reset          = bool<br>    load_distribution         = string<br>    idle_timeout_in_minutes   = number<br>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The name of the Resource Group in which to create the Load Balancer | `string` | `"eastus"` | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | Private IP Address to assign to the Load Balancer. The last one and first four IPs in any range are reserved and cannot be manually assigned. | `string` | `null` | no |
| <a name="input_private_ip_address_allocation"></a> [private\_ip\_address\_allocation](#input\_private\_ip\_address\_allocation) | The allocation method for the Private IP Address used by this Load Balancer. Possible values as Dynamic and Static | `string` | `"Static"` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the Resource Group in which to create the Load Balancer | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | A list of Availability Zones which the Load Balancer's IP Addresses should be created in | `list(string)` | `[]` | no |

## Outputs

No outputs.
