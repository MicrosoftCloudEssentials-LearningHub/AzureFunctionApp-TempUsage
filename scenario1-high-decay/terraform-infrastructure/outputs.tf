# outputs.tf
# This file contains the outputs from the Terraform deployment

output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "The name of the resource group"
}

output "function_app_name" {
  value       = azurerm_windows_function_app.function_app.name
  description = "The name of the function app"
}

output "function_app_default_hostname" {
  value       = azurerm_windows_function_app.function_app.default_hostname
  description = "The default hostname of the function app"
}

output "storage_account_name" {
  value       = data.azurerm_storage_account.storage.name
  description = "The name of the storage account"
}

output "application_insights_name" {
  value       = azurerm_application_insights.appinsights.name
  description = "The name of the Application Insights instance"
}

output "application_insights_instrumentation_key" {
  value       = azurerm_application_insights.appinsights.instrumentation_key
  description = "The instrumentation key of the Application Insights instance"
  sensitive   = true
}

output "sql_server_name" {
  value       = azurerm_mssql_server.sql_server.name
  description = "The name of the SQL server"
}

output "sql_server_fqdn" {
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
  description = "The fully qualified domain name of the SQL server"
}

output "sql_database_name" {
  value       = azurerm_mssql_database.sql_db.name
  description = "The name of the SQL database"
}

output "key_vault_name" {
  value       = azurerm_key_vault.kv.name
  description = "The name of the Key Vault"
}

output "key_vault_uri" {
  value       = azurerm_key_vault.kv.vault_uri
  description = "The URI of the Key Vault"
}
