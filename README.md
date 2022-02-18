# ![AzureIcon] Common Azure Resource Modules Library

## Description

This repository includes a CI platform for and collection of mature and curated [Bicep][Bicep]  modules.
The platform supports both ARM and Bicep and can be leveraged using GitHub actions as well as Azure DevOps pipelines.

## Status

<a href="https://github.com/Azure/ResourceModules/actions/workflows/linter.yml">
  <img alt="Super Linter" src="https://github.com/Azure/ResourceModules/actions/workflows/linter.yml/badge.svg" />
</a>
<a href="https://github.com/Azure/ResourceModules/issues">
  <img alt="Issues" src="https://img.shields.io/github/issues/Azure/ResourceModules?color=0088ff" />
</a>
<a href="https://github.com/Azure/ResourceModules/pulls">
  <img alt="Pull requests" src="https://img.shields.io/github/issues-pr/Azure/ResourceModules?color=0088ff" />
</a>

## Get started

* For introduction guidance visit the [Wiki](https://github.com/azure/ResourceModules/wiki)
* For reference documentation visit [Enterprise-Scale](https://github.com/azure/enterprise-scale)
* For information on contributing, see [Contribution](<https://github.com/Azure/ResourceModules/wiki#contributing>)
* File an issue via [GitHub Issues](https://github.com/azure/ResourceModules/issues/new/choose)

## Available Resource Modules

| Name | Status |
| - | - |
| [Action Groups](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Insights/actionGroups) | [!['Insights: ActionGroups'](https://github.com/Azure/ResourceModules/actions/workflows/ms.insights.actiongroups.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.insights.actiongroups.yml) |
| [Activity Log Alerts](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Insights/activityLogAlerts) | [!['Insights: ActivityLogAlerts'](https://github.com/Azure/ResourceModules/actions/workflows/ms.insights.activitylogalerts.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.insights.activitylogalerts.yml) |
| [Activity Logs](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Insights/diagnosticSettings) | [!['Insights: DiagnosticSettings'](https://github.com/Azure/ResourceModules/actions/workflows/ms.insights.diagnosticsettings.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.insights.diagnosticsettings.yml) |
| [Analysis Services Server](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.AnalysisServices/servers) | [!['AnalysisServices: Servers'](https://github.com/Azure/ResourceModules/actions/workflows/ms.analysisservices.servers.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.analysisservices.servers.yml) |
| [API Connections](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Web/connections) | [!['Web: Connections'](https://github.com/Azure/ResourceModules/actions/workflows/ms.web.connections.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.web.connections.yml) |
| [API Management Services](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.ApiManagement/service) | [!['ApiManagement: Service'](https://github.com/Azure/ResourceModules/actions/workflows/ms.apimanagement.service.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.apimanagement.service.yml) |
| [App Service Environments](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Web/hostingEnvironments) | [!['Web: HostingEnvironments'](https://github.com/Azure/ResourceModules/actions/workflows/ms.web.hostingenvironments.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.web.hostingenvironments.yml) |
| [App Service Plans](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Web/serverfarms) | [!['Web: Serverfarms'](https://github.com/Azure/ResourceModules/actions/workflows/ms.web.serverfarms.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.web.serverfarms.yml) |
| [Application Gateways](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/applicationGateways) | [!['Network: ApplicationGateways'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.applicationgateways.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.applicationgateways.yml) |
| [Application Insights](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Insights/components) | [!['Insights: Components'](https://github.com/Azure/ResourceModules/actions/workflows/ms.insights.components.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.insights.components.yml) |
| [Application Security Groups](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/applicationSecurityGroups) | [!['Network: ApplicationSecurityGroups'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.applicationsecuritygroups.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.applicationsecuritygroups.yml) |
| [Automation Accounts](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Automation/automationAccounts) | [!['Automation: AutomationAccounts'](https://github.com/Azure/ResourceModules/actions/workflows/ms.automation.automationaccounts.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.automation.automationaccounts.yml) |
| [Availability Sets](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Compute/availabilitySets) | [!['Compute: AvailabilitySets'](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.availabilitysets.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.availabilitysets.yml) |
| [AVD Application Groups](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.DesktopVirtualization/applicationgroups) | [!['DesktopVirtualization: ApplicationGroups'](https://github.com/Azure/ResourceModules/actions/workflows/ms.desktopvirtualization.applicationgroups.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.desktopvirtualization.applicationgroups.yml) |
| [AVD Host Pools](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.DesktopVirtualization/hostpools) | [!['DesktopVirtualization: HostPools'](https://github.com/Azure/ResourceModules/actions/workflows/ms.desktopvirtualization.hostpools.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.desktopvirtualization.hostpools.yml) |
| [AVD Workspaces](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.DesktopVirtualization/workspaces) | [!['DesktopVirtualization: Workspaces'](https://github.com/Azure/ResourceModules/actions/workflows/ms.desktopvirtualization.workspaces.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.desktopvirtualization.workspaces.yml) |
| [Azure Compute Galleries](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Compute/galleries) | [!['Compute: Galleries'](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.galleries.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.galleries.yml) |
| [Azure Databricks](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Databricks/workspaces) | [!['Databricks: Workspaces'](https://github.com/Azure/ResourceModules/actions/workflows/ms.databricks.workspaces.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.databricks.workspaces.yml) |
| [Azure Firewalls](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/azureFirewalls) | [!['Network: AzureFirewalls'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.azurefirewalls.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.azurefirewalls.yml) |
| [Azure Health Bots](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.HealthBot/healthBots) | [!['HealthBot: HealthBots'](https://github.com/Azure/ResourceModules/actions/workflows/ms.healthbot.healthbots.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.healthbot.healthbots.yml) |
| [Azure Kubernetes Services](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.ContainerService/managedClusters) | [!['ContainerService: ManagedClusters'](https://github.com/Azure/ResourceModules/actions/workflows/ms.containerservice.managedclusters.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.containerservice.managedclusters.yml) |
| [Azure Monitor Private Link Scopes](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Insights/privateLinkScopes) | [!['Insights: PrivateLinkScopes'](https://github.com/Azure/ResourceModules/actions/workflows/ms.insights.privatelinkscopes.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.insights.privatelinkscopes.yml) |
| [Azure NetApp Files](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.NetApp/netAppAccounts) | [!['NetApp: NetAppAccounts'](https://github.com/Azure/ResourceModules/actions/workflows/ms.netapp.netappaccounts.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.netapp.netappaccounts.yml) |
| [Azure Security Center](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Security/azureSecurityCenter) | [!['Security: AzureSecurityCenter'](https://github.com/Azure/ResourceModules/actions/workflows/ms.security.azuresecuritycenter.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.security.azuresecuritycenter.yml) |
| [Bastion Hosts](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/bastionHosts) | [!['Network: BastionHosts'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.bastionhosts.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.bastionhosts.yml) |
| [Batch Accounts](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Batch/batchAccounts) | [!['Batch: BatchAccounts'](https://github.com/Azure/ResourceModules/actions/workflows/ms.batch.batchaccounts.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.batch.batchaccounts.yml) |
| [Budgets](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Consumption/budgets) | [!['Consumption: Budgets'](https://github.com/Azure/ResourceModules/actions/workflows/ms.consumption.budgets.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.consumption.budgets.yml) |
| [Cognitive Services](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.CognitiveServices/accounts) | [!['CognitiveServices: Accounts'](https://github.com/Azure/ResourceModules/actions/workflows/ms.cognitiveservices.accounts.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.cognitiveservices.accounts.yml) |
| [Compute Disks](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Compute/disks) | [!['Compute: Disks'](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.disks.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.disks.yml) |
| [Container Instances](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.ContainerInstance/containerGroups) | [!['ContainerInstance: ContainerGroups'](https://github.com/Azure/ResourceModules/actions/workflows/ms.containerinstance.containergroups.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.containerinstance.containergroups.yml) |
| [Container Registries](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.ContainerRegistry/registries) | [!['ContainerRegistry: Registries'](https://github.com/Azure/ResourceModules/actions/workflows/ms.containerregistry.registries.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.containerregistry.registries.yml) |
| [Data Factories](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.DataFactory/factories) | [!['DataFactory: Factories'](https://github.com/Azure/ResourceModules/actions/workflows/ms.datafactory.factories.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.datafactory.factories.yml) |
| [DDoS Protection Plans](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/ddosProtectionPlans) | [!['Network: DdosProtectionPlans'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.ddosprotectionplans.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.ddosprotectionplans.yml) |
| [Deployment Scripts](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Resources/deploymentScripts) | [!['Resources: DeploymentScripts'](https://github.com/Azure/ResourceModules/actions/workflows/ms.resources.deploymentscripts.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.resources.deploymentscripts.yml) |
| [Disk Encryption Sets](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Compute/diskEncryptionSets) | [!['Compute: DiskEncryptionSets'](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.diskencryptionsets.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.diskencryptionsets.yml) |
| [DocumentDB Database Accounts](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.DocumentDB/databaseAccounts) | [!['DocumentDB: DatabaseAccounts'](https://github.com/Azure/ResourceModules/actions/workflows/ms.documentdb.databaseaccounts.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.documentdb.databaseaccounts.yml) |
| [Event Grid Topics](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.EventGrid/topics) | [!['EventGrid: Topics'](https://github.com/Azure/ResourceModules/actions/workflows/ms.eventgrid.topics.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.eventgrid.topics.yml) |
| [Event Hub Namespaces](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.EventHub/namespaces) | [!['EventHub: Namespaces'](https://github.com/Azure/ResourceModules/actions/workflows/ms.eventhub.namespaces.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.eventhub.namespaces.yml) |
| [ExpressRoute Circuits](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/expressRouteCircuits) | [!['Network: ExpressRouteCircuits'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.expressroutecircuits.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.expressroutecircuits.yml) |
| [Image Templates](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.VirtualMachineImages/imageTemplates) | [!['VirtualMachineImages: ImageTemplates'](https://github.com/Azure/ResourceModules/actions/workflows/ms.virtualmachineimages.imagetemplates.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.virtualmachineimages.imagetemplates.yml) |
| [Images](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Compute/images) | [!['Compute: Images'](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.images.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.images.yml) |
| [IP Groups](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/ipGroups) | [!['Network: IpGroups'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.ipgroups.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.ipgroups.yml) |
| [Key Vaults](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.KeyVault/vaults) | [!['KeyVault: Vaults'](https://github.com/Azure/ResourceModules/actions/workflows/ms.keyvault.vaults.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.keyvault.vaults.yml) |
| [Load Balancers](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/loadBalancers) | [!['Network: LoadBalancers'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.loadbalancers.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.loadbalancers.yml) |
| [Local Network Gateways](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/localNetworkGateways) | [!['Network: LocalNetworkGateways'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.localnetworkgateways.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.localnetworkgateways.yml) |
| [Log Analytics Workspaces](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.OperationalInsights/workspaces) | [!['OperationalInsights: Workspaces'](https://github.com/Azure/ResourceModules/actions/workflows/ms.operationalinsights.workspaces.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.operationalinsights.workspaces.yml) |
| [Logic Apps](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Logic/workflows) | [!['Logic: Workflows'](https://github.com/Azure/ResourceModules/actions/workflows/ms.logic.workflows.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.logic.workflows.yml) |
| [Machine Learning Workspaces](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.MachineLearningServices/workspaces) | [!['MachineLearningServices: Workspaces'](https://github.com/Azure/ResourceModules/actions/workflows/ms.machinelearningservices.workspaces.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.machinelearningservices.workspaces.yml) |
| [Management Groups](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Management/managementGroups) | [!['Management: ManagementGroups'](https://github.com/Azure/ResourceModules/actions/workflows/ms.management.managementgroups.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.management.managementgroups.yml) |
| [Metric Alerts](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Insights/metricAlerts) | [!['Insights: MetricAlerts'](https://github.com/Azure/ResourceModules/actions/workflows/ms.insights.metricalerts.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.insights.metricalerts.yml) |
| [NAT Gateways](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/natGateways) | [!['Network: NatGateways'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.natgateways.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.natgateways.yml) |
| [Network Firewall Policies](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/firewallPolicies) | [!['Network: FirewallPolicies'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.firewallpolicies.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.firewallpolicies.yml) |
| [Network Security Groups](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/networkSecurityGroups) | [!['Network: NetworkSecurityGroups'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.networksecuritygroups.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.networksecuritygroups.yml) |
| [Network Watchers](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/networkWatchers) | [!['Network: NetworkWatchers'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.networkwatchers.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.networkwatchers.yml) |
| [Policy Assignments](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Authorization/policyAssignments) | [!['Authorization: PolicyAssignments'](https://github.com/Azure/ResourceModules/actions/workflows/ms.authorization.policyassignments.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.authorization.policyassignments.yml) |
| [Policy Definitions](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Authorization/policyDefinitions) | [!['Authorization: PolicyDefinitions'](https://github.com/Azure/ResourceModules/actions/workflows/ms.authorization.policydefinitions.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.authorization.policydefinitions.yml) |
| [Policy Exemptions](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Authorization/policyExemptions) | [!['Authorization: PolicyExemptions'](https://github.com/Azure/ResourceModules/actions/workflows/ms.authorization.policyexemptions.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.authorization.policyexemptions.yml) |
| [Policy Set Definitions](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Authorization/policySetDefinitions) | [!['Authorization: PolicySetDefinitions'](https://github.com/Azure/ResourceModules/actions/workflows/ms.authorization.policysetdefinitions.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.authorization.policysetdefinitions.yml) |
| [Private DNS Zones](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/privateDnsZones) | [!['Network: PrivateDnsZones'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.privatednszones.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.privatednszones.yml) |
| [Private Endpoints](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/privateEndpoints) | [!['Network: PrivateEndpoints'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.privateendpoints.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.privateendpoints.yml) |
| [Proximity Placement Groups](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Compute/proximityPlacementGroups) | [!['Compute: ProximityPlacementGroups'](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.proximityplacementgroups.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.proximityplacementgroups.yml) |
| [Public IP Addresses](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/publicIPAddresses) | [!['Network: PublicIpAddresses'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.publicipaddresses.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.publicipaddresses.yml) |
| [Public IP Prefixes](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/publicIPPrefixes) | [!['Network: PublicIpPrefixes'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.publicipprefixes.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.publicipprefixes.yml) |
| [Recovery Services Vaults](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.RecoveryServices/vaults) | [!['RecoveryServices: Vaults'](https://github.com/Azure/ResourceModules/actions/workflows/ms.recoveryservices.vaults.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.recoveryservices.vaults.yml) |
| [Registration Definitions](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.ManagedServices/registrationDefinitions) | [!['ManagedServices: RegistrationDefinitions'](https://github.com/Azure/ResourceModules/actions/workflows/ms.managedservices.registrationdefinitions.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.managedservices.registrationdefinitions.yml) |
| [Resource Groups](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Resources/resourceGroups) | [!['Resources: ResourceGroups'](https://github.com/Azure/ResourceModules/actions/workflows/ms.resources.resourcegroups.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.resources.resourcegroups.yml) |
| [Role Assignments](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Authorization/roleAssignments) | [!['Authorization: RoleAssignments'](https://github.com/Azure/ResourceModules/actions/workflows/ms.authorization.roleassignments.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.authorization.roleassignments.yml) |
| [Role Definitions](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Authorization/roleDefinitions) | [!['Authorization: RoleDefinitions'](https://github.com/Azure/ResourceModules/actions/workflows/ms.authorization.roledefinitions.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.authorization.roledefinitions.yml) |
| [Route Tables](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/routeTables) | [!['Network: RouteTables'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.routetables.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.routetables.yml) |
| [Scheduled Query Rules](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Insights/scheduledQueryRules) | [!['Insights: ScheduledQueryRules'](https://github.com/Azure/ResourceModules/actions/workflows/ms.insights.scheduledqueryrules.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.insights.scheduledqueryrules.yml) |
| [Service Bus Namespaces](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.ServiceBus/namespaces) | [!['ServiceBus: Namespaces'](https://github.com/Azure/ResourceModules/actions/workflows/ms.servicebus.namespaces.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.servicebus.namespaces.yml) |
| [ServiceFabric Cluster](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.ServiceFabric/clusters) | [!['Service Fabric: Clusters'](https://github.com/Azure/ResourceModules/actions/workflows/ms.servicefabric.clusters.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.servicefabric.clusters.yml) |
| [SQL Managed Instances](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Sql/managedInstances) | [!['Sql: ManagedInstances'](https://github.com/Azure/ResourceModules/actions/workflows/ms.sql.managedinstances.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.sql.managedinstances.yml) |
| [SQL Servers](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Sql/servers) | [!['Sql: Servers'](https://github.com/Azure/ResourceModules/actions/workflows/ms.sql.servers.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.sql.servers.yml) |
| [Storage Accounts](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Storage/storageAccounts) | [!['Storage: StorageAccounts'](https://github.com/Azure/ResourceModules/actions/workflows/ms.storage.storageaccounts.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.storage.storageaccounts.yml) |
| [Synapse PrivateLinkHubs](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Synapse/privateLinkHubs) | [!['Synapse: PrivateLinkHubs'](https://github.com/Azure/ResourceModules/actions/workflows/ms.synapse.privatelinkhubs.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.synapse.privatelinkhubs.yml) |
| [Traffic Manager Profiles](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/trafficmanagerprofiles) | [!['Network: TrafficManagerProfiles'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.trafficmanagerprofiles.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.trafficmanagerprofiles.yml) |
| [User Assigned Identities](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.ManagedIdentity/userAssignedIdentities) | [!['ManagedIdentity: UserAssignedIdentities'](https://github.com/Azure/ResourceModules/actions/workflows/ms.managedidentity.userassignedidentities.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.managedidentity.userassignedidentities.yml) |
| [Virtual Hub](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/virtualHubs) | [!['Network: Virtual Hubs'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.virtualhubs.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.virtualhubs.yml) |
| [Virtual Machine Scale Sets](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Compute/virtualMachineScaleSets) | [!['Compute: VirtualMachineScaleSets'](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.virtualmachinescalesets.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.virtualmachinescalesets.yml) |
| [Virtual Machines](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Compute/virtualMachines) | [!['Compute: VirtualMachines'](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.virtualmachines.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.compute.virtualmachines.yml) |
| [Virtual Network Gateway Connections](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/connections) | [!['Network: Connections'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.connections.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.connections.yml) |
| [Virtual Network Gateways](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/virtualNetworkGateways) | [!['Network: VirtualNetworkGateways'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.virtualnetworkgateways.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.virtualnetworkgateways.yml) |
| [Virtual Networks](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/virtualNetworks) | [!['Network: VirtualNetworks'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.virtualnetworks.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.virtualnetworks.yml) |
| [Virtual WANs](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Network/virtualWans) | [!['Network: VirtualWans'](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.virtualwans.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.network.virtualwans.yml) |
| [Web/Function Apps](https://github.com/Azure/ResourceModules/tree/main/arm/Microsoft.Web/sites) | [!['Web: Sites'](https://github.com/Azure/ResourceModules/actions/workflows/ms.web.sites.yml/badge.svg)](https://github.com/Azure/ResourceModules/actions/workflows/ms.web.sites.yml) |

## Tooling

| Name | Status | Docs |
| - | - | - |
| [ConvertTo-ARMTemplate](https://github.com/Azure/ResourceModules/blob/main/utilities/tools/ConvertTo-ARMTemplate.ps1) | [![.Platform: Test - ConvertTo-ARMTemplate.ps1](https://github.com/Azure/ResourceModules/actions/workflows/platform.convertToArmTemplate.tests.yml/badge.svg?branch=main)](https://github.com/Azure/ResourceModules/actions/workflows/platform.convertToArmTemplate.tests.yml) | [link](https://github.com/Azure/ResourceModules/wiki/UtilitiesConvertToARMTemplate) |

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

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
