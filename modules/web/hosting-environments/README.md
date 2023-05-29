# App Service Environments `[Microsoft.Web/hostingEnvironments]`

This module deploys an app service environment.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Web/hostingEnvironments` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-03-01/hostingEnvironments) |
| `Microsoft.Web/hostingEnvironments/configurations` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/hostingEnvironments/configurations) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the App Service Environment. |
| `subnetResourceId` | string | ResourceId for the subnet. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `customDnsSuffixCertificateUrl` | string | `''` | The URL referencing the Azure Key Vault certificate secret that should be used as the default SSL/TLS certificate for sites with the custom domain suffix. Required if customDnsSuffix is not empty. Cannot be used when kind is set to ASEv2. |
| `customDnsSuffixKeyVaultReferenceIdentity` | string | `''` | The user-assigned identity to use for resolving the key vault certificate reference. If not specified, the system-assigned ASE identity will be used if available. Required if customDnsSuffix is not empty. Cannot be used when kind is set to ASEv2. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowNewPrivateEndpointConnections` | bool | `False` |  | Property to enable and disable new private endpoint connection creation on ASE. Ignored when kind is set to ASEv2. |
| `clusterSettings` | array | `[System.Management.Automation.OrderedHashtable]` |  | Custom settings for changing the behavior of the App Service Environment. |
| `customDnsSuffix` | string | `''` |  | Enable the default custom domain suffix to use for all sites deployed on the ASE. If provided, then customDnsSuffixCertificateUrl and customDnsSuffixKeyVaultReferenceIdentity are required. Cannot be used when kind is set to ASEv2. |
| `dedicatedHostCount` | int | `0` |  | The Dedicated Host Count. If `zoneRedundant` is false, and you want physical hardware isolation enabled, set to 2. Otherwise 0. Cannot be used when kind is set to ASEv2. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, AppServiceEnvironmentPlatformLogs]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `dnsSuffix` | string | `''` |  | DNS suffix of the App Service Environment. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `frontEndScaleFactor` | int | `15` |  | Scale factor for frontends. |
| `ftpEnabled` | bool | `False` |  | Property to enable and disable FTP on ASEV3. Ignored when kind is set to ASEv2. |
| `inboundIpAddressOverride` | string | `''` |  | Customer provided Inbound IP Address. Only able to be set on Ase create. Ignored when kind is set to ASEv2. |
| `internalLoadBalancingMode` | string | `'None'` | `[None, Publishing, Web, Web, Publishing]` | Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment. - None, Web, Publishing, Web,Publishing. "None" Exposes the ASE-hosted apps on an internet-accessible IP address. |
| `ipsslAddressCount` | int | `0` |  | Number of IP SSL addresses reserved for the App Service Environment. Cannot be used when kind is set to ASEv3. |
| `kind` | string | `'ASEv3'` | `[ASEv2, ASEv3]` | Kind of resource. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `multiSize` | string | `''` | `['', ExtraLarge, Large, Medium, Standard_D1_V2, Standard_D2, Standard_D2_V2, Standard_D3, Standard_D3_V2, Standard_D4, Standard_D4_V2]` | Frontend VM size. Cannot be used when kind is set to ASEv3. |
| `remoteDebugEnabled` | bool | `False` |  | Property to enable and disable Remote Debug on ASEv3. Ignored when kind is set to ASEv2. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Resource tags. |
| `upgradePreference` | string | `'None'` | `[Early, Late, Manual, None]` | Specify preference for when and how the planned maintenance is applied. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `userWhitelistedIpRanges` | array | `[]` |  | User added IP ranges to whitelist on ASE DB. Cannot be used with 'kind' `ASEv3`. |
| `zoneRedundant` | bool | `False` |  | Switch to make the App Service Environment zone redundant. If enabled, the minimum App Service plan instance count will be three, otherwise 1. If enabled, the `dedicatedHostCount` must be set to `-1`. |


### Parameter Usage: `clusterSettings`

<details>

<summary>Parameter JSON format</summary>

```json
"clusterSettings": {
    "value": [
        {
            "name": "DisableTls1.0",
            "value": "1"
        }
    ]
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
clusterSettings:  [
    {
        name: 'DisableTls1.0'
        value: '1'
    }
]
```

</details>

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
| `name` | string | The name of the App Service Environment. |
| `resourceGroupName` | string | The resource group the App Service Environment was deployed into. |
| `resourceId` | string | The resource ID of the App Service Environment. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Asev2</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironments './web/hosting-environments/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-whasev2'
  params: {
    // Required parameters
    name: '<<namePrefix>>whasev2001'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    clusterSettings: [
      {
        name: 'DisableTls1.0'
        value: '1'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    ipsslAddressCount: 2
    kind: 'ASEv2'
    location: '<location>'
    lock: 'CanNotDelete'
    multiSize: 'Standard_D1_V2'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    systemAssignedIdentity: true
    tags: {
      hostingEnvironmentName: '<<namePrefix>>whasev2001'
      resourceType: 'App Service Environment'
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
      "value": "<<namePrefix>>whasev2001"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "clusterSettings": {
      "value": [
        {
          "name": "DisableTls1.0",
          "value": "1"
        }
      ]
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
    "ipsslAddressCount": {
      "value": 2
    },
    "kind": {
      "value": "ASEv2"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "multiSize": {
      "value": "Standard_D1_V2"
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
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "hostingEnvironmentName": "<<namePrefix>>whasev2001",
        "resourceType": "App Service Environment"
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

<h3>Example 2: Asev3</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironments './web/hosting-environments/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-whasev3'
  params: {
    // Required parameters
    name: '<<namePrefix>>whasev3001'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    allowNewPrivateEndpointConnections: true
    clusterSettings: [
      {
        name: 'DisableTls1.0'
        value: '1'
      }
    ]
    customDnsSuffix: 'internal.contoso.com'
    customDnsSuffixCertificateUrl: '<customDnsSuffixCertificateUrl>'
    customDnsSuffixKeyVaultReferenceIdentity: '<customDnsSuffixKeyVaultReferenceIdentity>'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    ftpEnabled: true
    inboundIpAddressOverride: '10.0.0.10'
    internalLoadBalancingMode: 'Web Publishing'
    location: '<location>'
    lock: 'CanNotDelete'
    remoteDebugEnabled: true
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    systemAssignedIdentity: true
    tags: {
      hostingEnvironmentName: '<<namePrefix>>whasev3001'
      resourceType: 'App Service Environment'
    }
    upgradePreference: 'Late'
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
      "value": "<<namePrefix>>whasev3001"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "allowNewPrivateEndpointConnections": {
      "value": true
    },
    "clusterSettings": {
      "value": [
        {
          "name": "DisableTls1.0",
          "value": "1"
        }
      ]
    },
    "customDnsSuffix": {
      "value": "internal.contoso.com"
    },
    "customDnsSuffixCertificateUrl": {
      "value": "<customDnsSuffixCertificateUrl>"
    },
    "customDnsSuffixKeyVaultReferenceIdentity": {
      "value": "<customDnsSuffixKeyVaultReferenceIdentity>"
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
    "ftpEnabled": {
      "value": true
    },
    "inboundIpAddressOverride": {
      "value": "10.0.0.10"
    },
    "internalLoadBalancingMode": {
      "value": "Web, Publishing"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "remoteDebugEnabled": {
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
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "hostingEnvironmentName": "<<namePrefix>>whasev3001",
        "resourceType": "App Service Environment"
      }
    },
    "upgradePreference": {
      "value": "Late"
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
