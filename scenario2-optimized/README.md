# Scenario 2 - Overview <br/> Optimized Mounted Deployment with Minimal Disk Write Access

Costa Rica

[![GitHub](https://badgen.net/badge/icon/github?icon=github&label)](https://github.com)
[![GitHub](https://img.shields.io/badge/--181717?logo=github&logoColor=ffffff)](https://github.com/)
[brown9804](https://github.com/brown9804)

Last updated: 2025-09-05

-----------------------------

> This scenario is designed to test minimal temp file creation and stable disk usage in Azure Functions.

<details>
<summary><b>List of References</b> (Click to expand)</summary>
  
- [Kudu service overview](https://learn.microsoft.com/en-us/azure/app-service/resources-kudu)
- [Run from package](https://learn.microsoft.com/en-us/azure/app-service/deploy-run-package)
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
> - Minimal temp file creation <br/>
> - Disk usage remains stable over time <br/>
> - Restart not required for cleanup 

## Infrastructure Setup

- **App Service Plan (Windows)** - P1v3 tier for high-load testing

  ```terraform
  # Service Plan  
  sku_name            = "P1v3"    
  ```

    <img width="1908" height="842" alt="image" src="" />

- **Deployment Method (Function App Environment Variables)**: ZipDeploy with mounted package

  ```terraform
  # Use mounted package deployment for optimized disk usage
  "WEBSITE_RUN_FROM_PACKAGE" = "1"
  ```

    <img width="1903" height="842" alt="image" src="" />

- **Diagnostics Settings (Function App Environment Variables)**: Minimal diagnostics enabled

  ```terraform
  # Disable detailed diagnostics for better performance
  "WEBSITE_ENABLE_DETAILED_DIAGNOSTICS" = "false"
  ```

    <img width="1917" height="796" alt="image" src="" />

- **Logging Configuration (Function App Environment Variables)**: Minimal logging enabled. Click here to understand more about [log levels types](https://learn.microsoft.com/en-us/azure/azure-functions/configure-monitoring?tabs=v2#configure-log-levels)

  ```terraform
  # Set minimal logging
  "AzureFunctionsJobHost__logging__LogLevel__Default" = "Warning"
  ```

    <img width="1898" height="828" alt="image" src="" />

- **SCM Separation (Function App Environment Variables)**: Disabled for better performance

  ```terraform
  # Disable SCM separation for better performance
  "WEBSITE_DISABLE_SCM_SEPARATION" = "true"
  ```

    <img width="1907" height="842" alt="image" src="" />

- **Temp Access (Function App Environment Variables)**: Explicitly disabled for better performance

  ```terraform
  # Disable temp file access for better performance
  "WEBSITE_ENABLE_TEMP_ACCESS" = "false"
  ```

    <img width="1907" height="841" alt="image" src="" />

> Overall:

<img width="973" height="825" alt="image" src="" />

- **Application Insights**: Sampling enabled (5%). Click here to understand more about [Sampling overrides %](https://learn.microsoft.com/en-us/azure/azure-monitor/app/java-standalone-config#sampling-overrides)

  ```terraform
  # Enable sampling - optimized for low disk usage
  sampling_percentage = 5
  ```

  <img width="1903" height="837" alt="image" src="" />

- **Key Vault Integration**: Secrets stored in Azure Key Vault with auto-generated credentials
- **Managed Identity**: System-assigned identity for Key Vault and Storage access

## Deployment Instructions

1. Please follow the [Terraform Deployment guide](./terraform-infrastructure/README.md) to deploy the necessary Azure resources for the workshop.
2. After infrastructure deployment, follow the deployment approaches in [DEPLOYMENT.md](./DEPLOYMENT.md) to publish the function app using the mounted package approach.

## Testing

> The function app includes HTTP triggers that can be used to test disk usage under load. Use tools like Apache JMeter or Azure Load Testing to simulate concurrent users.

## Monitoring

> Monitor the function app using:

- Azure Portal > Function App > Development Tools > Advanced tools ([Kudu](https://learn.microsoft.com/en-us/azure/app-service/resources-kudu))



- Application Insights
- Azure Monitor metrics

<!-- START BADGE -->
<div align="center">
  <img src="https://img.shields.io/badge/Total%20views-865-limegreen" alt="Total views">
  <p>Refresh Date: 2025-09-05</p>
</div>
<!-- END BADGE -->
