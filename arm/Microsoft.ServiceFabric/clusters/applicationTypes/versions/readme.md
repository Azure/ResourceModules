# ServiceFabric Clusters ApplicationTypes Versions `[Microsoft.ServiceFabric/clusters/applicationTypes/versions]`

This module deploys ServiceFabric Clusters ApplicationTypes Versions.
// TODO: Replace Resource and fill in description

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceFabric/clusters/applicationTypes/versions` | 2021-06-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `applicationTypeName` | string | `default` |  | Optional. Application type name. |
| `appPackageUrl` | string |  |  | Required. The URL to the application package. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `name` | string | `defaultVersion` |  | The name of the application type version |
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
| `versionName` | string | The name of the Version. |
| `versionResourceGroup` | string | The resource group of the Version. |
| `versionResourceId` | string | The resource ID of the Version. |

## Template references

- [Clusters/Applicationtypes/Versions](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ServiceFabric/2021-06-01/clusters/applicationTypes/versions)
