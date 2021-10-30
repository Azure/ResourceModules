# SQL Managed Instances Administrator `[Microsoft.Sql/managedInstances/administrators]`

This module deploys an administrator for the SQL managed instance

## Resource Types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/administrators` | 2021-02-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `login` | string |  |  | Required. Login name of the managed instance administrator. |
| `managedInstanceName` | string |  |  | Name of the resource. |
| `sid` | string |  |  | Required. SID (object ID) of the managed instance administrator. |
| `tenantId` | string |  |  | Optional. Tenant ID of the managed instance administrator. |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `administratorName` | string | The name of the deployed managed instance |
| `administratorResourceGroup` | string | The resource group of the deployed managed instance |
| `administratorResourceId` | string | The resourceId of the deployed managed instance |

## Template references

- [Managedinstances/Administrators](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/managedInstances/administrators)
