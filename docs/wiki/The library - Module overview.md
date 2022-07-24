This section provides an overview of the library's feature set.

---

### _Navigation_

- [Feature table](#feature-table)
  - [Legend](#legend)

---

# Feature table

| # | Module | RBAC | Locks | Tags | Diag | PE | PIP | # children | # lines |
| - | - | - | - | - | - | - | - | - | - |
| 1 | MS.AAD<p>DomainServices | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 226 |
| 2 | MS.AnalysisServices<p>servers | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 141 |
| 3 | MS.ApiManagement<p>service | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:11, L2:3] | 411 |
| 4 | MS.AppConfiguration<p>configurationStores | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:1] | 203 |
| 5 | MS.Authorization<p>locks |  |  |  |  |  |  | [L1:2] | 57 |
| 6 | MS.Authorization<p>policyAssignments |  |  |  |  |  |  | [L1:3] | 130 |
| 7 | MS.Authorization<p>policyDefinitions |  |  |  |  |  |  | [L1:2] | 84 |
| 8 | MS.Authorization<p>policyExemptions |  |  |  |  |  |  | [L1:3] | 104 |
| 9 | MS.Authorization<p>policySetDefinitions |  |  |  |  |  |  | [L1:2] | 75 |
| 10 | MS.Authorization<p>roleAssignments |  |  |  |  |  |  | [L1:3] | 104 |
| 11 | MS.Authorization<p>roleDefinitions |  |  |  |  |  |  | [L1:3] | 91 |
| 12 | MS.Automation<p>automationAccounts | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:6] | 360 |
| 13 | MS.Batch<p>batchAccounts |  | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | 207 |
| 14 | MS.Cache<p>redis | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | 235 |
| 15 | MS.CognitiveServices<p>accounts | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | 246 |
| 16 | MS.Compute<p>availabilitySets | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 81 |
| 17 | MS.Compute<p>diskEncryptionSets | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 103 |
| 18 | MS.Compute<p>disks | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 168 |
| 19 | MS.Compute<p>galleries | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:1] | 100 |
| 20 | MS.Compute<p>images | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 70 |
| 21 | MS.Compute<p>proximityPlacementGroups | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 69 |
| 22 | MS.Compute<p>virtualMachines | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:1] | 575 |
| 23 | MS.Compute<p>virtualMachineScaleSets | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:1] | 570 |
| 24 | MS.Consumption<p>budgets |  |  |  |  |  |  |  | 90 |
| 25 | MS.ContainerInstance<p>containerGroups |  | :white_check_mark: | :white_check_mark: |  |  |  |  | 113 |
| 26 | MS.ContainerRegistry<p>registries | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:2] | 306 |
| 27 | MS.ContainerService<p>managedClusters | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:1] | 493 |
| 28 | MS.Databricks<p>workspaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 139 |
| 29 | MS.DataFactory<p>factories | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:2] | 227 |
| 30 | MS.DataProtection<p>backupVaults | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:1] | 105 |
| 31 | MS.DesktopVirtualization<p>applicationgroups | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:1] | 145 |
| 32 | MS.DesktopVirtualization<p>hostpools | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 177 |
| 33 | MS.DesktopVirtualization<p>scalingplans | :white_check_mark: |  | :white_check_mark: | :white_check_mark: |  |  |  | 136 |
| 34 | MS.DesktopVirtualization<p>workspaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 117 |
| 35 | MS.DocumentDB<p>databaseAccounts | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:3, L2:3] | 310 |
| 36 | MS.EventGrid<p>systemTopics | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 137 |
| 37 | MS.EventGrid<p>topics | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | 154 |
| 38 | MS.EventHub<p>namespaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:4, L2:2] | 279 |
| 39 | MS.HealthBot<p>healthBots | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 66 |
| 40 | MS.Insights<p>actionGroups | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 83 |
| 41 | MS.Insights<p>activityLogAlerts | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 72 |
| 42 | MS.Insights<p>components | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 97 |
| 43 | MS.Insights<p>diagnosticSettings |  |  |  | :white_check_mark: |  |  |  | 79 |
| 44 | MS.Insights<p>metricAlerts | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 120 |
| 45 | MS.Insights<p>privateLinkScopes | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  | [L1:1] | 95 |
| 46 | MS.Insights<p>scheduledQueryRules | :white_check_mark: |  | :white_check_mark: |  |  |  |  | 104 |
| 47 | MS.KeyVault<p>vaults | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:3] | 283 |
| 48 | MS.KubernetesConfiguration<p>extensions |  |  |  |  |  |  |  | 63 |
| 49 | MS.KubernetesConfiguration<p>fluxConfigurations |  |  |  |  |  |  |  | 67 |
| 50 | MS.Logic<p>workflows | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 192 |
| 51 | MS.MachineLearningServices<p>workspaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:1] | 267 |
| 52 | MS.ManagedIdentity<p>userAssignedIdentities | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 62 |
| 53 | MS.ManagedServices<p>registrationDefinitions |  |  |  |  |  |  |  | 60 |
| 54 | MS.Management<p>managementGroups |  |  |  |  |  |  |  | 40 |
| 55 | MS.NetApp<p>netAppAccounts | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:1, L2:1] | 104 |
| 56 | MS.Network<p>applicationGateways | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 306 |
| 57 | MS.Network<p>applicationSecurityGroups | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 61 |
| 58 | MS.Network<p>azureFirewalls | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  | 260 |
| 59 | MS.Network<p>bastionHosts | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  | 194 |
| 60 | MS.Network<p>connections |  | :white_check_mark: | :white_check_mark: |  |  |  |  | 107 |
| 61 | MS.Network<p>ddosProtectionPlans | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 62 |
| 62 | MS.Network<p>expressRouteCircuits | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 186 |
| 63 | MS.Network<p>firewallPolicies |  |  | :white_check_mark: |  |  |  | [L1:1] | 152 |
| 64 | MS.Network<p>frontDoors | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 148 |
| 65 | MS.Network<p>ipGroups | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 66 |
| 66 | MS.Network<p>loadBalancers | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:2] | 236 |
| 67 | MS.Network<p>localNetworkGateways | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 86 |
| 68 | MS.Network<p>natGateways | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 182 |
| 69 | MS.Network<p>networkInterfaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 142 |
| 70 | MS.Network<p>networkSecurityGroups | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:1] | 150 |
| 71 | MS.Network<p>networkWatchers | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:2] | 95 |
| 72 | MS.Network<p>privateDnsZones | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:9] | 187 |
| 73 | MS.Network<p>privateEndpoints | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:1] | 97 |
| 74 | MS.Network<p>publicIPAddresses | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 166 |
| 75 | MS.Network<p>publicIPPrefixes | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 72 |
| 76 | MS.Network<p>routeTables | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 68 |
| 77 | MS.Network<p>trafficmanagerprofiles | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 162 |
| 78 | MS.Network<p>virtualHubs |  | :white_check_mark: | :white_check_mark: |  |  |  | [L1:2] | 148 |
| 79 | MS.Network<p>virtualNetworkGateways | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 359 |
| 80 | MS.Network<p>virtualNetworks | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:2] | 228 |
| 81 | MS.Network<p>virtualWans | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 78 |
| 82 | MS.Network<p>vpnGateways |  | :white_check_mark: | :white_check_mark: |  |  |  | [L1:2] | 104 |
| 83 | MS.Network<p>vpnSites | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 88 |
| 84 | MS.OperationalInsights<p>workspaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:5] | 258 |
| 85 | MS.OperationsManagement<p>solutions |  |  |  |  |  |  |  | 50 |
| 86 | MS.RecoveryServices<p>vaults | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:6, L2:2, L3:1] | 269 |
| 87 | MS.Resources<p>deploymentScripts |  | :white_check_mark: | :white_check_mark: |  |  |  |  | 111 |
| 88 | MS.Resources<p>resourceGroups | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 62 |
| 89 | MS.Resources<p>tags |  |  | :white_check_mark: |  |  |  | [L1:2] | 51 |
| 90 | MS.Security<p>azureSecurityCenter |  |  |  |  |  |  |  | 217 |
| 91 | MS.ServiceBus<p>namespaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:6, L2:2] | 329 |
| 92 | MS.ServiceFabric<p>clusters | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | [L1:1] | 279 |
| 93 | MS.SignalRService<p>webPubSub | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  |  | 151 |
| 94 | MS.Sql<p>managedInstances | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  | [L1:6, L2:2] | 324 |
| 95 | MS.Sql<p>servers | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  | [L1:4] | 204 |
| 96 | MS.Storage<p>storageAccounts | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:5, L2:4, L3:1] | 346 |
| 97 | MS.Synapse<p>privateLinkHubs | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  |  | 85 |
| 98 | MS.Synapse<p>workspaces | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:1] | 263 |
| 99 | MS.VirtualMachineImages<p>imageTemplates | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 163 |
| 100 | MS.Web<p>connections | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  |  | 86 |
| 101 | MS.Web<p>hostingEnvironments | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 162 |
| 102 | MS.Web<p>serverfarms | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |  |  | 154 |
| 103 | MS.Web<p>sites | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | [L1:2] | 248 |
| 104 | MS.Web<p>staticSites | :white_check_mark: | :white_check_mark: | :white_check_mark: |  | :white_check_mark: |  |  | 144 |
| Sum | | 81 | 79 | 89 | 48 | 21 | 2 | 140 | 17338 |





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
