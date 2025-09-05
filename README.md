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
- [Accessing the kudu service](https://github.com/projectkudu/kudu/wiki/Accessing-the-kudu-service) - GitHub repo
- [Understanding the Azure App Service file system](https://github.com/projectkudu/kudu/wiki/Understanding-the-Azure-App-Service-file-system#temporary-files) - GitHub repo

</details>

<details>
<summary><b>Table of Content</b> (Click to expand)</summary>

- [Scenarios](#scenarios)
- [How to Compare Results](#how-to-compare-results)
- [Deployment Approaches](#deployment-approaches)
    - [High-Decay ](#high-decay-writable-approach) - `Writable Approach + Configs`
    - [Optimized](#optimized-mounted-package-approach) - `Mounted Package Approach + Configs`

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

1. [High-Decay](./scenario1-high-decay) (Writable Approach), click here for [quick deployment guide](./scenario1-high-decay/DEPLOYMENT.md)
2. [Optimized](./scenario2-optimized) (Mounted Package Approach), click here for [quick deployment guide](./scenario2-optimized/DEPLOYMENT.md)

###  High-Decay (Writable Approach)

> The combination of writable deployment, intensive logging, and full diagnostics causes Azure Functions to generate and buffer a large amount of telemetry and log data in local temp storage. This leads to rapid disk usage growth, temp file accumulation, and eventual disk decay. Click here to go to [High-Decay](./scenario1-high-decay) test approach

- **Deployment Method**: Standard deployment (extracted to wwwroot)
- **File Access**: Files are writable by the Function App
- **Pipelines**: Azure DevOps pipeline with standard deployment

> [!IMPORTANT]
> Overall, the problem with standard/writable deployment with intensive logging:
> - **Intensive logging and diagnostics** (full Application Insights, detailed diagnostics, verbose log level) generate a large volume of log and telemetry data.
> - **Writable deployment** (`WEBSITE_RUN_FROM_PACKAGE = 0`) means the function app runs from extracted files in `wwwroot`, allowing the app and platform to write files locally.
> - **Azure Functions and the platform buffer logs, telemetry, and temp files in the local file system**, specifically under `C:\local\Temp` and `D:\local\Temp` (on Windows plans).
> - **Telemetry and diagnostic logs are first written to local temp storage** before being sent to Application Insights or other destinations.
> - **High load and verbose logging** cause rapid accumulation of files in these temp directories.
> - **Disk usage grows over time** as temp files, logs, and telemetry buffers accumulate, especially if the app is under sustained or bursty load.
> - **Some files may remain locked or not be cleaned up automatically**, even after a function app restart, leading to "disk decay" (progressive loss of available disk space).
> - **Performance degrades** as disk fills up, and the app may eventually fail if the temp storage is exhausted.

### Optimized (Mounted Package Approach):

> The combination of mounted (read-only) deployment, optimized logging, and minimal diagnostics causes Azure Functions to generate and buffer very little telemetry and log data in local temp storage. This prevents disk usage from growing, avoids temp file accumulation, and eliminates disk decay. Click here to go to [Optimized](./scenario2-optimized) test approach

- **Deployment Method**: ZipDeploy with `WEBSITE_RUN_FROM_PACKAGE=1`
- **File Access**: Files are read-only (mounted from zip)
- **Pipelines**: Azure DevOps pipeline with ZipDeploy or GitHub Actions workflow

> [!IMPORTANT]
> **Overall, the benefit with optimized (mounted) deployment and minimal logging:**
> - **Minimal logging and diagnostics** (Application Insights with sampling, reduced diagnostics, less verbose log level) generate far less log and telemetry data.
> - **Mounted deployment** (`WEBSITE_RUN_FROM_PACKAGE = 1`) means the function app runs from a read-only mounted package, preventing the app and platform from writing files to `wwwroot`.
> - **Azure Functions and the platform buffer far fewer logs and temp files in the local file system**, reducing writes to `C:\local\Temp` and `D:\local\Temp`.
> - **Telemetry and diagnostic logs are sampled and sent directly to Application Insights or other destinations,** with minimal local buffering.
> - **Even under high load, temp file accumulation is negligible** because the app and platform cannot write to the mounted package and logging is optimized.
> - **Disk usage remains stable over time** as temp files, logs, and telemetry buffers are minimized and cleaned up efficiently.
> - **Restarts are rarely needed** for disk cleanup, and locked files are uncommon.
> - **Performance remains consistent** even under sustained load, as disk space is preserved and temp file decay is prevented.


<!-- START BADGE -->
<div align="center">
  <img src="https://img.shields.io/badge/Total%20views-1403-limegreen" alt="Total views">
  <p>Refresh Date: 2025-09-05</p>
</div>
<!-- END BADGE -->
