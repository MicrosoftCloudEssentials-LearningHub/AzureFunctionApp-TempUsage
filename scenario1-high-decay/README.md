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
- [log levels types](https://learn.microsoft.com/en-us/azure/azure-functions/configure-monitoring?tabs=v2#configure-log-levels)
- [How to configure monitoring for Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/configure-monitoring?tabs=v2)
- [host.json reference for Azure Functions 2.x and later](https://learn.microsoft.com/en-us/azure/azure-functions/functions-host-json#override-hostjson-values)
- [Sampling overrides %](https://learn.microsoft.com/en-us/azure/azure-monitor/app/java-standalone-config#sampling-overrides)
- [Sampling in Azure Monitor Application Insights with OpenTelemetry](https://learn.microsoft.com/en-us/azure/azure-monitor/app/opentelemetry-sampling)

</details>

<details>
<summary><b>Table of content</b> (Click to expand)</summary>

- [Infrastructure Setup](#infrastructure-setup)
- [Deployment Instructions](#deployment-instructions)
- [Testing](#testing)
- [Monitoring](#monitoring)

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

    <img width="1908" height="842" alt="image" src="https://github.com/user-attachments/assets/fd5b96e4-be63-4319-b533-5c0fe18ec862" />

- **Deployment Method (Function App Environment Variables)**: Standard deployment (extracted .zip)

  ```terraform
  # Force standard deployment instead of mounted package
  "WEBSITE_RUN_FROM_PACKAGE" = "0"
  ```

    <img width="1903" height="842" alt="image" src="https://github.com/user-attachments/assets/412aeee4-3c7d-43b6-82ea-87050e30f4fe" />

- **Diagnostics Settings (Function App Environment Variables)**: Detailed diagnostics enabled

  ```terraform
  # Enable full diagnostics for troubleshooting
  "WEBSITE_ENABLE_DETAILED_DIAGNOSTICS" = "true"
  ```

    <img width="1917" height="796" alt="image" src="https://github.com/user-attachments/assets/bf8e1b7f-bc4a-4c1d-aced-e06f92df5185" />

- **Logging Configuration (Function App Environment Variables)**: Verbose logging enabled. Click here to understand more about [log levels types](https://learn.microsoft.com/en-us/azure/azure-functions/configure-monitoring?tabs=v2#configure-log-levels)

  ```terraform
  # Set verbose logging level for better diagnostics but higher disk usage
  "AzureFunctionsJobHost__logging__LogLevel__Default" = "Information"
  ```

    <img width="1898" height="828" alt="image" src="https://github.com/user-attachments/assets/6a10498c-fa5d-4e01-a392-0da31ae89cfb" />

- **SCM Separation (Function App Environment Variables)**: Enabled to ensure Kudu and function app run as separate processes

  ```terraform
  # Enable SCM separation for diagnostics
  "WEBSITE_DISABLE_SCM_SEPARATION" = "false"
  ```

    <img width="1907" height="842" alt="image" src="https://github.com/user-attachments/assets/d2128b76-38e1-4e3a-af3f-835db68b428f" />

- **Temp Access (Function App Environment Variables)**: Explicitly enabled for diagnostics and reporting

  ```terraform
  # Enable temp file access for diagnostics
  "WEBSITE_ENABLE_TEMP_ACCESS" = "true"
  ```

    <img width="1907" height="841" alt="image" src="https://github.com/user-attachments/assets/9fbb1211-5d5c-4356-b18f-deef61963150" />

> Overall:

<img width="973" height="825" alt="image" src="https://github.com/user-attachments/assets/4563a3f1-7168-4b86-b629-6210e99b8f90" />

- **Application Insights**: Full logging (no sampling). Click here to understand more about [Sampling overrides %](https://learn.microsoft.com/en-us/azure/azure-monitor/app/java-standalone-config#sampling-overrides)

  ```terraform
  # No sampling configured - full logging
  sampling_percentage = 100
  ```

  <img width="1903" height="837" alt="image" src="https://github.com/user-attachments/assets/24197ef8-b302-480e-825b-4ddb34e18598" />

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
  <img src="https://img.shields.io/badge/Total%20views-1403-limegreen" alt="Total views">
  <p>Refresh Date: 2025-09-05</p>
</div>
<!-- END BADGE -->
