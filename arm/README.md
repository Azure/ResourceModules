In this section you can find useful information regarding the modules that are contained in this repository.

# Available modules
The following table provides you with an outline of all modules that are currently available for use. Several sub-resources may be their own modules and are hence displayed as a child path (e.g. `service/caches`).

| Resource provider namespace | Azure service | ARM | Bicep |
| --------------------------- | ------------- | --- | ----- |
| `Microsoft.AnalysisServices` | [servers](Microsoft.AnalysisServices/servers) | :heavy_check_mark: | |
| `Microsoft.ApiManagement` | [service](Microsoft.ApiManagement/service) | :heavy_check_mark: | |
| | [service\apis](Microsoft.ApiManagement\serviceResources\apis) | :heavy_check_mark: | |
| | [service\authorizationServers](Microsoft.ApiManagement\serviceResources\authorizationServers) | :heavy_check_mark: | |
| | [service\backends](Microsoft.ApiManagement\serviceResources\backends) | :heavy_check_mark: | |
| | [service\caches](Microsoft.ApiManagement\serviceResources\caches) | :heavy_check_mark: | |
| | [service\namedValues](Microsoft.ApiManagement\serviceResources\namedValues) | :heavy_check_mark: | |
| | [service\products](Microsoft.ApiManagement\serviceResources\products) | :heavy_check_mark: | |
| | [service\subscriptions](Microsoft.ApiManagement\serviceResources\subscriptions) | :heavy_check_mark: | |
| `Microsoft.Authorization` | [policyAssignments](Microsoft.Authorization/policyAssignments) | :heavy_check_mark: | |
| | [roleAssignments](Microsoft.Authorization/roleAssignments) | :heavy_check_mark: | |
| | [roleDefinitions](Microsoft.Authorization/roleDefinitions) | :heavy_check_mark: | |
| `Microsoft.Automanage` | [accounts](Microsoft.Automanage/accounts) | :heavy_check_mark: | |
| `Microsoft.Automation` | [automationAccounts](Microsoft.Automation/automationAccounts) | :heavy_check_mark: | |
| | [automationAccounts\softwareUpdateConfigurations](Microsoft.Automation\automationAccountsResources\softwareUpdateConfigurations) | :heavy_check_mark: | |
| `Microsoft.Batch` | [batchAccounts](Microsoft.Batch/batchAccounts) | :heavy_check_mark: | |
| `Microsoft.CognitiveServices` | [accounts](Microsoft.CognitiveServices/accounts) | :heavy_check_mark: | |
| `Microsoft.Compute` | [diskEncryptionSets](Microsoft.Compute/diskEncryptionSets) | :heavy_check_mark: | |
| | [galleries](Microsoft.Compute/galleries) | :heavy_check_mark: | :heavy_check_mark: |
| | [galleries\images](Microsoft.Compute\galleriesResources\images) | :heavy_check_mark: | |
| | [images](Microsoft.Compute/images) | :heavy_check_mark: | |
| | [virtualMachines](Microsoft.Compute/virtualMachines) | :heavy_check_mark: | |
| | [virtualMachineScaleSets](Microsoft.Compute/virtualMachineScaleSets) | :heavy_check_mark: | |
| `Microsoft.Consumption` | [budgets](Microsoft.Consumption/budgets) | :heavy_check_mark: | |
| `Microsoft.ContainerInstance` | [containerGroups](Microsoft.ContainerInstance/containerGroups) | :heavy_check_mark: | |
| `Microsoft.ContainerRegistry` | [registries](Microsoft.ContainerRegistry/registries) | :heavy_check_mark: | |
| `Microsoft.ContainerService` | [managedClusters](Microsoft.ContainerService/managedClusters) | :heavy_check_mark: | |
| `Microsoft.Databricks` | [workspaces](Microsoft.Databricks/workspaces) | :heavy_check_mark: | |
| `Microsoft.DataFactory` | [factories](Microsoft.DataFactory/factories) | :heavy_check_mark: | |
| `Microsoft.DesktopVirtualization` | [applicationgroups](Microsoft.DesktopVirtualization/applicationgroups) | :heavy_check_mark: | |
| | [applicationGroups\applications](Microsoft.DesktopVirtualization\applicationGroupsResources\applications) | :heavy_check_mark: | :heavy_check_mark: |
| | [hostpools](Microsoft.DesktopVirtualization/hostpools) | :heavy_check_mark: | |
| | [workspaces](Microsoft.DesktopVirtualization/workspaces) | :heavy_check_mark: | |
| | [wvdScalingScheduler](Microsoft.DesktopVirtualization/wvdScalingScheduler) | :heavy_check_mark: | |
| `Microsoft.EventGrid` | [topics](Microsoft.EventGrid/topics) | :heavy_check_mark: | |
| `Microsoft.EventHub` | [namespaces](Microsoft.EventHub/namespaces) | :heavy_check_mark: | |
| | [namespaces\eventhubs](Microsoft.EventHub\namespacesResources\eventhubs) | :heavy_check_mark: | |
| `Microsoft.HealthBot` | [healthBots](Microsoft.HealthBot/healthBots) | :heavy_check_mark: | |
| `Microsoft.Insights` | [actionGroups](Microsoft.Insights/actionGroups) | :heavy_check_mark: | |
| | [activityLogAlerts](Microsoft.Insights/activityLogAlerts) | :heavy_check_mark: | |
| | [components](Microsoft.Insights/components) | :heavy_check_mark: | |
| | [diagnosticSettings](Microsoft.Insights/diagnosticSettings) | :heavy_check_mark: | |
| | [metricAlerts](Microsoft.Insights/metricAlerts) | :heavy_check_mark: | |
| | [privateLinkScopes](Microsoft.Insights/privateLinkScopes) | :heavy_check_mark: | |
| | [scheduledQueryRules](Microsoft.Insights/scheduledQueryRules) | :heavy_check_mark: | |
| `Microsoft.KeyVault` | [vaults](Microsoft.KeyVault/vaults) | :heavy_check_mark: | |
| `Microsoft.MachineLearningServices` | [workspaces](Microsoft.MachineLearningServices/workspaces) | :heavy_check_mark: | |
| `Microsoft.ManagedIdentity` | [userAssignedIdentities](Microsoft.ManagedIdentity/userAssignedIdentities) | :heavy_check_mark: | |
| `Microsoft.ManagedServices` | [registrationDefinitions](Microsoft.ManagedServices/registrationDefinitions) | :heavy_check_mark: | |
| `Microsoft.Management` | [managementGroups](Microsoft.Management/managementGroups) | :heavy_check_mark: | |
| `Microsoft.NetApp` | [netAppAccounts](Microsoft.NetApp/netAppAccounts) | :heavy_check_mark: | |
| `Microsoft.Network` | [applicationGateways](Microsoft.Network/applicationGateways) | :heavy_check_mark: | |
| | [applicationSecurityGroups](Microsoft.Network/applicationSecurityGroups) | :heavy_check_mark: | |
| | [azureFirewalls](Microsoft.Network/azureFirewalls) | :heavy_check_mark: | |
| | [bastionHosts](Microsoft.Network/bastionHosts) | :heavy_check_mark: | |
| | [connections](Microsoft.Network/connections) | :heavy_check_mark: | |
| | [ddosProtectionPlans](Microsoft.Network/ddosProtectionPlans) | :heavy_check_mark: | |
| | [expressRouteCircuits](Microsoft.Network/expressRouteCircuits) | :heavy_check_mark: | |
| | [ipGroups](Microsoft.Network/ipGroups) | :heavy_check_mark: | |
| | [loadBalancers](Microsoft.Network/loadBalancers) | :heavy_check_mark: | |
| | [localNetworkGateways](Microsoft.Network/localNetworkGateways) | :heavy_check_mark: | |
| | [natGateways](Microsoft.Network/natGateways) | :heavy_check_mark: | |
| | [networkSecurityGroups](Microsoft.Network/networkSecurityGroups) | :heavy_check_mark: | |
| | [networkWatcherFlowLogs](Microsoft.Network/networkWatcherFlowLogs) | :heavy_check_mark: | |
| | [networkWatchers](Microsoft.Network/networkWatchers) | :heavy_check_mark: | |
| | [privateDnsZones](Microsoft.Network/privateDnsZones) | :heavy_check_mark: | |
| | [privateEndpoints](Microsoft.Network/privateEndpoints) | :heavy_check_mark: | |
| | [publicIPAddresses](Microsoft.Network/publicIPAddresses) | :heavy_check_mark: | |
| | [publicIPPrefixes](Microsoft.Network/publicIPPrefixes) | :heavy_check_mark: | |
| | [routeTables](Microsoft.Network/routeTables) | :heavy_check_mark: | |
| | [trafficmanagerprofiles](Microsoft.Network/trafficmanagerprofiles) | :heavy_check_mark: | |
| | [virtualNetworkGateways](Microsoft.Network/virtualNetworkGateways) | :heavy_check_mark: | |
| | [virtualNetworkPeerings](Microsoft.Network/virtualNetworkPeerings) | :heavy_check_mark: | |
| | [virtualNetworks](Microsoft.Network/virtualNetworks) | :heavy_check_mark: | |
| | [virtualWans](Microsoft.Network/virtualWans) | :heavy_check_mark: | |
| `Microsoft.OperationalInsights` | [workspaces](Microsoft.OperationalInsights/workspaces) | :heavy_check_mark: | |
| `Microsoft.RecoveryServices` | [vaults](Microsoft.RecoveryServices/vaults) | :heavy_check_mark: | |
| `Microsoft.Resources` | [deploymentScripts](Microsoft.Resources/deploymentScripts) | :heavy_check_mark: | |
| | [resourceGroups](Microsoft.Resources/resourceGroups) | :heavy_check_mark: | :heavy_check_mark: |
| `Microsoft.Security` | [azureSecurityCenter](Microsoft.Security/azureSecurityCenter) | :heavy_check_mark: | |
| `Microsoft.ServiceBus` | [namespaces](Microsoft.ServiceBus/namespaces) | :heavy_check_mark: | |
| | [namespaces\queues](Microsoft.ServiceBus\namespacesResources\queues) | :heavy_check_mark: | |
| `Microsoft.Sql` | [managedInstances](Microsoft.Sql/managedInstances) | :heavy_check_mark: | |
| | [managedInstances\databases](Microsoft.Sql\managedInstancesResources\databases) | :heavy_check_mark: | |
| | [servers](Microsoft.Sql/servers) | :heavy_check_mark: | |
| | [servers\databases](Microsoft.Sql\serversResources\databases) | :heavy_check_mark: | |
| `Microsoft.Storage` | [storageAccounts](Microsoft.Storage/storageAccounts) | :heavy_check_mark: | :heavy_check_mark: |
| `Microsoft.Subscription` | [aliases](Microsoft.Subscription/aliases) | :heavy_check_mark: | |
| `Microsoft.VirtualMachineImages` | [imageTemplates](Microsoft.VirtualMachineImages/imageTemplates) | :heavy_check_mark: | |
| `Microsoft.Web` | [connections](Microsoft.Web/connections) | :heavy_check_mark: | |
| | [hostingEnvironments](Microsoft.Web/hostingEnvironments) | :heavy_check_mark: | |
| | [serverfarms](Microsoft.Web/serverfarms) | :heavy_check_mark: | |
| | [sites\appService](Microsoft.Web\sites\appService) | :heavy_check_mark: | |
| | [sites\functionApp](Microsoft.Web\sites\functionApp) | :heavy_check_mark: | |
| | [sites\webApp](Microsoft.Web\sites\webApp) | :heavy_check_mark: | |