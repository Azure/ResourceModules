This section provides an overview of the library's feature set.

---

### _Navigation_

- [Feature table](#feature-table)
  - [Legend](#legend)

---

# Feature table

| # | Module | RBAC | Locks | Tags | Diag | PE | PIP | # children | # lines |
| - | - | - | - | - | - | - | - | - | - |
| 1 | MS.HealthBot<p>healthBots | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 68 |
| 2 | MS.KubernetesConfiguration<p>extensions |  |  |  |  |  |  |  | 63 |
| 3 | MS.KubernetesConfiguration<p>fluxConfigurations |  |  |  |  |  |  |  | 67 |
| 4 | MS.Cache<p>redis | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | 233 |
| 5 | MS.EventGrid<p>topics | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | 156 |
| 6 | MS.EventGrid<p>systemTopics | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 139 |
| 7 | MS.Compute<p>diskEncryptionSets | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 105 |
| 8 | MS.Compute<p>virtualMachineScaleSets | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:1] | 560 |
| 9 | MS.Compute<p>images | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 107 |
| 10 | MS.Compute<p>disks | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 170 |
| 11 | MS.Compute<p>proximityPlacementGroups | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 80 |
| 12 | MS.Compute<p>galleries | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:1] | 102 |
| 13 | MS.Compute<p>availabilitySets | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 83 |
| 14 | MS.Compute<p>virtualMachines | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:1] | 586 |
| 15 | MS.Consumption<p>budgets |  |  |  |  |  |  |  | 89 |
| 16 | MS.DesktopVirtualization<p>hostpools | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 179 |
| 17 | MS.DesktopVirtualization<p>scalingplans | :white_check_mark: |  | :white_check_mark: | :white_check_mark: |  |  |  | 151 |
| 18 | MS.DesktopVirtualization<p>workspaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 119 |
| 19 | MS.DesktopVirtualization<p>applicationgroups | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:1] | 147 |
| 20 | MS.AnalysisServices<p>servers | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 143 |
| 21 | MS.ContainerRegistry<p>registries | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:2] | 333 |
| 22 | MS.MachineLearningServices<p>workspaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:1] | 277 |
| 23 | MS.Databricks<p>workspaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 141 |
| 24 | MS.ContainerService<p>managedClusters | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:1] | 504 |
| 25 | MS.EventHub<p>namespaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:4, L2:2] | 279 |
| 26 | MS.NetApp<p>netAppAccounts | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:1, L2:1] | 106 |
| 27 | MS.AAD<p>DomainServices | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 231 |
| 28 | MS.Logic<p>workflows | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 196 |
| 29 | MS.ServiceFabric<p>clusters | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:1] | 281 |
| 30 | MS.AppConfiguration<p>configurationStores | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:1] | 205 |
| 31 | MS.DocumentDB<p>databaseAccounts | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:3, L2:3] | 312 |
| 32 | MS.OperationsManagement<p>solutions |  |  |  |  |  |  |  | 50 |
| 33 | MS.DataFactory<p>factories | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:2, L2:1] | 251 |
| 34 | MS.Insights<p>actionGroups | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 85 |
| 35 | MS.Insights<p>metricAlerts | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 122 |
| 36 | MS.Insights<p>activityLogAlerts | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 74 |
| 37 | MS.Insights<p>components | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 99 |
| 38 | MS.Insights<p>diagnosticSettings |  |  |  | :white_check_mark: |  |  |  | 79 |
| 39 | MS.Insights<p>privateLinkScopes | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  | [L1:1] | 97 |
| 40 | MS.Insights<p>scheduledQueryRules | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 106 |
| 41 | MS.DBforPostgreSQL<p>flexibleServers | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:3] | 269 |
| 42 | MS.Web<p>hostingEnvironments | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 164 |
| 43 | MS.Web<p>sites | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:2] | 257 |
| 44 | MS.Web<p>staticSites | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  | [L1:3] | 190 |
| 45 | MS.Web<p>connections | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 89 |
| 46 | MS.Web<p>serverfarms | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 159 |
| 47 | MS.ApiManagement<p>service | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:11, L2:3] | 413 |
| 48 | MS.Management<p>managementGroups |  |  |  |  |  |  |  | 44 |
| 49 | MS.OperationalInsights<p>workspaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:5] | 260 |
| 50 | MS.Authorization<p>roleAssignments |  |  |  |  |  |  | [L1:3] | 104 |
| 51 | MS.Authorization<p>policyDefinitions |  |  |  |  |  |  | [L1:2] | 82 |
| 52 | MS.Authorization<p>roleDefinitions |  |  |  |  |  |  | [L1:3] | 91 |
| 53 | MS.Authorization<p>policyExemptions |  |  |  |  |  |  | [L1:3] | 111 |
| 54 | MS.Authorization<p>locks |  |  |  |  |  |  | [L1:2] | 59 |
| 55 | MS.Authorization<p>policySetDefinitions |  |  |  |  |  |  | [L1:2] | 73 |
| 56 | MS.Authorization<p>policyAssignments |  |  |  |  |  |  | [L1:3] | 130 |
| 57 | MS.ContainerInstance<p>containerGroups |  | :white_check_mark: | :white_check_mark: |  |  |  |  | 84 |
| 58 | MS.Synapse<p>workspaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:1] | 264 |
| 59 | MS.Synapse<p>privateLinkHubs | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  |  | 87 |
| 60 | MS.Automation<p>automationAccounts | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:6] | 365 |
| 61 | MS.DataProtection<p>backupVaults | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:1] | 105 |
| 62 | MS.ServiceBus<p>namespaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:6, L2:2] | 326 |
| 63 | MS.PowerBIDedicated<p>capacities | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 96 |
| 64 | MS.Sql<p>managedInstances | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:6, L2:2] | 338 |
| 65 | MS.Sql<p>servers | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  | [L1:6] | 254 |
| 66 | MS.RecoveryServices<p>vaults | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:7, L2:2, L3:1] | 291 |
| 67 | MS.ManagedIdentity<p>userAssignedIdentities | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 64 |
| 68 | MS.Storage<p>storageAccounts | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:5, L2:4, L3:1] | 343 |
| 69 | MS.VirtualMachineImages<p>imageTemplates | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 167 |
| 70 | MS.Network<p>networkWatchers | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:2] | 97 |
| 71 | MS.Network<p>expressRouteCircuits | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 188 |
| 72 | MS.Network<p>trafficmanagerprofiles | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 164 |
| 73 | MS.Network<p>vpnGateways |  | :white_check_mark: | :white_check_mark: |  |  |  | [L1:2] | 104 |
| 74 | MS.Network<p>frontDoors | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 151 |
| 75 | MS.Network<p>privateEndpoints | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:1] | 108 |
| 76 | MS.Network<p>virtualWans | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 80 |
| 77 | MS.Network<p>virtualHubs |  | :white_check_mark: | :white_check_mark: |  |  |  | [L1:2] | 148 |
| 78 | MS.Network<p>applicationGatewayWebApplicationFirewallPolicies |  |  | :white_check_mark: |  |  |  |  | 44 |
| 79 | MS.Network<p>publicIPAddresses | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 167 |
| 80 | MS.Network<p>ddosProtectionPlans | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 64 |
| 81 | MS.Network<p>virtualNetworks | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:2] | 230 |
| 82 | MS.Network<p>publicIPPrefixes | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 74 |
| 83 | MS.Network<p>privateLinkServices | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 85 |
| 84 | MS.Network<p>connections |  | :white_check_mark: | :white_check_mark: |  |  |  |  | 107 |
| 85 | MS.Network<p>azureFirewalls | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  | 265 |
| 86 | MS.Network<p>firewallPolicies |  |  | :white_check_mark: |  |  |  | [L1:1] | 153 |
| 87 | MS.Network<p>ipGroups | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 68 |
| 88 | MS.Network<p>bastionHosts | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  | 204 |
| 89 | MS.Network<p>privateDnsZones | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:9] | 189 |
| 90 | MS.Network<p>networkSecurityGroups | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:1] | 152 |
| 91 | MS.Network<p>natGateways | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 184 |
| 92 | MS.Network<p>virtualNetworkGateways | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 378 |
| 93 | MS.Network<p>localNetworkGateways | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 88 |
| 94 | MS.Network<p>loadBalancers | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:2] | 238 |
| 95 | MS.Network<p>vpnSites | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 88 |
| 96 | MS.Network<p>routeTables | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 70 |
| 97 | MS.Network<p>dnsResolvers | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 100 |
| 98 | MS.Network<p>applicationGateways | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 308 |
| 99 | MS.Network<p>networkInterfaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 144 |
| 100 | MS.Network<p>applicationSecurityGroups | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 63 |
| 101 | MS.CognitiveServices<p>accounts | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | 252 |
| 102 | MS.Maintenance<p>maintenanceConfigurations | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 101 |
| 103 | MS.KeyVault<p>vaults | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:3] | 278 |
| 104 | MS.SignalRService<p>webPubSub | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  |  | 153 |
| 105 | MS.Security<p>azureSecurityCenter |  |  |  |  |  |  |  | 217 |
| 106 | MS.Batch<p>batchAccounts |  | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | 225 |
| 107 | MS.ManagedServices<p>registrationDefinitions |  |  |  |  |  |  |  | 60 |
| 108 | MS.Resources<p>resourceGroups | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 64 |
| 109 | MS.Resources<p>tags |  |  | :white_check_mark: |  |  |  | [L1:2] | 51 |
| 110 | MS.Resources<p>deploymentScripts |  | :white_check_mark: | :white_check_mark: |  |  |  |  | 111 |
| Sum | | 86 | 84 | 95 | 49 | 21 | 2 | 150 | 18469 |

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
