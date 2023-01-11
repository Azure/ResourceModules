This section provides an overview of the library's feature set.

---

### _Navigation_

- [Feature table](#feature-table)
  - [Legend](#legend)

---

# Feature table

| # | Module | RBAC | Locks | Tags | Diag | PE | PIP | # children | # lines |
| - | - | - | - | - | - | - | - | - | - |
| 1 | MS.Batch<p>batchAccounts |  | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | 239 |
| 2 | MS.Consumption<p>budgets |  |  |  |  |  |  |  | 89 |
| 3 | MS.ServiceFabric<p>clusters | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:1] | 281 |
| 4 | MS.Storage<p>storageAccounts | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:6, L2:4, L3:1] | 369 |
| 5 | MS.Authorization<p>roleAssignments |  |  |  |  |  |  | [L1:3] | 104 |
| 6 | MS.Authorization<p>roleDefinitions |  |  |  |  |  |  | [L1:3] | 91 |
| 7 | MS.Authorization<p>policyExemptions |  |  |  |  |  |  | [L1:3] | 111 |
| 8 | MS.Authorization<p>locks |  |  |  |  |  |  | [L1:2] | 59 |
| 9 | MS.Authorization<p>policyAssignments |  |  |  |  |  |  | [L1:3] | 140 |
| 10 | MS.Authorization<p>policySetDefinitions |  |  |  |  |  |  | [L1:2] | 73 |
| 11 | MS.Authorization<p>policyDefinitions |  |  |  |  |  |  | [L1:2] | 83 |
| 12 | MS.ContainerService<p>managedClusters | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:1] | 509 |
| 13 | MS.Sql<p>managedInstances | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:6, L2:2] | 348 |
| 14 | MS.Sql<p>servers | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  | [L1:7] | 272 |
| 15 | MS.AAD<p>DomainServices | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 234 |
| 16 | MS.ManagedIdentity<p>userAssignedIdentities | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 64 |
| 17 | MS.EventHub<p>namespaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:4, L2:2] | 285 |
| 18 | MS.DesktopVirtualization<p>workspaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 127 |
| 19 | MS.DesktopVirtualization<p>scalingplans | :white_check_mark: |  | :white_check_mark: | :white_check_mark: |  |  |  | 162 |
| 20 | MS.DesktopVirtualization<p>applicationgroups | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:1] | 156 |
| 21 | MS.DesktopVirtualization<p>hostpools | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 185 |
| 22 | MS.DocumentDB<p>databaseAccounts | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:3, L2:3] | 315 |
| 23 | MS.Automation<p>automationAccounts | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:6] | 377 |
| 24 | MS.DBforPostgreSQL<p>flexibleServers | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:3] | 309 |
| 25 | MS.EventGrid<p>domains | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | 175 |
| 26 | MS.EventGrid<p>topics | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | 169 |
| 27 | MS.EventGrid<p>systemTopics | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 150 |
| 28 | MS.HealthBot<p>healthBots | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 68 |
| 29 | MS.CDN<p>profiles | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:1, L2:1] | 106 |
| 30 | MS.PolicyInsights<p>remediations |  |  |  |  |  |  | [L1:3] | 103 |
| 31 | MS.DataProtection<p>backupVaults | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:1] | 105 |
| 32 | MS.Compute<p>disks | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 170 |
| 33 | MS.Compute<p>virtualMachineScaleSets | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:1] | 560 |
| 34 | MS.Compute<p>virtualMachines | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:1] | 637 |
| 35 | MS.Compute<p>diskEncryptionSets | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 105 |
| 36 | MS.Compute<p>proximityPlacementGroups | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 80 |
| 37 | MS.Compute<p>images | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 107 |
| 38 | MS.Compute<p>availabilitySets | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 83 |
| 39 | MS.Compute<p>galleries | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:2] | 123 |
| 40 | MS.ApiManagement<p>service | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:11, L2:3] | 424 |
| 41 | MS.OperationalInsights<p>workspaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:5] | 271 |
| 42 | MS.ContainerRegistry<p>registries | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:2] | 349 |
| 43 | MS.ServiceBus<p>namespaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:6, L2:2] | 340 |
| 44 | MS.Web<p>hostingEnvironments | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 175 |
| 45 | MS.Web<p>serverfarms | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 159 |
| 46 | MS.Web<p>connections | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 89 |
| 47 | MS.Web<p>sites | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:3, L2:2] | 317 |
| 48 | MS.Web<p>staticSites | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  | [L1:3] | 193 |
| 49 | MS.ManagedServices<p>registrationDefinitions |  |  |  |  |  |  |  | 60 |
| 50 | MS.KubernetesConfiguration<p>extensions |  |  |  |  |  |  |  | 63 |
| 51 | MS.KubernetesConfiguration<p>fluxConfigurations |  |  |  |  |  |  |  | 67 |
| 52 | MS.SignalRService<p>webPubSub | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  |  | 156 |
| 53 | MS.Network<p>vpnGateways |  | :white_check_mark: | :white_check_mark: |  |  |  | [L1:2] | 104 |
| 54 | MS.Network<p>virtualHubs |  | :white_check_mark: | :white_check_mark: |  |  |  | [L1:2] | 143 |
| 55 | MS.Network<p>trafficmanagerprofiles | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 175 |
| 56 | MS.Network<p>firewallPolicies |  |  | :white_check_mark: |  |  |  | [L1:1] | 153 |
| 57 | MS.Network<p>networkWatchers | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:2] | 97 |
| 58 | MS.Network<p>applicationGateways | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 317 |
| 59 | MS.Network<p>applicationGatewayWebApplicationFirewallPolicies |  |  | :white_check_mark: |  |  |  |  | 44 |
| 60 | MS.Network<p>applicationSecurityGroups | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 63 |
| 61 | MS.Network<p>publicIPPrefixes | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 74 |
| 62 | MS.Network<p>ddosProtectionPlans | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 64 |
| 63 | MS.Network<p>networkManagers | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:4, L2:2, L3:1] | 133 |
| 64 | MS.Network<p>privateDnsZones | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:9] | 189 |
| 65 | MS.Network<p>virtualNetworkGateways | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 358 |
| 66 | MS.Network<p>virtualNetworks | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:2] | 243 |
| 67 | MS.Network<p>localNetworkGateways | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 88 |
| 68 | MS.Network<p>expressRouteCircuits | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 195 |
| 69 | MS.Network<p>natGateways | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 193 |
| 70 | MS.Network<p>ipGroups | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 68 |
| 71 | MS.Network<p>connections |  | :white_check_mark: | :white_check_mark: |  |  |  |  | 107 |
| 72 | MS.Network<p>loadBalancers | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:2] | 238 |
| 73 | MS.Network<p>privateLinkServices | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 85 |
| 74 | MS.Network<p>azureFirewalls | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  | 285 |
| 75 | MS.Network<p>dnsResolvers | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 100 |
| 76 | MS.Network<p>frontDoors | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 161 |
| 77 | MS.Network<p>vpnSites | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 88 |
| 78 | MS.Network<p>networkSecurityGroups | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:1] | 162 |
| 79 | MS.Network<p>networkInterfaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 144 |
| 80 | MS.Network<p>publicIPAddresses | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 187 |
| 81 | MS.Network<p>routeTables | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 70 |
| 82 | MS.Network<p>virtualWans | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 80 |
| 83 | MS.Network<p>bastionHosts | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  | 215 |
| 84 | MS.Network<p>privateEndpoints | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:1] | 108 |
| 85 | MS.Management<p>managementGroups |  |  |  |  |  |  |  | 44 |
| 86 | MS.AnalysisServices<p>servers | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 153 |
| 87 | MS.DataFactory<p>factories | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:2, L2:1] | 257 |
| 88 | MS.Synapse<p>workspaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:1] | 273 |
| 89 | MS.Synapse<p>privateLinkHubs | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  |  | 90 |
| 90 | MS.MachineLearningServices<p>workspaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:1] | 284 |
| 91 | MS.Resources<p>tags |  |  | :white_check_mark: |  |  |  | [L1:2] | 51 |
| 92 | MS.Resources<p>deploymentScripts |  | :white_check_mark: | :white_check_mark: |  |  |  |  | 111 |
| 93 | MS.Resources<p>resourceGroups | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 67 |
| 94 | MS.Logic<p>workflows | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 207 |
| 95 | MS.ContainerInstance<p>containerGroups |  | :white_check_mark: | :white_check_mark: |  |  |  |  | 154 |
| 96 | MS.Insights<p>scheduledQueryRules | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 106 |
| 97 | MS.Insights<p>metricAlerts | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 122 |
| 98 | MS.Insights<p>diagnosticSettings |  |  |  | :white_check_mark: |  |  |  | 83 |
| 99 | MS.Insights<p>activityLogAlerts | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 74 |
| 100 | MS.Insights<p>privateLinkScopes | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  | [L1:1] | 100 |
| 101 | MS.Insights<p>actionGroups | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 85 |
| 102 | MS.Insights<p>components | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 99 |
| 103 | MS.AppConfiguration<p>configurationStores | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:1] | 218 |
| 104 | MS.KeyVault<p>vaults | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:3] | 279 |
| 105 | MS.NetApp<p>netAppAccounts | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:1, L2:1] | 106 |
| 106 | MS.CognitiveServices<p>accounts | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | 294 |
| 107 | MS.RecoveryServices<p>vaults | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:7, L2:2, L3:1] | 299 |
| 108 | MS.Databricks<p>workspaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 143 |
| 109 | MS.DevTestLab<p>labs | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:6, L2:1] | 262 |
| 110 | MS.OperationsManagement<p>solutions |  |  |  |  |  |  |  | 50 |
| 111 | MS.Cache<p>redis | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | 247 |
| 112 | MS.Security<p>azureSecurityCenter |  |  |  |  |  |  |  | 217 |
| 113 | MS.VirtualMachineImages<p>imageTemplates | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 197 |
| 114 | MS.Maintenance<p>maintenanceConfigurations | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 101 |
| 115 | MS.PowerBIDedicated<p>capacities | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 96 |
| Sum | | 90 | 88 | 99 | 50 | 22 | 2 | 175 | 19986 |

## Legend

| Term | Description |
| - | - |
| `Module` | The name of the module. |
| `RBAC` | Whether the module can deploy _Role Assignments_. |
| `Locks` | Whether the module can deploy _Locks_. |
| `Tags` | Whether the module can deploy _Tags_. |
| `Diag` | Whether the module can deploy _Diagnostic Settings_. |
| `PE` | Whether the module can deploy _Private Endpoints_. |
| `PIP` | Whether the module can deploy a _Public IP_ as a secondary resource. |
| `# children` | The number of children in the given module. Children (if any) are displayed in format `[L1:5, L2:4, L3:1]`. Each item (separated via ',') shows the level of nesting in the front (e.g. L1) and the number of children in this level (separated by a colon ':'). In the previous example, the module has 5 direct children, 4 of them have direct children themselves and 1 of them has 1 more child. |
| `# lines` | The number of lines in the module Bicep deployment file. |
