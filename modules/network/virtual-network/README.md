# Virtual Networks `[Microsoft.Network/virtualNetworks]`

This module deploys a Virtual Network (vNet).

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
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/virtualNetworks` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/virtualNetworkPeerings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `addressPrefixes` | array | An Array of 1 or more IP Address Prefixes for the Virtual Network. |
| `name` | string | The Virtual Network (vNet) Name. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `ddosProtectionPlanId` | string | `''` |  | Resource ID of the DDoS protection plan to assign the VNET to. If it's left blank, DDoS protection will not be configured. If it's provided, the VNET created by this template will be attached to the referenced DDoS protection plan. The DDoS protection plan can exist in the same or in a different subscription. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', allLogs, VMProtectionAlerts]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `dnsServers` | array | `[]` |  | DNS Servers associated to the Virtual Network. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `flowTimeoutInMinutes` | int | `0` |  | The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes. Default value 0 will set the property to null. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `peerings` | array | `[]` |  | Virtual Network Peerings configurations. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `subnets` | array | `[]` |  | An Array of subnets to deploy to the Virtual Network. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `vnetEncryption` | bool | `False` |  | Indicates if encryption is enabled on virtual network and if VM without encryption is allowed in encrypted VNet. Requires the EnableVNetEncryption feature to be registered for the subscription and a supported region to use this property. |
| `vnetEncryptionEnforcement` | string | `'AllowUnencrypted'` | `[AllowUnencrypted, DropUnencrypted]` | If the encrypted VNet allows VM that does not support encryption. Can only be used when vnetEncryption is enabled. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `diagnosticsLogs` | array | The Diagnostic Settings of the virtual network. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the virtual network. |
| `resourceGroupName` | string | The resource group the virtual network was deployed into. |
| `resourceId` | string | The resource ID of the virtual network. |
| `subnetNames` | array | The names of the deployed subnets. |
| `subnetResourceIds` | array | The resource IDs of the deployed subnets. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetwork './network/virtual-network/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvncom'
  params: {
    // Required parameters
    addressPrefixes: [
      '<addressPrefix>'
    ]
    name: 'nvncom001'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    dnsServers: [
      '10.0.1.4'
      '10.0.1.5'
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    flowTimeoutInMinutes: 20
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    subnets: [
      {
        addressPrefix: '<addressPrefix>'
        name: 'GatewaySubnet'
      }
      {
        addressPrefix: '<addressPrefix>'
        name: 'az-subnet-x-001'
        networkSecurityGroupId: '<networkSecurityGroupId>'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        routeTableId: '<routeTableId>'
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
          {
            service: 'Microsoft.Sql'
          }
        ]
      }
      {
        addressPrefix: '<addressPrefix>'
        delegations: [
          {
            name: 'netappDel'
            properties: {
              serviceName: 'Microsoft.Netapp/volumes'
            }
          }
        ]
        name: 'az-subnet-x-002'
      }
      {
        addressPrefix: '<addressPrefix>'
        name: 'az-subnet-x-003'
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
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
    "addressPrefixes": {
      "value": [
        "<addressPrefix>"
      ]
    },
    "name": {
      "value": "nvncom001"
    },
    // Non-required parameters
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
    "dnsServers": {
      "value": [
        "10.0.1.4",
        "10.0.1.5"
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "flowTimeoutInMinutes": {
      "value": 20
    },
    "lock": {
      "value": "CanNotDelete"
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
    "subnets": {
      "value": [
        {
          "addressPrefix": "<addressPrefix>",
          "name": "GatewaySubnet"
        },
        {
          "addressPrefix": "<addressPrefix>",
          "name": "az-subnet-x-001",
          "networkSecurityGroupId": "<networkSecurityGroupId>",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "routeTableId": "<routeTableId>",
          "serviceEndpoints": [
            {
              "service": "Microsoft.Storage"
            },
            {
              "service": "Microsoft.Sql"
            }
          ]
        },
        {
          "addressPrefix": "<addressPrefix>",
          "delegations": [
            {
              "name": "netappDel",
              "properties": {
                "serviceName": "Microsoft.Netapp/volumes"
              }
            }
          ],
          "name": "az-subnet-x-002"
        },
        {
          "addressPrefix": "<addressPrefix>",
          "name": "az-subnet-x-003",
          "privateEndpointNetworkPolicies": "Disabled",
          "privateLinkServiceNetworkPolicies": "Enabled"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetwork './network/virtual-network/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvnmin'
  params: {
    // Required parameters
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    name: 'nvnmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "addressPrefixes": {
      "value": [
        "10.0.0.0/16"
      ]
    },
    "name": {
      "value": "nvnmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

<h3>Example 3: Vnetpeering</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetwork './network/virtual-network/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-nvnpeer'
  params: {
    // Required parameters
    addressPrefixes: [
      '10.1.0.0/24'
    ]
    name: 'nvnpeer001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    peerings: [
      {
        allowForwardedTraffic: true
        allowGatewayTransit: false
        allowVirtualNetworkAccess: true
        remotePeeringAllowForwardedTraffic: true
        remotePeeringAllowVirtualNetworkAccess: true
        remotePeeringEnabled: true
        remotePeeringName: 'customName'
        remoteVirtualNetworkId: '<remoteVirtualNetworkId>'
        useRemoteGateways: false
      }
    ]
    subnets: [
      {
        addressPrefix: '10.1.0.0/26'
        name: 'GatewaySubnet'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
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
    "addressPrefixes": {
      "value": [
        "10.1.0.0/24"
      ]
    },
    "name": {
      "value": "nvnpeer001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "peerings": {
      "value": [
        {
          "allowForwardedTraffic": true,
          "allowGatewayTransit": false,
          "allowVirtualNetworkAccess": true,
          "remotePeeringAllowForwardedTraffic": true,
          "remotePeeringAllowVirtualNetworkAccess": true,
          "remotePeeringEnabled": true,
          "remotePeeringName": "customName",
          "remoteVirtualNetworkId": "<remoteVirtualNetworkId>",
          "useRemoteGateways": false
        }
      ]
    },
    "subnets": {
      "value": [
        {
          "addressPrefix": "10.1.0.0/26",
          "name": "GatewaySubnet"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>


## Notes

### Considerations

The network security group and route table resources must reside in the same resource group as the virtual network.

### Parameter Usage: `peerings`

As the virtual network peering array allows you to deploy not only a one-way but also two-way peering (i.e reverse), you can use the following ***additional*** properties on top of what is documented in _[virtualNetworkPeering](virtual-network-peering/README.md)_.

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `remotePeeringEnabled` | bool | `false` |  | Optional. Set to true to also deploy the reverse peering for the configured remote virtual networks to the local network |
| `remotePeeringName` | string | `'${last(split(peering.remoteVirtualNetworkId, '/'))}-${name}'` | | Optional. The Name of Vnet Peering resource. If not provided, default value will be <remoteVnetName>-<localVnetName> |
| `remotePeeringAllowForwardedTraffic` | bool | `true` | | Optional. Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network. |
| `remotePeeringAllowGatewayTransit` | bool | `false` | | Optional. If gateway links can be used in remote virtual networking to link to this virtual network. |
| `remotePeeringAllowVirtualNetworkAccess` | bool | `true` | | Optional. Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space. |
| `remotePeeringDoNotVerifyRemoteGateways` | bool | `true` | | Optional. If we need to verify the provisioning state of the remote gateway. |
| `remotePeeringUseRemoteGateways` | bool | `false` | |  Optional. If remote gateways can be used on this virtual network. If the flag is set to `true`, and allowGatewayTransit on local peering is also `true`, virtual network will use gateways of local virtual network for transit. Only one peering can have this flag set to `true`. This flag cannot be set if virtual network already has a gateway.  |
