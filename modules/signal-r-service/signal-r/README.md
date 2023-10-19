# SignalR Service SignalR `[Microsoft.SignalRService/signalR]`

This module deploys a SignalR Service SignalR.

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
| `Microsoft.SignalRService/signalR` | [2022-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SignalRService/2022-02-01/signalR) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/signal-r-service.signal-r:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Using only defaults](#example-2-using-only-defaults)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module signalR 'br:bicep/modules/signal-r-service.signal-r:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-srssrcom'
  params: {
    // Required parameters
    name: 'srssrcom-001'
    // Non-required parameters
    capacity: 2
    clientCertEnabled: false
    disableAadAuth: false
    disableLocalAuth: true
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'SignalR'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    networkAcls: {
      defaultAction: 'Allow'
      privateEndpoints: [
        {
          allow: []
          deny: [
            'ServerConnection'
            'Trace'
          ]
          name: 'pe-srssrcom-001'
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
        service: 'signalr'
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
      "value": "srssrcom-001"
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
    "kind": {
      "value": "SignalR"
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
            "name": "pe-srssrcom-001"
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
          "service": "signalr",
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
module signalR 'br:bicep/modules/signal-r-service.signal-r:1.0.0' = {
  name: '${uniqueString(deployment().name)}-test-srsdrmin'
  params: {
    // Required parameters
    name: 'srsdrmin-001'
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
      "value": "srsdrmin-001"
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
| [`name`](#parameter-name) | string | The name of the SignalR Service resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedOrigins`](#parameter-allowedorigins) | array | The allowed origin settings of the resource. |
| [`capacity`](#parameter-capacity) | int | The unit count of the resource. |
| [`clientCertEnabled`](#parameter-clientcertenabled) | bool | Request client certificate during TLS handshake if enabled. |
| [`disableAadAuth`](#parameter-disableaadauth) | bool | The disable Azure AD auth settings of the resource. |
| [`disableLocalAuth`](#parameter-disablelocalauth) | bool | The disable local auth settings of the resource. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`features`](#parameter-features) | array | The features settings of the resource, `ServiceMode` is the only required feature. See https://learn.microsoft.com/en-us/azure/templates/microsoft.signalrservice/signalr?pivots=deployment-language-bicep#signalrfeature for more information. |
| [`kind`](#parameter-kind) | string | The kind of the service. |
| [`liveTraceCatagoriesToEnable`](#parameter-livetracecatagoriestoenable) | array | Control permission for data plane traffic coming from public networks while private endpoint is enabled. |
| [`location`](#parameter-location) | string | The location for the resource. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`networkAcls`](#parameter-networkacls) | object | Networks ACLs, this value contains IPs to allow and/or Subnet information. Can only be set if the 'SKU' is not 'Free_F1'. For security reasons, it is recommended to set the DefaultAction Deny. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| [`resourceLogConfigurationsToEnable`](#parameter-resourcelogconfigurationstoenable) | array | Control permission for data plane traffic coming from public networks while private endpoint is enabled. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`sku`](#parameter-sku) | string | The SKU of the service. |
| [`tags`](#parameter-tags) | object | The tags of the resource. |
| [`upstreamTemplatesToEnable`](#parameter-upstreamtemplatestoenable) | array | Upstream templates to enable. For more information, see https://learn.microsoft.com/en-us/azure/templates/microsoft.signalrservice/2022-02-01/signalr?pivots=deployment-language-bicep#upstreamtemplate. |

### Parameter: `allowedOrigins`

The allowed origin settings of the resource.
- Required: No
- Type: array
- Default: `[*]`

### Parameter: `capacity`

The unit count of the resource.
- Required: No
- Type: int
- Default: `1`

### Parameter: `clientCertEnabled`

Request client certificate during TLS handshake if enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `disableAadAuth`

The disable Azure AD auth settings of the resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `disableLocalAuth`

The disable local auth settings of the resource.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `features`

The features settings of the resource, `ServiceMode` is the only required feature. See https://learn.microsoft.com/en-us/azure/templates/microsoft.signalrservice/signalr?pivots=deployment-language-bicep#signalrfeature for more information.
- Required: No
- Type: array
- Default: `[System.Management.Automation.OrderedHashtable]`

### Parameter: `kind`

The kind of the service.
- Required: No
- Type: string
- Default: `'SignalR'`
- Allowed: `[RawWebSockets, SignalR]`

### Parameter: `liveTraceCatagoriesToEnable`

Control permission for data plane traffic coming from public networks while private endpoint is enabled.
- Required: No
- Type: array
- Default: `[ConnectivityLogs, MessagingLogs]`
- Allowed: `[ConnectivityLogs, MessagingLogs]`

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

The name of the SignalR Service resource.
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

The SKU of the service.
- Required: No
- Type: string
- Default: `'Standard_S1'`
- Allowed: `[Free_F1, Premium_P1, Premium_P2, Premium_P3, Standard_S1, Standard_S2, Standard_S3]`

### Parameter: `tags`

The tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `upstreamTemplatesToEnable`

Upstream templates to enable. For more information, see https://learn.microsoft.com/en-us/azure/templates/microsoft.signalrservice/2022-02-01/signalr?pivots=deployment-language-bicep#upstreamtemplate.
- Required: No
- Type: array
- Default: `[]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The SignalR name. |
| `resourceGroupName` | string | The SignalR resource group. |
| `resourceId` | string | The SignalR resource ID. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/private-endpoint` | Local reference |
