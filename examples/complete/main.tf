# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "app-gateway" {
  //  source = "github.com/tietoevry-infra-as-code/terraform-azurerm-application-gateway?ref=v1.0.0"
  source = "../../"
  # Resource Group and location, VNet and Subnet detials (Required)
  resource_group_name         = "rg-shared-westeurope-01"
  location                    = "westeurope"
  virtual_network_name        = "vnet-shared-hub-westeurope-001"
  subnet_name                 = "snet-management"
  app_gateway_name            = "testgateway"
  frontend_port               = 80
  public_ip_sku               = "Basic"
  public_ip_allocation_method = "Dynamic"
  /* # (Optional) To enable Azure Monitoring and install log analytics agents
  log_analytics_workspace_name = "logaws-yhjhmxvd-default-hub-westeurope"
  storage_account_name     = "stdiaglogsdefaulthub"
*/
  sku = {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 1
  }

  backend_address_pool = {
    fqdns = ["example.com"]
  }

  backend_http_settings = {
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 300
  }

  request_routing_rule = {
    rule_type = "Basic"
  }

  http_listener = {
    protocol = "Http"
  }

  # Adding TAG's to your Azure resources (Required)
  # ProjectName and Env are already declared above, to use them here, create a varible. 
  tags = {
    ProjectName  = "tieto-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}
