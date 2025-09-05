# Scenario 1 - Overview <br/> High-Load Writable Deployment with Aggressive Logging 

Costa Rica

[![GitHub](https://badgen.net/badge/icon/github?icon=github&label)](https://github.com)
[![GitHub](https://img.shields.io/badge/--181717?logo=github&logoColor=ffffff)](https://github.com/)
[brown9804](https://github.com/brown9804)

Last updated: 2025-08-27

-----------------------------

> This scenario is intended to demonstrate rapid temporary file accumulation and disk degradation in Azure Functions.

<details>
<summary><b>List of References</b> (Click to expand)</summary>
  
- [Kudu service overview](https://learn.microsoft.com/en-us/azure/app-service/resources-kudu)
  
</details>

> [!NOTE]
> Expected Results: <br/>
> - Rapid temp file accumulation in `C:\local\Temp` <br/>
> - Disk decay within 1-2 days <br/>
> - Restart clears only partial space due to locked files 

## Infrastructure Setup

- **App Service Plan (Windows)** - P1v3 tier for high-load testing

  ```terraform
  # Service Plan  
  sku_name            = "P1v3"    
  ```

- **Deployment Method**: Standard deployment (extracted .zip)

  ```terraform
  # Force standard deployment instead of mounted package
  "WEBSITE_RUN_FROM_PACKAGE" = "0"
  ```

- **Application Insights**: Full logging (no sampling)

  ```terraform
  # No sampling configured - full logging
  sampling_percentage = 100
  ```
- **Verbose Diagnostics**: Enabled

  ```terraform
  # Enable full diagnostics
  "WEBSITE_ENABLE_DETAILED_DIAGNOSTICS" = "true"
  ```

- **Storage Logging**: Enabled

  ```terraform
  # Log to storage account (increases I/O operations)
  "AzureWebJobsDashboard" = azurerm_storage_account.storage.primary_connection_string
  ```
- **WEBSITE_RUN_FROM_PACKAGE**: `Disabled (set to 0)`
- **Key Vault Integration**: Secrets stored in Azure Key Vault
- **Managed Identity**: System-assigned identity for Key Vault access


## Deployment Instructions

1. Please follow the [Terraform Deployment guide](./terraform-infrastructure/README.md) to deploy the necessary Azure resources for the workshop.
2. After infrastructure deployment, follow the deployment approaches in [Deployment Guide](./DEPLOYMENT.md) to publish the function app.

## Testing

> The function app includes HTTP triggers that can be used to test disk usage under load

## Monitoring

> Monitor the function app using:

- Azure Portal > Function App > Development Tools > Advanced tools ([Kudu](https://learn.microsoft.com/en-us/azure/app-service/resources-kudu))

    https://github.com/user-attachments/assets/0e529115-13ae-4a2f-83ad-35c33be8bb67

- Application Insights
- Azure Monitor metrics

<!-- START BADGE -->
<div align="center">
  <img src="https://img.shields.io/badge/Total%20views-1342-limegreen" alt="Total views">
  <p>Refresh Date: 2025-08-29</p>
</div>
<!-- END BADGE -->
