In this section you can find useful information regarding the Modules that are contained in this repository.

# Available Modules
The following table provides you with an outline of all Modules that are currently available for use. Several sub-resources may be their own Modules and are hence displayed as a child path (e.g. `service/caches`).

| Resource provider namespace | Azure service | Resource Name | ARM | Bicep |
| --------------------------- | ------------- | ------------- | --- | ----- |
| `MS.AnalysisServices` | [servers](Microsoft.AnalysisServices/servers) | Analysis Services | :heavy_check_mark: | |
| `MS.ApiManagement` | [service](Microsoft.ApiManagement/service) | Api Management | :heavy_check_mark: | |
| | [service/apis](Microsoft.ApiManagement/serviceResources/apis) | Api Management Service Apis | :heavy_check_mark: | |
| | [service/authorizationServers](Microsoft.ApiManagement/serviceResources/authorizationServers) | Api Management Service Authorization Servers | :heavy_check_mark: | |
| | [service/backends](Microsoft.ApiManagement/serviceResources/backends) | Api Management Service Backends | :heavy_check_mark: | |
| | [service/caches](Microsoft.ApiManagement/serviceResources/caches) | Api Management Service Cache | :heavy_check_mark: | |
| | [service/namedValues](Microsoft.ApiManagement/serviceResources/namedValues) | Api Management Service Named Values | :heavy_check_mark: | |
| | [service/products](Microsoft.ApiManagement/serviceResources/products) | Api Management Service Products | :heavy_check_mark: | |
| | [service/subscriptions](Microsoft.ApiManagement/serviceResources/subscriptions) | Api Management Subscriptions | :heavy_check_mark: | |
| `MS.Authorization` | [policyAssignments](Microsoft.Authorization/policyAssignments) | PolicyAssignment | :heavy_check_mark: | |
| | [roleAssignments](Microsoft.Authorization/roleAssignments) | Role Assignments | :heavy_check_mark: | |
| | [roleDefinitions](Microsoft.Authorization/roleDefinitions) | Role Definitions | :heavy_check_mark: | |
| `MS.Automanage` | [accounts](Microsoft.Automanage/accounts) | AutoManage | :heavy_check_mark: | |
| `MS.Automation` | [automationAccounts](Microsoft.Automation/automationAccounts) | AutomationAccounts | :heavy_check_mark: | |
| | [automationAccounts/softwareUpdateConfigurations](Microsoft.Automation/automationAccountsResources/softwareUpdateConfigurations) | Software Update Configuration | :heavy_check_mark: | |
| `MS.Batch` | [batchAccounts](Microsoft.Batch/batchAccounts) | Batch Accounts | :heavy_check_mark: | |
| `MS.CognitiveServices` | [accounts](Microsoft.CognitiveServices/accounts) | CognitiveServices | :heavy_check_mark: | |
| `MS.Compute` | [diskEncryptionSets](Microsoft.Compute/diskEncryptionSets) | DiskEncryptionSet | :heavy_check_mark: | |
| | [galleries](Microsoft.Compute/galleries) | Shared Image Gallery | :heavy_check_mark: | :heavy_check_mark: |
| | [galleries/images](Microsoft.Compute/galleriesResources/images) | Shared Image Definition | :heavy_check_mark: | |
| | [images](Microsoft.Compute/images) | Image | :heavy_check_mark: | |
| | [virtualMachines](Microsoft.Compute/virtualMachines) | Virtual Machines | :heavy_check_mark: | |
| | [virtualMachineScaleSets](Microsoft.Compute/virtualMachineScaleSets) | Virtual Machine Scale Sets | :heavy_check_mark: | |
| `MS.Consumption` | [budgets](Microsoft.Consumption/budgets) | Budgets | :heavy_check_mark: | |
| `MS.ContainerInstance` | [containerGroups](Microsoft.ContainerInstance/containerGroups) | ContainerInstances | :heavy_check_mark: | |
| `MS.ContainerRegistry` | [registries](Microsoft.ContainerRegistry/registries) | ContainerRegistry | :heavy_check_mark: | |
| `MS.ContainerService` | [managedClusters](Microsoft.ContainerService/managedClusters) | AzureKubernetesService | :heavy_check_mark: | |
| `MS.Databricks` | [workspaces](Microsoft.Databricks/workspaces) | Azure Databricks | :heavy_check_mark: | |
| `MS.DataFactory` | [factories](Microsoft.DataFactory/factories) | DataFactory | :heavy_check_mark: | |
| `MS.DesktopVirtualization` | [applicationgroups](Microsoft.DesktopVirtualization/applicationgroups) | WVD Application Groups | :heavy_check_mark: | |
| | [applicationGroups/applications](Microsoft.DesktopVirtualization/applicationGroupsResources/applications) | WVD Applications | :heavy_check_mark: | :heavy_check_mark: |
| | [hostpools](Microsoft.DesktopVirtualization/hostpools) | WVD HostPools | :heavy_check_mark: | |
| | [workspaces](Microsoft.DesktopVirtualization/workspaces) | WVD Workspaces | :heavy_check_mark: | |
| | [wvdScalingScheduler](Microsoft.DesktopVirtualization/wvdScalingScheduler) | WvdScaling Scheduler | :heavy_check_mark: | |
| `MS.EventGrid` | [topics](Microsoft.EventGrid/topics) | Event Grid | :heavy_check_mark: | |
| `MS.EventHub` | [namespaces](Microsoft.EventHub/namespaces) | EventHub Namespaces | :heavy_check_mark: | |
| | [namespaces/eventhubs](Microsoft.EventHub/namespacesResources/eventhubs) | EventHubs | :heavy_check_mark: | |
| `MS.HealthBot` | [healthBots](Microsoft.HealthBot/healthBots) | Azure Health Bot | :heavy_check_mark: | |
| `MS.Insights` | [actionGroups](Microsoft.Insights/actionGroups) | Action Group | :heavy_check_mark: | |
| | [activityLogAlerts](Microsoft.Insights/activityLogAlerts) | Activity Log Alert | :heavy_check_mark: | |
| | [components](Microsoft.Insights/components) | Application Insights | :heavy_check_mark: | |
| | [diagnosticSettings](Microsoft.Insights/diagnosticSettings) | ActivityLog | :heavy_check_mark: | |
| | [metricAlerts](Microsoft.Insights/metricAlerts) | Metric Alert | :heavy_check_mark: | |
| | [privateLinkScopes](Microsoft.Insights/privateLinkScopes) | Azure Monitor Private Link Scope | :heavy_check_mark: | |
| | [scheduledQueryRules](Microsoft.Insights/scheduledQueryRules) | Scheduled Query Rules | :heavy_check_mark: | |
| `MS.KeyVault` | [vaults](Microsoft.KeyVault/vaults) | KeyVault | :heavy_check_mark: | |
| `MS.achineLearningServices` | [workspaces](Microsoft.MachineLearningServices/workspaces) | Machine Learning Services | :heavy_check_mark: | |
| `MS.anagedIdentity` | [userAssignedIdentities](Microsoft.ManagedIdentity/userAssignedIdentities) | User Assigned Identities | :heavy_check_mark: | |
| `MS.anagedServices` | [registrationDefinitions](Microsoft.ManagedServices/registrationDefinitions) | Lighthouse | :heavy_check_mark: | |
| `MS.anagement` | [managementGroups](Microsoft.Management/managementGroups) | Management groups | :heavy_check_mark: | |
| `MS.NetApp` | [netAppAccounts](Microsoft.NetApp/netAppAccounts) | AzureNetAppFiles | :heavy_check_mark: | |
| `MS.Network` | [applicationGateways](Microsoft.Network/applicationGateways) | ApplicationGateway | :heavy_check_mark: | |
| | [applicationSecurityGroups](Microsoft.Network/applicationSecurityGroups) | ApplicationSecurityGroups | :heavy_check_mark: | |
| | [azureFirewalls](Microsoft.Network/azureFirewalls) | AzureFirewall | :heavy_check_mark: | |
| | [bastionHosts](Microsoft.Network/bastionHosts) | AzureBastion | :heavy_check_mark: | |
| | [connections](Microsoft.Network/connections) | VirtualNetworkGatewayConnection | :heavy_check_mark: | |
| | [ddosProtectionPlans](Microsoft.Network/ddosProtectionPlans) | DDoS Protection Plans | :heavy_check_mark: | |
| | [expressRouteCircuits](Microsoft.Network/expressRouteCircuits) | ExpressRoute Circuit | :heavy_check_mark: | |
| | [ipGroups](Microsoft.Network/ipGroups) | KeyVault | :heavy_check_mark: | |
| | [loadBalancers](Microsoft.Network/loadBalancers) | LoadBalancer | :heavy_check_mark: | |
| | [localNetworkGateways](Microsoft.Network/localNetworkGateways) | Local Network Gateway | :heavy_check_mark: | |
| | [natGateways](Microsoft.Network/natGateways) | NAT Gateway | :heavy_check_mark: | |
| | [networkSecurityGroups](Microsoft.Network/networkSecurityGroups) | NetworkSecurityGroups | :heavy_check_mark: | |
| | [networkWatcherFlowLogs](Microsoft.Network/networkWatcherFlowLogs) | NSG Flow Logs | :heavy_check_mark: | |
| | [networkWatchers](Microsoft.Network/networkWatchers) | Network Watcher | :heavy_check_mark: | |
| | [privateDnsZones](Microsoft.Network/privateDnsZones) | PrivateDnsZones | :heavy_check_mark: | |
| | [privateEndpoints](Microsoft.Network/privateEndpoints) | PrivateEndpoints | :heavy_check_mark: | |
| | [publicIPAddresses](Microsoft.Network/publicIPAddresses) | Public IP Addresses | :heavy_check_mark: | |
| | [publicIPPrefixes](Microsoft.Network/publicIPPrefixes) | Public IP Prefixes | :heavy_check_mark: | |
| | [routeTables](Microsoft.Network/routeTables) | RouteTables | :heavy_check_mark: | |
| | [trafficmanagerprofiles](Microsoft.Network/trafficmanagerprofiles) | TrafficManager | :heavy_check_mark: | |
| | [virtualNetworkGateways](Microsoft.Network/virtualNetworkGateways) | VirtualNetworkGateway | :heavy_check_mark: | |
| | [virtualNetworkPeerings](Microsoft.Network/virtualNetworkPeerings) | VirtualNetworkPeering | :heavy_check_mark: | |
| | [virtualNetworks](Microsoft.Network/virtualNetworks) | Virtual Network | :heavy_check_mark: | |
| | [virtualWans](Microsoft.Network/virtualWans) | Virtual Wan | :heavy_check_mark: | |
| `MS.OperationalInsights` | [workspaces](Microsoft.OperationalInsights/workspaces) | LogAnalytics | :heavy_check_mark: | |
| `MS.RecoveryServices` | [vaults](Microsoft.RecoveryServices/vaults) | RecoveryServicesVaults | :heavy_check_mark: | |
| `MS.Resources` | [deploymentScripts](Microsoft.Resources/deploymentScripts) | Deployment Scripts | :heavy_check_mark: | |
| | [resourceGroups](Microsoft.Resources/resourceGroups) | Resource Group | :heavy_check_mark: | :heavy_check_mark: |
| `MS.Security` | [azureSecurityCenter](Microsoft.Security/azureSecurityCenter) | AzureSecurityCenter | :heavy_check_mark: | |
| `MS.ServiceBus` | [namespaces](Microsoft.ServiceBus/namespaces) | ServiceBusNamespaces | :heavy_check_mark: | |
| | [namespaces/queues](Microsoft.ServiceBus/namespacesResources/queues) | ServiceBusQueues | :heavy_check_mark: | |
| `MS.Sql` | [managedInstances](Microsoft.Sql/managedInstances) | SQL Managed Instances | :heavy_check_mark: | |
| | [managedInstances/databases](Microsoft.Sql/managedInstancesResources/databases) | SQL Managed Instances Database | :heavy_check_mark: | |
| | [servers](Microsoft.Sql/servers) | AzureSQLServer | :heavy_check_mark: | |
| | [servers/databases](Microsoft.Sql/serversResources/databases) | AzureSQLDatabase | :heavy_check_mark: | |
| `MS.Storage` | [storageAccounts](Microsoft.Storage/storageAccounts) | StorageAccounts | :heavy_check_mark: | :heavy_check_mark: |
| `MS.Subscription` | [aliases](Microsoft.Subscription/aliases) | Subscription | :heavy_check_mark: | |
| `MS.VirtualMachineImages` | [imageTemplates](Microsoft.VirtualMachineImages/imageTemplates) | Image Templates | :heavy_check_mark: | |
| `MS.Web` | [connections](Microsoft.Web/connections) | API Connection | :heavy_check_mark: | |
| | [hostingEnvironments](Microsoft.Web/hostingEnvironments) | App Service Environment | :heavy_check_mark: | |
| | [serverfarms](Microsoft.Web/serverfarms) | AppServicePlan | :heavy_check_mark: | |
| | [sites/appService](Microsoft.Web/sites/appService) | App Services | :heavy_check_mark: | |
| | [sites/functionApp](Microsoft.Web/sites/functionApp) | FunctionApp | :heavy_check_mark: | |
| | [sites/webApp](Microsoft.Web/sites/webApp) | WebApp | :heavy_check_mark: | |