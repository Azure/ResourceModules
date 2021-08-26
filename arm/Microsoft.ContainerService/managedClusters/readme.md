# AzureKubernetesService

This module deploys Azure Kubernetes Cluster (AKS).


## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.ContainerService/managedClusters/agentPools` | 2021-05-01 |
| `Microsoft.ContainerService/managedClusters/providers/diagnosticsettings` | 2017-05-01-preview |
| `Microsoft.ContainerService/managedClusters/providers/roleAssignments` | 2018-09-01-preview |
| `Microsoft.ContainerService/managedClusters` | 2021-05-01 |
| `Microsoft.Resources/deployments` | 2020-06-01 |


## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `aksClusterName` | string |  |  | Required. Specifies the name of the AKS cluster. |
| `location` | string | [resourceGroup().location] |  | Optional. Specifies the location of AKS cluster. It picks up Resource Group's location by default. |
| `aksClusterDnsPrefix` | string | [parameters('aksClusterName')] |  | Optional. Specifies the DNS prefix specified when creating the managed cluster. |
| `identity` | object | { "type": "SystemAssigned" } |  | Optional. The identity of the managed cluster. |
| `aksClusterNetworkPlugin` | string | "" | "", azure, kubenet | Optional. Specifies the network plugin used for building Kubernetes network. - azure or kubenet. |
| `aksClusterNetworkPolicy` | string | "" | "", azure, calico | Optional. Specifies the network policy used for building Kubernetes network. - calico or azure |
| `aksClusterPodCidr` | string | "" |  | Optional. Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used. |
| `aksClusterServiceCidr` | string | "" |  | Optional. A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges. |
| `aksClusterDnsServiceIP` | string | "" |  | Optional. Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr. |
| `aksClusterDockerBridgeCidr` | string | "" |  | Optional. Specifies the CIDR notation IP range assigned to the Docker bridge network. It must not overlap with any Subnet IP ranges or the Kubernetes service address range. |
| `aksClusterLoadBalancerSku` | string | standard | basic, standard | Optional. Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools. |
| `managedOutboundIPCount` | int | 0 |  | Optional. Outbound IP Count for the Load balancer. |
| `aksClusterOutboundType` | string | loadBalancer | loadBalancer, userDefinedRouting | Optional. Specifies outbound (egress) routing method. - loadBalancer or userDefinedRouting. |
| `aksClusterSkuTier` | string | Free | Free, Paid | Optional. Tier of a managed cluster SKU. - Free or Paid |
| `aksClusterKubernetesVersion` | string | "" |  | Optional. Version of Kubernetes specified when creating the managed cluster. |
| `aksClusterAdminUsername` | string | azureuser |  | Optional. Specifies the administrator username of Linux virtual machines. |
| `aksClusterSshPublicKey` | string |  |  | Optional. Specifies the SSH RSA public key string for the Linux nodes. |
| `aksServicePrincipalProfile` | object | {} |  | Optional. Information about a service principal identity for the cluster to use for manipulating Azure APIs. |
| `aadProfileClientAppID` | string | "" |  | Optional. The client AAD application ID. |
| `aadProfileServerAppID` | string | "" |  | Optional. The server AAD application ID. |
| `aadProfileServerAppSecret` | string | "" |  | Optional. The server AAD application secret. |
| `aadProfileTenantId` | string | [subscription().tenantId] |  | Optional. Specifies the tenant id of the Azure Active Directory used by the AKS cluster for authentication. |
| `aadProfileAdminGroupObjectIDs` | array | System.Object[] |  | Optional. Specifies the AAD group object IDs that will have admin role of the cluster. |
| `aadProfileManaged` | bool | True |  | Optional. Specifies whether to enable managed AAD integration. |
| `aadProfileEnableAzureRBAC` | bool | True |  | Optional. Specifies whether to enable Azure RBAC for Kubernetes authorization. |
| `nodeResourceGroup` | string | concat(resourceGroup().name, '_aks_nodes') |  | Optional. Name of the resource group containing agent pool nodes. |
| `aksClusterEnablePrivateCluster` | bool | False |  | Optional. Specifies whether to create the cluster as a private cluster or not. |
| `primaryAgentPoolProfile` | array | |  | Required. Properties of the primary agent pool. |
| `additionalAgentPools` | array | System.Object[] |  | Optional. Define one or multiple node pools. |
| `httpApplicationRoutingEnabled` | bool | False |  | Optional. Specifies whether the httpApplicationRouting add-on is enabled or not. |
| `aciConnectorLinuxEnabled` | bool | False |  | Optional. Specifies whether the aciConnectorLinux add-on is enabled or not. |
| `azurePolicyEnabled` | bool | True |  | Optional. Specifies whether the azurepolicy add-on is enabled or not. |
| `azurePolicyVersion` | string | v2 |  | Optional. Specifies the azure policy version to use. |
| `kubeDashboardEnabled` | bool | False |  | Optional. Specifies whether the kubeDashboard add-on is enabled or not. |
| `autoScalerProfileScanInterval` | string | 10s |  | Optional. Specifies the scan interval of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownDelayAfterAdd` | string | 10m |  | Optional. Specifies the scale down delay after add of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownDelayAfterDelete` | string | 20s |  | Optional. Specifies the scale down delay after delete of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownDelayAfterFailure` | string | 3m |  | Optional. Specifies scale down delay after failure of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownUnneededTime` | string | 10m |  | Optional. Specifies the scale down unneeded time of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownUnreadyTime` | string | 20m |  | Optional. Specifies the scale down unready time of the auto-scaler of the AKS cluster. |
| `autoScalerProfileUtilizationThreshold` | string | 0.5 |  | Optional. Specifies the utilization threshold of the auto-scaler of the AKS cluster. |
| `autoScalerProfileMaxGracefulTerminationSec` | string | 600 |  | Optional. Specifies the max graceful termination time interval in seconds for the auto-scaler of the AKS cluster. |
| `diagnosticSettingName` | string | service |  | Optional. The name of the Diagnostic setting. |
| `diagnosticStorageAccountId` | string | "" |  | Optional. Resource identifier of the Diagnostic Storage Account. |
| `workspaceId` | string | "" |  | Optional. Resource identifier of Log Analytics. |
| `omsAgentEnabled` | bool | True |  | Optional. Specifies whether the OMS agent is enabled. |
| `eventHubAuthorizationRuleId` | string | "" |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string | "" |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogsRetentionInDays` | int | 365 |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `cuaId` | string | "" |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered. |
| `roleAssignments` | array | System.Object[] |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `lockForDeletion` | bool | False |  | Optional. Switch to lock Key Vault from deletion. |
| `tags` | object | {} |  | Optional. Tags of the resource. |


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

See also https://docs.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters?tabs=json#managedclusteridentity-object

```json
"identity": {
  "value": {
    "type": "string",
    "userAssignedIdentities": {}
  }
}
```


### Parameter Usage: `aksServicePrincipalProfile`

See also https://docs.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters?tabs=json#managedclusterserviceprincipalprofile-object

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
For available properties check https://docs.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters?tabs=json#managedclusteragentpoolprofile-object

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


### Parameter Usage: `additionalAgentPools`

For available properties check https://docs.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters/agentpools?tabs=json#managedclusteragentpoolprofileproperties-object

```json
"additionalAgentPools": {
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


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `azureKubernetesServiceName` | string | The Name of the Azure Kubernetes Service. |
| `azureKubernetesServiceResourceGroup` | string | The name of the Resource Group the Azure Kubernetes Service was created in. |
| `azureKubernetesServiceResourceId` | string | The Resource Id of the Azure Kubernetes Service. |
| `controlPlaneFQDN` | string | The FQDN of the Azure Kubernetes Service. |


## Considerations

- *None*


## Additional resources

- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
- [Azure Resource Manager template reference](https://docs.microsoft.com/en-us/azure/templates/)
- [ManagedClusters](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2020-11-01/managedClusters)
- [ManagedClusters/providers/diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2017-05-01-preview/managedClusters/providers/diagnosticsettings)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)