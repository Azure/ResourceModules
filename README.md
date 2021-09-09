# ![AzureIcon] Modules

This repository consists of a collection of compliant [Azure Resource Manager (ARM)][AzureResourceManager] and [Bicep][Bicep] templates as well as supporting [template specs][TemplateSpecs].

## Description

This library of **Modules** ensures organizations can deploy compliant Azure services aligned with the proactive and preventive policies provided by [Enterprise-Scale landing zones (ESLZ)][ESLZ], aligned with [Azure Security Benchmark][AzureSecurityBenchmark].

> This repository serves ***currently*** as a temporary extension and **active** development site for [ESLZ Workload Templates library][ESLZWorkloadTemplatesLibrary].
## Status

<a href="https://github.com/Azure/Modules/actions/workflows/linter.yml">
  <img alt="Super Linter" src="https://github.com/Azure/Modules/actions/workflows/linter.yml/badge.svg" />
</a>
<a href="https://github.com/Azure/Modules/issues">
  <img alt="Issues" src="https://img.shields.io/github/issues/Azure/Modules?color=0088ff" />
</a>
<a href="https://github.com/Azure/Modules/pulls">
  <img alt="Pull requests" src="https://img.shields.io/github/issues-pr/Azure/Modules?color=0088ff" />
</a>

## Get started

* For introduction guidance visit the [Wiki](https://github.com/azure/Modules/wiki)
* For reference documentation visit [Enterprise-Scale](https://github.com/azure/enterprise-scale)
* For information on contributing, see [Contribution](<https://github.com/Azure/Modules/wiki#contributing>)
* File an issue via [GitHub Issues](https://github.com/azure/Modules/issues/new/choose)

## Available modules
| Name | ARM / Bicep | Deploy |
| - | - | - |
| Action Group | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Insights%5cactionGroups%2fdeploy.json>) |
| Activity Log Alert | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Insights%5cactivityLogAlerts%2fdeploy.json>) |
| ActivityLog | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Insights%5cdiagnosticSettings%2fdeploy.json>) |
| Analysis Services | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.AnalysisServices%5cservers%2fdeploy.json>) |
| API Connection | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Web%5cconnections%2fdeploy.json>) |
| Api Management | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.ApiManagement%5cservice%2fdeploy.json>) |
| Api Management Service Apis | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.ApiManagement%5cserviceResources%5capis%2fdeploy.json>) |
| Api Management Service Authorization Servers | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.ApiManagement%5cserviceResources%5cauthorizationServers%2fdeploy.json>) |
| Api Management Service Backends | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.ApiManagement%5cserviceResources%5cbackends%2fdeploy.json>) |
| Api Management Service Cache | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.ApiManagement%5cserviceResources%5ccaches%2fdeploy.json>) |
| Api Management Service Named Values | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.ApiManagement%5cserviceResources%5cnamedValues%2fdeploy.json>) |
| Api Management Service Products | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.ApiManagement%5cserviceResources%5cproducts%2fdeploy.json>) |
| Api Management Subscriptions | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.ApiManagement%5cserviceResources%5csubscriptions%2fdeploy.json>) |
| App Service Environment | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Web%5chostingEnvironments%2fdeploy.json>) |
| App Services | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Web%5csites%5cappService%2fdeploy.json>) |
| Application Insights | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Insights%5ccomponents%2fdeploy.json>) |
| ApplicationGateway | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5capplicationGateways%2fdeploy.json>) |
| ApplicationSecurityGroups | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5capplicationSecurityGroups%2fdeploy.json>) |
| AppServicePlan | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Web%5cserverfarms%2fdeploy.json>) |
| AutoManage | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Automanage%5caccounts%2fdeploy.json>) |
| AutomationAccounts | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Automation%5cautomationAccounts%2fdeploy.json>) |
| Azure Databricks | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Databricks%5cworkspaces%2fdeploy.json>) |
| Azure Health Bot | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.HealthBot%5chealthBots%2fdeploy.json>) |
| Azure Monitor Private Link Scope | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Insights%5cprivateLinkScopes%2fdeploy.json>) |
| AzureBastion | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cbastionHosts%2fdeploy.json>) |
| AzureFirewall | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cazureFirewalls%2fdeploy.json>) |
| AzureKubernetesService | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.ContainerService%5cmanagedClusters%2fdeploy.json>) |
| AzureNetAppFiles | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.NetApp%5cnetAppAccounts%2fdeploy.json>) |
| AzureSecurityCenter | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Security%5cazureSecurityCenter%2fdeploy.json>) |
| AzureSQLDatabase | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Sql%5cserversResources%5cdatabases%2fdeploy.json>) |
| AzureSQLServer | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Sql%5cservers%2fdeploy.json>) |
| Batch Accounts | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Batch%5cbatchAccounts%2fdeploy.json>) |
| Budgets | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Consumption%5cbudgets%2fdeploy.json>) |
| CognitiveServices | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.CognitiveServices%5caccounts%2fdeploy.json>) |
| ContainerInstances | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.ContainerInstance%5ccontainerGroups%2fdeploy.json>) |
| ContainerRegistry | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.ContainerRegistry%5cregistries%2fdeploy.json>) |
| DataFactory | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.DataFactory%5cfactories%2fdeploy.json>) |
| DDoS Protection Plans | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cddosProtectionPlans%2fdeploy.json>) |
| Deployment Scripts | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Resources%5cdeploymentScripts%2fdeploy.json>) |
| DiskEncryptionSet | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Compute%5cdiskEncryptionSets%2fdeploy.json>) |
| Event Grid | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.EventGrid%5ctopics%2fdeploy.json>) |
| EventHub Namespaces | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.EventHub%5cnamespaces%2fdeploy.json>) |
| EventHubs | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.EventHub%5cnamespacesResources%5ceventhubs%2fdeploy.json>) |
| ExpressRoute Circuit | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cexpressRouteCircuits%2fdeploy.json>) |
| FunctionApp | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Web%5csites%5cfunctionApp%2fdeploy.json>) |
| Image | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Compute%5cimages%2fdeploy.json>) |
| Image Templates | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.VirtualMachineImages%5cimageTemplates%2fdeploy.json>) |
| IP Groups | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cipGroups%2fdeploy.json>) |
| KeyVault | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.KeyVault%5cvaults%2fdeploy.json>) |
| Lighthouse | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.ManagedServices%5cregistrationDefinitions%2fdeploy.json>) |
| LoadBalancer | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cloadBalancers%2fdeploy.json>) |
| Local Network Gateway | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5clocalNetworkGateways%2fdeploy.json>) |
| LogAnalytics | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.OperationalInsights%5cworkspaces%2fdeploy.json>) |
| Machine Learning Services | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.MachineLearningServices%5cworkspaces%2fdeploy.json>) |
| Management groups | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Management%5cmanagementGroups%2fdeploy.json>) |
| Metric Alert | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Insights%5cmetricAlerts%2fdeploy.json>) |
| NAT Gateway | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cnatGateways%2fdeploy.json>) |
| Network Watcher | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cnetworkWatchers%2fdeploy.json>) |
| NetworkSecurityGroups | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cnetworkSecurityGroups%2fdeploy.json>) |
| NSG Flow Logs | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cnetworkWatcherFlowLogs%2fdeploy.json>) |
| PolicyAssignment | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Authorization%5cpolicyAssignments%2fdeploy.json>) |
| PrivateDnsZones | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cprivateDnsZones%2fdeploy.json>) |
| PrivateEndpoints | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cprivateEndpoints%2fdeploy.json>) |
| Public IP Addresses | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cpublicIPAddresses%2fdeploy.json>) |
| Public IP Prefixes | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cpublicIPPrefixes%2fdeploy.json>) |
| RecoveryServicesVaults | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.RecoveryServices%5cvaults%2fdeploy.json>) |
| Resource Group | :heavy_check_mark:/:heavy_check_mark: | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Resources%5cresourceGroups%2fdeploy.json>) |
| Role Assignments | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Authorization%5croleAssignments%2fdeploy.json>) |
| Role Definitions | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Authorization%5croleDefinitions%2fdeploy.json>) |
| RouteTables | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5crouteTables%2fdeploy.json>) |
| Scheduled Query Rules | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Insights%5cscheduledQueryRules%2fdeploy.json>) |
| ServiceBusNamespaces | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.ServiceBus%5cnamespaces%2fdeploy.json>) |
| ServiceBusQueues | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.ServiceBus%5cnamespacesResources%5cqueues%2fdeploy.json>) |
| Shared Image Definition | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Compute%5cgalleriesResources%5cimages%2fdeploy.json>) |
| Shared Image Gallery | :heavy_check_mark:/:heavy_check_mark: | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Compute%5cgalleries%2fdeploy.json>) |
| Software Update Configuration | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Automation%5cautomationAccountsResources%5csoftwareUpdateConfigurations%2fdeploy.json>) |
| SQL Managed Instances | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Sql%5cmanagedInstances%2fdeploy.json>) |
| SQL Managed Instances Database | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Sql%5cmanagedInstancesResources%5cdatabases%2fdeploy.json>) |
| StorageAccounts | :heavy_check_mark:/:heavy_check_mark: | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Storage%5cstorageAccounts%2fdeploy.json>) |
| Subscription | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Subscription%5caliases%2fdeploy.json>) |
| TrafficManager | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5ctrafficmanagerprofiles%2fdeploy.json>) |
| User Assigned Identities | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.ManagedIdentity%5cuserAssignedIdentities%2fdeploy.json>) |
| Virtual Machine Scale Sets | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Compute%5cvirtualMachineScaleSets%2fdeploy.json>) |
| Virtual Machines | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Compute%5cvirtualMachines%2fdeploy.json>) |
| Virtual Network | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cvirtualNetworks%2fdeploy.json>) |
| Virtual Wan | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cvirtualWans%2fdeploy.json>) |
| VirtualNetworkGateway | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cvirtualNetworkGateways%2fdeploy.json>) |
| VirtualNetworkGatewayConnection | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cconnections%2fdeploy.json>) |
| VirtualNetworkPeering | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Network%5cvirtualNetworkPeerings%2fdeploy.json>) |
| WebApp | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.Web%5csites%5cwebApp%2fdeploy.json>) |
| WVD Application Groups | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.DesktopVirtualization%5capplicationgroups%2fdeploy.json>) |
| WVD Applications | :heavy_check_mark:/:heavy_check_mark: | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.DesktopVirtualization%5capplicationGroupsResources%5capplications%2fdeploy.json>) |
| WVD HostPools | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.DesktopVirtualization%5chostpools%2fdeploy.json>) |
| WVD Workspaces | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.DesktopVirtualization%5cworkspaces%2fdeploy.json>) |
| WvdScaling Scheduler | :heavy_check_mark:/ | [![Deploy to Azure](/docs/media/deploytoazure.svg?sanitize=true)](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fAzure%2fModules%2fmain%2farm%5cMicrosoft.DesktopVirtualization%5cwvdScalingScheduler%2fdeploy.json>) |

<!-- ## Contributors

Contributors names and contact info

* [@segraef](<https://twitter.com/segraef>)

-->

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.

## Learn More

* [PowerShell Documentation][PowerShellDocs]
* [Microsoft Azure Documentation][MicrosoftAzureDocs]
* [GitHubDocs][GitHubDocs]
* [Azure Resource Manager][AzureResourceManager]
* [Bicep][Bicep]

<!-- References -->

<!-- Local -->
[Wiki]: <https://github.com/Azure/Modules/wiki>
[ProjectSetup]: <https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions>
[GitHubDocs]: <https://docs.github.com/>
[AzureDevOpsDocs]: <https://docs.microsoft.com/en-us/azure/devops/?view=azure-devops>
[GitHubIssues]: <https://github.com/Azure/Modules/issues>
[Contributing]: CONTRIBUTING.md
[AzureIcon]: docs/media/MicrosoftAzure-32px.png
[PowershellIcon]: docs/media/MicrosoftPowerShellCore-32px.png
[BashIcon]: docs/media/Bash_Logo_black_and_white_icon_only-32px.svg.png

<!-- External -->
[Bicep]: <https://github.com/Azure/bicep>
[Az]: <https://img.shields.io/powershellgallery/v/Az.svg?style=flat-square&label=Az>
[AzGallery]: <https://www.powershellgallery.com/packages/Az/>
[PowerShellCore]: <https://github.com/PowerShell/PowerShell/releases/latest>
[InstallAzPs]: <https://docs.microsoft.com/en-us/powershell/azure/install-az-ps>
[AzureResourceManager]: <https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview>
[TemplateSpecs]: <https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs>

[ESLZ]: <https://github.com/Azure/Enterprise-Scale>
[AzureSecurityBenchmark]: <https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/security-governance-and-compliance#azure-security-benchmark>
[ESLZWorkloadTemplatesLibrary]: <https://github.com/Azure/Enterprise-Scale/tree/main/workloads>

<!-- Docs -->
[MicrosoftAzureDocs]: <https://docs.microsoft.com/en-us/azure/>
[PowerShellDocs]: <https://docs.microsoft.com/en-us/powershell/>