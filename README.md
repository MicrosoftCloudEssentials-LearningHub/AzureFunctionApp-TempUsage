# Azure Function App Infrastructure - Overview <br/> Runtime and Storage Insights (Temp Files)

Costa Rica

[![GitHub](https://badgen.net/badge/icon/github?icon=github&label)](https://github.com)
[![GitHub](https://img.shields.io/badge/--181717?logo=github&logoColor=ffffff)](https://github.com/)
[brown9804](https://github.com/brown9804)

Last updated: 2025-08-27

-----------------------------

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

</details>


<!-- START BADGE -->
<div align="center">
  <img src="https://img.shields.io/badge/Total%20views-42-limegreen" alt="Total views">
  <p>Refresh Date: 2025-09-05</p>
</div>
<!-- END BADGE -->
