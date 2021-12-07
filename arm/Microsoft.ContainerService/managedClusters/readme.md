# Azure Kubernetes Services `[Microsoft.ContainerService/managedClusters]`

This module deploys Azure Kubernetes Cluster (AKS).

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.ContainerService/managedClusters` | 2021-07-01 |
| `Microsoft.ContainerService/managedClusters/agentPools` | 2021-05-01 |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `aadProfileAdminGroupObjectIDs` | array | `[]` |  | Optional. Specifies the AAD group object IDs that will have admin role of the cluster. |
| `aadProfileClientAppID` | string |  |  | Optional. The client AAD application ID. |
| `aadProfileEnableAzureRBAC` | bool | `True` |  | Optional. Specifies whether to enable Azure RBAC for Kubernetes authorization. |
| `aadProfileManaged` | bool | `True` |  | Optional. Specifies whether to enable managed AAD integration. |
| `aadProfileServerAppID` | string |  |  | Optional. The server AAD application ID. |
| `aadProfileServerAppSecret` | string |  |  | Optional. The server AAD application secret. |
| `aadProfileTenantId` | string | `[subscription().tenantId]` |  | Optional. Specifies the tenant ID of the Azure Active Directory used by the AKS cluster for authentication. |
| `aciConnectorLinuxEnabled` | bool |  |  | Optional. Specifies whether the aciConnectorLinux add-on is enabled or not. |
| `agentPools` | _[agentPools](agentPools/readme.md)_ array | `[]` |  | Optional. Define one or more secondary/additional agent pools |
| `aksClusterAdminUsername` | string | `azureuser` |  | Optional. Specifies the administrator username of Linux virtual machines. |
| `aksClusterDnsPrefix` | string | `[parameters('name')]` |  | Optional. Specifies the DNS prefix specified when creating the managed cluster. |
| `aksClusterDnsServiceIP` | string |  |  | Optional. Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr. |
| `aksClusterDockerBridgeCidr` | string |  |  | Optional. Specifies the CIDR notation IP range assigned to the Docker bridge network. It must not overlap with any Subnet IP ranges or the Kubernetes service address range. |
| `aksClusterEnablePrivateCluster` | bool |  |  | Optional. Specifies whether to create the cluster as a private cluster or not. |
| `aksClusterKubernetesVersion` | string |  |  | Optional. Version of Kubernetes specified when creating the managed cluster. |
| `aksClusterLoadBalancerSku` | string | `standard` | `[basic, standard]` | Optional. Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools. |
| `aksClusterNetworkPlugin` | string |  | `[, azure, kubenet]` | Optional. Specifies the network plugin used for building Kubernetes network. - azure or kubenet. |
| `aksClusterNetworkPolicy` | string |  | `[, azure, calico]` | Optional. Specifies the network policy used for building Kubernetes network. - calico or azure |
| `aksClusterOutboundType` | string | `loadBalancer` | `[loadBalancer, userDefinedRouting]` | Optional. Specifies outbound (egress) routing method. - loadBalancer or userDefinedRouting. |
| `aksClusterPodCidr` | string |  |  | Optional. Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used. |
| `aksClusterServiceCidr` | string |  |  | Optional. A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges. |
| `aksClusterSkuTier` | string | `Free` | `[Free, Paid]` | Optional. Tier of a managed cluster SKU. - Free or Paid |
| `aksClusterSshPublicKey` | string |  |  | Optional. Specifies the SSH RSA public key string for the Linux nodes. |
| `aksServicePrincipalProfile` | object | `{object}` |  | Optional. Information about a service principal identity for the cluster to use for manipulating Azure APIs. |
| `autoScalerProfileMaxGracefulTerminationSec` | string | `600` |  | Optional. Specifies the max graceful termination time interval in seconds for the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownDelayAfterAdd` | string | `10m` |  | Optional. Specifies the scale down delay after add of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownDelayAfterDelete` | string | `20s` |  | Optional. Specifies the scale down delay after delete of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownDelayAfterFailure` | string | `3m` |  | Optional. Specifies scale down delay after failure of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownUnneededTime` | string | `10m` |  | Optional. Specifies the scale down unneeded time of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownUnreadyTime` | string | `20m` |  | Optional. Specifies the scale down unready time of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScanInterval` | string | `10s` |  | Optional. Specifies the scan interval of the auto-scaler of the AKS cluster. |
| `autoScalerProfileUtilizationThreshold` | string | `0.5` |  | Optional. Specifies the utilization threshold of the auto-scaler of the AKS cluster. |
| `azurePolicyEnabled` | bool | `True` |  | Optional. Specifies whether the azurepolicy add-on is enabled or not. |
| `azurePolicyVersion` | string | `v2` |  | Optional. Specifies the azure policy version to use. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `httpApplicationRoutingEnabled` | bool |  |  | Optional. Specifies whether the httpApplicationRouting add-on is enabled or not. |
| `kubeDashboardEnabled` | bool |  |  | Optional. Specifies whether the kubeDashboard add-on is enabled or not. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Specifies the location of AKS cluster. It picks up Resource Group's location by default. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[kube-apiserver, kube-audit, kube-controller-manager, kube-scheduler, cluster-autoscaler]` | `[kube-apiserver, kube-audit, kube-controller-manager, kube-scheduler, cluster-autoscaler]` | Optional. The name of logs that will be streamed. |
| `managedOutboundIPCount` | int |  |  | Optional. Outbound IP Count for the Load balancer. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `name` | string |  |  | Required. Specifies the name of the AKS cluster. |
| `nodeResourceGroup` | string | `[format('{0}_aks_{1}_nodes', resourceGroup().name, parameters('name'))]` |  | Optional. Name of the resource group containing agent pool nodes. |
| `omsAgentEnabled` | bool | `True` |  | Optional. Specifies whether the OMS agent is enabled. |
| `primaryAgentPoolProfile` | array |  |  | Required. Properties of the primary agent pool. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `systemAssignedIdentity` | bool |  |  | Optional. Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. The ID(s) to assign to the resource. |
| `workspaceId` | string |  |  | Optional. Resource ID of log analytics. |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ]
        }
    ]
}
```

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

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

### Parameter Usage: `identity`

See also <https://docs.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters?tabs=json#managedclusteridentity-object>

```json
"identity": {
  "value": {
    "type": "string",
    "userAssignedIdentities": {}
  }
}
```

### Parameter Usage: `aksServicePrincipalProfile`

See also <https://docs.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters?tabs=json#managedclusterserviceprincipalprofile-object>

```json
"aksServicePrincipalProfile": {
  "value": {
    "clientId": "string",
    "secret": "string"
  }
}
```

### Parameter Usage: `primaryAgentPoolProfile`

Provide values for primary agent pool as needed.
For available properties check <https://docs.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters?tabs=json#managedclusteragentpoolprofile-object>

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
        "Owner": "abc.def@contoso.com",
        "BusinessUnit": "IaCs",
        "Environment": "PROD",
        "Region": "USEast"
      }
    }
  ]
}
```

### Parameter Usage: `agentPools`

For available properties check <https://docs.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters/agentpools?tabs=json#managedclusteragentpoolprofileproperties-object>

```json
"agentPools": {
      "value": [
          {
            "name": "pool1",
            "properties": {
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
                    "Owner": "abc.def@contoso.com",
                    "BusinessUnit": "IaCs",
                    "Environment": "PROD",
                    "Region": "USEast"
                }
            }
        },
        {
            "name": "pool2",
            "properties": {
                "..."
            }
        }
      ]
    }
```

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
},
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `azureKubernetesServiceName` | string | The name of the managed cluster |
| `azureKubernetesServiceResourceGroup` | string | The resource group the managed cluster was deployed into |
| `azureKubernetesServiceResourceId` | string | The resource ID of the managed cluster |
| `controlPlaneFQDN` | string | The control plane FQDN of the managed cluster |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Managedclusters](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2021-07-01/managedClusters)
- [Managedclusters/Agentpools](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2021-05-01/managedClusters/agentPools)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
