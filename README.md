# Azure Function App Infrastructure - Overview <br/> Runtime and Storage Insights (Temp Files)

Costa Rica

[![GitHub](https://badgen.net/badge/icon/github?icon=github&label)](https://github.com)
[![GitHub](https://img.shields.io/badge/--181717?logo=github&logoColor=ffffff)](https://github.com/)
[brown9804](https://github.com/brown9804)

Last updated: 2025-08-27

-----------------------------

> Contains two scenarios to compare temp file decay behavior in Azure Functions. The goal is to demonstrate how different configuration and coding practices affect temporary file accumulation and disk usage.

> [!IMPORTANT]
> Overview about how Azure Function Apps operate within App Service infrastructure, focusing on temp file creation, storage, and management. Runtime behavior, deployment impact, and optimization strategies. For official guidance, support, or more detailed information, please refer to Microsoft's official documentation or contact Microsoft directly: [Microsoft Sales and Support](https://support.microsoft.com/contactus?ContactUsExperienceEntryPointAssetId=S.HP.SMC-HOME)

<details>
<summary><b>List of References</b> (Click to expand)</summary>
  
- [Kudu service overview](https://learn.microsoft.com/en-us/azure/app-service/resources-kudu)
- [log levels types](https://learn.microsoft.com/en-us/azure/azure-functions/configure-monitoring?tabs=v2#configure-log-levels)
- [How to configure monitoring for Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/configure-monitoring?tabs=v2)
- [host.json reference for Azure Functions 2.x and later](https://learn.microsoft.com/en-us/azure/azure-functions/functions-host-json#override-hostjson-values)
- [Sampling overrides %](https://learn.microsoft.com/en-us/azure/azure-monitor/app/java-standalone-config#sampling-overrides)
- [Sampling in Azure Monitor Application Insights with OpenTelemetry](https://learn.microsoft.com/en-us/azure/azure-monitor/app/opentelemetry-sampling)
- [Azure Functions deployment technologies](https://learn.microsoft.com/en-us/azure/azure-functions/functions-deployment-technologies)
- [Run your Azure Functions from a package file](https://learn.microsoft.com/en-us/azure/azure-functions/run-functions-from-deployment-package)
- [Continuous delivery by using Azure DevOps](https://learn.microsoft.com/en-us/azure/azure-functions/functions-continuous-deployment)
- [Continuous delivery by using GitHub Actions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-how-to-github-actions)
- [Best practices for reliable Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-best-practices)
- [Improve the performance and reliability of Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/performance-reliability)

</details>

## Scenarios

1. [High Decay test](./scenario1-high-decay): Test rapid temp file accumulation and disk decay
2. Recommendations for [Optimized configuration](./scenario2-optimized): Test how to minimize temp file accumulation
   
## How to Compare Results

> When deployed, two scenarios were compared by:

1. Monitoring disk usage in Kudu (`https://<function-app-name>.scm.azurewebsites.net/DebugConsole`)
2. Running load tests against both function apps
3. Observing memory usage and response times
4. Checking temp directories for file accumulation

## Deployment Approaches

> Each scenario includes detailed deployment guides that explain different approaches:

1. High-Decay (Writable Approach), click here for [quick deployment guide](./scenario1-high-decay/DEPLOYMENT.md)
    - **Deployment Method**: Standard deployment (extracted to wwwroot)
    - **File Access**: Files are writable by the Function App
    - **Pipelines**: Azure DevOps pipeline with standard deployment

2. Optimized (Mounted Package Approach), click here for [quick deployment guide](./scenario2-optimized/DEPLOYMENT.md)
    - **Deployment Method**: ZipDeploy with `WEBSITE_RUN_FROM_PACKAGE=1`
    - **File Access**: Files are read-only (mounted from zip)
    - **Pipelines**: Azure DevOps pipeline with ZipDeploy or GitHub Actions workflow

<!-- START BADGE -->
<div align="center">
  <img src="https://img.shields.io/badge/Total%20views-42-limegreen" alt="Total views">
  <p>Refresh Date: 2025-09-05</p>
</div>
<!-- END BADGE -->
