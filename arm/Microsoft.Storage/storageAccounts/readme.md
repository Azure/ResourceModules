# StorageAccounts

This module is used to deploy an Azure Storage Account, with resource lock and the ability to deploy 1 or more Blob Containers and 1 or more File Shares. Optional ACLs can be configured on the Storage Account and optional RBAC can be assigned on the Storage Account and on each Blob Container and File Share.

The default parameter values are based on the needs of deploying a diagnostic storage account.

## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `immutabilityPolicies` | 2019-06-01 |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2020-05-01 |
| `Microsoft.Network/privateEndpoints` | 2020-05-01 |
| `Microsoft.Resources/deployments` | 2020-06-01 |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2019-06-01 |
| `Microsoft.Storage/storageAccounts/blobServices` | 2019-06-01 |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | 2019-06-01 |
| `Microsoft.Storage/storageAccounts/managementPolicies` | 2019-06-01 |
| `Microsoft.Storage/storageAccounts/providers/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | 2019-06-01 |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | 2019-06-01 |
| `Microsoft.Storage/storageAccounts` | 2019-06-01 |
| `providers/locks` | 2016-09-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowBlobPublicAccess` | bool | True |  | Optional. Indicates whether public access is enabled for all blobs or containers in the storage account. |
| `automaticSnapshotPolicyEnabled` | bool | False |  | Optional. Automatic Snapshot is enabled if set to true. |
| `azureFilesIdentityBasedAuthentication` | object |  |  | Optional. Provides the identity based authentication settings for Azure Files. |
| `baseTime` | string | [utcNow('u')] |  | Generated. Do not provide a value! This date value is used to generate a SAS token to access the modules. |
| `blobContainers` | array | System.Object[] |  | Optional. Blob containers to create. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `deleteBlobsAfter` | int | 1096 |  | Optional. Set up the amount of days after which the blobs will be deleted |
| `deleteRetentionPolicy` | bool | True |  | Optional. Indicates whether DeleteRetentionPolicy is enabled for the Blob service. |
| `deleteRetentionPolicyDays` | int | 7 |  | Optional. Indicates the number of days that the deleted blob should be retained. The minimum specified value can be 1 and the maximum value can be 365. |
| `enableArchiveAndDelete` | bool | False |  | Optional. If true, enables move to archive tier and auto-delete |
| `enableHierarchicalNamespace` | bool | False |  | Optional. If true, enables Hierarchical Namespace for the storage account |
| `fileShares` | array | System.Object[] |  | Optional. File shares to create. |
| `location` | string | [resourceGroup().location] |  | Optional. Location for all resources. |
| `lockForDeletion` | bool | False |  | Optional. Switch to lock storage from deletion. |
| `minimumTlsVersion` | string | TLS1_2 | System.Object[] | Optional. Set the minimum TLS version on request to storage. |
| `moveToArchiveAfter` | int | 30 |  | Optional. Set up the amount of days after which the blobs will be moved to archive tier |
| `networkAcls` | object |  |  | Optional. Networks ACLs, this value contains IPs to whitelist and/or Subnet information. |
| `privateEndpoints` | array | System.Object[] |  | Optional. Configuration Details for private endpoints. |
| `queues` | array | System.Object[] |  | Optional. Queues to create. |
| `roleAssignments` | array | System.Object[] |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it's fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `managedServiceIdentity` | string | None | System.Object[] | Optional. Type of managed service identity. |
| `userAssignedIdentities` | object | | System.Object[] | Optional. Mandatory 'managedServiceIdentity' contains UserAssigned. The identy to assign to the resource. |
| `sasTokenValidityLength` | string | PT8H |  | Optional. SAS token validity length. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours. |
| `storageAccountAccessTier` | string | Hot | System.Object[] | Optional. Storage Account Access Tier. |
| `storageAccountKind` | string | StorageV2 | System.Object[] | Optional. Type of Storage Account to create. |
| `storageAccountName` | string |  |  | Optional. Name of the Storage Account. If no name is provided, then unique name will be created.| 
| `storageAccountSku` | string | Standard_GRS | System.Object[] | Optional. Storage Account Sku Name. |
| `tables` | array | System.Object[] |  | Optional. Tables to create. |
| `tags` | object |  |  | Optional. Tags of the resource. |
| `vNetId` | string |  |  | Optional. Virtual Network Identifier used to create a service endpoint. |

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Storage File Data SMB Share Contributor",
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

### Parameter Usage: `networkAcls`

```json
"networkAcls": {
    "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny",
        "virtualNetworkRules": [
            {
                "subnet": "sharedsvcs"
            }
        ],
        "ipRules": []
    }
}
```

### Parameter Usage: `blobContainers`

The `blobContainer` parameter accepts a JSON Array of object with "name" and "publicAccess" properties in each to specify the name of the Blob Containers to create and level of public access (container level, blob level or none). Also RBAC can be assigned at Blob Container level

Here's an example of specifying two Blob Containes. The first named "one" with public access set at container level and RBAC Reader role assigned to two principal Ids. The second named "two" with no public access level and no RBAC role assigned.

```json
"blobContainers": {
    "value": [
        {
            "name": "one",
            "publicAccess": "Container", //Container, Blob, None
            "roleAssignments": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "12345678-1234-1234-1234-123456789012", // object 1
                        "78945612-1234-1234-1234-123456789012" // object 2
                    ]
                },
        {
            "name": "two",
            "publicAccess": "None", //Container, Blob, None
            "roleAssignments": [],
            "enableWORM": true,
            "WORMRetention": 200,
            "allowProtectedAppendWrites": false
        }
    ]
```

### Parameter Usage: `fileShares`

The `fileShares` parameter accepts a JSON Array of object with "name" and "shareQuota" properties in each to specify the name of the File Shares to create and the maximum size of the shares, in gigabytes. Also RBAC can be assigned at File Share level.

Here's an example of specifying a single File Share named "wvdprofiles" with 5TB (5120GB) of shareQuota and Reader role assigned to two principal Ids.

```json
"fileShares": {
    "value": [
        {
            "name": "wvdprofiles",
            "shareQuota": "5120",
            "roleAssignments": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "12345678-1234-1234-1234-123456789012", // object 1
                        "78945612-1234-1234-1234-123456789012" // object 2
                    ]
                }
            ]
        }
    ]
}
```

### Parameter Usage: `queues`

The `queues` parameter accepts a JSON Array of object with "name" and "metadata" properties in each to specify the name of the queue to create and its metadata, as a name-value pair. Also RBAC can be assigned at queue level.

Here's an example of specifying a single qeue named "queue1" with no metadata and Reader role assigned to two principal Ids.

```json
"queues": {
    "value": [
        {
            "name": "queue1",
            "metadata": {},
            "roleAssignments": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "12345678-1234-1234-1234-123456789012", // object 1
                        "78945612-1234-1234-1234-123456789012" // object 2
                    ]
                }
            ]
        }
    ]
}
```

### Parameter Usage: `tables`

The tables to be created in the storage account

```json
"tables": {
    "value": [
        "table1",
        "table2"
    ]
},
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

### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`.  Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.

- Although not strictly required, it is highly recommened to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-sa-cac-y-123-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-001/subnets/sxx-az-subnet-weu-x-001",
            "service": "blob",
            "privateDnsZoneResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
            ],
            "customDnsConfigs": [ // Optional
                {
                    "fqdn": "customname.test.local",
                    "ipAddresses": [
                        "10.10.10.10"
                    ]
                }
            ]
        },
        // Example showing only mandatory fields
        {
            "subnetResourceId": "/subscriptions/8629be3b-96bc-482d-a04b-ffff597c65a2/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-weu-x-001/subnets/sxx-az-subnet-weu-x-001",
            "service": "file"
        }
    ]
}
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `blobContainers` | array | The array of the blob containers created. |
| `fileShares` | array | The array of the file shares created. |
| `queues` | array | The array of the queues created. |
| `storageAccountsAccessKey` | securestring | The Access Key for the Storage Account. |
| `storageAccountsName` | string | The Name of the Storage Account. |
| `storageAccountsPrimaryBlobEndpoint` | string | The public endpoint of the Storage Account. |
| `storageAccountsRegion` | string | The Region of the Storage Account. |
| `storageAccountsResourceGroup` | string | The name of the Resource Group the Storage Account was created in. |
| `storageAccountsResourceId` | string | The Resource Id of the Storage Account. |
| `storageAccountsSasToken` | securestring | The SAS Token for the Storage Account. |
| `tables` | array | The array of the tables created. |
| `assignedIdentityID` | string | User id of the created system assigned identity. |

## Considerations

This is a generic module for deploying a Storage Account. Any customization for different storage needs (such as a diagnostic or other storage account) need to be done through the Archetype.
The hierarchical namespace of the storage account (see parameter `enableHierarchicalNamespace`), can be only set at creation time.

## Additional resources

- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)
- [Azure Resource Manager template reference](https://docs.microsoft.com/en-us/azure/templates/)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [StorageAccountS](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [StorageAccountS/blobServiceS](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/blobServices)
- [StorageAccountS/blobServiceS/containerS](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/blobServices/containers)
- [StorageAccountS/managementPolicieS](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/managementPolicies)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [StorageAccountS/fileServiceS/ShareS](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/fileServices/shares)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [StorageAccountS/queueServiceS/queueS](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/queueServices/queues)
- [Deployments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-06-01/deployments)
- [StorageAccountS/tableServiceS/tableS](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/tableServices/tables)
