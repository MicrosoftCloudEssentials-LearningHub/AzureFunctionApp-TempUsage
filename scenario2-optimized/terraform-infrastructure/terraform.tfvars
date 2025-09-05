# terraform.tfvars
# This file contains the values for the variables defined in variables.tf
# Sample values 
subscription_id = "your-subscription-id" # Replace with your actual subscription ID
resource_group_name = "RG-FA-optimizedx3" # Desired resource group name
location = "West US 2" # Desired location
environment = "dev" # Desired environment tag
# SQL credentials are automatically generated and stored in Key Vault
# SQL password is auto-generated securely and stored in Key Vault secret "sql-admin-password"
resource_suffix = "x3x" # Unique suffix for resource names to avoid conflicts (used for demos)
