# NAT Gateway

This module deploys a NAT Gateway.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Network/bastionHosts/providers/roleAssignments` | 2018-09-01-preview |
| `Microsoft.Network/natGateways` | 2020-08-01 |
| `Microsoft.Network/publicIPAddresses/providers/diagnosticSettings` | 2017-05-01-preview |
| `Microsoft.Network/publicIPAddresses` | 2020-08-01 |
| `Microsoft.Resources/deployments` | 2020-06-01 |
| `providers/locks` | 2016-09-01 |

### Resource dependency

The following resources are required to be able to deploy this resource.

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |
| `idleTimeoutInMinutes` | int | Optional. The idle timeout of the nat gateway. | 5 |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock resource from deletion. | False |  |
| `natGatewayDomainNameLabel` | string | Optional. DNS name of the Public IP resource. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com |  |  |
| `natGatewayName` | string | Required. Name of the Azure Bastion resource |  |  |
| `natGatewayPipName` | string | Optional. Specifies the name of the Public IP used by the NAT Gateway. If it's not provided, a '-pip' suffix will be appended to the Bastion's name. |  |  |
| `natGatewayPublicIpAddress` | bool | Optional. Use to have a new Public IP Address created for the NAT Gateway. | False |  |
| `natGatewayPublicIPPrefixId` | string | Optional. Resource Id of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix. |  |  |
| `publicIpAddresses` | array | Optional. Existing Public IP Address resource names to use for the NAT Gateway. | System.Object[] |  |
| `publicIpPrefixes` | array | Optional. Existing Public IP Prefixes resource names to use for the NAT Gateway. | System.Object[] |  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `tags` | object | Optional. Tags for the resource. |  |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |  |
| `zones` | array | Optional. A list of availability zones denoting the zone in which Nat Gateway should be deployed. | System.Object[] |  |

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
| `natGatewayName` | string | The Name of the Load Balancer. |
| `natGatewayResourceGroup` | string | The resource Group name in which the reosurce is created. |
| `natGatewayResourceId` | string | The Resource ID of the Load Balancer. |

## Considerations

*N/A*

### References

#### Template references

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [PublicIPAddresses](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-05-01/publicIPAddresses)
- [NatGateways](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-05-01/natGateways)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)

## Additional resources

- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [PublicIPAddresses](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-05-01/publicIPAddresses)
- [NatGateways](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-05-01/natGateways)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
