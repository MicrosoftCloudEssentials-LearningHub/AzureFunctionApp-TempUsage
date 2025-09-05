variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  default     = "rg-func-optimized"
}

variable "location" {
  type        = string
  description = "Azure region for resources"
  default     = "West US"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "storage_account_tier" {
  type        = string
  description = "Storage account tier"
  default     = "Standard"
}

variable "storage_account_replication_type" {
  type        = string
  description = "Storage account replication type"
  default     = "LRS"
}

variable "app_service_plan_tier" {
  type        = string
  description = "App Service Plan tier (PremiumV3 tier for high performance)"
  default     = "P1v3"
}

variable "app_service_plan_size" {
  type        = string
  description = "App Service Plan size (PremiumV3 tier for high performance)"
  default     = "P1v3"
}

variable "sql_server_admin_login" {
  type        = string
  description = "SQL Server admin login"
  default     = "sqladmin"
}

# Configuration for auto-generated SQL password
variable "sql_password_length" {
  type        = number
  description = "Length of the automatically generated SQL password"
  default     = 24
}

variable "sql_database_name" {
  type        = string
  description = "SQL Database name"
  default     = "funcdb"
}

# Optional: provide an existing storage account name to avoid creating a new one
variable "override_storage_account_name" {
  type        = string
  description = "If set, use this existing storage account name instead of creating a new one"
  default     = ""
}

# Optional: provide the access key for the existing storage account (sensitive)
variable "override_storage_account_key" {
  type        = string
  description = "If set, use this storage account access key instead of the created account's key"
  sensitive   = true
  default     = ""
}

# Optional: if you already have an App Service Plan in-region, set its resource id here to avoid creating one
variable "existing_service_plan_id" {
  type        = string
  description = "Resource ID of an existing App Service Plan to use instead of creating a new one"
  default     = ""
}

# Resource name suffix for demo environments
variable "resource_suffix" {
  description = "Suffix to append to all resource names for uniqueness."
  type        = string
}

# Base names for resources (optional, for further flexibility)
variable "base_service_plan_name" {
  description = "Base name for the service plan."
  type        = string
  default     = "asp-optimized"
}
variable "base_app_insights_name" {
  description = "Base name for Application Insights."
  type        = string
  default     = "appi-optimized"
}
variable "base_log_analytics_name" {
  description = "Base name for Log Analytics Workspace."
  type        = string
  default     = "log-optimized"
}
variable "base_key_vault_name" {
  description = "Base name for Key Vault."
  type        = string
  default     = "kv-optimized"
}
variable "base_sql_server_name" {
  description = "Base name for SQL Server."
  type        = string
  default     = "sql-optimized"
}
variable "base_function_app_name" {
  description = "Base name for Function App."
  type        = string
  default     = "func-optimized"
}
variable "base_data_storage_name" {
  description = "Base name for Data Storage Account."
  type        = string
  default     = "stoptimized"
}
