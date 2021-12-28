# Network Security Groups `[Microsoft.Network/networkSecurityGroups]`

This template deploys a network security group (NSG) with optional security rules.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Network/networkSecurityGroups` | 2021-02-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[NetworkSecurityGroupEvent, NetworkSecurityGroupRuleCounter]` | `[NetworkSecurityGroupEvent, NetworkSecurityGroupRuleCounter]` | Optional. The name of logs that will be streamed. |
| `name` | string |  |  | Required. Name of the Network Security Group. |
| `networkSecurityGroupSecurityRules` | array | `[]` |  | Optional. Array of Security Rules to deploy to the Network Security Group. When not provided, an NSG including only the built-in roles will be deployed. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags` | object | `{object}` |  | Optional. Tags of the NSG resource. |
| `workspaceId` | string |  |  | Optional. Resource ID of log analytics. |

### Parameter Usage: `networkSecurityGroupSecurityRules`

The `networkSecurityGroupSecurityRules` parameter accepts a JSON Array of `securityRule` to deploy to the Network Security Group (NSG).

Note that in case of using ASGs (Application Security Groups) - `sourceApplicationSecurityGroupIds` and `destinationApplicationSecurityGroupIds` properties - both the NSG and the ASG(s) have to be in the same Azure region. Currently an NSG can only handle one source and one destination ASG.
Here's an example of specifying a couple security rules:

```json
"networkSecurityGroupSecurityRules": {
  "value": [
    {
      "name": "Port_8080",
      "properties": {
        "description": "Allow inbound access on TCP 8080",
        "protocol": "*",
        "sourcePortRange": "*",
        "destinationPortRange": "8080",
        "sourceAddressPrefix": "*",
        "destinationAddressPrefix": "*",
        "access": "Allow",
        "priority": 100,
        "direction": "Inbound",
        "sourcePortRanges": [],
        "destinationPortRanges": [],
        "sourceAddressPrefixes": [],
        "destinationAddressPrefixes": [],
        "sourceApplicationSecurityGroupIds": [],
        "destinationApplicationSecurityGroupIds": []
      }
    },
    {
      "name": "Port_8081",
      "properties": {
        "description": "Allow inbound access on TCP 8081",
        "protocol": "*",
        "sourcePortRange": "*",
        "destinationPortRange": "8081",
        "sourceAddressPrefix": "*",
        "destinationAddressPrefix": "*",
        "access": "Allow",
        "priority": 101,
        "direction": "Inbound",
        "sourcePortRanges": [],
        "destinationPortRanges": [],
        "sourceAddressPrefixes": [],
        "destinationAddressPrefixes": [],
        "sourceApplicationSecurityGroupIds": [],
        "destinationApplicationSecurityGroupIds": []
      }
    },
    {
      "name": "Port_8082",
      "properties": {
        "description": "Allow inbound access on TCP 8082",
        "protocol": "*",
        "sourcePortRange": "*",
        "destinationPortRange": "8082",
        "sourceAddressPrefix": "",
        "destinationAddressPrefix": "",
        "access": "Allow",
        "priority": 102,
        "direction": "Inbound",
        "sourcePortRanges": [],
        "destinationPortRanges": [],
        "sourceAddressPrefixes": [],
        "destinationAddressPrefixes": [],
        //sourceApplicationSecurityGroupIds currently only supports 1 ID !
        "sourceApplicationSecurityGroupIds": [
          "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/<rgName>/providers/Microsoft.Network/applicationSecurityGroups/<Application Security Group Name 2>"
        ],
        //destinationApplicationSecurityGroupIds currently only supports 1 ID !
        "destinationApplicationSecurityGroupIds": [
          "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/<rgName>/providers/Microsoft.Network/applicationSecurityGroups/<Application Security Group Name 1>"
        ]
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
| `networkSecurityGroupName` | string | The name of the network security group |
| `networkSecurityGroupResourceGroup` | string | The resource group the network security group was deployed into |
| `networkSecurityGroupResourceId` | string | The resource ID of the network security group |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Networksecuritygroups](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-02-01/networkSecurityGroups)
