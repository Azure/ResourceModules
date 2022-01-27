# ServiceFabric Cluster Application Type `[Microsoft.ServiceFabric/clusters/applicationTypes]`

This module deploys a ServiceFabric cluster application type.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceFabric/clusters/applicationTypes` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `name` | string | `defaultApplicationType` |  | Optional. Application type name. |
| `serviceFabricClusterName` | string |  |  | Required. Name of the Service Fabric cluster. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |

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
| `name` | string | The resource name of the Application type. |
| `resourceGroupName` | string | The resource group of the Application type. |
| `resourceID` | string | The resource ID of the Application type. |

## Template references

- [Clusters/Applicationtypes](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceFabric/2021-06-01/clusters/applicationTypes)
