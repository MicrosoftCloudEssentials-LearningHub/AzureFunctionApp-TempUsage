# main.tf
# Scenario 1: High-Load Writable Deployment with Aggressive Logging
# Test rapid temp file accumulation and disk decay

# Get current client configuration
data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  # Output the resource group name
  provisioner "local-exec" {
    command = "echo Resource Group: ${self.name}"
  }
}

# Storage Account for Function App Runtime using Azure CLI 
locals {
  runtime_storage_name = "struntime${var.resource_suffix}"
}

resource "null_resource" "runtime_storage_account" {
  # Create storage account using Azure CLI
  provisioner "local-exec" {
    command = "az storage account create --name ${local.runtime_storage_name} --resource-group ${azurerm_resource_group.rg.name} --location eastus2 --sku Standard_LRS --https-only true --min-tls-version TLS1_2"
  }
  
  depends_on = [azurerm_resource_group.rg]
}

# Use data source to get info about the created storage account
data "azurerm_storage_account" "runtime" {
  name                = local.runtime_storage_name
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [null_resource.runtime_storage_account]
}

# Storage Account for Data using Azure CLI 
locals {
  data_storage_name = "${var.base_data_storage_name}${var.resource_suffix}"
}

resource "null_resource" "data_storage_account" {
  # Create storage account using Azure CLI
  provisioner "local-exec" {
    command = "az storage account create --name ${local.data_storage_name} --resource-group ${azurerm_resource_group.rg.name} --location eastus2 --sku Standard_LRS --https-only true --min-tls-version TLS1_2"
  }
  
  depends_on = [azurerm_resource_group.rg]
}

# Use data source to get info about the created storage account
data "azurerm_storage_account" "storage" {
  name                = local.data_storage_name
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [null_resource.data_storage_account]
}

# Blob Container for Output Files - create with Azure CLI
resource "null_resource" "output_container" {
  # Create blob container using Azure CLI
  provisioner "local-exec" {
    command = "az storage container create --name output --account-name ${local.data_storage_name} --auth-mode login"
  }
  
  depends_on = [null_resource.data_storage_account, data.azurerm_storage_account.storage]
}

# Service Plan  
resource "azurerm_service_plan" "asp" {
  name                = "${var.base_service_plan_name}${var.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows" 
  sku_name            = "P1v3"    

  depends_on = [azurerm_resource_group.rg]

  # Output the service plan name
  provisioner "local-exec" {
    command = "echo Service Plan: ${self.name}"
  }
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                = "${var.base_log_analytics_name}${var.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  depends_on = [azurerm_resource_group.rg]

  # Output the log analytics workspace name
  provisioner "local-exec" {
    command = "echo Log Analytics Workspace: ${self.name}"
  }
}

# Application Insights
resource "azurerm_application_insights" "appinsights" {
  name                = "${var.base_app_insights_name}${var.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  sampling_percentage = 100 # No sampling - full logging for high decay scenario test
  workspace_id        = azurerm_log_analytics_workspace.loganalytics.id

  depends_on = [azurerm_log_analytics_workspace.loganalytics]

  provisioner "local-exec" {
    command = "echo Application Insights: ${self.name}"
  }
}

# Key Vault
resource "azurerm_key_vault" "kv" {
  name                       = "${var.base_key_vault_name}${var.resource_suffix}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    
    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge"
    ]
  }

  depends_on = [azurerm_resource_group.rg]

  # Output the key vault name
  provisioner "local-exec" {
    command = "echo Key Vault: ${self.name}"
  }
}

# SQL Server
resource "azurerm_mssql_server" "sql_server" {
  name                         = "${var.base_sql_server_name}${var.resource_suffix}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_server_admin_login
  administrator_login_password = var.sql_server_admin_password
  
  tags = {
    Environment = var.environment
    Scenario    = "High-Decay"
  }
}

# SQL Database
resource "azurerm_mssql_database" "sql_db" {
  name        = var.sql_database_name
  server_id   = azurerm_mssql_server.sql_server.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  sku_name    = "Basic"
  max_size_gb = 2
  
  tags = {
    Environment = var.environment
    Scenario    = "High-Decay"
  }
}

# Store SQL connection string in Key Vault
resource "azurerm_key_vault_secret" "sql_connection_string" {
  name         = "sql-connection-string"
  value        = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sql_db.name};Persist Security Info=False;User ID=${var.sql_server_admin_login};Password=${var.sql_server_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.kv.id
}

# SQL Firewall rule to allow Azure services
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Azure Function App 
resource "azurerm_windows_function_app" "function_app" {
  name                        = "${var.base_function_app_name}${var.resource_suffix}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  service_plan_id             = azurerm_service_plan.asp.id
  
  # Use the runtime storage account for Function App requirements
  storage_account_name        = data.azurerm_storage_account.runtime.name
  storage_uses_managed_identity = true
  
  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      dotnet_version = "v6.0" # .NET 6 
    }
    
    ftps_state = "FtpsOnly"
  }

  # App settings for high decay scenario test
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"                = "dotnet"
    "FUNCTIONS_EXTENSION_VERSION"             = "~4"
    
    # Force standard deployment instead of mounted package for high decay test
    "WEBSITE_RUN_FROM_PACKAGE"                = "0"
    
    # Enable full diagnostics
    "WEBSITE_ENABLE_DETAILED_DIAGNOSTICS"     = "true"
    
    # Set verbose logging
    "AzureFunctionsJobHost__logging__LogLevel__Default" = "Information"
    
    # Use managed identity for storage access
    "AzureWebJobsStorage__accountName"        = data.azurerm_storage_account.runtime.name
    
    # SQL connection string - Reference to Key Vault
    "SqlConnectionString"                     = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.sql_connection_string.id})"
    
    # Application Insights settings
    "APPINSIGHTS_INSTRUMENTATIONKEY"          = azurerm_application_insights.appinsights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"   = azurerm_application_insights.appinsights.connection_string
    
    # Enable SCM separation for diagnostics
    "WEBSITE_DISABLE_SCM_SEPARATION"          = "false"
    
    # Enable temp file access for diagnostics
    "WEBSITE_ENABLE_TEMP_ACCESS"              = "true"
    
    # Key Vault reference
    "AZURE_KEY_VAULT_ENDPOINT"                = azurerm_key_vault.kv.vault_uri
    
    # Data storage connection settings
    "DataStorageConnection__accountName"      = data.azurerm_storage_account.storage.name
  }

  # Ensure dependent resources are provisioned before the function app
  depends_on = [
    azurerm_resource_group.rg,
    null_resource.runtime_storage_account,
    data.azurerm_storage_account.runtime,
    null_resource.data_storage_account,
    data.azurerm_storage_account.storage,
    azurerm_service_plan.asp,
    azurerm_application_insights.appinsights,
    azurerm_key_vault.kv
  ]
  
  # Force default deployment method (zip without run from package)
  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]
  }
}

# Grant the Function App's managed identity access to Key Vault
resource "azurerm_key_vault_access_policy" "function_app_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_windows_function_app.function_app.identity[0].principal_id
  
  secret_permissions = [
    "Get", "List"
  ]
  
  depends_on = [
    azurerm_windows_function_app.function_app,
    azurerm_key_vault.kv
  ]
}

# Grant the Function App's managed identity access to Runtime Storage
resource "azurerm_role_assignment" "function_runtime_storage_blob_data" {
  scope                = data.azurerm_storage_account.runtime.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_windows_function_app.function_app.identity[0].principal_id
  
  depends_on = [
    azurerm_windows_function_app.function_app,
    data.azurerm_storage_account.runtime
  ]
}

resource "azurerm_role_assignment" "function_runtime_storage_queue_data" {
  scope                = data.azurerm_storage_account.runtime.id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = azurerm_windows_function_app.function_app.identity[0].principal_id
  
  depends_on = [
    azurerm_windows_function_app.function_app,
    data.azurerm_storage_account.runtime
  ]
}

resource "azurerm_role_assignment" "function_runtime_storage_table_data" {
  scope                = data.azurerm_storage_account.runtime.id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = azurerm_windows_function_app.function_app.identity[0].principal_id
  
  depends_on = [
    azurerm_windows_function_app.function_app,
    data.azurerm_storage_account.runtime
  ]
}

# Grant the Function App's managed identity access to Data Storage
resource "azurerm_role_assignment" "function_data_storage_blob_data" {
  scope                = data.azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_windows_function_app.function_app.identity[0].principal_id
  
  depends_on = [
    azurerm_windows_function_app.function_app,
    data.azurerm_storage_account.storage
  ]
}

resource "azurerm_role_assignment" "function_data_storage_queue_data" {
  scope                = data.azurerm_storage_account.storage.id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = azurerm_windows_function_app.function_app.identity[0].principal_id
  
  depends_on = [
    azurerm_windows_function_app.function_app,
    data.azurerm_storage_account.storage
  ]
}
