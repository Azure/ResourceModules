# Purview Accounts `[Microsoft.Purview/accounts]`

This module deploys a Purview Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Purview/accounts` | [2021-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Purview/2021-07-01/accounts) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Purview Account. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `accountPrivateEndpoints` | array | `[]` |  | Configuration details for Purview Account private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to 'account'. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, DataSensitivity, PurviewAccountAuditEvents, ScanStatus]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `eventHubPrivateEndpoints` | array | `[]` |  | Configuration details for Purview Managed Event Hub namespace private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to 'namespace'. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `managedResourceGroupName` | string | `[format('managed-rg-{0}', parameters('name'))]` |  | The Managed Resource Group Name. A managed Storage Account, and an Event Hubs will be created in the selected subscription for catalog ingestion scenarios. Default is 'managed-rg-<purview-account-name>'. |
| `portalPrivateEndpoints` | array | `[]` |  | Configuration details for Purview Portal private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to 'portal'. |
| `publicNetworkAccess` | string | `'NotSpecified'` | `[Disabled, Enabled, NotSpecified]` | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `storageBlobPrivateEndpoints` | array | `[]` |  | Configuration details for Purview Managed Storage Account blob private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to 'blob'. |
| `storageQueuePrivateEndpoints` | array | `[]` |  | Configuration details for Purview Managed Storage Account queue private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to 'queue'. |
| `tags` | object | `{object}` |  | Tags of the resource. |
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
| `location` | string | The location the resource was deployed into. |
| `managedEventHubId` | string | The resource ID of the managed Event Hub Namespace. |
| `managedResourceGroupId` | string | The resource ID of the managed resource group. |
| `managedResourceGroupName` | string | The name of the managed resource group. |
| `managedStorageAccountId` | string | The resource ID of the managed storage account. |
| `name` | string | The name of the Purview Account. |
| `resourceGroupName` | string | The resource group the Purview Account was deployed into. |
| `resourceId` | string | The resource ID of the Purview Account. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `network/private-endpoints` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module accounts './purview/accounts/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-pvacom'
  params: {
    // Required parameters
    name: '<<namePrefix>>pvacom001'
    // Non-required parameters
    accountPrivateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<purviewAccountPrivateDNSResourceId>'
          ]
        }
        service: 'account'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogCategoriesToEnable: [
      'allLogs'
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticMetricsToEnable: [
      'AllMetrics'
    ]
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    eventHubPrivateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<eventHubPrivateDNSResourceId>'
          ]
        }
        service: 'namespace'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    location: '<location>'
    lock: 'CanNotDelete'
    managedResourceGroupName: '<<namePrefix>>pvacom001-managed-rg'
    portalPrivateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<purviewPortalPrivateDNSResourceId>'
          ]
        }
        service: 'portal'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    publicNetworkAccess: 'Disabled'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    storageBlobPrivateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<storageBlobPrivateDNSResourceId>'
          ]
        }
        service: 'blob'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    storageQueuePrivateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<storageQueuePrivateDNSResourceId>'
          ]
        }
        service: 'queue'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    tags: {
      Environment: 'Non-Prod'
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
      "value": "<<namePrefix>>pvacom001"
    },
    // Non-required parameters
    "accountPrivateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<purviewAccountPrivateDNSResourceId>"
            ]
          },
          "service": "account",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticLogCategoriesToEnable": {
      "value": [
        "allLogs"
      ]
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
    },
    "diagnosticMetricsToEnable": {
      "value": [
        "AllMetrics"
      ]
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
    "eventHubPrivateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<eventHubPrivateDNSResourceId>"
            ]
          },
          "service": "namespace",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "managedResourceGroupName": {
      "value": "<<namePrefix>>pvacom001-managed-rg"
    },
    "portalPrivateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<purviewPortalPrivateDNSResourceId>"
            ]
          },
          "service": "portal",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "publicNetworkAccess": {
      "value": "Disabled"
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
    "storageBlobPrivateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<storageBlobPrivateDNSResourceId>"
            ]
          },
          "service": "blob",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "storageQueuePrivateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<storageQueuePrivateDNSResourceId>"
            ]
          },
          "service": "queue",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
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

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module accounts './purview/accounts/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-pvamin'
  params: {
    // Required parameters
    name: '<<namePrefix>>pvamin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    managedResourceGroupName: '<<namePrefix>>pvamin001-managed-rg'
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
      "value": "<<namePrefix>>pvamin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "managedResourceGroupName": {
      "value": "<<namePrefix>>pvamin001-managed-rg"
    }
  }
}
```

</details>
<p>
