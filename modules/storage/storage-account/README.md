# Storage Accounts `[Microsoft.Storage/storageAccounts]`

This module deploys a Storage Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Storage/storageAccounts` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2022-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-05-01/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/tableServices/tables) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/storage.storage-account:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [Encr](#example-2-encr)
- [Using only defaults](#example-3-using-only-defaults)
- [Nfs](#example-4-nfs)
- [V1](#example-5-v1)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br:bicep/modules/storage.storage-account:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ssacom'
  params: {
    // Required parameters
    name: 'ssacom001'
    // Non-required parameters
    allowBlobPublicAccess: false
    blobServices: {
      automaticSnapshotPolicyEnabled: true
      containerDeleteRetentionPolicyDays: 10
      containerDeleteRetentionPolicyEnabled: true
      containers: [
        {
          enableNfsV3AllSquash: true
          enableNfsV3RootSquash: true
          name: 'avdscripts'
          publicAccess: 'None'
          roleAssignments: [
            {
              principalIds: [
                '<managedIdentityPrincipalId>'
              ]
              principalType: 'ServicePrincipal'
              roleDefinitionIdOrName: 'Reader'
            }
          ]
        }
        {
          allowProtectedAppendWrites: false
          enableWORM: true
          metadata: {
            testKey: 'testValue'
          }
          name: 'archivecontainer'
          publicAccess: 'None'
          WORMRetention: 666
        }
      ]
      deleteRetentionPolicyDays: 9
      deleteRetentionPolicyEnabled: true
      diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
      diagnosticEventHubName: '<diagnosticEventHubName>'
      diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
      diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
      lastAccessTimeTrackingPolicyEnabled: true
    }
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enableHierarchicalNamespace: true
    enableNfsV3: true
    enableSftp: true
    fileServices: {
      diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
      diagnosticEventHubName: '<diagnosticEventHubName>'
      diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
      diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
      shares: [
        {
          accessTier: 'Hot'
          name: 'avdprofiles'
          roleAssignments: [
            {
              principalIds: [
                '<managedIdentityPrincipalId>'
              ]
              principalType: 'ServicePrincipal'
              roleDefinitionIdOrName: 'Reader'
            }
          ]
          shareQuota: 5120
        }
        {
          name: 'avdprofiles2'
          shareQuota: 102400
        }
      ]
    }
    largeFileSharesState: 'Enabled'
    localUsers: [
      {
        hasSharedKey: false
        hasSshKey: true
        hasSshPassword: false
        homeDirectory: 'avdscripts'
        name: 'testuser'
        permissionScopes: [
          {
            permissions: 'r'
            resourceName: 'avdscripts'
            service: 'blob'
          }
        ]
        storageAccountName: 'ssacom001'
      }
    ]
    lock: 'CanNotDelete'
    managementPolicyRules: [
      {
        definition: {
          actions: {
            baseBlob: {
              delete: {
                daysAfterModificationGreaterThan: 30
              }
              tierToCool: {
                daysAfterLastAccessTimeGreaterThan: 5
              }
            }
          }
          filters: {
            blobIndexMatch: [
              {
                name: 'BlobIndex'
                op: '=='
                value: '1'
              }
            ]
            blobTypes: [
              'blockBlob'
            ]
            prefixMatch: [
              'sample-container/log'
            ]
          }
        }
        enabled: true
        name: 'FirstRule'
        type: 'Lifecycle'
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        {
          action: 'Allow'
          value: '1.1.1.1'
        }
      ]
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: '<id>'
        }
      ]
    }
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'blob'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    queueServices: {
      diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
      diagnosticEventHubName: '<diagnosticEventHubName>'
      diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
      diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
      queues: [
        {
          metadata: {
            key1: 'value1'
            key2: 'value2'
          }
          name: 'queue1'
          roleAssignments: [
            {
              principalIds: [
                '<managedIdentityPrincipalId>'
              ]
              principalType: 'ServicePrincipal'
              roleDefinitionIdOrName: 'Reader'
            }
          ]
        }
        {
          metadata: {}
          name: 'queue2'
        }
      ]
    }
    requireInfrastructureEncryption: true
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    sasExpirationPeriod: '180.00:00:00'
    skuName: 'Standard_LRS'
    systemAssignedIdentity: true
    tableServices: {
      diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
      diagnosticEventHubName: '<diagnosticEventHubName>'
      diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
      diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
      tables: [
        'table1'
        'table2'
      ]
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "ssacom001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "blobServices": {
      "value": {
        "automaticSnapshotPolicyEnabled": true,
        "containerDeleteRetentionPolicyDays": 10,
        "containerDeleteRetentionPolicyEnabled": true,
        "containers": [
          {
            "enableNfsV3AllSquash": true,
            "enableNfsV3RootSquash": true,
            "name": "avdscripts",
            "publicAccess": "None",
            "roleAssignments": [
              {
                "principalIds": [
                  "<managedIdentityPrincipalId>"
                ],
                "principalType": "ServicePrincipal",
                "roleDefinitionIdOrName": "Reader"
              }
            ]
          },
          {
            "allowProtectedAppendWrites": false,
            "enableWORM": true,
            "metadata": {
              "testKey": "testValue"
            },
            "name": "archivecontainer",
            "publicAccess": "None",
            "WORMRetention": 666
          }
        ],
        "deleteRetentionPolicyDays": 9,
        "deleteRetentionPolicyEnabled": true,
        "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
        "diagnosticEventHubName": "<diagnosticEventHubName>",
        "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
        "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
        "lastAccessTimeTrackingPolicyEnabled": true
      }
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enableHierarchicalNamespace": {
      "value": true
    },
    "enableNfsV3": {
      "value": true
    },
    "enableSftp": {
      "value": true
    },
    "fileServices": {
      "value": {
        "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
        "diagnosticEventHubName": "<diagnosticEventHubName>",
        "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
        "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
        "shares": [
          {
            "accessTier": "Hot",
            "name": "avdprofiles",
            "roleAssignments": [
              {
                "principalIds": [
                  "<managedIdentityPrincipalId>"
                ],
                "principalType": "ServicePrincipal",
                "roleDefinitionIdOrName": "Reader"
              }
            ],
            "shareQuota": 5120
          },
          {
            "name": "avdprofiles2",
            "shareQuota": 102400
          }
        ]
      }
    },
    "largeFileSharesState": {
      "value": "Enabled"
    },
    "localUsers": {
      "value": [
        {
          "hasSharedKey": false,
          "hasSshKey": true,
          "hasSshPassword": false,
          "homeDirectory": "avdscripts",
          "name": "testuser",
          "permissionScopes": [
            {
              "permissions": "r",
              "resourceName": "avdscripts",
              "service": "blob"
            }
          ],
          "storageAccountName": "ssacom001"
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "managementPolicyRules": {
      "value": [
        {
          "definition": {
            "actions": {
              "baseBlob": {
                "delete": {
                  "daysAfterModificationGreaterThan": 30
                },
                "tierToCool": {
                  "daysAfterLastAccessTimeGreaterThan": 5
                }
              }
            },
            "filters": {
              "blobIndexMatch": [
                {
                  "name": "BlobIndex",
                  "op": "==",
                  "value": "1"
                }
              ],
              "blobTypes": [
                "blockBlob"
              ],
              "prefixMatch": [
                "sample-container/log"
              ]
            }
          },
          "enabled": true,
          "name": "FirstRule",
          "type": "Lifecycle"
        }
      ]
    },
    "networkAcls": {
      "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny",
        "ipRules": [
          {
            "action": "Allow",
            "value": "1.1.1.1"
          }
        ],
        "virtualNetworkRules": [
          {
            "action": "Allow",
            "id": "<id>"
          }
        ]
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "blob",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "queueServices": {
      "value": {
        "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
        "diagnosticEventHubName": "<diagnosticEventHubName>",
        "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
        "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
        "queues": [
          {
            "metadata": {
              "key1": "value1",
              "key2": "value2"
            },
            "name": "queue1",
            "roleAssignments": [
              {
                "principalIds": [
                  "<managedIdentityPrincipalId>"
                ],
                "principalType": "ServicePrincipal",
                "roleDefinitionIdOrName": "Reader"
              }
            ]
          },
          {
            "metadata": {},
            "name": "queue2"
          }
        ]
      }
    },
    "requireInfrastructureEncryption": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "sasExpirationPeriod": {
      "value": "180.00:00:00"
    },
    "skuName": {
      "value": "Standard_LRS"
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tableServices": {
      "value": {
        "diagnosticEventHubAuthorizationRuleId": "<diagnosticEventHubAuthorizationRuleId>",
        "diagnosticEventHubName": "<diagnosticEventHubName>",
        "diagnosticStorageAccountId": "<diagnosticStorageAccountId>",
        "diagnosticWorkspaceId": "<diagnosticWorkspaceId>",
        "tables": [
          "table1",
          "table2"
        ]
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

### Example 2: _Encr_

<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br:bicep/modules/storage.storage-account:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ssaencr'
  params: {
    // Required parameters
    name: 'ssaencr001'
    // Non-required parameters
    allowBlobPublicAccess: false
    blobServices: {
      automaticSnapshotPolicyEnabled: true
      changeFeedEnabled: true
      changeFeedRetentionInDays: 10
      containerDeleteRetentionPolicyAllowPermanentDelete: true
      containerDeleteRetentionPolicyDays: 10
      containerDeleteRetentionPolicyEnabled: true
      containers: [
        {
          name: 'container'
          publicAccess: 'None'
        }
      ]
      defaultServiceVersion: '2008-10-27'
      deleteRetentionPolicyDays: 9
      deleteRetentionPolicyEnabled: true
      isVersioningEnabled: true
      lastAccessTimeTrackingPolicyEnable: true
      restorePolicyDays: 8
      restorePolicyEnabled: true
    }
    cMKKeyName: '<cMKKeyName>'
    cMKKeyVaultResourceId: '<cMKKeyVaultResourceId>'
    cMKUserAssignedIdentityResourceId: '<cMKUserAssignedIdentityResourceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSZoneResourceId>'
          ]
        }
        service: 'blob'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    requireInfrastructureEncryption: true
    skuName: 'Standard_LRS'
    systemAssignedIdentity: false
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "ssaencr001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "blobServices": {
      "value": {
        "automaticSnapshotPolicyEnabled": true,
        "changeFeedEnabled": true,
        "changeFeedRetentionInDays": 10,
        "containerDeleteRetentionPolicyAllowPermanentDelete": true,
        "containerDeleteRetentionPolicyDays": 10,
        "containerDeleteRetentionPolicyEnabled": true,
        "containers": [
          {
            "name": "container",
            "publicAccess": "None"
          }
        ],
        "defaultServiceVersion": "2008-10-27",
        "deleteRetentionPolicyDays": 9,
        "deleteRetentionPolicyEnabled": true,
        "isVersioningEnabled": true,
        "lastAccessTimeTrackingPolicyEnable": true,
        "restorePolicyDays": 8,
        "restorePolicyEnabled": true
      }
    },
    "cMKKeyName": {
      "value": "<cMKKeyName>"
    },
    "cMKKeyVaultResourceId": {
      "value": "<cMKKeyVaultResourceId>"
    },
    "cMKUserAssignedIdentityResourceId": {
      "value": "<cMKUserAssignedIdentityResourceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSZoneResourceId>"
            ]
          },
          "service": "blob",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "requireInfrastructureEncryption": {
      "value": true
    },
    "skuName": {
      "value": "Standard_LRS"
    },
    "systemAssignedIdentity": {
      "value": false
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

### Example 3: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br:bicep/modules/storage.storage-account:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ssamin'
  params: {
    // Required parameters
    name: 'ssamin001'
    // Non-required parameters
    allowBlobPublicAccess: false
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "ssamin001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

### Example 4: _Nfs_

<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br:bicep/modules/storage.storage-account:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ssanfs'
  params: {
    // Required parameters
    name: 'ssanfs001'
    // Non-required parameters
    allowBlobPublicAccess: false
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    fileServices: {
      shares: [
        {
          enabledProtocols: 'NFS'
          name: 'nfsfileshare'
        }
      ]
    }
    kind: 'FileStorage'
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    skuName: 'Premium_LRS'
    supportsHttpsTrafficOnly: false
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "ssanfs001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticStorageAccountId": {
      "value": "<diagnosticStorageAccountId>"
    },
    "diagnosticWorkspaceId": {
      "value": "<diagnosticWorkspaceId>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "fileServices": {
      "value": {
        "shares": [
          {
            "enabledProtocols": "NFS",
            "name": "nfsfileshare"
          }
        ]
      }
    },
    "kind": {
      "value": "FileStorage"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "roleAssignments": {
      "value": [
        {
          "principalIds": [
            "<managedIdentityPrincipalId>"
          ],
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "skuName": {
      "value": "Premium_LRS"
    },
    "supportsHttpsTrafficOnly": {
      "value": false
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
    }
  }
}
```

</details>
<p>

### Example 5: _V1_

<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br:bicep/modules/storage.storage-account:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ssav1'
  params: {
    // Required parameters
    name: 'ssav1001'
    // Non-required parameters
    allowBlobPublicAccess: false
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'Storage'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "ssav1001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "Storage"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Storage Account. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessTier`](#parameter-accesstier) | string | Required if the Storage Account kind is set to BlobStorage. The access tier is used for billing. The "Premium" access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type. |
| [`cMKKeyVaultResourceId`](#parameter-cmkkeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty. |
| [`cMKUserAssignedIdentityResourceId`](#parameter-cmkuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if 'cMKKeyName' is not empty. |
| [`enableHierarchicalNamespace`](#parameter-enablehierarchicalnamespace) | bool | If true, enables Hierarchical Namespace for the storage account. Required if enableSftp or enableNfsV3 is set to true. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowBlobPublicAccess`](#parameter-allowblobpublicaccess) | bool | Indicates whether public access is enabled for all blobs or containers in the storage account. For security reasons, it is recommended to set it to false. |
| [`allowCrossTenantReplication`](#parameter-allowcrosstenantreplication) | bool | Allow or disallow cross AAD tenant object replication. |
| [`allowedCopyScope`](#parameter-allowedcopyscope) | string | Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet. |
| [`allowSharedKeyAccess`](#parameter-allowsharedkeyaccess) | bool | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is null, which is equivalent to true. |
| [`azureFilesIdentityBasedAuthentication`](#parameter-azurefilesidentitybasedauthentication) | object | Provides the identity based authentication settings for Azure Files. |
| [`blobServices`](#parameter-blobservices) | object | Blob service and containers to deploy. |
| [`cMKKeyName`](#parameter-cmkkeyname) | string | The name of the customer managed key to use for encryption. Cannot be deployed together with the parameter 'systemAssignedIdentity' enabled. |
| [`cMKKeyVersion`](#parameter-cmkkeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, latest is used. |
| [`customDomainName`](#parameter-customdomainname) | string | Sets the custom domain name assigned to the storage account. Name is the CNAME source. |
| [`customDomainUseSubDomainName`](#parameter-customdomainusesubdomainname) | bool | Indicates whether indirect CName validation is enabled. This should only be set on updates. |
| [`defaultToOAuthAuthentication`](#parameter-defaulttooauthauthentication) | bool | A boolean flag which indicates whether the default authentication is OAuth or not. |
| [`diagnosticEventHubAuthorizationRuleId`](#parameter-diagnosticeventhubauthorizationruleid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`diagnosticEventHubName`](#parameter-diagnosticeventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`diagnosticMetricsToEnable`](#parameter-diagnosticmetricstoenable) | array | The name of metrics that will be streamed. |
| [`diagnosticSettingsName`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| [`diagnosticStorageAccountId`](#parameter-diagnosticstorageaccountid) | string | Resource ID of the diagnostic storage account. |
| [`diagnosticWorkspaceId`](#parameter-diagnosticworkspaceid) | string | Resource ID of the diagnostic log analytics workspace. |
| [`dnsEndpointType`](#parameter-dnsendpointtype) | string | Allows you to specify the type of endpoint. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`enableNfsV3`](#parameter-enablenfsv3) | bool | If true, enables NFS 3.0 support for the storage account. Requires enableHierarchicalNamespace to be true. |
| [`enableSftp`](#parameter-enablesftp) | bool | If true, enables Secure File Transfer Protocol for the storage account. Requires enableHierarchicalNamespace to be true. |
| [`fileServices`](#parameter-fileservices) | object | File service and shares to deploy. |
| [`isLocalUserEnabled`](#parameter-islocaluserenabled) | bool | Enables local users feature, if set to true. |
| [`kind`](#parameter-kind) | string | Type of Storage Account to create. |
| [`largeFileSharesState`](#parameter-largefilesharesstate) | string | Allow large file shares if sets to 'Enabled'. It cannot be disabled once it is enabled. Only supported on locally redundant and zone redundant file shares. It cannot be set on FileStorage storage accounts (storage accounts for premium file shares). |
| [`localUsers`](#parameter-localusers) | array | Local users to deploy for SFTP authentication. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`managementPolicyRules`](#parameter-managementpolicyrules) | array | The Storage Account ManagementPolicies Rules. |
| [`minimumTlsVersion`](#parameter-minimumtlsversion) | string | Set the minimum TLS version on request to storage. |
| [`networkAcls`](#parameter-networkacls) | object | Networks ACLs, this value contains IPs to whitelist and/or Subnet information. For security reasons, it is recommended to set the DefaultAction Deny. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set. |
| [`queueServices`](#parameter-queueservices) | object | Queue service and queues to create. |
| [`requireInfrastructureEncryption`](#parameter-requireinfrastructureencryption) | bool | A Boolean indicating whether or not the service applies a secondary layer of encryption with platform managed keys for data at rest. For security reasons, it is recommended to set it to true. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`sasExpirationPeriod`](#parameter-sasexpirationperiod) | string | The SAS expiration period. DD.HH:MM:SS. |
| [`skuName`](#parameter-skuname) | string | Storage Account Sku Name. |
| [`supportsHttpsTrafficOnly`](#parameter-supportshttpstrafficonly) | bool | Allows HTTPS traffic only to storage service if sets to true. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tableServices`](#parameter-tableservices) | object | Table service and tables to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | object | The ID(s) to assign to the resource. |

### Parameter: `accessTier`

Required if the Storage Account kind is set to BlobStorage. The access tier is used for billing. The "Premium" access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type.
- Required: No
- Type: string
- Default: `'Hot'`
- Allowed: `[Cool, Hot, Premium]`

### Parameter: `allowBlobPublicAccess`

Indicates whether public access is enabled for all blobs or containers in the storage account. For security reasons, it is recommended to set it to false.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `allowCrossTenantReplication`

Allow or disallow cross AAD tenant object replication.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `allowedCopyScope`

Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', AAD, PrivateLink]`

### Parameter: `allowSharedKeyAccess`

Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is null, which is equivalent to true.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `azureFilesIdentityBasedAuthentication`

Provides the identity based authentication settings for Azure Files.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `blobServices`

Blob service and containers to deploy.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `cMKKeyName`

The name of the customer managed key to use for encryption. Cannot be deployed together with the parameter 'systemAssignedIdentity' enabled.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKKeyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKKeyVersion`

The version of the customer managed key to reference for encryption. If not provided, latest is used.
- Required: No
- Type: string
- Default: `''`

### Parameter: `cMKUserAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if 'cMKKeyName' is not empty.
- Required: No
- Type: string
- Default: `''`

### Parameter: `customDomainName`

Sets the custom domain name assigned to the storage account. Name is the CNAME source.
- Required: No
- Type: string
- Default: `''`

### Parameter: `customDomainUseSubDomainName`

Indicates whether indirect CName validation is enabled. This should only be set on updates.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `defaultToOAuthAuthentication`

A boolean flag which indicates whether the default authentication is OAuth or not.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `diagnosticEventHubAuthorizationRuleId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticEventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticMetricsToEnable`

The name of metrics that will be streamed.
- Required: No
- Type: array
- Default: `[Transaction]`
- Allowed: `[Transaction]`

### Parameter: `diagnosticSettingsName`

The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticStorageAccountId`

Resource ID of the diagnostic storage account.
- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticWorkspaceId`

Resource ID of the diagnostic log analytics workspace.
- Required: No
- Type: string
- Default: `''`

### Parameter: `dnsEndpointType`

Allows you to specify the type of endpoint. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', AzureDnsZone, Standard]`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableHierarchicalNamespace`

If true, enables Hierarchical Namespace for the storage account. Required if enableSftp or enableNfsV3 is set to true.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableNfsV3`

If true, enables NFS 3.0 support for the storage account. Requires enableHierarchicalNamespace to be true.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableSftp`

If true, enables Secure File Transfer Protocol for the storage account. Requires enableHierarchicalNamespace to be true.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `fileServices`

File service and shares to deploy.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `isLocalUserEnabled`

Enables local users feature, if set to true.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `kind`

Type of Storage Account to create.
- Required: No
- Type: string
- Default: `'StorageV2'`
- Allowed: `[BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2]`

### Parameter: `largeFileSharesState`

Allow large file shares if sets to 'Enabled'. It cannot be disabled once it is enabled. Only supported on locally redundant and zone redundant file shares. It cannot be set on FileStorage storage accounts (storage accounts for premium file shares).
- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed: `[Disabled, Enabled]`

### Parameter: `localUsers`

Local users to deploy for SFTP authentication.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `managementPolicyRules`

The Storage Account ManagementPolicies Rules.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `minimumTlsVersion`

Set the minimum TLS version on request to storage.
- Required: No
- Type: string
- Default: `'TLS1_2'`
- Allowed: `[TLS1_0, TLS1_1, TLS1_2]`

### Parameter: `name`

Name of the Storage Account.
- Required: Yes
- Type: string

### Parameter: `networkAcls`

Networks ACLs, this value contains IPs to whitelist and/or Subnet information. For security reasons, it is recommended to set the DefaultAction Deny.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', Disabled, Enabled]`

### Parameter: `queueServices`

Queue service and queues to create.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `requireInfrastructureEncryption`

A Boolean indicating whether or not the service applies a secondary layer of encryption with platform managed keys for data at rest. For security reasons, it is recommended to set it to true.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `sasExpirationPeriod`

The SAS expiration period. DD.HH:MM:SS.
- Required: No
- Type: string
- Default: `''`

### Parameter: `skuName`

Storage Account Sku Name.
- Required: No
- Type: string
- Default: `'Standard_GRS'`
- Allowed: `[Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, Standard_LRS, Standard_RAGRS, Standard_RAGZRS, Standard_ZRS]`

### Parameter: `supportsHttpsTrafficOnly`

Allows HTTPS traffic only to storage service if sets to true.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `systemAssignedIdentity`

Enables system assigned managed identity on the resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tableServices`

Table service and tables to create.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `userAssignedIdentities`

The ID(s) to assign to the resource.
- Required: No
- Type: object
- Default: `{object}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed storage account. |
| `primaryBlobEndpoint` | string | The primary blob endpoint reference if blob services are deployed. |
| `resourceGroupName` | string | The resource group of the deployed storage account. |
| `resourceId` | string | The resource ID of the deployed storage account. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/private-endpoint` | Local reference |

## Notes

This is a generic module for deploying a Storage Account. Any customization for different storage needs (such as a diagnostic or other storage account) need to be done through the Archetype.
The hierarchical namespace of the storage account (see parameter `enableHierarchicalNamespace`), can be only set at creation time.
