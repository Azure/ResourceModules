# RouteTables

This template deploys User Defined Route Tables.

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Network/routeTables`|2020-08-01|
|`providers/locks`|2016-09-01|
|`Microsoft.Network/routeTables/providers/roleAssignments`|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `disableBgpRoutePropagation` | bool | Optional. Switch to disable BGP route propagation. | False |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock storage from deletion. | False |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `routes` | array | Optional. An Array of Routes to be established within the hub route table. | System.Object[] |  |       
| `routeTableName` | string | Required. Name given for the hub route table. |  |  |
| `tags` | object | Optional. Tags of the resource. |  |  |

### Parameter Usage: `routes`

The `routes` parameter accepts a JSON Array of Route objects to deploy to the Route Table.

Here's an example of specifying a few routes:

```json
"routes": {
  "value": [
    {
      "name": "tojumpboxes",
      "properties": {
        "addressPrefix": "172.16.0.48/28",
        "nextHopType": "VnetLocal"
      }
    },
    {
      "name": "tosharedservices",
      "properties": {
        "addressPrefix": "172.16.0.64/27",
        "nextHopType": "VnetLocal"
      }
    },
    {
      "name": "toonprem",
      "properties": {
        "addressPrefix": "10.0.0.0/8",
        "nextHopType": "VirtualNetworkGateway"
      }
    },
    {
      "name": "tonva",
      "properties": {
        "addressPrefix": "172.16.0.0/18",
        "nextHopType": "VirtualAppliance",
        "nextHopIpAddress": "172.16.0.20"
      }
    }
  ]
}
```

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

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `routeTablesName` | string | The name of the Route Table deployed. |
| `routeTablesResourceGroup` | string | The name of the Resource Group the Route Table was deployed to. |
| `routeTablesResourceId` | string | The Resource id of the Virtual Network deployed. |

## Considerations

*N/A*

## Additional resources

- [Microsoft.Network routeTables template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-09-01/routetables)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
