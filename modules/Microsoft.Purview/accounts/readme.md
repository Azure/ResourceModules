# `[Microsoft.Purview/accounts]`

This module deploys .
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2022-05-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-05-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Purview/accounts` | [2021-07-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Purview/2021-07-01/accounts) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `managedResourceGroupName` | string | The Managed Resource Group Name. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `accountPrivateEndpointName` | string | `''` | Name of the Purview Account Private Endpoint. Required for the Purview account Private Endpoint. |
| `eventHubPrivateEndpointName` | string | `''` | Name of the managed Event Hub Namespace Private Endpoint. Required for the managed Event Hub Namespace private endpoint. |
| `portalPrivateEndpointName` | string | `''` | Name of the Purview Portal Private Endpoint. Required for the Purview portal Private Endpoint. |
| `storageAccountBlobPrivateEndpointName` | string | `''` | Name of the managed Storage Account blob Private Endpoint. Required for the managed storage account blob private endpoint. |
| `storageAccountQueuePrivateEndpointName` | string | `''` | Name of the managed Storage Account queue Private Endpoint. Required for the managed storage account queue private endpoint |
| `subnetId` | string | `''` | Existing Subnet Resource ID to assign to the Private Endpoint. Required for Private Endpoints. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `accountPrivateEndpointIP` | string | `''` |  | The static privavte IP address for the Purview Account private endpoint. |
| `accountPrivateEndpointNicName` | string | `''` |  | The custom name of the network interface attached to the Purview Account private endpoint. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, DataSensitivity, PurviewAccountAuditEvents, ScanStatus]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `eventHubPrivateEndpointIP` | string | `''` |  | The static private IP address for the managed Event Hub Namespace private endpoint. |
| `eventHubPrivateEndpointNicName` | string | `''` |  | The custom name of the network interface attached to the managed Event Hub Namespace private endpoint. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `portalPrivateEndpointIP` | string | `''` |  | The static privavte IP address for the Purview Portal private endpoint. |
| `portalPrivateEndpointNicName` | string | `''` |  | The custom name of the network interface attached to the Purview Portal private endpoint. |
| `publicNetworkAccess` | string | `'Disabled'` | `[Disabled, Enabled, NotSpecified]` | Enable or disable resource provider inbound network traffic from public clients. default is Disabled |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `storageAccountBlobPrivateEndpointIP` | string | `''` |  | The static private IP address for the managed Storage Account blob private endpoint. |
| `storageAccountBlobPrivateEndpointNicName` | string | `''` |  | The custom name of the network interface attached to the managed Storage Account blob private endpoint. |
| `storageAccountQueuePrivateEndpointIP` | string | `''` |  | The static private IP address for the managed Storage Account blob private endpoint. |
| `storageAccountQueuePrivateEndpointNicName` | string | `''` |  | The custom name of the network interface attached to the managed Storage Account queue private endpoint. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |

**Azure location where the Purview Account will be created parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |

**Name of the Purview Account parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |

**Tags parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

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

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `accountName` | string | The name of the Microsoft Purview Account. |
| `accountPrivateEndpointId` | string | The resource ID of the Purview Account private endpoint |
| `eventHubPrivateEndpointId` | string | The resource ID of the Purview Managed Event Hub Namepsace private endpoint |
| `location` | string | The location the resource was deployed into. |
| `managedEventHubId` | string | The resource ID of the managed Event Hub Namespace |
| `managedResourceGroupId` | string | The resource ID of the managed resource group. |
| `managedResourceGroupName` | string | The name of the managed resource group. |
| `managedStorageAccountId` | string | The resource ID of the managed storage account. |
| `portalPrivateEndpointId` | string | The resource ID of the Purview portal private endpoint |
| `resourceGroupName` | string | The resource group the Microsoft Purview Account was deployed into. |
| `resourceId` | string | The resource ID of the Microsoft Purview Account. |
| `storageAccountBlobPrivateEndpointId` | string | The resource ID of the Purview Managed Storage Account Blob private endpoint |
| `storageAccountQueuePrivateEndpointId` | string | The resource ID of the Purview Managed Storage Account Queue private endpoint |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `Microsoft.Network/privateEndpoints` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module accounts './Microsoft.Purview/accounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-pviewcom'
  params: {
    // Required parameters
    managedResourceGroupName: '<<namePrefix>>pviewcom002-managed-rg'
    name: '<<namePrefix>>pviewcom002'
    // Non-required parameters
    accountPrivateEndpointName: 'pe-<<namePrefix>>pviewcom002-account'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    eventHubPrivateEndpointName: 'pe-<<namePrefix>>pviewcom002-eh'
    portalPrivateEndpointName: 'pe-<<namePrefix>>pviewcom002-portal'
    publicNetworkAccess: 'Disabled'
    storageAccountBlobPrivateEndpointName: 'pe-<<namePrefix>>pviewcom002-sa-blob-blob'
    storageAccountQueuePrivateEndpointName: 'pe-<<namePrefix>>pviewcom002-sa-queue-blob'
    subnetId: '<subnetId>'
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
    "managedResourceGroupName": {
      "value": "<<namePrefix>>pviewcom002-managed-rg"
    },
    "name": {
      "value": "<<namePrefix>>pviewcom002"
    },
    // Non-required parameters
    "accountPrivateEndpointName": {
      "value": "pe-<<namePrefix>>pviewcom002-account"
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
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
    "eventHubPrivateEndpointName": {
      "value": "pe-<<namePrefix>>pviewcom002-eh"
    },
    "portalPrivateEndpointName": {
      "value": "pe-<<namePrefix>>pviewcom002-portal"
    },
    "publicNetworkAccess": {
      "value": "Disabled"
    },
    "storageAccountBlobPrivateEndpointName": {
      "value": "pe-<<namePrefix>>pviewcom002-sa-blob-blob"
    },
    "storageAccountQueuePrivateEndpointName": {
      "value": "pe-<<namePrefix>>pviewcom002-sa-queue-blob"
    },
    "subnetId": {
      "value": "<subnetId>"
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
module accounts './Microsoft.Purview/accounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-test-pviewmin'
  params: {
    // Required parameters
    managedResourceGroupName: '<<namePrefix>>pviewmin001-managed-rg'
    name: '<<namePrefix>>pviewmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    publicNetworkAccess: 'Enabled'
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
    "managedResourceGroupName": {
      "value": "<<namePrefix>>pviewmin001-managed-rg"
    },
    "name": {
      "value": "<<namePrefix>>pviewmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "publicNetworkAccess": {
      "value": "Enabled"
    }
  }
}
```

</details>
<p>
