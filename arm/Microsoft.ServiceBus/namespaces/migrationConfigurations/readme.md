# ServiceBus Namespace Migration Configuration `[Microsoft.ServiceBus/namespaces/migrationConfigurations]`

This module deploys a migration configuration for a service bus namespace

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/migrationConfigurations` | 2017-04-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string | `$default` |  | Optional. The name of the migration configuration |
| `namespaceName` | string |  |  | Required. Name of the parent Service Bus Namespace for the Service Bus Queue. |
| `postMigrationName` | string |  |  | Required. Name to access Standard Namespace after migration |
| `targetNamespaceResourceId` | string |  |  | Required. Existing premium Namespace resource ID which has no entities, will be used for migration |

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the migration configuration. |
| `resourceGroupName` | string | The name of the Resource Group the migration configuration was created in. |
| `resourceId` | string | The Resource ID of the migration configuration |

## Template references

- [Namespaces/Migrationconfigurations](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2017-04-01/namespaces/migrationConfigurations)
