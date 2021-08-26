# NetworkSecurityGroups

This template deploys a Network Security Groups (NSG) with optional security rules.

## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Resources/deployments`|2018-02-01|
|`Microsoft.Network/networkSecurityGroups`|2020-08-01|
|`providers/locks`|2016-09-01|
|`Microsoft.Network/networkSecurityGroups/providers/diagnosticsettings`|2017-05-01-preview|
|`Microsoft.Network/networkSecurityGroups/providers/roleAssignments`|2018-09-01-preview|
|`Microsoft.Network/networkWatchers/flowLogs`|2020-05-01|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock NSG from deletion. | False |  |
| `networkSecurityGroupName` | string | Required. Name of the Network Security Group. |  |  |
| `networkSecurityGroupSecurityRules` | array | Optional. Array of Security Rules to deploy to the Network Security Group. When not provided, an NSG including only the built-in roles will be deployed. | System.Object[] |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `tags` | object | Optional. Tags of the NSG resource. |  |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |  |
| `flowAnalyticsEnabled`| bool | Optional. Enables/disables flow analytics. If Flow Analytics was previously enabled, workspaceResourceID is mandatory (even when disabling it) | false |  |
| `flowLogEnabled` | bool | Optional. If the flow log should be enabled | false |  |
| `flowLogIntervalInMinutes` | int | Optional. The interval in minutes which would decide how frequently TA service should do flow analytics | 60 | 10,60  |
| `flowLogName` | string | Optional. Name of the NSG flow log. If empty, no flow log will be deployed. |  |  |
| `flowLogworkspaceId` | string | Optional. Resource identifier of Log Analytics for the flow logs. |  |  |
| `logFormatVersion` | int | Optional. The flow log format version | 2 |  |
| `networkWatcherName`| string | Optional. Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG |  |  |
| `retentionEnabled`| bool | Optional. If the flow log retention should be enabled | true |  |
| `networkwatcherResourceGroup`| string | Required. Resource Group Name of the network watcher in whcih the NSG flow log would be created. | NetworkWatcherRG |  |

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
| `networkSecurityGroupsName` | string | The Name of the Network Security Group deployed. |
| `networkSecurityGroupsResourceGroup` | string | The name of the Resource Group the Network Security Groups were created in. |    
| `networkSecurityGroupsResourceId` | string | The Resource Ids of the Network Security Group deployed. |
| `flowLogName` | string | The Name of the FlowLog deployed |
| `flowLogResourceId` | string | The Resource Ids of the Network Security Group deployed. |

## Considerations

When specifying the Security Rules for the Network Security Group (NSG) with the `networkSecurityGroupSecurityRules` parameter, pass in the Security Rules as a JSON Array in the same format as would be used for the `securityRules` property of the `Microsoft.Network/networkSecurityGroups` resource provider in an ARM Template.

If Flow Logs traffic analytic has ever been enabled for the considered Network Security Group, even when disabling it WorkspaceResourceId must be specified targeting an existing Log Analytics workspace.<br />
If no Log Analytics Workspace exists or you don't want it to remain stored in the Flow Log configuration, delete the Flow Log resource.

## Additional resources

- [Azure Network Security Groups](https://docs.microsoft.com/en-us/azure/virtual-network/security-overview)
- [Microsoft.Network networkSecurityGroups template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-11-01/networksecuritygroups)
- [Microsoft.Network networkSecurityGroups/securityRules template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-11-01/networksecuritygroups/securityrules)
- [Azure Flow Logs](https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-nsg-flow-logging-overview)
- [Microsoft.Network networkWatchers/flowLogs template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-11-01/networkwatchers/flowlogs)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)