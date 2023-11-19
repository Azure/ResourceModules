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

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/storage.storage-account:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Encr](#example-2-encr)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [Nfs](#example-4-nfs)
- [V1](#example-5-v1)
- [WAF-aligned](#example-6-waf-aligned)

### Example 1: _Using only defaults_

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
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
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
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": false,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
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

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br:bicep/modules/storage.storage-account:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ssamax'
  params: {
    // Required parameters
    name: 'ssamax001'
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
              principalId: '<principalId>'
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
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      lastAccessTimeTrackingPolicyEnabled: true
    }
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enableHierarchicalNamespace: true
    enableNfsV3: true
    enableSftp: true
    fileServices: {
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      shares: [
        {
          accessTier: 'Hot'
          name: 'avdprofiles'
          roleAssignments: [
            {
              principalId: '<principalId>'
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
        storageAccountName: 'ssamax001'
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
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
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
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
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      queues: [
        {
          metadata: {
            key1: 'value1'
            key2: 'value2'
          }
          name: 'queue1'
          roleAssignments: [
            {
              principalId: '<principalId>'
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
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    sasExpirationPeriod: '180.00:00:00'
    skuName: 'Standard_LRS'
    tableServices: {
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
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
      "value": "ssamax001"
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
                "principalId": "<principalId>",
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
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "lastAccessTimeTrackingPolicyEnabled": true
      }
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
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
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "shares": [
          {
            "accessTier": "Hot",
            "name": "avdprofiles",
            "roleAssignments": [
              {
                "principalId": "<principalId>",
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
          "storageAccountName": "ssamax001"
        }
      ]
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
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
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
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
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "queues": [
          {
            "metadata": {
              "key1": "value1",
              "key2": "value2"
            },
            "name": "queue1",
            "roleAssignments": [
              {
                "principalId": "<principalId>",
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
          "principalId": "<principalId>",
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
    "tableServices": {
      "value": {
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
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
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
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
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    skuName: 'Premium_LRS'
    supportsHttpsTrafficOnly: false
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
      "value": "ssanfs001"
    },
    // Non-required parameters
    "allowBlobPublicAccess": {
      "value": false
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
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
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
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

### Example 6: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module storageAccount 'br:bicep/modules/storage.storage-account:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-ssawaf'
  params: {
    // Required parameters
    name: 'ssawaf001'
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
              principalId: '<principalId>'
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
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      lastAccessTimeTrackingPolicyEnabled: true
    }
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enableHierarchicalNamespace: true
    enableNfsV3: true
    enableSftp: true
    fileServices: {
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      shares: [
        {
          accessTier: 'Hot'
          name: 'avdprofiles'
          roleAssignments: [
            {
              principalId: '<principalId>'
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
        storageAccountName: 'ssawaf001'
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
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
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
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
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      queues: [
        {
          metadata: {
            key1: 'value1'
            key2: 'value2'
          }
          name: 'queue1'
          roleAssignments: [
            {
              principalId: '<principalId>'
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
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    sasExpirationPeriod: '180.00:00:00'
    skuName: 'Standard_LRS'
    tableServices: {
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
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
      "value": "ssawaf001"
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
                "principalId": "<principalId>",
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
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "lastAccessTimeTrackingPolicyEnabled": true
      }
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
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
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "shares": [
          {
            "accessTier": "Hot",
            "name": "avdprofiles",
            "roleAssignments": [
              {
                "principalId": "<principalId>",
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
          "storageAccountName": "ssawaf001"
        }
      ]
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
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
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
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
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "queues": [
          {
            "metadata": {
              "key1": "value1",
              "key2": "value2"
            },
            "name": "queue1",
            "roleAssignments": [
              {
                "principalId": "<principalId>",
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
          "principalId": "<principalId>",
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
    "tableServices": {
      "value": {
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
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
| [`customDomainName`](#parameter-customdomainname) | string | Sets the custom domain name assigned to the storage account. Name is the CNAME source. |
| [`customDomainUseSubDomainName`](#parameter-customdomainusesubdomainname) | bool | Indicates whether indirect CName validation is enabled. This should only be set on updates. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`defaultToOAuthAuthentication`](#parameter-defaulttooauthauthentication) | bool | A boolean flag which indicates whether the default authentication is OAuth or not. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
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
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
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
| [`tableServices`](#parameter-tableservices) | object | Table service and tables to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `accessTier`

Required if the Storage Account kind is set to BlobStorage. The access tier is used for billing. The "Premium" access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type.
- Required: No
- Type: string
- Default: `'Hot'`
- Allowed:
  ```Bicep
  [
    'Cool'
    'Hot'
    'Premium'
  ]
  ```

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
- Allowed:
  ```Bicep
  [
    ''
    'AAD'
    'PrivateLink'
  ]
  ```

### Parameter: `allowSharedKeyAccess`

Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is null, which is equivalent to true.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `azureFilesIdentityBasedAuthentication`

Provides the identity based authentication settings for Azure Files.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `blobServices`

Blob service and containers to deploy.
- Required: No
- Type: object
- Default: `{}`

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

### Parameter: `customerManagedKey`

The customer managed key definition.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`keyName`](#parameter-customermanagedkeykeyname) | Yes | string | Required. The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-customermanagedkeykeyvaultresourceid) | Yes | string | Required. The resource ID of a key vault to reference a customer managed key for encryption from. |
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | No | string | Optional. The version of the customer managed key to reference for encryption. If not provided, using 'latest'. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | No | string | Optional. User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `customerManagedKey.keyName`

Required. The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

Required. The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVersion`

Optional. The version of the customer managed key to reference for encryption. If not provided, using 'latest'.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

Optional. User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `defaultToOAuthAuthentication`

A boolean flag which indicates whether the default authentication is OAuth or not.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | No | string | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | No | string | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | No | string | Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | No | string | Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | No | array | Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`name`](#parameter-diagnosticsettingsname) | No | string | Optional. The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | No | string | Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | No | string | Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed: `[AzureDiagnostics, Dedicated]`

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | Yes | string | Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to 'AllMetrics' to collect all metrics. |

### Parameter: `diagnosticSettings.metricCategories.category`

Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to 'AllMetrics' to collect all metrics.

- Required: Yes
- Type: string


### Parameter: `diagnosticSettings.name`

Optional. The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `dnsEndpointType`

Allows you to specify the type of endpoint. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier.
- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'AzureDnsZone'
    'Standard'
  ]
  ```

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
- Default: `{}`

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
- Allowed:
  ```Bicep
  [
    'BlobStorage'
    'BlockBlobStorage'
    'FileStorage'
    'Storage'
    'StorageV2'
  ]
  ```

### Parameter: `largeFileSharesState`

Allow large file shares if sets to 'Enabled'. It cannot be disabled once it is enabled. Only supported on locally redundant and zone redundant file shares. It cannot be set on FileStorage storage accounts (storage accounts for premium file shares).
- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

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

The lock settings of the service.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`kind`](#parameter-lockkind) | No | string | Optional. Specify the type of lock. |
| [`name`](#parameter-lockname) | No | string | Optional. Specify the name of lock. |

### Parameter: `lock.kind`

Optional. Specify the type of lock.

- Required: No
- Type: string
- Allowed: `[CanNotDelete, None, ReadOnly]`

### Parameter: `lock.name`

Optional. Specify the name of lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | No | bool | Optional. Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | No | array | Optional. The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Optional. Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

Optional. The resource ID(s) to assign to the resource.

- Required: No
- Type: array

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
- Allowed:
  ```Bicep
  [
    'TLS1_0'
    'TLS1_1'
    'TLS1_2'
  ]
  ```

### Parameter: `name`

Name of the Storage Account.
- Required: Yes
- Type: string

### Parameter: `networkAcls`

Networks ACLs, this value contains IPs to whitelist and/or Subnet information. For security reasons, it is recommended to set the DefaultAction Deny.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | No | array | Optional. Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | No | array | Optional. Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | No | string | Optional. The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | No | bool | Optional. Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | No | array | Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`location`](#parameter-privateendpointslocation) | No | string | Optional. The location to deploy the private endpoint to. |
| [`lock`](#parameter-privateendpointslock) | No | object | Optional. Specify the type of lock. |
| [`manualPrivateLinkServiceConnections`](#parameter-privateendpointsmanualprivatelinkserviceconnections) | No | array | Optional. Manual PrivateLink Service Connections. |
| [`name`](#parameter-privateendpointsname) | No | string | Optional. The name of the private endpoint. |
| [`privateDnsZoneGroupName`](#parameter-privateendpointsprivatednszonegroupname) | No | string | Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided. |
| [`privateDnsZoneResourceIds`](#parameter-privateendpointsprivatednszoneresourceids) | No | array | Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | No | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`service`](#parameter-privateendpointsservice) | Yes | string | Required. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob". |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | Yes | string | Required. Resource ID of the subnet where the endpoint needs to be created. |
| [`tags`](#parameter-privateendpointstags) | No | object | Optional. Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Optional. Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Optional. Custom DNS configurations.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | No | string | Required. Fqdn that resolves to private endpoint ip address. |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | Yes | array | Required. A list of private ip addresses of the private endpoint. |

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

Required. Fqdn that resolves to private endpoint ip address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

Required. A list of private ip addresses of the private endpoint.

- Required: Yes
- Type: array


### Parameter: `privateEndpoints.customNetworkInterfaceName`

Optional. The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Optional. Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`name`](#parameter-privateendpointsipconfigurationsname) | Yes | string | Required. The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-privateendpointsipconfigurationsproperties) | Yes | object | Required. Properties of private endpoint IP configurations. |

### Parameter: `privateEndpoints.ipConfigurations.name`

Required. The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties`

Required. Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`groupId`](#parameter-privateendpointsipconfigurationspropertiesgroupid) | Yes | string | Required. The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-privateendpointsipconfigurationspropertiesmembername) | Yes | string | Required. The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-privateendpointsipconfigurationspropertiesprivateipaddress) | Yes | string | Required. A private ip address obtained from the private endpoint's subnet. |

### Parameter: `privateEndpoints.ipConfigurations.properties.groupId`

Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.memberName`

Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.privateIPAddress`

Required. A private ip address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string



### Parameter: `privateEndpoints.location`

Optional. The location to deploy the private endpoint to.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock`

Optional. Specify the type of lock.

- Required: No
- Type: object

### Parameter: `privateEndpoints.manualPrivateLinkServiceConnections`

Optional. Manual PrivateLink Service Connections.

- Required: No
- Type: array

### Parameter: `privateEndpoints.name`

Optional. The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroupName`

Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneResourceIds`

Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.

- Required: No
- Type: array

### Parameter: `privateEndpoints.roleAssignments`

Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: No
- Type: array

### Parameter: `privateEndpoints.service`

Required. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.subnetResourceId`

Required. Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.tags`

Optional. Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.
- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `queueServices`

Queue service and queues to create.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `requireInfrastructureEncryption`

A Boolean indicating whether or not the service applies a secondary layer of encryption with platform managed keys for data at rest. For security reasons, it is recommended to set it to true.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | No | string | Optional. The description of the role assignment. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | Yes | string | Required. The principal ID of the principal (user/group/identity) to assign the role to. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | No | string | Optional. The principal type of the assigned principal ID. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | Yes | string | Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

### Parameter: `roleAssignments.condition`

Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Optional. Version of the condition.

- Required: No
- Type: string
- Allowed: `[2.0]`

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

Optional. The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

Optional. The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalId`

Required. The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

Optional. The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed: `[Device, ForeignGroup, Group, ServicePrincipal, User]`

### Parameter: `roleAssignments.roleDefinitionIdOrName`

Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

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
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
    'Standard_GRS'
    'Standard_GZRS'
    'Standard_LRS'
    'Standard_RAGRS'
    'Standard_RAGZRS'
    'Standard_ZRS'
  ]
  ```

### Parameter: `supportsHttpsTrafficOnly`

Allows HTTPS traffic only to storage service if sets to true.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `tableServices`

Table service and tables to create.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed storage account. |
| `primaryBlobEndpoint` | string | The primary blob endpoint reference if blob services are deployed. |
| `resourceGroupName` | string | The resource group of the deployed storage account. |
| `resourceId` | string | The resource ID of the deployed storage account. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/private-endpoint` | Local reference |

## Notes

This is a generic module for deploying a Storage Account. Any customization for different storage needs (such as a diagnostic or other storage account) need to be done through the Archetype.
The hierarchical namespace of the storage account (see parameter `enableHierarchicalNamespace`), can be only set at creation time.
