# ServiceFabric Clusters Applications Services `[Microsoft.ServiceFabric/clusters/applications/services]`

This module deploys ServiceFabric Clusters Applications Services.
// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceFabric/clusters/applications/services` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `applicationName` | string | `defaultApplication` |  | Optional. Application name. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `name` | string | `defaultService` |  | Optional. Name of the Service. |
| `properties` | object | `{object}` |  | Optional. Properties of the Service. |
| `serviceFabricClusterName` | string |  |  | Required. Name of the Serivce Fabric cluster. |
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
| `serviceName` | string | The resource name of the service. |
| `serviceResourceGroup` | string | The resource group of the service. |
| `serviceResourceId` | string | The resource ID of the service. |

## Template references

- [Clusters/Applications/Services](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceFabric/2021-06-01/clusters/applications/services)
