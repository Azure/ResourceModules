# Azure Kubernetes Service (AKS) Managed Clusters `[Microsoft.ContainerService/managedClusters]`

This module deploys an Azure Kubernetes Service (AKS) Managed Cluster.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)
- [Notes](#Notes)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.ContainerService/managedClusters` | [2023-06-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2023-06-02-preview/managedClusters) |
| `Microsoft.ContainerService/managedClusters/agentPools` | [2023-06-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2023-06-02-preview/managedClusters/agentPools) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KubernetesConfiguration/extensions` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/extensions) |
| `Microsoft.KubernetesConfiguration/fluxConfigurations` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/fluxConfigurations) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Specifies the name of the AKS cluster. |
| `primaryAgentPoolProfile` | array | Properties of the primary agent pool. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `aksServicePrincipalProfile` | object | `{object}` | Information about a service principal identity for the cluster to use for manipulating Azure APIs. Required if no managed identities are assigned to the cluster. |
| `appGatewayResourceId` | string | `''` | Specifies the resource ID of connected application gateway. Required if `ingressApplicationGatewayEnabled` is set to `true`. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `aadProfileAdminGroupObjectIDs` | array | `[]` |  | Specifies the AAD group object IDs that will have admin role of the cluster. |
| `aadProfileClientAppID` | string | `''` |  | The client AAD application ID. |
| `aadProfileEnableAzureRBAC` | bool | `[parameters('enableRBAC')]` |  | Specifies whether to enable Azure RBAC for Kubernetes authorization. |
| `aadProfileManaged` | bool | `True` |  | Specifies whether to enable managed AAD integration. |
| `aadProfileServerAppID` | string | `''` |  | The server AAD application ID. |
| `aadProfileServerAppSecret` | string | `''` |  | The server AAD application secret. |
| `aadProfileTenantId` | string | `[subscription().tenantId]` |  | Specifies the tenant ID of the Azure Active Directory used by the AKS cluster for authentication. |
| `aciConnectorLinuxEnabled` | bool | `False` |  | Specifies whether the aciConnectorLinux add-on is enabled or not. |
| `adminUsername` | string | `'azureuser'` |  | Specifies the administrator username of Linux virtual machines. |
| `agentPools` | array | `[]` |  | Define one or more secondary/additional agent pools. |
| `authorizedIPRanges` | array | `[]` |  | IP ranges are specified in CIDR format, e.g. 137.117.106.88/29. This feature is not compatible with clusters that use Public IP Per Node, or clusters that are using a Basic Load Balancer. |
| `autoScalerProfileBalanceSimilarNodeGroups` | string | `'false'` | `[false, true]` | Specifies the balance of similar node groups for the auto-scaler of the AKS cluster. |
| `autoScalerProfileExpander` | string | `'random'` | `[least-waste, most-pods, priority, random]` | Specifies the expand strategy for the auto-scaler of the AKS cluster. |
| `autoScalerProfileMaxEmptyBulkDelete` | string | `'10'` |  | Specifies the maximum empty bulk delete for the auto-scaler of the AKS cluster. |
| `autoScalerProfileMaxGracefulTerminationSec` | string | `'600'` |  | Specifies the max graceful termination time interval in seconds for the auto-scaler of the AKS cluster. |
| `autoScalerProfileMaxNodeProvisionTime` | string | `'15m'` |  | Specifies the maximum node provisioning time for the auto-scaler of the AKS cluster. Values must be an integer followed by an "m". No unit of time other than minutes (m) is supported. |
| `autoScalerProfileMaxTotalUnreadyPercentage` | string | `'45'` |  | Specifies the mximum total unready percentage for the auto-scaler of the AKS cluster. The maximum is 100 and the minimum is 0. |
| `autoScalerProfileNewPodScaleUpDelay` | string | `'0s'` |  | For scenarios like burst/batch scale where you do not want CA to act before the kubernetes scheduler could schedule all the pods, you can tell CA to ignore unscheduled pods before they are a certain age. Values must be an integer followed by a unit ("s" for seconds, "m" for minutes, "h" for hours, etc). |
| `autoScalerProfileOkTotalUnreadyCount` | string | `'3'` |  | Specifies the OK total unready count for the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownDelayAfterAdd` | string | `'10m'` |  | Specifies the scale down delay after add of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownDelayAfterDelete` | string | `'20s'` |  | Specifies the scale down delay after delete of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownDelayAfterFailure` | string | `'3m'` |  | Specifies scale down delay after failure of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownUnneededTime` | string | `'10m'` |  | Specifies the scale down unneeded time of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownUnreadyTime` | string | `'20m'` |  | Specifies the scale down unready time of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScanInterval` | string | `'10s'` |  | Specifies the scan interval of the auto-scaler of the AKS cluster. |
| `autoScalerProfileSkipNodesWithLocalStorage` | string | `'true'` | `[false, true]` | Specifies if nodes with local storage should be skipped for the auto-scaler of the AKS cluster. |
| `autoScalerProfileSkipNodesWithSystemPods` | string | `'true'` | `[false, true]` | Specifies if nodes with system pods should be skipped for the auto-scaler of the AKS cluster. |
| `autoScalerProfileUtilizationThreshold` | string | `'0.5'` |  | Specifies the utilization threshold of the auto-scaler of the AKS cluster. |
| `autoUpgradeProfileUpgradeChannel` | string | `''` | `['', node-image, none, patch, rapid, stable]` | Auto-upgrade channel on the AKS cluster. |
| `azurePolicyEnabled` | bool | `True` |  | Specifies whether the azurepolicy add-on is enabled or not. For security reasons, this setting should be enabled. |
| `azurePolicyVersion` | string | `'v2'` |  | Specifies the azure policy version to use. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', allLogs, cluster-autoscaler, guard, kube-apiserver, kube-audit, kube-audit-admin, kube-controller-manager, kube-scheduler]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `disableLocalAccounts` | bool | `False` |  | If set to true, getting static credentials will be disabled for this cluster. This must only be used on Managed Clusters that are AAD enabled. |
| `disableRunCommand` | bool | `False` |  | Whether to disable run command for the cluster or not. |
| `diskEncryptionSetID` | string | `''` |  | The resource ID of the disc encryption set to apply to the cluster. For security reasons, this value should be provided. |
| `dnsPrefix` | string | `[parameters('name')]` |  | Specifies the DNS prefix specified when creating the managed cluster. |
| `dnsServiceIP` | string | `''` |  | Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr. |
| `dnsZoneResourceId` | string | `''` |  | Specifies the resource ID of connected DNS zone. It will be ignored if `webApplicationRoutingEnabled` is set to `false`. |
| `enableAzureDefender` | bool | `False` |  | Whether to enable Azure Defender. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `enableDnsZoneContributorRoleAssignment` | bool | `True` |  | Specifies whether assing the DNS zone contributor role to the cluster service principal. It will be ignored if `webApplicationRoutingEnabled` is set to `false` or `dnsZoneResourceId` not provided. |
| `enableKeyvaultSecretsProvider` | bool | `False` |  | Specifies whether the KeyvaultSecretsProvider add-on is enabled or not. |
| `enableOidcIssuerProfile` | bool | `False` |  | Whether the The OIDC issuer profile of the Managed Cluster is enabled. |
| `enablePodSecurityPolicy` | bool | `False` |  | Whether to enable Kubernetes pod security policy. Requires enabling the pod security policy feature flag on the subscription. |
| `enablePrivateCluster` | bool | `False` |  | Specifies whether to create the cluster as a private cluster or not. |
| `enablePrivateClusterPublicFQDN` | bool | `False` |  | Whether to create additional public FQDN for private cluster or not. |
| `enableRBAC` | bool | `True` |  | Whether to enable Kubernetes Role-Based Access Control. |
| `enableSecretRotation` | string | `'false'` | `[false, true]` | Specifies whether the KeyvaultSecretsProvider add-on uses secret rotation. |
| `enableStorageProfileBlobCSIDriver` | bool | `False` |  | Whether the AzureBlob CSI Driver for the storage profile is enabled. |
| `enableStorageProfileDiskCSIDriver` | bool | `False` |  | Whether the AzureDisk CSI Driver for the storage profile is enabled. |
| `enableStorageProfileFileCSIDriver` | bool | `False` |  | Whether the AzureFile CSI Driver for the storage profile is enabled. |
| `enableStorageProfileSnapshotController` | bool | `False` |  | Whether the snapshot controller for the storage profile is enabled. |
| `enableWorkloadIdentity` | bool | `False` |  | Whether to enable Workload Identity. Requires OIDC issuer profile to be enabled. |
| `fluxConfigurationProtectedSettings` | secureObject | `{object}` |  | Configuration settings that are sensitive, as name-value pairs for configuring this extension. |
| `fluxExtension` | object | `{object}` |  | Settings and configurations for the flux extension. |
| `httpApplicationRoutingEnabled` | bool | `False` |  | Specifies whether the httpApplicationRouting add-on is enabled or not. |
| `httpProxyConfig` | object | `{object}` |  | Configurations for provisioning the cluster with HTTP proxy servers. |
| `identityProfile` | object | `{object}` |  | Identities associated with the cluster. |
| `ingressApplicationGatewayEnabled` | bool | `False` |  | Specifies whether the ingressApplicationGateway (AGIC) add-on is enabled or not. |
| `kubeDashboardEnabled` | bool | `False` |  | Specifies whether the kubeDashboard add-on is enabled or not. |
| `kubernetesVersion` | string | `''` |  | Version of Kubernetes specified when creating the managed cluster. |
| `loadBalancerSku` | string | `'standard'` | `[basic, standard]` | Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools. |
| `location` | string | `[resourceGroup().location]` |  | Specifies the location of AKS cluster. It picks up Resource Group's location by default. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `managedOutboundIPCount` | int | `0` |  | Outbound IP Count for the Load balancer. |
| `monitoringWorkspaceId` | string | `''` |  | Resource ID of the monitoring log analytics workspace. |
| `networkDataplane` | string | `''` | `['', azure, cilium]` | Network dataplane used in the Kubernetes cluster. Not compatible with kubenet network plugin. |
| `networkPlugin` | string | `''` | `['', azure, kubenet]` | Specifies the network plugin used for building Kubernetes network. |
| `networkPluginMode` | string | `''` | `['', overlay]` | Network plugin mode used for building the Kubernetes network. Not compatible with kubenet network plugin. |
| `networkPolicy` | string | `''` | `['', azure, calico]` | Specifies the network policy used for building Kubernetes network. - calico or azure. |
| `nodeResourceGroup` | string | `[format('{0}_aks_{1}_nodes', resourceGroup().name, parameters('name'))]` |  | Name of the resource group containing agent pool nodes. |
| `omsAgentEnabled` | bool | `True` |  | Specifies whether the OMS agent is enabled. |
| `openServiceMeshEnabled` | bool | `False` |  | Specifies whether the openServiceMesh add-on is enabled or not. |
| `outboundType` | string | `'loadBalancer'` | `[loadBalancer, userDefinedRouting]` | Specifies outbound (egress) routing method. - loadBalancer or userDefinedRouting. |
| `podCidr` | string | `''` |  | Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used. |
| `podIdentityProfileAllowNetworkPluginKubenet` | bool | `False` |  | Running in Kubenet is disabled by default due to the security related nature of AAD Pod Identity and the risks of IP spoofing. |
| `podIdentityProfileEnable` | bool | `False` |  | Whether the pod identity addon is enabled. |
| `podIdentityProfileUserAssignedIdentities` | array | `[]` |  | The pod identities to use in the cluster. |
| `podIdentityProfileUserAssignedIdentityExceptions` | array | `[]` |  | The pod identity exceptions to allow. |
| `privateDNSZone` | string | `''` |  | Private DNS Zone configuration. Set to 'system' and AKS will create a private DNS zone in the node resource group. Set to '' to disable private DNS Zone creation and use public DNS. Supply the resource ID here of an existing Private DNS zone to use an existing zone. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `serviceCidr` | string | `''` |  | A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges. |
| `skuTier` | string | `'Free'` | `[Free, Premium, Standard]` | Tier of a managed cluster SKU. - Free or Standard. |
| `sshPublicKey` | string | `''` |  | Specifies the SSH RSA public key string for the Linux nodes. |
| `supportPlan` | string | `'KubernetesOfficial'` | `[AKSLongTermSupport, KubernetesOfficial]` | The support plan for the Managed Cluster. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `webApplicationRoutingEnabled` | bool | `False` |  | Specifies whether the webApplicationRoutingEnabled add-on is enabled or not. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `addonProfiles` | object | The addonProfiles of the Kubernetes cluster. |
| `controlPlaneFQDN` | string | The control plane FQDN of the managed cluster. |
| `keyvaultIdentityClientId` | string | The Client ID of the Key Vault Secrets Provider identity. |
| `keyvaultIdentityObjectId` | string | The Object ID of the Key Vault Secrets Provider identity. |
| `kubeletidentityObjectId` | string | The Object ID of the AKS identity. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the managed cluster. |
| `oidcIssuerUrl` | string | The OIDC token issuer URL. |
| `omsagentIdentityObjectId` | string | The Object ID of the OMS agent identity. |
| `resourceGroupName` | string | The resource group the managed cluster was deployed into. |
| `resourceId` | string | The resource ID of the managed cluster. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `kubernetes-configuration/extension` | Local reference |
| `kubernetes-configuration/flux-configuration` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Azure</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster './container-service/managed-cluster/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-csmaz'
  params: {
    // Required parameters
    name: 'csmaz001'
    primaryAgentPoolProfile: [
      {
        availabilityZones: [
          '3'
        ]
        count: 1
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        mode: 'System'
        name: 'systempool'
        osDiskSizeGB: 0
        osType: 'Linux'
        serviceCidr: ''
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
    ]
    // Non-required parameters
    agentPools: [
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool1'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 128
        osType: 'Linux'
        proximityPlacementGroupResourceId: '<proximityPlacementGroupResourceId>'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool2'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
    ]
    autoUpgradeProfileUpgradeChannel: 'stable'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    diskEncryptionSetID: '<diskEncryptionSetID>'
    enableAzureDefender: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enableKeyvaultSecretsProvider: true
    enableOidcIssuerProfile: true
    enablePodSecurityPolicy: false
    enableStorageProfileBlobCSIDriver: true
    enableStorageProfileDiskCSIDriver: true
    enableStorageProfileFileCSIDriver: true
    enableStorageProfileSnapshotController: true
    enableWorkloadIdentity: true
    fluxExtension: {
      configurations: [
        {
          gitRepository: {
            repositoryRef: {
              branch: 'main'
            }
            sshKnownHosts: ''
            syncIntervalInSeconds: 300
            timeoutInSeconds: 180
            url: 'https://github.com/mspnp/aks-baseline'
          }
          namespace: 'flux-system'
        }
        {
          gitRepository: {
            repositoryRef: {
              branch: 'main'
            }
            sshKnownHosts: ''
            syncIntervalInSeconds: 300
            timeoutInSeconds: 180
            url: 'https://github.com/Azure/gitops-flux2-kustomize-helm-mt'
          }
          kustomizations: {
            apps: {
              dependsOn: [
                'infra'
              ]
              path: './apps/staging'
              prune: true
              retryIntervalInSeconds: 120
              syncIntervalInSeconds: 600
              timeoutInSeconds: 600
            }
            infra: {
              dependsOn: []
              path: './infrastructure'
              prune: true
              syncIntervalInSeconds: 600
              timeoutInSeconds: 600
              validation: 'none'
            }
          }
          namespace: 'flux-system-helm'
        }
      ]
      configurationSettings: {
        'helm-controller.enabled': 'true'
        'image-automation-controller.enabled': 'false'
        'image-reflector-controller.enabled': 'false'
        'kustomize-controller.enabled': 'true'
        'notification-controller.enabled': 'true'
        'source-controller.enabled': 'true'
      }
    }
    identityProfile: {
      kubeletidentity: {
        resourceId: '<resourceId>'
      }
    }
    lock: 'CanNotDelete'
    monitoringWorkspaceId: '<monitoringWorkspaceId>'
    networkDataplane: 'azure'
    networkPlugin: 'azure'
    networkPluginMode: 'overlay'
    omsAgentEnabled: true
    openServiceMeshEnabled: true
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "csmaz001"
    },
    "primaryAgentPoolProfile": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 1,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "mode": "System",
          "name": "systempool",
          "osDiskSizeGB": 0,
          "osType": "Linux",
          "serviceCidr": "",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        }
      ]
    },
    // Non-required parameters
    "agentPools": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool1",
          "nodeLabels": {},
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "proximityPlacementGroupResourceId": "<proximityPlacementGroupResourceId>",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        },
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool2",
          "nodeLabels": {},
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        }
      ]
    },
    "autoUpgradeProfileUpgradeChannel": {
      "value": "stable"
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "diskEncryptionSetID": {
      "value": "<diskEncryptionSetID>"
    },
    "enableAzureDefender": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enableKeyvaultSecretsProvider": {
      "value": true
    },
    "enableOidcIssuerProfile": {
      "value": true
    },
    "enablePodSecurityPolicy": {
      "value": false
    },
    "enableStorageProfileBlobCSIDriver": {
      "value": true
    },
    "enableStorageProfileDiskCSIDriver": {
      "value": true
    },
    "enableStorageProfileFileCSIDriver": {
      "value": true
    },
    "enableStorageProfileSnapshotController": {
      "value": true
    },
    "enableWorkloadIdentity": {
      "value": true
    },
    "fluxExtension": {
      "value": {
        "configurations": [
          {
            "gitRepository": {
              "repositoryRef": {
                "branch": "main"
              },
              "sshKnownHosts": "",
              "syncIntervalInSeconds": 300,
              "timeoutInSeconds": 180,
              "url": "https://github.com/mspnp/aks-baseline"
            },
            "namespace": "flux-system"
          },
          {
            "gitRepository": {
              "repositoryRef": {
                "branch": "main"
              },
              "sshKnownHosts": "",
              "syncIntervalInSeconds": 300,
              "timeoutInSeconds": 180,
              "url": "https://github.com/Azure/gitops-flux2-kustomize-helm-mt"
            },
            "kustomizations": {
              "apps": {
                "dependsOn": [
                  "infra"
                ],
                "path": "./apps/staging",
                "prune": true,
                "retryIntervalInSeconds": 120,
                "syncIntervalInSeconds": 600,
                "timeoutInSeconds": 600
              },
              "infra": {
                "dependsOn": [],
                "path": "./infrastructure",
                "prune": true,
                "syncIntervalInSeconds": 600,
                "timeoutInSeconds": 600,
                "validation": "none"
              }
            },
            "namespace": "flux-system-helm"
          }
        ],
        "configurationSettings": {
          "helm-controller.enabled": "true",
          "image-automation-controller.enabled": "false",
          "image-reflector-controller.enabled": "false",
          "kustomize-controller.enabled": "true",
          "notification-controller.enabled": "true",
          "source-controller.enabled": "true"
        }
      }
    },
    "identityProfile": {
      "value": {
        "kubeletidentity": {
          "resourceId": "<resourceId>"
        }
      }
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "monitoringWorkspaceId": {
      "value": "<monitoringWorkspaceId>"
    },
    "networkDataplane": {
      "value": "azure"
    },
    "networkPlugin": {
      "value": "azure"
    },
    "networkPluginMode": {
      "value": "overlay"
    },
    "omsAgentEnabled": {
      "value": true
    },
    "openServiceMeshEnabled": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Kubenet</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster './container-service/managed-cluster/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-csmkube'
  params: {
    // Required parameters
    name: 'csmkube001'
    primaryAgentPoolProfile: [
      {
        availabilityZones: [
          '3'
        ]
        count: 1
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        mode: 'System'
        name: 'systempool'
        osDiskSizeGB: 0
        osType: 'Linux'
        serviceCidr: ''
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
    ]
    // Non-required parameters
    agentPools: [
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool1'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool2'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    networkPlugin: 'kubenet'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "csmkube001"
    },
    "primaryAgentPoolProfile": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 1,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "mode": "System",
          "name": "systempool",
          "osDiskSizeGB": 0,
          "osType": "Linux",
          "serviceCidr": "",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2"
        }
      ]
    },
    // Non-required parameters
    "agentPools": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool1",
          "nodeLabels": {},
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2"
        },
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool2",
          "nodeLabels": {},
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2"
        }
      ]
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "networkPlugin": {
      "value": "kubenet"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

<h3>Example 3: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster './container-service/managed-cluster/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-csmmin'
  params: {
    // Required parameters
    name: 'csmmin001'
    primaryAgentPoolProfile: [
      {
        count: 1
        mode: 'System'
        name: 'systempool'
        vmSize: 'Standard_DS2_v2'
      }
    ]
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    systemAssignedIdentity: true
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "csmmin001"
    },
    "primaryAgentPoolProfile": {
      "value": [
        {
          "count": 1,
          "mode": "System",
          "name": "systempool",
          "vmSize": "Standard_DS2_v2"
        }
      ]
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "systemAssignedIdentity": {
      "value": true
    }
  }
}
```

</details>
<p>

<h3>Example 4: Priv</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster './container-service/managed-cluster/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-csmpriv'
  params: {
    // Required parameters
    name: 'csmpriv001'
    primaryAgentPoolProfile: [
      {
        availabilityZones: [
          '3'
        ]
        count: 1
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        mode: 'System'
        name: 'systempool'
        osDiskSizeGB: 0
        osType: 'Linux'
        serviceCidr: ''
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
    ]
    // Non-required parameters
    agentPools: [
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool1'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool2'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    dnsServiceIP: '10.10.200.10'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enablePrivateCluster: true
    networkPlugin: 'azure'
    privateDNSZone: '<privateDNSZone>'
    serviceCidr: '10.10.200.0/24'
    skuTier: 'Standard'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "csmpriv001"
    },
    "primaryAgentPoolProfile": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 1,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "mode": "System",
          "name": "systempool",
          "osDiskSizeGB": 0,
          "osType": "Linux",
          "serviceCidr": "",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        }
      ]
    },
    // Non-required parameters
    "agentPools": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool1",
          "nodeLabels": {},
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        },
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool2",
          "nodeLabels": {},
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "storageProfile": "ManagedDisks",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2"
        }
      ]
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "dnsServiceIP": {
      "value": "10.10.200.10"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enablePrivateCluster": {
      "value": true
    },
    "networkPlugin": {
      "value": "azure"
    },
    "privateDNSZone": {
      "value": "<privateDNSZone>"
    },
    "serviceCidr": {
      "value": "10.10.200.0/24"
    },
    "skuTier": {
      "value": "Standard"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>


## Notes

### Parameter Usage: `httpProxyConfig`

Configurations for provisioning the cluster with HTTP proxy servers. You can specify in the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"httpProxyConfig": {
    "value": {
        "httpProxy": "http://proxy.contoso.com:8080/",
        "httpsProxy": "http://proxy.contoso.com:8080/",
        "noProxy": [
            "10.0.0.0/8",
            "127.0.0.1",
            "168.63.129.16",
            "169.254.169.254",
            "azurecr.io",
            "konnectivity",
            "localhost"
        ]
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
httpProxyConfig: {
  httpProxy: 'http://proxy.contoso.com:8080/'
  httpsProxy: 'http://proxy.contoso.com:8080/'
  noProxy: [
    '10.0.0.0/8'
    '127.0.0.1'
    '168.63.129.16'
    '169.254.169.254'
    'azurecr.io'
    'konnectivity'
    'localhost'
  ]
}
```

</details>
<p>
