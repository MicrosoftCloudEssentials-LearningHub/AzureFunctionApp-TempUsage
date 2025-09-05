# Scenario 1: High-Load Writable Deployment with Aggressive Logging - Overview 

Costa Rica

[![GitHub](https://badgen.net/badge/icon/github?icon=github&label)](https://github.com)
[![GitHub](https://img.shields.io/badge/--181717?logo=github&logoColor=ffffff)](https://github.com/)
[brown9804](https://github.com/brown9804)

Last updated: 2025-08-27

-----------------------------

> This scenario is intended to demonstrate rapid temporary file accumulation and disk degradation in Azure Functions.


## Infrastructure Setup

- **App Service Plan (Windows)** - P1v3 tier for high-load testing
  - See: [./terraform-infrastructure/variables.tf](./terraform-infrastructure/variables.tf) (lines 12-21)
  - See: [./terraform-infrastructure/main.tf](./terraform-infrastructure/main.tf) (lines 35-45)
- **Deployment Method**: Standard deployment (extracted .zip)
  - See: [./terraform-infrastructure/main.tf](./terraform-infrastructure/main.tf) (line 115)
  ```terraform
  # Force standard deployment instead of mounted package
  "WEBSITE_RUN_FROM_PACKAGE" = "0"
  ```
- **Application Insights**: Full logging (no sampling)
  - See: [./terraform-infrastructure/main.tf](./terraform-infrastructure/main.tf) (lines 47-56)
  ```terraform
  # No sampling configured - full logging
  sampling_percentage = 100
  ```
- **Verbose Diagnostics**: Enabled
  - See: [./terraform-infrastructure/main.tf](./terraform-infrastructure/main.tf) (line 118)
  ```terraform
  # Enable full diagnostics
  "WEBSITE_ENABLE_DETAILED_DIAGNOSTICS" = "true"
  ```
- **Storage Logging**: Enabled
  - See: [./terraform-infrastructure/main.tf](./terraform-infrastructure/main.tf) (line 124)
  ```terraform
  # Log to storage account (increases I/O operations)
  "AzureWebJobsDashboard" = azurerm_storage_account.storage.primary_connection_string
  ```
- **WEBSITE_RUN_FROM_PACKAGE**: Disabled (set to "0")
  - See: [./terraform-infrastructure/main.tf](./terraform-infrastructure/main.tf) (line 115)
- **Key Vault Integration**: Secrets stored in Azure Key Vault
  - See: [./terraform-infrastructure/main.tf](./terraform-infrastructure/main.tf) (lines 147-193)
- **Managed Identity**: System-assigned identity for Key Vault access
  - See: [./terraform-infrastructure/main.tf](./terraform-infrastructure/main.tf) (lines 96-98)

## Expected Results

- Rapid temp file accumulation in `C:\local\Temp`
- Disk decay within 1-2 days
- Restart clears only partial space due to locked files

## Deployment Instructions

> For detailed deployment instructions including VS Code deployment and Azure DevOps pipeline samples, see the [DEPLOYMENT.md](./DEPLOYMENT.md) guide.

1. Go to the terraform-infrastructure directory:
   ```
   cd scenario-1-high-decay/terraform-infrastructure
   ```

2. Update the `terraform.tfvars` file with your Azure subscription ID and preferred configuration values.

3. Initialize Terraform:
   ```
   terraform init
   ```

4. Apply the Terraform configuration:
   ```
   terraform apply
   ```

5. After infrastructure deployment, follow the deployment approaches in [DEPLOYMENT.md](./DEPLOYMENT.md) to publish the function app.

## Testing

> The function app includes HTTP triggers that can be used to test disk usage under load

## Monitoring

> Monitor the function app using:

- Azure Portal > Function App > Platform features > Advanced tools (Kudu)
- Application Insights
- Azure Monitor metrics

<!-- START BADGE -->
<div align="center">
  <img src="https://img.shields.io/badge/Total%20views-1342-limegreen" alt="Total views">
  <p>Refresh Date: 2025-08-29</p>
</div>
<!-- END BADGE -->
