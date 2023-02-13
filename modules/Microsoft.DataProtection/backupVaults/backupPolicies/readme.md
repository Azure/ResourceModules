# DataProtection BackupVaults BackupPolicies `[Microsoft.DataProtection/backupVaults/backupPolicies]`

This module deploys DataProtection BackupVaults BackupPolicies.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DataProtection/backupVaults/backupPolicies` | [2022-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataProtection/2022-05-01/backupVaults/backupPolicies) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `backupVaultName` | string | The name of the backup vault. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `name` | string | `'DefaultPolicy'` | The name of the backup policy. |
| `properties` | object | `{object}` | The properties of the backup policy. |


### Parameter Usage: `properties`

Create a backup policy.

<details>

<summary>Parameter JSON format</summary>

```json
 "properties": {
    "value": {
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
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
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
```

</details>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup policy. |
| `resourceGroupName` | string | The name of the resource group the backup policy was created in. |
| `resourceId` | string | The resource ID of the backup policy. |

## Cross-referenced modules

_None_
