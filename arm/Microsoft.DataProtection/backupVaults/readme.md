# DataProtection BackupVaults `[Microsoft.DataProtection/backupVaults]`

This module deploys DataProtection BackupVaults.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.DataProtection/backupVaults` | [2022-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataProtection/2022-03-01/backupVaults) |
| `Microsoft.DataProtection/backupVaults/backupPolicies` | [2022-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DataProtection/2022-03-01/backupVaults/backupPolicies) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Backup Vault. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `backupPolicies` | _[backupPolicies](backupPolicies/readme.md)_ array | `[]` |  | List of all backup policies. |
| `dataStoreType` | string | `'SnapshotStore'` | `[ArchiveStore, SnapshotStore, VaultStore]` | The datastore type to use. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the Recovery Service Vault resource. |
| `type` | string | `'LocallyRedundant'` | `[LocallyRedundant, GeoRedundant]` | The vault redundancy level to use. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |


### Parameter Usage: `backupPolicies`

Create backup policies in the backupvault.

<details>

<summary>Parameter JSON format</summary>
```json
 "backupPolicies": {
    "value": [
        {
            "name": "DefaultPolicy",
            "properties": {
                "policyRules": [
                    {
                        "backupParameters": {
                            "backupType": "Incremental",
                            "objectType": "AzureBackupParams"
                        },
                        "trigger": {
                            "schedule": {
                                "repeatingTimeIntervals": [
                                    "R/2022-05-31T23:30:00+01:00/P1D"
                                ],
                                "timeZone": "W. Europe Standard Time"
                            },
                            "taggingCriteria": [
                                {
                                    "tagInfo": {
                                        "tagName": "Default",
                                        "id": "Default_"
                                    },
                                    "taggingPriority": 99,
                                    "isDefault": true
                                }
                            ],
                            "objectType": "ScheduleBasedTriggerContext"
                        },
                        "dataStore": {
                            "dataStoreType": "OperationalStore",
                            "objectType": "DataStoreInfoBase"
                        },
                        "name": "BackupDaily",
                        "objectType": "AzureBackupRule"
                    },
                    {
                        "lifecycles": [
                            {
                                "deleteAfter": {
                                    "objectType": "AbsoluteDeleteOption",
                                    "duration": "P7D"
                                },
                                "targetDataStoreCopySettings": [],
                                "sourceDataStore": {
                                    "dataStoreType": "OperationalStore",
                                    "objectType": "DataStoreInfoBase"
                                }
                            }
                        ],
                        "isDefault": true,
                        "name": "Default",
                        "objectType": "AzureRetentionRule"
                    }
                ],
                "datasourceTypes": [
                    "Microsoft.Compute/disks"
                ],
                "objectType": "BackupPolicy"
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
backupPolicies: [
    {
        name: 'DefaultPolicy'
        properties: {
            policyRules: [
                {
                    backupParameters: {
                        backupType: 'Incremental'
                        objectType: 'AzureBackupParams'
                    }
                    trigger: {
                        schedule: {
                            repeatingTimeIntervals: [
                                'R/2022-05-31T23:30:00+01:00/P1D'
                            ]
                            timeZone: 'W. Europe Standard Time'
                        }
                        taggingCriteria: [
                            {
                                tagInfo: {
                                    tagName: 'Default'
                                    id: 'Default_'
                                }
                                taggingPriority: 99
                                isDefault: true
                            }
                        ]
                        objectType: 'ScheduleBasedTriggerContext'
                    }
                    dataStore: {
                        dataStoreType: 'OperationalStore'
                        objectType: 'DataStoreInfoBase'
                    }
                    name: 'BackupDaily'
                    objectType: 'AzureBackupRule'
                }
                {
                    lifecycles: [
                        {
                            deleteAfter: {
                                objectType: 'AbsoluteDeleteOption'
                                duration: 'P7D'
                            }
                            targetDataStoreCopySettings: []
                            sourceDataStore: {
                                dataStoreType: 'OperationalStore'
                                objectType: 'DataStoreInfoBase'
                            }
                        }
                    ]
                    isDefault: true
                    name: 'Default'
                    objectType: 'AzureRetentionRule'
                }
            ]
            datasourceTypes: [
                'Microsoft.Compute/disks'
            ]
            objectType: 'BackupPolicy'
        }
    }
]
```

</details>

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The Name of the backup vault. |
| `resourceGroupName` | string | The name of the resource group the recovery services vault was created in. |
| `resourceId` | string | The resource ID of the backup vault. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-bv-min-001"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module backupVaults './Microsoft.DataProtection/backupVaults/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-backupVaults'
  params: {
    name: '<<namePrefix>>-az-bv-min-001'
  }
}
```

</details>
<p>

<h3>Example 2</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-bv-x-001"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "backupPolicies": {
            "value": [
                {
                    "name": "DefaultPolicy",
                    "properties": {
                        "policyRules": [
                            {
                                "backupParameters": {
                                    "backupType": "Incremental",
                                    "objectType": "AzureBackupParams"
                                },
                                "trigger": {
                                    "schedule": {
                                        "repeatingTimeIntervals": [
                                            "R/2022-05-31T23:30:00+01:00/P1D"
                                        ],
                                        "timeZone": "W. Europe Standard Time"
                                    },
                                    "taggingCriteria": [
                                        {
                                            "tagInfo": {
                                                "tagName": "Default",
                                                "id": "Default_"
                                            },
                                            "taggingPriority": 99,
                                            "isDefault": true
                                        }
                                    ],
                                    "objectType": "ScheduleBasedTriggerContext"
                                },
                                "dataStore": {
                                    "dataStoreType": "OperationalStore",
                                    "objectType": "DataStoreInfoBase"
                                },
                                "name": "BackupDaily",
                                "objectType": "AzureBackupRule"
                            },
                            {
                                "lifecycles": [
                                    {
                                        "deleteAfter": {
                                            "objectType": "AbsoluteDeleteOption",
                                            "duration": "P7D"
                                        },
                                        "targetDataStoreCopySettings": [],
                                        "sourceDataStore": {
                                            "dataStoreType": "OperationalStore",
                                            "objectType": "DataStoreInfoBase"
                                        }
                                    }
                                ],
                                "isDefault": true,
                                "name": "Default",
                                "objectType": "AzureRetentionRule"
                            }
                        ],
                        "datasourceTypes": [
                            "Microsoft.Compute/disks"
                        ],
                        "objectType": "BackupPolicy"
                    }
                }
            ]
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module backupVaults './Microsoft.DataProtection/backupVaults/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-backupVaults'
  params: {
    name: '<<namePrefix>>-az-bv-x-001'
    lock: 'CanNotDelete'
    backupPolicies: [
      {
        name: 'DefaultPolicy'
        properties: {
          policyRules: [
            {
              backupParameters: {
                backupType: 'Incremental'
                objectType: 'AzureBackupParams'
              }
              trigger: {
                schedule: {
                  repeatingTimeIntervals: [
                    'R/2022-05-31T23:30:00+01:00/P1D'
                  ]
                  timeZone: 'W. Europe Standard Time'
                }
                taggingCriteria: [
                  {
                    tagInfo: {
                      tagName: 'Default'
                      id: 'Default_'
                    }
                    taggingPriority: 99
                    isDefault: true
                  }
                ]
                objectType: 'ScheduleBasedTriggerContext'
              }
              dataStore: {
                dataStoreType: 'OperationalStore'
                objectType: 'DataStoreInfoBase'
              }
              name: 'BackupDaily'
              objectType: 'AzureBackupRule'
            }
            {
              lifecycles: [
                {
                  deleteAfter: {
                    objectType: 'AbsoluteDeleteOption'
                    duration: 'P7D'
                  }
                  targetDataStoreCopySettings: []
                  sourceDataStore: {
                    dataStoreType: 'OperationalStore'
                    objectType: 'DataStoreInfoBase'
                  }
                }
              ]
              isDefault: true
              name: 'Default'
              objectType: 'AzureRetentionRule'
            }
          ]
          datasourceTypes: [
            'Microsoft.Compute/disks'
          ]
          objectType: 'BackupPolicy'
        }
      }
    ]
  }
}
```

</details>
<p>
