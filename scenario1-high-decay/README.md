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

  > `WEBSITE_RUN_FROM_PACKAGE = 0` means your app is deployed by extracting files from a zip package, rather than mounting the zip directly. `Extracted deployments allow your app to write to its local disk (such as C:\local\Temp), which is essential for scenarios testing temp file accumulation.`

  ```terraform
  # Force standard deployment instead of mounted package
  "WEBSITE_RUN_FROM_PACKAGE" = "0"
  ```

    <img width="1903" height="842" alt="image" src="https://github.com/user-attachments/assets/412aeee4-3c7d-43b6-82ea-87050e30f4fe" />

- **Diagnostics Settings (Function App Environment Variables)**: Detailed diagnostics enabled

  > This enables verbose diagnostics for the Function App, assisting in troubleshooting. `More detailed logs make it easier to observe how temp files accumulate and to identify issues.`

  ```terraform
  # Enable full diagnostics for troubleshooting
  "WEBSITE_ENABLE_DETAILED_DIAGNOSTICS" = "true"
  ```

    <img width="1917" height="796" alt="image" src="https://github.com/user-attachments/assets/bf8e1b7f-bc4a-4c1d-aced-e06f92df5185" />

- **Logging Configuration (Function App Environment Variables)**: Verbose logging enabled. Click here to understand more about [log levels types](https://learn.microsoft.com/en-us/azure/azure-functions/configure-monitoring?tabs=v2#configure-log-levels)

  > Sets the default logging level (e.g., “Information”) for the Azure Functions host. `Higher verbosity (like “Information” or “Verbose”) increases disk usage due to more logs being written, which is relevant for stress-testing disk decay.`

  ```terraform
  # Set verbose logging level for better diagnostics but higher disk usage
  "AzureFunctionsJobHost__logging__LogLevel__Default" = "Information"
  ```

    <img width="1898" height="828" alt="image" src="https://github.com/user-attachments/assets/6a10498c-fa5d-4e01-a392-0da31ae89cfb" />

- **SCM Separation (Function App Environment Variables)**: Enabled to ensure Kudu and function app run as separate processes

  > SCM stands for Source Control Management. In Azure, SCM refers to the Kudu service, which is the advanced tool behind deployments and diagnostics. When SCM Separation is enabled (WEBSITE_DISABLE_SCM_SEPARATION=false), the Kudu (SCM) site runs in a separate process from the main Function App. Separation improves security and stability, ensuring that debugging or diagnostic actions via Kudu do not interfere with the running Function App.

  ```terraform
  # Enable SCM separation for diagnostics
  "WEBSITE_DISABLE_SCM_SEPARATION" = "false"
  ```

    <img width="1907" height="842" alt="image" src="https://github.com/user-attachments/assets/d2128b76-38e1-4e3a-af3f-835db68b428f" />

- **Temp Access (Function App Environment Variables)**: Explicitly enabled for diagnostics and reporting

  > Explicitly allows the Function App to access and write to the temp directory on the server. Necessary for scenarios where you want to observe temp file build-up or diagnose disk usage issues.

  ```terraform
  # Enable temp file access for diagnostics
  "WEBSITE_ENABLE_TEMP_ACCESS" = "true"
  ```

    <img width="1907" height="841" alt="image" src="https://github.com/user-attachments/assets/9fbb1211-5d5c-4356-b18f-deef61963150" />

> Overall:

<img width="973" height="825" alt="image" src="https://github.com/user-attachments/assets/4563a3f1-7168-4b86-b629-6210e99b8f90" />

- **Application Insights**: Full logging (no sampling). Click here to understand more about [Sampling overrides %](https://learn.microsoft.com/en-us/azure/azure-monitor/app/java-standalone-config#sampling-overrides)

  > Sampling reduces the volume of telemetry data sent to Application Insights. Setting sampling_percentage = 100 means no sampling, so all logs/events are recorded. `Full logging provides the most complete diagnostics but increases disk and network usage.`

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
  <img src="https://img.shields.io/badge/Total%20views-1325-limegreen" alt="Total views">
  <p>Refresh Date: 2025-10-01</p>
</div>
<!-- END BADGE -->
