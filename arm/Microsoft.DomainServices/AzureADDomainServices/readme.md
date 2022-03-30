# Azure Active Directory Domain Services `[Microsoft.DomainServices/AzureADDomainServices]`

This template deploys Azure Active Directory Domain Services (AADDS).

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AAD/DomainServices` | 2021-05-01 |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Authorization/locks` | 2017-04-01 |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `domainName` | string |  |  | Required. The domain name specific to Azure ADDS Services only - not recommended to use <<domain>>.onmicrosoft.com for production |
| `sku` | string |  | Standard | Required. The name of the sku specific to Azure ADDS Services. |
| `subnetId` | string |  |  | Required. The subnet Id to deploy the Azure ADDS Services. |
| `location` | string |  |  | Required: The location to deploy the Azure ADDS Services. |
| `pfxCertificate` | string |  | Required: The value is the base64encoded representation of the certificate pfx file. |
| `pfxCertificatePassword` | string | |  | Required: The value is to decrypt the provided Secure LDAP certificate pfx file. |
| `additionalRecipients` | array |  |  | Required: The email recipient value to receive alerts. |
| `domainConfigurationType` | string | `enabled` |  | Optional: The value is to provide domain configuration type. |
| `filteredSync` | string | `enabled`  |  | Optional: The value is to synchronise scoped users and groups. |
| `tlsV1` | string | `enabled`  |  | Optional: The value is to enable clients making request using TLSv1. |
| `ntlmV1` | string | `enabled` | | Optional: The value is to enable clients making request using NTLM v1. |
| `syncNtlmPasswords` | string  | `enabled` |  | Optional: The value is to enable synchronised users to use NTLM authentication. |
| `syncOnPremPasswords` | string | `enabled`  |  | Optional: The value is to enable on-premises users to authenticate against managed domain |
| `kerberosRc4Encryption` | string | `enabled`  |  | Optional: The value is to enable Kerberos requests that use RC4 encryption |
| `kerberosArmoring` | string | `enabled`  |  | Optional: The value is to enable to provide a protected channel between the Kerberos client and the KDC |
| `notifyDcAdmins` | string  | `enabled`  |  | Optional: The value is to notify the DC Admins|
| `notifyGlobalAdmins` | string | `enabled` |  | Optional: The value is to notify the Global Admins |
| `ldapexternalaccess` | string  | `enabled`  |  | Required: The value is to enable the Secure LDAP for external services of Azure ADDS Services |
| `secureldap` | string  | `enabled`  |  | Required: The value is to enable the Secure LDAP for Azure ADDS Services |
| `diagnosticStorageAccountId ` | string  |  |  | Optional. Resource ID of the diagnostic storage account |
| `diagnosticWorkspaceId ` | string  |  |  | Optional. Resource ID of the diagnostic log analytics workspace. |
| `diagnosticEventHubAuthorizationRuleId ` | string  |  |  | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to |
| `diagnosticEventHubName ` | string  | |  | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category |
| `tags ` | object | `{object}` |  | Optional. Tags of the resource. |
| `diagnosticLogsRetentionInDays` | int  | |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely |
| `lock  ` | string |  |  | Optional. Specify the type of lock. |
| `roleAssignments  ` | array  | `[array]` |  | Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\' |
| `logsToEnable   ` | array  | `[array]` |  | optional. The name of logs that will be streamed |

### Parameter Usage: `subnets`

Below you can find an example for the subnet property's usage. For all remaining properties, please refer to the _[subnets](subnets/readme.md)_ readme.

```json
"subnets": {
    "value": [
        {
            "name": "GatewaySubnet",
            "addressPrefix": "10.0.255.0/24"
        },
        {
            "name": "<<namePrefix>>-az-subnet-x-001",
            "addressPrefix": "10.0.0.0/24",
            "networkSecurityGroupId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/networkSecurityGroups/adp-<<namePrefix>>-az-nsg-x-001",
            "serviceEndpoints": [
                {
                    "service": "Microsoft.Storage"
                },
                {
                    "service": "Microsoft.Sql"
                }
            ],
            "routeTableId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/routeTables/adp-<<namePrefix>>-az-udr-x-001",
            "delegations": [
                {
                    "name": "netappDel",
                    "properties": {
                        "serviceName": "Microsoft.Netapp/volumes"
                    }
                }
            ],
            "privateEndpointNetworkPolicies": "Disabled",
            "privateLinkServiceNetworkPolicies": "Enabled"
        }
    ]
}
```

### Parameter Usage: `virtualNetworkPeerings`

As the virtual network peering array allows you to deploy not only a one-way but also two-way peering (i.e reverse), you can use the following ***additional*** properties on top of what is documented in _[virtualNetworkPeerings](virtualNetworkPeerings/readme.md)_.

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `remotePeeringEnabled` | bool | `false` |  | Optional. Set to true to also deploy the reverse peering for the configured remote virtual networks to the local network |
| `remotePeeringName` | string | `'${last(split(peering.remoteVirtualNetworkId, '/'))}-${name}'` | | Optional. The Name of Vnet Peering resource. If not provided, default value will be <remoteVnetName>-<localVnetName> |
| `remotePeeringAllowForwardedTraffic` | bool | `true` | | Optional. Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network. |
| `remotePeeringAllowGatewayTransit` | bool | `false` | | Optional. If gateway links can be used in remote virtual networking to link to this virtual network. |
| `remotePeeringAllowVirtualNetworkAccess` | bool | `true` | | Optional. Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space. |
| `remotePeeringDoNotVerifyRemoteGateways` | bool | `true` | | Optional. If we need to verify the provisioning state of the remote gateway. |
| `remotePeeringUseRemoteGateways` | bool | `false` | |  Optional. If remote gateways can be used on this virtual network. If the flag is set to `true`, and allowGatewayTransit on local peering is also `true`, virtual network will use gateways of local virtual network for transit. Only one peering can have this flag set to `true`. This flag cannot be set if virtual network already has a gateway.  |

```json
"virtualNetworkPeerings": {
    "value": [
        {
            "remoteVirtualNetworkId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-peer01",
            "allowForwardedTraffic": true,
            "allowGatewayTransit": false,
            "allowVirtualNetworkAccess": true,
            "useRemoteGateways": false,
            "remotePeeringEnabled": true,
            "remotePeeringName": "customName",
            "remotePeeringAllowVirtualNetworkAccess": true,
            "remotePeeringAllowForwardedTraffic": true
        }
    ]
}
```

### Parameter Usage: `addressPrefixes`

The `addressPrefixes` parameter accepts a JSON Array of string values containing the IP Address Prefixes for the Virtual Network (vNet).

Here's an example of specifying a single Address Prefix:

```json
"addressPrefixes": {
    "value": [
        "10.1.0.0/16"
    ]
}
```

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to 'ServicePrincipal'. This will ensure the role assignment waits for the principal's propagation in Azure.

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
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

## Considerations

The network security group and route table resources must reside in the same resource group as the virtual network.

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the virtual network |
| `resourceGroupName` | string | The resource group the virtual network was deployed into |
| `resourceId` | string | The resource ID of the virtual network |
| `subnetNames` | array | The names of the deployed subnets |
| `subnetResourceIds` | array | The resource IDs of the deployed subnets |

## Template references

- [AzureADDS](https://docs.microsoft.com/en-us/azure/templates/microsoft.aad/2021-05-01/domainservices)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
