In this section you can find useful information regarding the Modules that are contained in this repository.

# Available Modules
The following table provides you with an outline of all Modules that are currently available for use. Several sub-resources may be their own Modules and are hence displayed as a child path (e.g. `service/caches`).

| Resource provider namespace | Resource Name | Azure service | ARM | Bicep |
| --------------------------- | ------------- | ------------- | --- | ----- |
| `Microsoft.AnalysisServices` |  Analysis Services |[servers](Microsoft.AnalysisServices/servers) | :heavy_check_mark: | |
| `Microsoft.ApiManagement` |  Api Management |[service](Microsoft.ApiManagement/service) | :heavy_check_mark: | |
| | Api Management Service Apis | [service/apis](Microsoft.ApiManagement/serviceResources/apis) | :heavy_check_mark: | |
| | Api Management Service Authorization Servers | [service/authorizationServers](Microsoft.ApiManagement/serviceResources/authorizationServers) | :heavy_check_mark: | |
| | Api Management Service Backends | [service/backends](Microsoft.ApiManagement/serviceResources/backends) | :heavy_check_mark: | |
| | Api Management Service Cache | [service/caches](Microsoft.ApiManagement/serviceResources/caches) | :heavy_check_mark: | |
| | Api Management Service Named Values | [service/namedValues](Microsoft.ApiManagement/serviceResources/namedValues) | :heavy_check_mark: | |
| | Api Management Service Products | [service/products](Microsoft.ApiManagement/serviceResources/products) | :heavy_check_mark: | |
| | Api Management Subscriptions | [service/subscriptions](Microsoft.ApiManagement/serviceResources/subscriptions) | :heavy_check_mark: | |
| `Microsoft.Authorization` |  PolicyAssignment |[policyAssignments](Microsoft.Authorization/policyAssignments) | :heavy_check_mark: | |
| |  Role Assignments |[roleAssignments](Microsoft.Authorization/roleAssignments) | :heavy_check_mark: | |
| |  Role Definitions |[roleDefinitions](Microsoft.Authorization/roleDefinitions) | :heavy_check_mark: | |
| `Microsoft.Automanage` |  AutoManage |[accounts](Microsoft.Automanage/accounts) | :heavy_check_mark: | |
| `Microsoft.Automation` |  AutomationAccounts |[automationAccounts](Microsoft.Automation/automationAccounts) | :heavy_check_mark: | |
| | Software Update Configuration | [automationAccounts/softwareUpdateConfigurations](Microsoft.Automation/automationAccountsResources/softwareUpdateConfigurations) | :heavy_check_mark: | |
| `Microsoft.Batch` |  Batch Accounts |[batchAccounts](Microsoft.Batch/batchAccounts) | :heavy_check_mark: | |
| `Microsoft.CognitiveServices` |  CognitiveServices |[accounts](Microsoft.CognitiveServices/accounts) | :heavy_check_mark: | |
| `Microsoft.Compute` |  DiskEncryptionSet |[diskEncryptionSets](Microsoft.Compute/diskEncryptionSets) | :heavy_check_mark: | |
| |  Shared Image Gallery |[galleries](Microsoft.Compute/galleries) | :heavy_check_mark: | :heavy_check_mark: |
| | Shared Image Definition | [galleries/images](Microsoft.Compute/galleriesResources/images) | :heavy_check_mark: | |
| |  Image |[images](Microsoft.Compute/images) | :heavy_check_mark: | |
| |  Virtual Machines |[virtualMachines](Microsoft.Compute/virtualMachines) | :heavy_check_mark: | |
| |  Virtual Machine Scale Sets |[virtualMachineScaleSets](Microsoft.Compute/virtualMachineScaleSets) | :heavy_check_mark: | |
| `Microsoft.Consumption` |  Budgets |[budgets](Microsoft.Consumption/budgets) | :heavy_check_mark: | |
| `Microsoft.ContainerInstance` |  ContainerInstances |[containerGroups](Microsoft.ContainerInstance/containerGroups) | :heavy_check_mark: | |
| `Microsoft.ContainerRegistry` |  ContainerRegistry |[registries](Microsoft.ContainerRegistry/registries) | :heavy_check_mark: | |
| `Microsoft.ContainerService` |  AzureKubernetesService |[managedClusters](Microsoft.ContainerService/managedClusters) | :heavy_check_mark: | |
| `Microsoft.Databricks` |  Azure Databricks |[workspaces](Microsoft.Databricks/workspaces) | :heavy_check_mark: | |
| `Microsoft.DataFactory` |  DataFactory |[factories](Microsoft.DataFactory/factories) | :heavy_check_mark: | |
| `Microsoft.DesktopVirtualization` |  WVD Application Groups |[applicationgroups](Microsoft.DesktopVirtualization/applicationgroups) | :heavy_check_mark: | |
| | WVD Applications | [applicationGroups/applications](Microsoft.DesktopVirtualization/applicationGroupsResources/applications) | :heavy_check_mark: | :heavy_check_mark: |
| |  WVD HostPools |[hostpools](Microsoft.DesktopVirtualization/hostpools) | :heavy_check_mark: | |
| |  WVD Workspaces |[workspaces](Microsoft.DesktopVirtualization/workspaces) | :heavy_check_mark: | |
| |  WvdScaling Scheduler |[wvdScalingScheduler](Microsoft.DesktopVirtualization/wvdScalingScheduler) | :heavy_check_mark: | |
| `Microsoft.EventGrid` |  Event Grid |[topics](Microsoft.EventGrid/topics) | :heavy_check_mark: | |
| `Microsoft.EventHub` |  EventHub Namespaces |[namespaces](Microsoft.EventHub/namespaces) | :heavy_check_mark: | |
| | EventHubs | [namespaces/eventhubs](Microsoft.EventHub/namespacesResources/eventhubs) | :heavy_check_mark: | |
| `Microsoft.HealthBot` |  Azure Health Bot |[healthBots](Microsoft.HealthBot/healthBots) | :heavy_check_mark: | |
| `Microsoft.Insights` |  Action Group |[actionGroups](Microsoft.Insights/actionGroups) | :heavy_check_mark: | |
| |  Activity Log Alert |[activityLogAlerts](Microsoft.Insights/activityLogAlerts) | :heavy_check_mark: | |
| |  Application Insights |[components](Microsoft.Insights/components) | :heavy_check_mark: | |
| |  ActivityLog |[diagnosticSettings](Microsoft.Insights/diagnosticSettings) | :heavy_check_mark: | |
| |  Metric Alert |[metricAlerts](Microsoft.Insights/metricAlerts) | :heavy_check_mark: | |
| |  Azure Monitor Private Link Scope |[privateLinkScopes](Microsoft.Insights/privateLinkScopes) | :heavy_check_mark: | |
| |  Scheduled Query Rules |[scheduledQueryRules](Microsoft.Insights/scheduledQueryRules) | :heavy_check_mark: | |
| `Microsoft.KeyVault` |  KeyVault |[vaults](Microsoft.KeyVault/vaults) | :heavy_check_mark: | |
| `Microsoft.MachineLearningServices` |  Machine Learning Services |[workspaces](Microsoft.MachineLearningServices/workspaces) | :heavy_check_mark: | |
| `Microsoft.ManagedIdentity` |  User Assigned Identities |[userAssignedIdentities](Microsoft.ManagedIdentity/userAssignedIdentities) | :heavy_check_mark: | |
| `Microsoft.ManagedServices` |  Lighthouse |[registrationDefinitions](Microsoft.ManagedServices/registrationDefinitions) | :heavy_check_mark: | |
| `Microsoft.Management` |  Management groups |[managementGroups](Microsoft.Management/managementGroups) | :heavy_check_mark: | |
| `Microsoft.NetApp` |  AzureNetAppFiles |[netAppAccounts](Microsoft.NetApp/netAppAccounts) | :heavy_check_mark: | |
| `Microsoft.Network` |  ApplicationGateway |[applicationGateways](Microsoft.Network/applicationGateways) | :heavy_check_mark: | |
| |  ApplicationSecurityGroups |[applicationSecurityGroups](Microsoft.Network/applicationSecurityGroups) | :heavy_check_mark: | |
| |  AzureFirewall |[azureFirewalls](Microsoft.Network/azureFirewalls) | :heavy_check_mark: | |
| |  AzureBastion |[bastionHosts](Microsoft.Network/bastionHosts) | :heavy_check_mark: | |
| |  VirtualNetworkGatewayConnection |[connections](Microsoft.Network/connections) | :heavy_check_mark: | |
| |  DDoS Protection Plans |[ddosProtectionPlans](Microsoft.Network/ddosProtectionPlans) | :heavy_check_mark: | |
| |  ExpressRoute Circuit |[expressRouteCircuits](Microsoft.Network/expressRouteCircuits) | :heavy_check_mark: | |
| |  KeyVault |[ipGroups](Microsoft.Network/ipGroups) | :heavy_check_mark: | |
| |  LoadBalancer |[loadBalancers](Microsoft.Network/loadBalancers) | :heavy_check_mark: | |
| |  Local Network Gateway |[localNetworkGateways](Microsoft.Network/localNetworkGateways) | :heavy_check_mark: | |
| |  NAT Gateway |[natGateways](Microsoft.Network/natGateways) | :heavy_check_mark: | |
| |  NetworkSecurityGroups |[networkSecurityGroups](Microsoft.Network/networkSecurityGroups) | :heavy_check_mark: | |
| |  NSG Flow Logs |[networkWatcherFlowLogs](Microsoft.Network/networkWatcherFlowLogs) | :heavy_check_mark: | |
| |  Network Watcher |[networkWatchers](Microsoft.Network/networkWatchers) | :heavy_check_mark: | |
| |  PrivateDnsZones |[privateDnsZones](Microsoft.Network/privateDnsZones) | :heavy_check_mark: | |
| |  PrivateEndpoints |[privateEndpoints](Microsoft.Network/privateEndpoints) | :heavy_check_mark: | |
| |  Public IP Addresses |[publicIPAddresses](Microsoft.Network/publicIPAddresses) | :heavy_check_mark: | |
| |  Public IP Prefixes |[publicIPPrefixes](Microsoft.Network/publicIPPrefixes) | :heavy_check_mark: | |
| |  RouteTables |[routeTables](Microsoft.Network/routeTables) | :heavy_check_mark: | |
| |  TrafficManager |[trafficmanagerprofiles](Microsoft.Network/trafficmanagerprofiles) | :heavy_check_mark: | |
| |  VirtualNetworkGateway |[virtualNetworkGateways](Microsoft.Network/virtualNetworkGateways) | :heavy_check_mark: | |
| |  VirtualNetworkPeering |[virtualNetworkPeerings](Microsoft.Network/virtualNetworkPeerings) | :heavy_check_mark: | |
| |  Virtual Network |[virtualNetworks](Microsoft.Network/virtualNetworks) | :heavy_check_mark: | |
| |  Virtual Wan |[virtualWans](Microsoft.Network/virtualWans) | :heavy_check_mark: | |
| `Microsoft.OperationalInsights` |  LogAnalytics |[workspaces](Microsoft.OperationalInsights/workspaces) | :heavy_check_mark: | |
| `Microsoft.RecoveryServices` |  RecoveryServicesVaults |[vaults](Microsoft.RecoveryServices/vaults) | :heavy_check_mark: | |
| `Microsoft.Resources` |  Deployment Scripts |[deploymentScripts](Microsoft.Resources/deploymentScripts) | :heavy_check_mark: | |
| |  Resource Group |[resourceGroups](Microsoft.Resources/resourceGroups) | :heavy_check_mark: | :heavy_check_mark: |
| `Microsoft.Security` |  AzureSecurityCenter |[azureSecurityCenter](Microsoft.Security/azureSecurityCenter) | :heavy_check_mark: | |
| `Microsoft.ServiceBus` |  ServiceBusNamespaces |[namespaces](Microsoft.ServiceBus/namespaces) | :heavy_check_mark: | |
| | ServiceBusQueues | [namespaces/queues](Microsoft.ServiceBus/namespacesResources/queues) | :heavy_check_mark: | |
| `Microsoft.Sql` |  SQL Managed Instances |[managedInstances](Microsoft.Sql/managedInstances) | :heavy_check_mark: | |
| | SQL Managed Instances Database | [managedInstances/databases](Microsoft.Sql/managedInstancesResources/databases) | :heavy_check_mark: | |
| |  AzureSQLServer |[servers](Microsoft.Sql/servers) | :heavy_check_mark: | |
| | AzureSQLDatabase | [servers/databases](Microsoft.Sql/serversResources/databases) | :heavy_check_mark: | |
| `Microsoft.Storage` |  StorageAccounts |[storageAccounts](Microsoft.Storage/storageAccounts) | :heavy_check_mark: | :heavy_check_mark: |
| `Microsoft.Subscription` |  Subscription |[aliases](Microsoft.Subscription/aliases) | :heavy_check_mark: | |
| `Microsoft.VirtualMachineImages` |  |[imageTemplates](Microsoft.VirtualMachineImages/imageTemplates) | :heavy_check_mark: | |
| `Microsoft.Web` |  API Connection |[connections](Microsoft.Web/connections) | :heavy_check_mark: | |
| |  App Service Environment |[hostingEnvironments](Microsoft.Web/hostingEnvironments) | :heavy_check_mark: | |
| |  AppServicePlan |[serverfarms](Microsoft.Web/serverfarms) | :heavy_check_mark: | |
| | App Services | [sites/appService](Microsoft.Web/sites/appService) | :heavy_check_mark: | |
| | FunctionApp | [sites/functionApp](Microsoft.Web/sites/functionApp) | :heavy_check_mark: | |
| | WebApp | [sites/webApp](Microsoft.Web/sites/webApp) | :heavy_check_mark: | |