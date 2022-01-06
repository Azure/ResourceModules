# Recovery Services Vaults `[Microsoft.RecoveryServices/vaults]`

This module deploys a recovery service vault.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.RecoveryServices/vaults` | 2021-08-01 |
| `Microsoft.RecoveryServices/vaults/backupconfig` | 2021-08-01 |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers` | 2021-08-01 |
| `Microsoft.RecoveryServices/vaults/backupPolicies` | 2021-08-01 |
| `Microsoft.RecoveryServices/vaults/backupstorageconfig` | 2021-08-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `backupConfig` | _[backupConfig](backupConfig/readme.md)_ object | `{object}` |  | Optional. The backup configuration. |
| `backupPolicies` | _[backupPolicies](backupPolicies/readme.md)_ array | `[]` |  | Optional. List of all backup policies. |
| `backupStorageConfig` | _[backupStorageConfig](backupStorageConfig/readme.md)_ object | `{object}` |  | Optional. The storage configuration for the Azure Recovery Service Vault |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[AzureBackupReport, CoreAzureBackup, AddonAzureBackupJobs, AddonAzureBackupAlerts, AddonAzureBackupPolicy, AddonAzureBackupStorage, AddonAzureBackupProtectedInstance, AzureSiteRecoveryJobs, AzureSiteRecoveryEvents, AzureSiteRecoveryReplicatedItems, AzureSiteRecoveryReplicationStats, AzureSiteRecoveryRecoveryPoints, AzureSiteRecoveryReplicationDataUploadRate, AzureSiteRecoveryProtectedDiskDataChurn]` | `[AzureBackupReport, CoreAzureBackup, AddonAzureBackupJobs, AddonAzureBackupAlerts, AddonAzureBackupPolicy, AddonAzureBackupStorage, AddonAzureBackupProtectedInstance, AzureSiteRecoveryJobs, AzureSiteRecoveryEvents, AzureSiteRecoveryReplicatedItems, AzureSiteRecoveryReplicationStats, AzureSiteRecoveryRecoveryPoints, AzureSiteRecoveryReplicationDataUploadRate, AzureSiteRecoveryProtectedDiskDataChurn]` | Optional. The name of logs that will be streamed. |
| `metricsToEnable` | array | `[Health]` | `[Health]` | Optional. The name of metrics that will be streamed. |
| `name` | string |  |  | Required. Name of the Azure Recovery Service Vault |
| `protectionContainers` | _[protectionContainers](protectionContainers/readme.md)_ array | `[]` |  | Optional. List of all protection containers. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `systemAssignedIdentity` | bool |  |  | Optional. Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Optional. Tags of the Recovery Service Vault resource. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. The ID(s) to assign to the resource. |
| `workspaceId` | string |  |  | Optional. Resource ID of log analytics. |

### Parameter Usage: `backupStorageConfig`

```json
"backupStorageConfig": {
    "value": {
      "storageModelType": "GeoRedundant",
      "crossRegionRestoreFlag": true
    }
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

### Parameter Usage: `backupPolicies`

Array of backup policies. They need to be properly formatted and can be VM backup policies, SQL on VM backup policies or fileshare policies. The following example shows all three types of backup policies.

```json
"backupPolicies": {
  "value": [
    {
      "name": "VMpolicy",
      "type": "Microsoft.RecoveryServices/vaults/backupPolicies",
      "properties": {
        "backupManagementType": "AzureIaasVM",
        "instantRPDetails": {},
        "schedulePolicy": {
          "schedulePolicyType": "SimpleSchedulePolicy",
          "scheduleRunFrequency": "Daily",
          "scheduleRunTimes": [
            "2019-11-07T07:00:00Z"
          ],
          "scheduleWeeklyFrequency": 0
        },
        "retentionPolicy": {
          "retentionPolicyType": "LongTermRetentionPolicy",
          "dailySchedule": {
            "retentionTimes": [
              "2019-11-07T07:00:00Z"
            ],
            "retentionDuration": {
              "count": 180,
              "durationType": "Days"
            }
          },
          "weeklySchedule": {
            "daysOfTheWeek": [
              "Sunday"
            ],
            "retentionTimes": [
              "2019-11-07T07:00:00Z"
            ],
            "retentionDuration": {
              "count": 12,
              "durationType": "Weeks"
            }
          },
          "monthlySchedule": {
            "retentionScheduleFormatType": "Weekly",
            "retentionScheduleWeekly": {
              "daysOfTheWeek": [
                "Sunday"
              ],
              "weeksOfTheMonth": [
                "First"
              ]
            },
            "retentionTimes": [
              "2019-11-07T07:00:00Z"
            ],
            "retentionDuration": {
              "count": 60,
              "durationType": "Months"
            }
          },
          "yearlySchedule": {
            "retentionScheduleFormatType": "Weekly",
            "monthsOfYear": [
              "January"
            ],
            "retentionScheduleWeekly": {
              "daysOfTheWeek": [
                "Sunday"
              ],
              "weeksOfTheMonth": [
                "First"
              ]
            },
            "retentionTimes": [
              "2019-11-07T07:00:00Z"
            ],
            "retentionDuration": {
              "count": 10,
              "durationType": "Years"
            }
          }
        },
        "instantRpRetentionRangeInDays": 2,
        "timeZone": "UTC",
        "protectedItemsCount": 0
      }
    },
    {
      "name": "sqlpolicy",
      "type": "Microsoft.RecoveryServices/vaults/backupPolicies",
      "properties": {
        "backupManagementType": "AzureWorkload",
        "workLoadType": "SQLDataBase",
        "settings": {
          "timeZone": "UTC",
          "issqlcompression": true,
          "isCompression": true
        },
        "subProtectionPolicy": [
          {
            "policyType": "Full",
            "schedulePolicy": {
              "schedulePolicyType": "SimpleSchedulePolicy",
              "scheduleRunFrequency": "Weekly",
              "scheduleRunDays": [
                "Sunday"
              ],
              "scheduleRunTimes": [
                "2019-11-07T22:00:00Z"
              ],
              "scheduleWeeklyFrequency": 0
            },
            "retentionPolicy": {
              "retentionPolicyType": "LongTermRetentionPolicy",
              "weeklySchedule": {
                "daysOfTheWeek": [
                  "Sunday"
                ],
                "retentionTimes": [
                  "2019-11-07T22:00:00Z"
                ],
                "retentionDuration": {
                  "count": 104,
                  "durationType": "Weeks"
                }
              },
              "monthlySchedule": {
                "retentionScheduleFormatType": "Weekly",
                "retentionScheduleWeekly": {
                  "daysOfTheWeek": [
                    "Sunday"
                  ],
                  "weeksOfTheMonth": [
                    "First"
                  ]
                },
                "retentionTimes": [
                  "2019-11-07T22:00:00Z"
                ],
                "retentionDuration": {
                  "count": 60,
                  "durationType": "Months"
                }
              },
              "yearlySchedule": {
                "retentionScheduleFormatType": "Weekly",
                "monthsOfYear": [
                  "January"
                ],
                "retentionScheduleWeekly": {
                  "daysOfTheWeek": [
                    "Sunday"
                  ],
                  "weeksOfTheMonth": [
                    "First"
                  ]
                },
                "retentionTimes": [
                  "2019-11-07T22:00:00Z"
                ],
                "retentionDuration": {
                  "count": 10,
                  "durationType": "Years"
                }
              }
            }
          },
          {
            "policyType": "Differential",
            "schedulePolicy": {
              "schedulePolicyType": "SimpleSchedulePolicy",
              "scheduleRunFrequency": "Weekly",
              "scheduleRunDays": [
                "Monday"
              ],
              "scheduleRunTimes": [
                "2017-03-07T02:00:00Z"
              ],
              "scheduleWeeklyFrequency": 0
            },
            "retentionPolicy": {
              "retentionPolicyType": "SimpleRetentionPolicy",
              "retentionDuration": {
                "count": 30,
                "durationType": "Days"
              }
            }
          },
          {
            "policyType": "Log",
            "schedulePolicy": {
              "schedulePolicyType": "LogSchedulePolicy",
              "scheduleFrequencyInMins": 120
            },
            "retentionPolicy": {
              "retentionPolicyType": "SimpleRetentionPolicy",
              "retentionDuration": {
                "count": 15,
                "durationType": "Days"
              }
            }
          }
        ],
        "protectedItemsCount": 0
      }
    },
    {
      "name": "filesharepolicy",
      "type": "Microsoft.RecoveryServices/vaults/backupPolicies",
      "properties": {
        "backupManagementType": "AzureStorage",
        "workloadType": "AzureFileShare",
        "schedulePolicy": {
          "schedulePolicyType": "SimpleSchedulePolicy",
          "scheduleRunFrequency": "Daily",
          "scheduleRunTimes": [
            "2019-11-07T04:30:00Z"
          ],
          "scheduleWeeklyFrequency": 0
        },
        "retentionPolicy": {
          "retentionPolicyType": "LongTermRetentionPolicy",
          "dailySchedule": {
            "retentionTimes": [
              "2019-11-07T04:30:00Z"
            ],
            "retentionDuration": {
              "count": 30,
              "durationType": "Days"
            }
          }
        },
        "timeZone": "UTC",
        "protectedItemsCount": 0
      }
    }
  ]
}
```

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
},
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `recoveryServicesVaultName` | string | The Name of the recovery services vault |
| `recoveryServicesVaultResourceGroup` | string | The name of the resource group the recovery services vault was created in |
| `recoveryServicesVaultResourceId` | string | The resource ID of the recovery services vault |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Vaults](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-08-01/vaults)
- [Vaults/Backupconfig](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-08-01/vaults/backupconfig)
- [Vaults/Backupfabrics/Protectioncontainers](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-08-01/vaults/backupFabrics/protectionContainers)
- [Vaults/Backuppolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-08-01/vaults/backupPolicies)
- [Vaults/Backupstorageconfig](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-08-01/vaults/backupstorageconfig)
