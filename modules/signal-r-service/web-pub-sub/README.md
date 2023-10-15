# SignalR Web PubSub Services `[Microsoft.SignalRService/webPubSub]`

This module deploys a SignalR Web PubSub Service.

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
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.SignalRService/webPubSub` | [2021-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SignalRService/2021-10-01/webPubSub) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/signal-r-service.web-pub-sub:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)
- [Pe](#example-3-pe)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module webPubSub 'br:bicep/modules/signal-r-service.web-pub-sub:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-srswpscom'
  params: {
    // Required parameters
    name: 'srswpscom-001'
    // Non-required parameters
    capacity: 2
    clientCertEnabled: false
    disableAadAuth: false
    disableLocalAuth: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    location: '<location>'
    lock: 'CanNotDelete'
    networkAcls: {
      defaultAction: 'Allow'
      privateEndpoints: [
        {
          allow: []
          deny: [
            'ServerConnection'
            'Trace'
          ]
          name: 'pe-srswpscom-001'
        }
      ]
      publicNetwork: {
        allow: []
        deny: [
          'RESTAPI'
          'Trace'
        ]
      }
    }
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSResourceId>'
          ]
        }
        service: 'webpubsub'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    resourceLogConfigurationsToEnable: [
      'ConnectivityLogs'
    ]
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    sku: 'Standard_S1'
    systemAssignedIdentity: true
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
    "name": {
      "value": "srswpscom-001"
    },
    // Non-required parameters
    "capacity": {
      "value": 2
    },
    "clientCertEnabled": {
      "value": false
    },
    "disableAadAuth": {
      "value": false
    },
    "disableLocalAuth": {
      "value": true
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "networkAcls": {
      "value": {
        "defaultAction": "Allow",
        "privateEndpoints": [
          {
            "allow": [],
            "deny": [
              "ServerConnection",
              "Trace"
            ],
            "name": "pe-srswpscom-001"
          }
        ],
        "publicNetwork": {
          "allow": [],
          "deny": [
            "RESTAPI",
            "Trace"
          ]
        }
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSResourceId>"
            ]
          },
          "service": "webpubsub",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "resourceLogConfigurationsToEnable": {
      "value": [
        "ConnectivityLogs"
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "sku": {
      "value": "Standard_S1"
    },
    "systemAssignedIdentity": {
      "value": true
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
module webPubSub 'br:bicep/modules/signal-r-service.web-pub-sub:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-srswpsmin'
  params: {
    // Required parameters
    name: 'srswpsmin-001'
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
    "name": {
      "value": "srswpsmin-001"
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

### Example 3: _Pe_

<details>

<summary>via Bicep module</summary>

```bicep
module webPubSub 'br:bicep/modules/signal-r-service.web-pub-sub:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-srswpspe'
  params: {
    // Required parameters
    name: 'srswpspe-001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSResourceId>'
          ]
        }
        service: 'webpubsub'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    sku: 'Standard_S1'
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
    "name": {
      "value": "srswpspe-001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSResourceId>"
            ]
          },
          "service": "webpubsub",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "sku": {
      "value": "Standard_S1"
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Web PubSub Service resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-capacity) | int | The unit count of the resource. 1 by default. |
| [`clientCertEnabled`](#parameter-clientcertenabled) | bool | Request client certificate during TLS handshake if enabled. |
| [`disableAadAuth`](#parameter-disableaadauth) | bool | When set as true, connection with AuthType=aad won't work. |
| [`disableLocalAuth`](#parameter-disablelocalauth) | bool | Disables all authentication methods other than AAD authentication. For security reasons, this value should be set to `true`. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | The location for the resource. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`networkAcls`](#parameter-networkacls) | object | Networks ACLs, this value contains IPs to allow and/or Subnet information. Can only be set if the 'SKU' is not 'Free_F1'. For security reasons, it is recommended to set the DefaultAction Deny. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| [`resourceLogConfigurationsToEnable`](#parameter-resourcelogconfigurationstoenable) | array | Control permission for data plane traffic coming from public networks while private endpoint is enabled. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`sku`](#parameter-sku) | string | Pricing tier of the resource. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |

### Parameter: `capacity`

The unit count of the resource. 1 by default.
- Required: No
- Type: int
- Default: `1`

### Parameter: `clientCertEnabled`

Request client certificate during TLS handshake if enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `disableAadAuth`

When set as true, connection with AuthType=aad won't work.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `disableLocalAuth`

Disables all authentication methods other than AAD authentication. For security reasons, this value should be set to `true`.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

The location for the resource.
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

The name of the Web PubSub Service resource.
- Required: Yes
- Type: string

### Parameter: `networkAcls`

Networks ACLs, this value contains IPs to allow and/or Subnet information. Can only be set if the 'SKU' is not 'Free_F1'. For security reasons, it is recommended to set the DefaultAction Deny.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', Disabled, Enabled]`

### Parameter: `resourceLogConfigurationsToEnable`

Control permission for data plane traffic coming from public networks while private endpoint is enabled.
- Required: No
- Type: array
- Default: `[ConnectivityLogs, MessagingLogs]`
- Allowed: `[ConnectivityLogs, MessagingLogs]`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `sku`

Pricing tier of the resource.
- Required: No
- Type: string
- Default: `'Standard_S1'`
- Allowed: `[Free_F1, Standard_S1]`

### Parameter: `systemAssignedIdentity`

Enables system assigned managed identity on the resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `externalIP` | string | The Web PubSub externalIP. |
| `hostName` | string | The Web PubSub hostName. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The Web PubSub name. |
| `publicPort` | int | The Web PubSub publicPort. |
| `resourceGroupName` | string | The Web PubSub resource group. |
| `resourceId` | string | The Web PubSub resource ID. |
| `serverPort` | int | The Web PubSub serverPort. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/private-endpoint` | Local reference |
