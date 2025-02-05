resource "azurerm_public_ip" "appgw_public_ip" {
  name                = "appgw-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_application_gateway" "appgw" {
  name                = "appgw"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.appgw_subnet_id  # Reference the subnet where the AppGW is deployed
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw_public_ip.id  # Attach public IP
  }

  frontend_port {
    name = "frontend-port"
    port = 80  # HTTP port (can be 443 for HTTPS)
  }

  backend_address_pool {
    name = "appgw-backend-pool"
    ip_addresses = ["10.0.1.10"]  # Private IP of NGINX Ingress Controller or other services
  }

  backend_http_settings {
    name                  = "appgw-backend-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
    probe_name            = "appgw-health-probe"
  }

  http_listener {
    name                           = "appgw-http-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"  # Reference frontend IP
    frontend_port_name             = "frontend-port"      # Reference frontend port
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "appgw-request-routing-rule"
    rule_type                  = "Basic"
    priority                   = 10
    http_listener_name         = "appgw-http-listener"  # Reference listener
    backend_address_pool_name  = "appgw-backend-pool"   # Reference backend pool
    backend_http_settings_name = "appgw-backend-http-settings"  # Reference backend settings
  }

    probe {
    name                = "appgw-health-probe"
    protocol            = "Http"
    host                = "127.0.0.1"
    port                = 80
    path                = "/healthz"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
  }

  tags = {
    environment = "Production"
  }
}
