# Operationalinsights Workspaces Linked Services `[Microsoft.OperationalInsights/workspaces/linkedServices]`

This template deploys a linked service for a Log Analytics workspace.

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | 2020-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `logAnalyticsWorkspaceName` | string |  |  | Required. Name of the Log Analytics workspace |
| `name` | string |  |  | Required. Name of the link |
| `provisioningState` | string | `Succeeded` | `[Deleting, ProvisioningAccount, Succeeded, Updating]` | Optional. The provisioning state of the linked service. |
| `resourceId` | string |  |  | Required. The resource id of the resource that will be linked to the workspace. This should be used for linking resources which require read access. |
| `tags` | object | `{object}` |  | Optional. Tags to configure in the resource. |
| `writeAccessResourceId` | string |  |  | Optional. The resource id of the resource that will be linked to the workspace. This should be used for linking resources which require write access.  |

## Outputs

| Output Name | Type |
| :-- | :-- |

## Template references

- [Workspaces/Linkedservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices)
