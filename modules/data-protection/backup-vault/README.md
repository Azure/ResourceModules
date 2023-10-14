# Data Protection Backup Vaults `[Microsoft.DataProtection/backupVaults]`

This module deploys a Data Protection Backup Vault.

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
| `Microsoft.DataProtection/backupVaults` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataProtection/backupVaults) |
| `Microsoft.DataProtection/backupVaults/backupPolicies` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataProtection/backupVaults/backupPolicies) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br:bicep/modules/data-protection.backup-vault:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using Maximum Parameters](#example-2-using-maximum-parameters)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module backupVault 'br:bicep/modules/data-protection.backup-vault:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dpbvcom'
  params: {
    // Required parameters
    name: 'dpbvcom001'
    // Non-required parameters
    azureMonitorAlertSettingsAlertsForAllJobFailures: 'Disabled'
    backupPolicies: [
      {
        name: 'DefaultPolicy'
        properties: {
          datasourceTypes: [
            'Microsoft.Compute/disks'
          ]
          objectType: 'BackupPolicy'
          policyRules: [
            {
              backupParameters: {
                backupType: 'Incremental'
                objectType: 'AzureBackupParams'
              }
              dataStore: {
                dataStoreType: 'OperationalStore'
                objectType: 'DataStoreInfoBase'
              }
              name: 'BackupDaily'
              objectType: 'AzureBackupRule'
              trigger: {
                objectType: 'ScheduleBasedTriggerContext'
                schedule: {
                  repeatingTimeIntervals: [
                    'R/2022-05-31T23:30:00+01:00/P1D'
                  ]
                  timeZone: 'W. Europe Standard Time'
                }
                taggingCriteria: [
                  {
                    isDefault: true
                    taggingPriority: 99
                    tagInfo: {
                      id: 'Default_'
                      tagName: 'Default'
                    }
                  }
                ]
              }
            }
            {
              isDefault: true
              lifecycles: [
                {
                  deleteAfter: {
                    duration: 'P7D'
                    objectType: 'AbsoluteDeleteOption'
                  }
                  sourceDataStore: {
                    dataStoreType: 'OperationalStore'
                    objectType: 'DataStoreInfoBase'
                  }
                  targetDataStoreCopySettings: []
                }
              ]
              name: 'Default'
              objectType: 'AzureRetentionRule'
            }
          ]
        }
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    systemAssignedIdentity: true
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
      "value": "dpbvcom001"
    },
    // Non-required parameters
    "azureMonitorAlertSettingsAlertsForAllJobFailures": {
      "value": "Disabled"
    },
    "backupPolicies": {
      "value": [
        {
          "name": "DefaultPolicy",
          "properties": {
            "datasourceTypes": [
              "Microsoft.Compute/disks"
            ],
            "objectType": "BackupPolicy",
            "policyRules": [
              {
                "backupParameters": {
                  "backupType": "Incremental",
                  "objectType": "AzureBackupParams"
                },
                "dataStore": {
                  "dataStoreType": "OperationalStore",
                  "objectType": "DataStoreInfoBase"
                },
                "name": "BackupDaily",
                "objectType": "AzureBackupRule",
                "trigger": {
                  "objectType": "ScheduleBasedTriggerContext",
                  "schedule": {
                    "repeatingTimeIntervals": [
                      "R/2022-05-31T23:30:00+01:00/P1D"
                    ],
                    "timeZone": "W. Europe Standard Time"
                  },
                  "taggingCriteria": [
                    {
                      "isDefault": true,
                      "taggingPriority": 99,
                      "tagInfo": {
                        "id": "Default_",
                        "tagName": "Default"
                      }
                    }
                  ]
                }
              },
              {
                "isDefault": true,
                "lifecycles": [
                  {
                    "deleteAfter": {
                      "duration": "P7D",
                      "objectType": "AbsoluteDeleteOption"
                    },
                    "sourceDataStore": {
                      "dataStoreType": "OperationalStore",
                      "objectType": "DataStoreInfoBase"
                    },
                    "targetDataStoreCopySettings": []
                  }
                ],
                "name": "Default",
                "objectType": "AzureRetentionRule"
              }
            ]
          }
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
    "systemAssignedIdentity": {
      "value": true
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

### Example 2: _Using Maximum Parameters_

This instance deploys the module with the large set of possible parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module backupVault 'br:bicep/modules/data-protection.backup-vault:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dpbvmin'
  params: {
    // Required parameters
    name: 'dpbvmin001'
    // Non-required parameters
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
      "value": "dpbvmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
| [`name`](#parameter-name) | string | Name of the Backup Vault. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureMonitorAlertSettingsAlertsForAllJobFailures`](#parameter-azuremonitoralertsettingsalertsforalljobfailures) | string | Settings for Azure Monitor based alerts for job failures. |
| [`backupPolicies`](#parameter-backuppolicies) | array | List of all backup policies. |
| [`dataStoreType`](#parameter-datastoretype) | string | The datastore type to use. ArchiveStore does not support ZoneRedundancy. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`featureSettings`](#parameter-featuresettings) | object | Feature settings for the backup vault. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`securitySettings`](#parameter-securitysettings) | object | Security settings for the backup vault. |
| [`systemAssignedIdentity`](#parameter-systemassignedidentity) | bool | Enables system assigned managed identity on the resource. |
| [`tags`](#parameter-tags) | object | Tags of the Recovery Service Vault resource. |
| [`type`](#parameter-type) | string | The vault redundancy level to use. |

### Parameter: `azureMonitorAlertSettingsAlertsForAllJobFailures`

Settings for Azure Monitor based alerts for job failures.
- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed: `[Disabled, Enabled]`

### Parameter: `backupPolicies`

List of all backup policies.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `dataStoreType`

The datastore type to use. ArchiveStore does not support ZoneRedundancy.
- Required: No
- Type: string
- Default: `'VaultStore'`
- Allowed: `[ArchiveStore, OperationalStore, VaultStore]`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `featureSettings`

Feature settings for the backup vault.
- Required: No
- Type: object
- Default: `{object}`

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

### Parameter: `name`

Name of the Backup Vault.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `securitySettings`

Security settings for the backup vault.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `systemAssignedIdentity`

Enables system assigned managed identity on the resource.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the Recovery Service Vault resource.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `type`

The vault redundancy level to use.
- Required: No
- Type: string
- Default: `'GeoRedundant'`
- Allowed: `[GeoRedundant, LocallyRedundant, ZoneRedundant]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The Name of the backup vault. |
| `resourceGroupName` | string | The name of the resource group the recovery services vault was created in. |
| `resourceId` | string | The resource ID of the backup vault. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

_None_

## Notes

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
