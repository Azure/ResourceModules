# Subscription Aliases `[Microsoft.Subscription/aliases]`

This module deploys a Subscription Alias.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Management/managementGroups/subscriptions` | 2021-04-01 |
| `Microsoft.Subscription/aliases` | 2021-10-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `alias` | string | Alias to assign to the subscription |

**Conditional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `billingAccount` | string | `''` | BillingAccount used for subscription billing. Required if no subscriptionId was provided. |
| `displayName` | string | `''` | Display name for the subscription. Required if no subscriptionId was provided. |
| `enrollmentAccount` | string | `''` | EnrollmentAccount used for subscription billing. Required if no subscriptionId was provided. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[deployment().location]` |  | Location deployment metadata. |
| `managementGroupId` | string | `''` |  | The ID of the management group to deploy into. If not provided the subscription is deployed into the root management group |
| `ownerId` | string | `''` |  | Owner Id of the subscription |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects to define RBAC on this resource. |
| `subscriptionId` | string | `''` |  | This parameter can be used to create alias for an existing subscription Id |
| `tags` | object | `{object}` |  | Tags for the subscription |
| `tenantId` | string | `''` |  | Tenant Id of the subscription |
| `workload` | string | `'Production'` | `[Production, DevTest]` | The workload type of the subscription. |


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

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed subscription alias |
| `resourceId` | string | The resource ID of the deployed subscription alias |
| `subscriptionId` | string | The subscription ID attached to the deployed alias |

## Template references

- [Aliases](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Subscription/2021-10-01/aliases)
- [Managementgroups/Subscriptions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Management/2021-04-01/managementGroups/subscriptions)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
