# Network Interface `[Microsoft.Network/networkInterfaces]`

This module deploys a Network Interface.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/networkInterfaces` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkInterfaces) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.network-interface:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module networkInterface 'br:bicep/modules/network.network-interface:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nnicom'
  params: {
    // Required parameters
    ipConfigurations: [
      {
        applicationSecurityGroups: [
          {
            id: '<id>'
          }
        ]
        loadBalancerBackendAddressPools: [
          {
            id: '<id>'
          }
        ]
        name: 'ipconfig01'
        subnetResourceId: '<subnetResourceId>'
      }
      {
        applicationSecurityGroups: [
          {
            id: '<id>'
          }
        ]
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    name: 'nnicom001'
    // Non-required parameters
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "ipConfigurations": {
      "value": [
        {
          "applicationSecurityGroups": [
            {
              "id": "<id>"
            }
          ],
          "loadBalancerBackendAddressPools": [
            {
              "id": "<id>"
            }
          ],
          "name": "ipconfig01",
          "subnetResourceId": "<subnetResourceId>"
        },
        {
          "applicationSecurityGroups": [
            {
              "id": "<id>"
            }
          ],
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "name": {
      "value": "nnicom001"
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module networkInterface 'br:bicep/modules/network.network-interface:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nnimin'
  params: {
    // Required parameters
    ipConfigurations: [
      {
        name: 'ipconfig01'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    name: 'nnimin001'
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
    "ipConfigurations": {
      "value": [
        {
          "name": "ipconfig01",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "name": {
      "value": "nnimin001"
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipConfigurations`](#parameter-ipconfigurations) | array | A list of IPConfigurations of the network interface. |
| [`name`](#parameter-name) | string | The name of the network interface. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auxiliaryMode`](#parameter-auxiliarymode) | string | Auxiliary mode of Network Interface resource. Not all regions are enabled for Auxiliary Mode Nic. |
| [`auxiliarySku`](#parameter-auxiliarysku) | string | Auxiliary sku of Network Interface resource. Not all regions are enabled for Auxiliary Mode Nic. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource identifier of log analytics. |
| [`disableTcpStateTracking`](#parameter-disabletcpstatetracking) | bool | Indicates whether to disable tcp state tracking. Subscription must be registered for the Microsoft.Network/AllowDisableTcpStateTracking feature before this property can be set to true. |
| [`dnsServers`](#parameter-dnsservers) | array | List of DNS servers IP addresses. Use 'AzureProvidedDNS' to switch to azure provided DNS resolution. 'AzureProvidedDNS' value cannot be combined with other IPs, it must be the only value in dnsServers collection. |
| [`enableAcceleratedNetworking`](#parameter-enableacceleratednetworking) | bool | If the network interface is accelerated networking enabled. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`enableIPForwarding`](#parameter-enableipforwarding) | bool | Indicates whether IP forwarding is enabled on this network interface. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`networkSecurityGroupResourceId`](#parameter-networksecuritygroupresourceid) | string | The network security group (NSG) to attach to the network interface. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `auxiliaryMode`

Auxiliary mode of Network Interface resource. Not all regions are enabled for Auxiliary Mode Nic.
- Required: No
- Type: string
- Default: `'None'`
- Allowed: `[Floating, MaxConnections, None]`

### Parameter: `auxiliarySku`

Auxiliary sku of Network Interface resource. Not all regions are enabled for Auxiliary Mode Nic.
- Required: No
- Type: string
- Default: `'None'`
- Allowed: `[A1, A2, A4, A8, None]`

### Parameter: `diagnosticEventHubAuthorizationRuleId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticMetricsToEnable`

The name of metrics that will be streamed.
- Required: No
- Type: array
- Default: `[AllMetrics]`
- Allowed: `[AllMetrics]`

### Parameter: `diagnosticSettingsName`

The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticStorageAccountId`

Resource ID of the diagnostic storage account.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticWorkspaceId`

Resource identifier of log analytics.
- Required: No
- Type: string
- Default: `''`

### Parameter: `disableTcpStateTracking`

Indicates whether to disable tcp state tracking. Subscription must be registered for the Microsoft.Network/AllowDisableTcpStateTracking feature before this property can be set to true.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `dnsServers`

List of DNS servers IP addresses. Use 'AzureProvidedDNS' to switch to azure provided DNS resolution. 'AzureProvidedDNS' value cannot be combined with other IPs, it must be the only value in dnsServers collection.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableAcceleratedNetworking`

If the network interface is accelerated networking enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableIPForwarding`

Indicates whether IP forwarding is enabled on this network interface.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `ipConfigurations`

A list of IPConfigurations of the network interface.
- Required: Yes
- Type: array

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

The name of the network interface.
- Required: Yes
- Type: string

### Parameter: `networkSecurityGroupResourceId`

The network security group (NSG) to attach to the network interface.
- Required: No
- Type: string
- Default: `''`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed resource. |
| `resourceGroupName` | string | The resource group of the deployed resource. |
| `resourceId` | string | The resource ID of the deployed resource. |

## Cross-referenced modules

_None_
