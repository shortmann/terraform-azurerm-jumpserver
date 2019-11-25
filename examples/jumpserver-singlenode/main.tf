# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY jumpserver
# This is an example of how to use the jumpserver module
# ---------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 0.12.12"
}

# ---------------------------------------------------------------------------------------------------------------------
# PREPARE PROVIDERS
# ---------------------------------------------------------------------------------------------------------------------

provider "azurerm" {
  version = "~> 1.36.0"
}

# Create a new resource group
resource "azurerm_resource_group" "test" {
  name     = "test-rg"
  location = "northeurope"
  tags = {
    environment = "Test"
    author      = "Kai Kahllund"
  }
}

module "network" {
    source              = "Azure/network/azurerm"
    resource_group_name = azurerm_resource_group.test.name
    location            = azurerm_resource_group.test.location
    address_space       = "10.0.0.0/16"
    subnet_prefixes     = ["10.0.1.0/24"]
    subnet_names        = ["default"]
}

# ---------------------------------------------------------------------------------------------------------------------
# USE THE MODULE
# ---------------------------------------------------------------------------------------------------------------------

module "jumpserver" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "github.com/shortmann/terraform-azurerm-jumpserver.git//modules/jumpserver?ref=v0.2.0"
  source = "../../modules/jumpserver"
  resource_group_name = azurerm_resource_group.test.name
  subnet_id = module.network.vnet_subnets[0]
}