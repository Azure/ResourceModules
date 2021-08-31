In this section you can find useful information regarding the modules that are contained in this repository.

# Available modules
The following table provides you with an outline of all modules that are currently available for use. Several sub-resources may be their own modules and are hence displayed as a child path (e.g. `service/caches`).

| Resource provider namespace | Azure service | ARM | Bicep |
| --------------------------- | ------------- | --- | ----- |
| `Microsoft.AnalysisServices` | [servers](Microsoft.AnalysisServices/servers)
| `Microsoft.ApiManagement` | [service](Microsoft.ApiManagement/service)
| | [service\apis](.\Microsoft.ApiManagement\serviceResources\apis) | X | |
| | [service\authorizationServers](.\Microsoft.ApiManagement\serviceResources\authorizationServers) | X | |
| | [service\backends](.\Microsoft.ApiManagement\serviceResources\backends) | X | |
| | [service\caches](.\Microsoft.ApiManagement\serviceResources\caches) | X | |
| | [service\namedValues](.\Microsoft.ApiManagement\serviceResources\namedValues) | X | |
| | [service\products](.\Microsoft.ApiManagement\serviceResources\products) | X | |
| | [service\subscriptions](.\Microsoft.ApiManagement\serviceResources\subscriptions) | X | |
| `Microsoft.Authorization` | [policyAssignments](Microsoft.Authorization/policyAssignments)
| | [roleAssignments](Microsoft.Authorization/roleAssignments)
| | [roleDefinitions](Microsoft.Authorization/roleDefinitions)
| `Microsoft.Automanage` | [accounts](Microsoft.Automanage/accounts)
| `Microsoft.Automation` | [automationAccounts](Microsoft.Automation/automationAccounts)
| | [automationAccounts\softwareUpdateConfigurations](.\Microsoft.Automation\automationAccountsResources\softwareUpdateConfigurations) | X | |
| `Microsoft.Batch` | [batchAccounts](Microsoft.Batch/batchAccounts)
| `Microsoft.CognitiveServices` | [accounts](Microsoft.CognitiveServices/accounts)
| `Microsoft.Compute` | [diskEncryptionSets](Microsoft.Compute/diskEncryptionSets)
| | [galleries](Microsoft.Compute/galleries)
| | [galleries\images](.\Microsoft.Compute\galleriesResources\images) | X | |
| | [images](Microsoft.Compute/images)
| | [virtualMachines](Microsoft.Compute/virtualMachines)
| | [virtualMachineScaleSets](Microsoft.Compute/virtualMachineScaleSets)
| `Microsoft.Consumption` | [budgets](Microsoft.Consumption/budgets)
| `Microsoft.ContainerInstance` | [containerGroups](Microsoft.ContainerInstance/containerGroups)
| `Microsoft.ContainerRegistry` | [registries](Microsoft.ContainerRegistry/registries)
| `Microsoft.ContainerService` | [managedClusters](Microsoft.ContainerService/managedClusters)
| `Microsoft.Databricks` | [workspaces](Microsoft.Databricks/workspaces)
| `Microsoft.DataFactory` | [factories](Microsoft.DataFactory/factories)
| `Microsoft.DesktopVirtualization` | [applicationgroups](Microsoft.DesktopVirtualization/applicationgroups)
| | [applicationGroups\applications](.\Microsoft.DesktopVirtualization\applicationGroupsResources\applications) | X | X |
| | [hostpools](Microsoft.DesktopVirtualization/hostpools)
| | [workspaces](Microsoft.DesktopVirtualization/workspaces)
| | [wvdScalingScheduler](Microsoft.DesktopVirtualization/wvdScalingScheduler)
| `Microsoft.EventGrid` | [topics](Microsoft.EventGrid/topics)
| `Microsoft.EventHub` | [namespaces](Microsoft.EventHub/namespaces)
| | [namespaces\eventhubs](.\Microsoft.EventHub\namespacesResources\eventhubs) | X | |
| `Microsoft.HealthBot` | [healthBots](Microsoft.HealthBot/healthBots)
| `Microsoft.Insights` | [actionGroups](Microsoft.Insights/actionGroups)
| | [activityLogAlerts](Microsoft.Insights/activityLogAlerts)
| | [components](Microsoft.Insights/components)
| | [diagnosticSettings](Microsoft.Insights/diagnosticSettings)
| | [metricAlerts](Microsoft.Insights/metricAlerts)
| | [privateLinkScopes](Microsoft.Insights/privateLinkScopes)
| | [scheduledQueryRules](Microsoft.Insights/scheduledQueryRules)
| `Microsoft.KeyVault` | [vaults](Microsoft.KeyVault/vaults)
| `Microsoft.MachineLearningServices` | [workspaces](Microsoft.MachineLearningServices/workspaces)
| `Microsoft.ManagedIdentity` | [userAssignedIdentities](Microsoft.ManagedIdentity/userAssignedIdentities)
| | [registrationDefinitions\.attachments](.\Microsoft.ManagedServices\registrationDefinitions\.attachments) | | |
| `Microsoft.Management` | [managementGroups](Microsoft.Management/managementGroups)
| `Microsoft.NetApp` | [netAppAccounts](Microsoft.NetApp/netAppAccounts)
| `Microsoft.Network` | [applicationGateways](Microsoft.Network/applicationGateways)
| | [applicationSecurityGroups](Microsoft.Network/applicationSecurityGroups)
| | [azureFirewalls](Microsoft.Network/azureFirewalls)
| | [bastionHosts](Microsoft.Network/bastionHosts)
| | [connections](Microsoft.Network/connections)
| | [ddosProtectionPlans](Microsoft.Network/ddosProtectionPlans)
| | [expressRouteCircuits](Microsoft.Network/expressRouteCircuits)
| | [ipGroups](Microsoft.Network/ipGroups)
| | [loadBalancers](Microsoft.Network/loadBalancers)
| | [localNetworkGateways](Microsoft.Network/localNetworkGateways)
| | [natGateways](Microsoft.Network/natGateways)
| | [networkSecurityGroups](Microsoft.Network/networkSecurityGroups)
| | [networkWatcherFlowLogs](Microsoft.Network/networkWatcherFlowLogs)
| | [networkWatchers](Microsoft.Network/networkWatchers)
| | [privateDnsZones](Microsoft.Network/privateDnsZones)
| | [privateEndpoints](Microsoft.Network/privateEndpoints)
| | [publicIPAddresses](Microsoft.Network/publicIPAddresses)
| | [publicIPPrefixes](Microsoft.Network/publicIPPrefixes)
| | [routeTables](Microsoft.Network/routeTables)
| | [trafficmanagerprofiles](Microsoft.Network/trafficmanagerprofiles)
| | [virtualNetworkGateways](Microsoft.Network/virtualNetworkGateways)
| | [virtualNetworkPeerings](Microsoft.Network/virtualNetworkPeerings)
| | [virtualNetworks](Microsoft.Network/virtualNetworks)
| | [virtualWans](Microsoft.Network/virtualWans)
| `Microsoft.OperationalInsights` | [workspaces](Microsoft.OperationalInsights/workspaces)
| `Microsoft.RecoveryServices` | [vaults](Microsoft.RecoveryServices/vaults)
| `Microsoft.Resources` | [deploymentScripts](Microsoft.Resources/deploymentScripts)
| | [resourceGroups](Microsoft.Resources/resourceGroups)
| `Microsoft.Security` | [azureSecurityCenter](Microsoft.Security/azureSecurityCenter)
| `Microsoft.ServiceBus` | [namespaces](Microsoft.ServiceBus/namespaces)
| | [namespaces\queues](.\Microsoft.ServiceBus\namespacesResources\queues) | X | |
| `Microsoft.Sql` | [managedInstances](Microsoft.Sql/managedInstances)
| | [managedInstances\databases](.\Microsoft.Sql\managedInstancesResources\databases) | X | |
| | [servers](Microsoft.Sql/servers)
| | [servers\databases](.\Microsoft.Sql\serversResources\databases) | X | |
| `Microsoft.Storage` | [storageAccounts](Microsoft.Storage/storageAccounts)
| `Microsoft.Subscription` | [aliases](Microsoft.Subscription/aliases)
| `Microsoft.VirtualMachineImages` | [imageTemplates](Microsoft.VirtualMachineImages/imageTemplates)
| `Microsoft.Web` | [connections](Microsoft.Web/connections)
| | [hostingEnvironments](Microsoft.Web/hostingEnvironments)
| | [serverfarms](Microsoft.Web/serverfarms)
| | [sites\appService](.\Microsoft.Web\sites\appService) | X | |
| | [sites\functionApp](.\Microsoft.Web\sites\functionApp) | X | |
| | [sites\webApp](.\Microsoft.Web\sites\webApp) | X | |