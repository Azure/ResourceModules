# ServiceFabric Clusters Applications `[Microsoft.ServiceFabric/clusters/applications]`

This module deploys ServiceFabric Clusters Applications.
// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceFabric/clusters/applications` | 2021-06-01 |
| `Microsoft.ServiceFabric/clusters/applications/services` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `identity` | object | `{object}` |  | Optional. Describes the managed identities for an Azure resource. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `name` | string | `defaultApplication` |  | Optional. Application name. |
| `properties` | object | `{object}` |  | Optional. The application resource properties. |
| `serviceFabricClusterName` | string |  |  | Required. Name of the Serivce Fabric cluster. |
| `services` | _[services](services/readme.md)_ array | `[]` |  | Optional. List of Services to be created in the Application. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |

### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

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

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `applicationName` | string | The resource name of the Application. |
| `applicationResourceGroup` | string | The resource group of the Application. |
| `applicationResourceId` | string | The resource ID of the Application. |

## Template references

- [Clusters/Applications](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceFabric/2021-06-01/clusters/applications)
- [Clusters/Applications/Services](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceFabric/2021-06-01/clusters/applications/services)
