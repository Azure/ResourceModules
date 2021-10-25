# AzureSQLServer `[Microsoft.Sql/servers]`

This module deploys an Azure SQL Server.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Sql/servers` | 2020-02-02-preview |
| `Microsoft.Sql/servers/firewallRules` | 2021-02-01-preview |
| `Microsoft.Sql/servers/providers/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Sql/servers/securityAlertPolicies` | 2021-02-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `administratorLogin` | string |  |  | Required. Administrator username for the server. |
| `administratorLoginPassword` | secureString |  |  | Required. The administrator login password. |
| `allowAzureIps` | bool |  |  | Required. Whether or not Azure IP's are allowed. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `enableADS` | bool |  |  | Optional. Whether or not ADS should be enabled. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `serverName` | string |  |  | Required. The name of the server. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Desktop Virtualization User",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
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

## Outputs

| Output Name | Type |
| :-- | :-- |
| `serverName` | string |
| `serverResourceGroup` | string |
| `serverResourceId` | string |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Servers](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2020-02-02-preview/servers)
- [Servers/Firewallrules](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/servers/firewallRules)
- [Servers/Securityalertpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/servers/securityAlertPolicies)
