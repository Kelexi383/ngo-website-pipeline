terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Generate a random suffix for globally unique storage account name
resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

# Resource Group
resource "azurerm_resource_group" "website" {
  name     = "CloudProject-RG-TF"   # You can use a different name for Terraform-managed RG
  location = "westcentralus"        # Same region that worked for you
}

# Storage Account with static website enabled
resource "azurerm_storage_account" "website" {
  name                     = "staticweb${random_integer.suffix.result}"
  resource_group_name      = azurerm_resource_group.website.name
  location                 = azurerm_resource_group.website.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

# Output the website URL
output "static_website_url" {
  value = azurerm_storage_account.website.primary_web_endpoint
}

output "storage_account_name" {
  value = azurerm_storage_account.website.name
}