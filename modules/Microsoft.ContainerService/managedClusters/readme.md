# Azure Kubernetes Services `[Microsoft.ContainerService/managedClusters]`

This module deploys Azure Kubernetes Cluster (AKS).

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.ContainerService/managedClusters` | [2022-03-02-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2022-03-02-preview/managedClusters) |
| `Microsoft.ContainerService/managedClusters/agentPools` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2021-08-01/managedClusters/agentPools) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Specifies the name of the AKS cluster. |
| `primaryAgentPoolProfile` | array | Properties of the primary agent pool. |

**Conditional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `appGatewayResourceId` | string | `''` | Specifies the resource ID of connected application gateway. Required if `ingressApplicationGatewayEnabled` is set to `true`. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `aadProfileAdminGroupObjectIDs` | array | `[]` |  | Specifies the AAD group object IDs that will have admin role of the cluster. |
| `aadProfileClientAppID` | string | `''` |  | The client AAD application ID. |
| `aadProfileEnableAzureRBAC` | bool | `True` |  | Specifies whether to enable Azure RBAC for Kubernetes authorization. |
| `aadProfileManaged` | bool | `True` |  | Specifies whether to enable managed AAD integration. |
| `aadProfileServerAppID` | string | `''` |  | The server AAD application ID. |
| `aadProfileServerAppSecret` | string | `''` |  | The server AAD application secret. |
| `aadProfileTenantId` | string | `[subscription().tenantId]` |  | Specifies the tenant ID of the Azure Active Directory used by the AKS cluster for authentication. |
| `aciConnectorLinuxEnabled` | bool | `False` |  | Specifies whether the aciConnectorLinux add-on is enabled or not. |
| `agentPools` | _[agentPools](agentPools/readme.md)_ array | `[]` |  | Define one or more secondary/additional agent pools. |
| `aksClusterAdminUsername` | string | `'azureuser'` |  | Specifies the administrator username of Linux virtual machines. |
| `aksClusterDnsPrefix` | string | `[parameters('name')]` |  | Specifies the DNS prefix specified when creating the managed cluster. |
| `aksClusterDnsServiceIP` | string | `''` |  | Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr. |
| `aksClusterDockerBridgeCidr` | string | `''` |  | Specifies the CIDR notation IP range assigned to the Docker bridge network. It must not overlap with any Subnet IP ranges or the Kubernetes service address range. |
| `aksClusterKubernetesVersion` | string | `''` |  | Version of Kubernetes specified when creating the managed cluster. |
| `aksClusterLoadBalancerSku` | string | `'standard'` | `[basic, standard]` | Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools. |
| `aksClusterNetworkPlugin` | string | `''` | `[, azure, kubenet]` | Specifies the network plugin used for building Kubernetes network. - azure or kubenet. |
| `aksClusterNetworkPolicy` | string | `''` | `[, azure, calico]` | Specifies the network policy used for building Kubernetes network. - calico or azure. |
| `aksClusterOutboundType` | string | `'loadBalancer'` | `[loadBalancer, userDefinedRouting]` | Specifies outbound (egress) routing method. - loadBalancer or userDefinedRouting. |
| `aksClusterPodCidr` | string | `''` |  | Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used. |
| `aksClusterServiceCidr` | string | `''` |  | A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges. |
| `aksClusterSkuTier` | string | `'Free'` | `[Free, Paid]` | Tier of a managed cluster SKU. - Free or Paid. |
| `aksClusterSshPublicKey` | string | `''` |  | Specifies the SSH RSA public key string for the Linux nodes. |
| `aksServicePrincipalProfile` | object | `{object}` |  | Information about a service principal identity for the cluster to use for manipulating Azure APIs. |
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
| `azurePolicyEnabled` | bool | `True` |  | Specifies whether the azurepolicy add-on is enabled or not. |
| `azurePolicyVersion` | string | `'v2'` |  | Specifies the azure policy version to use. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[kube-apiserver, kube-audit, kube-controller-manager, kube-scheduler, cluster-autoscaler]` | `[kube-apiserver, kube-audit, kube-controller-manager, kube-scheduler, cluster-autoscaler]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `disableLocalAccounts` | bool | `False` |  | If set to true, getting static credentials will be disabled for this cluster. This must only be used on Managed Clusters that are AAD enabled. |
| `disableRunCommand` | bool | `False` |  | Whether to disable run command for the cluster or not. |
| `enableAzureDefender` | bool | `False` |  | Whether to enable Azure Defender. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `enableKeyvaultSecretsProvider` | bool | `False` |  | Specifies whether the KeyvaultSecretsProvider add-on is enabled or not. |
| `enableOidcIssuerProfile` | bool | `False` |  | Whether the The OIDC issuer profile of the Managed Cluster is enabled. |
| `enablePodSecurityPolicy` | bool | `False` |  | Whether to enable Kubernetes pod security policy. |
| `enablePrivateCluster` | bool | `False` |  | Specifies whether to create the cluster as a private cluster or not. |
| `enablePrivateClusterPublicFQDN` | bool | `False` |  | Whether to create additional public FQDN for private cluster or not. |
| `enableSecretRotation` | string | `'false'` | `[false, true]` | Specifies whether the KeyvaultSecretsProvider add-on uses secret rotation. |
| `httpApplicationRoutingEnabled` | bool | `False` |  | Specifies whether the httpApplicationRouting add-on is enabled or not. |
| `ingressApplicationGatewayEnabled` | bool | `False` |  | Specifies whether the ingressApplicationGateway (AGIC) add-on is enabled or not. |
| `kubeDashboardEnabled` | bool | `False` |  | Specifies whether the kubeDashboard add-on is enabled or not. |
| `location` | string | `[resourceGroup().location]` |  | Specifies the location of AKS cluster. It picks up Resource Group's location by default. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `managedOutboundIPCount` | int | `0` |  | Outbound IP Count for the Load balancer. |
| `monitoringWorkspaceId` | string | `''` |  | Resource ID of the monitoring log analytics workspace. |
| `nodeResourceGroup` | string | `[format('{0}_aks_{1}_nodes', resourceGroup().name, parameters('name'))]` |  | Name of the resource group containing agent pool nodes. |
| `omsAgentEnabled` | bool | `True` |  | Specifies whether the OMS agent is enabled. |
| `podIdentityProfileAllowNetworkPluginKubenet` | bool | `False` |  | Running in Kubenet is disabled by default due to the security related nature of AAD Pod Identity and the risks of IP spoofing. |
| `podIdentityProfileEnable` | bool | `False` |  | Whether the pod identity addon is enabled. |
| `podIdentityProfileUserAssignedIdentities` | array | `[]` |  | The pod identities to use in the cluster. |
| `podIdentityProfileUserAssignedIdentityExceptions` | array | `[]` |  | The pod identity exceptions to allow. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `usePrivateDNSZone` | bool | `False` |  | If AKS will create a Private DNS Zone in the Node Resource Group. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |


### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

### Parameter Usage: `primaryAgentPoolProfile`

Provide values for primary agent pool as needed.
For available properties check <https://docs.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters?tabs=json#managedclusteragentpoolprofile-object>

<details>

<summary>Parameter JSON format</summary>

```json
"primaryAgentPoolProfile": {
  "value": [
    {
      "name": "poolname",
      "vmSize": "Standard_DS3_v2",
      "osDiskSizeGB": 128,
      "count": 2,
      "osType": "Linux",
      "maxCount": 5,
      "minCount": 1,
      "enableAutoScaling": true,
      "scaleSetPriority": "Regular",
      "scaleSetEvictionPolicy": "Delete",
      "nodeLabels": {},
      "nodeTaints": [
        "CriticalAddonsOnly=true:NoSchedule"
      ],
      "type": "VirtualMachineScaleSets",
      "availabilityZones": [
          "1",
          "2",
          "3"
      ],
      "maxPods": 30,
      "storageProfile": "ManagedDisks",
      "mode": "System",
      "vnetSubnetID": "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/myRg/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/mySubnet",
      "tags": {
        "Owner": "test.user@testcompany.com",
        "BusinessUnit": "IaCs",
        "Environment": "PROD",
        "Region": "USEast"
      }
    }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
primaryAgentPoolProfile: [
    {
        name: 'poolname'
        vmSize: 'Standard_DS3_v2'
        osDiskSizeGB: 128
        count: 2
        osType: 'Linux'
        maxCount: 5
        minCount: 1
        enableAutoScaling: true
        scaleSetPriority: 'Regular'
        scaleSetEvictionPolicy: 'Delete'
        nodeLabels: {}
        nodeTaints: [
            'CriticalAddonsOnly=true:NoSchedule'
        ]
        type: 'VirtualMachineScaleSets'
        availabilityZones: [
            '1'
            '2'
            '3'
        ]
        maxPods: 30
        storageProfile: 'ManagedDisks'
        mode: 'System'
        vnetSubnetID: '/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/myRg/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/mySubnet'
        tags: {
            Owner: 'test.user@testcompany.com'
            BusinessUnit: 'IaCs'
            Environment: 'PROD'
            Region: 'USEast'
        }
    }
]
```

</details>
<p>

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `controlPlaneFQDN` | string | The control plane FQDN of the managed cluster. |
| `kubeletidentityObjectId` | string | The Object ID of the AKS identity. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the managed cluster. |
| `omsagentIdentityObjectId` | string | The Object ID of the OMS agent identity. |
| `resourceGroupName` | string | The resource group the managed cluster was deployed into. |
| `resourceId` | string | The resource ID of the managed cluster. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-aks-azure-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "primaryAgentPoolProfile": {
            "value": [
                {
                    "name": "systempool",
                    "osDiskSizeGB": 0,
                    "count": 1,
                    "enableAutoScaling": true,
                    "minCount": 1,
                    "maxCount": 3,
                    "vmSize": "Standard_DS2_v2",
                    "osType": "Linux",
                    "storageProfile": "ManagedDisks",
                    "type": "VirtualMachineScaleSets",
                    "mode": "System",
                    "vnetSubnetID": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-aks/subnets/Primary",
                    "serviceCidr": "",
                    "maxPods": 30,
                    "availabilityZones": [
                        "1"
                    ]
                }
            ]
        },
        "aksClusterNetworkPlugin": {
            "value": "azure"
        },
        "agentPools": {
            "value": [
                {
                    "name": "userpool1",
                    "vmSize": "Standard_DS2_v2",
                    "osDiskSizeGB": 128,
                    "count": 2,
                    "osType": "Linux",
                    "maxCount": 3,
                    "minCount": 1,
                    "enableAutoScaling": true,
                    "scaleSetPriority": "Regular",
                    "scaleSetEvictionPolicy": "Delete",
                    "nodeLabels": {},
                    "nodeTaints": [
                        "CriticalAddonsOnly=true:NoSchedule"
                    ],
                    "type": "VirtualMachineScaleSets",
                    "availabilityZones": [
                        "1"
                    ],
                    "minPods": 2,
                    "maxPods": 30,
                    "storageProfile": "ManagedDisks",
                    "mode": "User",
                    "vnetSubnetID": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-aks/subnets/Secondary"
                },
                {
                    "name": "userpool2",
                    "vmSize": "Standard_DS2_v2",
                    "osDiskSizeGB": 128,
                    "count": 2,
                    "osType": "Linux",
                    "maxCount": 3,
                    "minCount": 1,
                    "enableAutoScaling": true,
                    "scaleSetPriority": "Regular",
                    "scaleSetEvictionPolicy": "Delete",
                    "nodeLabels": {},
                    "nodeTaints": [
                        "CriticalAddonsOnly=true:NoSchedule"
                    ],
                    "type": "VirtualMachineScaleSets",
                    "availabilityZones": [
                        "1"
                    ],
                    "minPods": 2,
                    "maxPods": 30,
                    "storageProfile": "ManagedDisks",
                    "mode": "User",
                    "vnetSubnetID": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-aks/subnets/Tertiary"
                }
            ]
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        },
        "diagnosticLogsRetentionInDays": {
            "value": 7
        },
        "diagnosticStorageAccountId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "diagnosticWorkspaceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
        },
        "diagnosticEventHubAuthorizationRuleId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
        },
        "diagnosticEventHubName": {
            "value": "adp-<<namePrefix>>-az-evh-x-001"
        },
        "systemAssignedIdentity": {
            "value": true
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module managedClusters './Microsoft.ContainerService/managedClusters/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-managedClusters'
  params: {
    name: '<<namePrefix>>-az-aks-azure-001'
    lock: 'CanNotDelete'
    primaryAgentPoolProfile: [
      {
        name: 'systempool'
        osDiskSizeGB: 0
        count: 1
        enableAutoScaling: true
        minCount: 1
        maxCount: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        vnetSubnetID: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-aks/subnets/Primary'
        serviceCidr: ''
        maxPods: 30
        availabilityZones: [
          '1'
        ]
      }
    ]
    aksClusterNetworkPlugin: 'azure'
    agentPools: [
      {
        name: 'userpool1'
        vmSize: 'Standard_DS2_v2'
        osDiskSizeGB: 128
        count: 2
        osType: 'Linux'
        maxCount: 3
        minCount: 1
        enableAutoScaling: true
        scaleSetPriority: 'Regular'
        scaleSetEvictionPolicy: 'Delete'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        type: 'VirtualMachineScaleSets'
        availabilityZones: [
          '1'
        ]
        minPods: 2
        maxPods: 30
        storageProfile: 'ManagedDisks'
        mode: 'User'
        vnetSubnetID: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-aks/subnets/Secondary'
      }
      {
        name: 'userpool2'
        vmSize: 'Standard_DS2_v2'
        osDiskSizeGB: 128
        count: 2
        osType: 'Linux'
        maxCount: 3
        minCount: 1
        enableAutoScaling: true
        scaleSetPriority: 'Regular'
        scaleSetEvictionPolicy: 'Delete'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        type: 'VirtualMachineScaleSets'
        availabilityZones: [
          '1'
        ]
        minPods: 2
        maxPods: 30
        storageProfile: 'ManagedDisks'
        mode: 'User'
        vnetSubnetID: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-aks/subnets/Tertiary'
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
    systemAssignedIdentity: true
  }
}
```

</details>
<p>

<h3>Example 2</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-aks-kubenet-001"
        },
        "primaryAgentPoolProfile": {
            "value": [
                {
                    "name": "systempool",
                    "osDiskSizeGB": 0,
                    "count": 1,
                    "enableAutoScaling": true,
                    "minCount": 1,
                    "maxCount": 3,
                    "vmSize": "Standard_DS2_v2",
                    "osType": "Linux",
                    "storageProfile": "ManagedDisks",
                    "type": "VirtualMachineScaleSets",
                    "mode": "System",
                    "serviceCidr": "",
                    "maxPods": 30,
                    "availabilityZones": [
                        "1"
                    ]
                }
            ]
        },
        "aksClusterNetworkPlugin": {
            "value": "kubenet"
        },
        "agentPools": {
            "value": [
                {
                    "name": "userpool1",
                    "vmSize": "Standard_DS2_v2",
                    "osDiskSizeGB": 128,
                    "count": 2,
                    "osType": "Linux",
                    "maxCount": 3,
                    "minCount": 1,
                    "enableAutoScaling": true,
                    "scaleSetPriority": "Regular",
                    "scaleSetEvictionPolicy": "Delete",
                    "nodeLabels": {},
                    "nodeTaints": [
                        "CriticalAddonsOnly=true:NoSchedule"
                    ],
                    "type": "VirtualMachineScaleSets",
                    "availabilityZones": [
                        "1"
                    ],
                    "minPods": 2,
                    "maxPods": 30,
                    "storageProfile": "ManagedDisks",
                    "mode": "User"
                },
                {
                    "name": "userpool2",
                    "vmSize": "Standard_DS2_v2",
                    "osDiskSizeGB": 128,
                    "count": 2,
                    "osType": "Linux",
                    "maxCount": 3,
                    "minCount": 1,
                    "enableAutoScaling": true,
                    "scaleSetPriority": "Regular",
                    "scaleSetEvictionPolicy": "Delete",
                    "nodeLabels": {},
                    "nodeTaints": [
                        "CriticalAddonsOnly=true:NoSchedule"
                    ],
                    "type": "VirtualMachineScaleSets",
                    "availabilityZones": [
                        "1"
                    ],
                    "minPods": 2,
                    "maxPods": 30,
                    "storageProfile": "ManagedDisks",
                    "mode": "User"
                }
            ]
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        },
        "diagnosticLogsRetentionInDays": {
            "value": 7
        },
        "diagnosticStorageAccountId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
        },
        "diagnosticWorkspaceId": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
        },
        "diagnosticEventHubAuthorizationRuleId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
        },
        "diagnosticEventHubName": {
            "value": "adp-<<namePrefix>>-az-evh-x-001"
        },
        "userAssignedIdentities": {
            "value": {
                "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
            }
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module managedClusters './Microsoft.ContainerService/managedClusters/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-managedClusters'
  params: {
    name: '<<namePrefix>>-az-aks-kubenet-001'
    primaryAgentPoolProfile: [
      {
        name: 'systempool'
        osDiskSizeGB: 0
        count: 1
        enableAutoScaling: true
        minCount: 1
        maxCount: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        storageProfile: 'ManagedDisks'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        serviceCidr: ''
        maxPods: 30
        availabilityZones: [
          '1'
        ]
      }
    ]
    aksClusterNetworkPlugin: 'kubenet'
    agentPools: [
      {
        name: 'userpool1'
        vmSize: 'Standard_DS2_v2'
        osDiskSizeGB: 128
        count: 2
        osType: 'Linux'
        maxCount: 3
        minCount: 1
        enableAutoScaling: true
        scaleSetPriority: 'Regular'
        scaleSetEvictionPolicy: 'Delete'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        type: 'VirtualMachineScaleSets'
        availabilityZones: [
          '1'
        ]
        minPods: 2
        maxPods: 30
        storageProfile: 'ManagedDisks'
        mode: 'User'
      }
      {
        name: 'userpool2'
        vmSize: 'Standard_DS2_v2'
        osDiskSizeGB: 128
        count: 2
        osType: 'Linux'
        maxCount: 3
        minCount: 1
        enableAutoScaling: true
        scaleSetPriority: 'Regular'
        scaleSetEvictionPolicy: 'Delete'
        nodeLabels: {}
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        type: 'VirtualMachineScaleSets'
        availabilityZones: [
          '1'
        ]
        minPods: 2
        maxPods: 30
        storageProfile: 'ManagedDisks'
        mode: 'User'
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
  }
}
```

</details>
<p>
