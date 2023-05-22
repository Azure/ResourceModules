# Recovery Services Vaults `[Microsoft.RecoveryServices/vaults]`

This module deploys a recovery service vault.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.RecoveryServices/vaults` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults) |
| `Microsoft.RecoveryServices/vaults/backupconfig` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupconfig) |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupFabrics/protectionContainers) |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupFabrics/protectionContainers/protectedItems) |
| `Microsoft.RecoveryServices/vaults/backupPolicies` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupPolicies) |
| `Microsoft.RecoveryServices/vaults/backupstorageconfig` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupstorageconfig) |
| `Microsoft.RecoveryServices/vaults/replicationAlertSettings` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationAlertSettings) |
| `Microsoft.RecoveryServices/vaults/replicationFabrics` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics) |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics/replicationProtectionContainers) |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings) |
| `Microsoft.RecoveryServices/vaults/replicationPolicies` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationPolicies) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Azure Recovery Service Vault. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `backupConfig` | _[backupConfig](backup-config/README.md)_ object | `{object}` |  | The backup configuration. |
| `backupPolicies` | _[backupPolicies](backup-policies/README.md)_ array | `[]` |  | List of all backup policies. |
| `backupStorageConfig` | _[backupStorageConfig](backup-storage-config/README.md)_ object | `{object}` |  | The storage configuration for the Azure Recovery Service Vault. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[AddonAzureBackupAlerts, AddonAzureBackupJobs, AddonAzureBackupPolicy, AddonAzureBackupProtectedInstance, AddonAzureBackupStorage, allLogs, AzureBackupReport, AzureSiteRecoveryEvents, AzureSiteRecoveryJobs, AzureSiteRecoveryProtectedDiskDataChurn, AzureSiteRecoveryRecoveryPoints, AzureSiteRecoveryReplicatedItems, AzureSiteRecoveryReplicationDataUploadRate, AzureSiteRecoveryReplicationStats, CoreAzureBackup]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[Health]` | `[Health]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `monitoringSettings` | object | `{object}` |  | Monitoring Settings of the vault. |
| `privateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `protectionContainers` | _[protectionContainers](protection-containers/README.md)_ array | `[]` |  | List of all protection containers. |
| `publicNetworkAccess` | string | `'Disabled'` | `[Disabled, Enabled]` | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. |
| `replicationAlertSettings` | _[replicationAlertSettings](replication-alert-settings/README.md)_ object | `{object}` |  | Replication alert settings. |
| `replicationFabrics` | _[replicationFabrics](replication-fabrics/README.md)_ array | `[]` |  | List of all replication fabrics. |
| `replicationPolicies` | _[replicationPolicies](replication-policies/README.md)_ array | `[]` |  | List of all replication policies. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `securitySettings` | object | `{object}` |  | Security Settings of the vault. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the Recovery Service Vault resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |


### Parameter Usage: `backupStorageConfig`

<details>

<summary>Parameter JSON format</summary>

```json
"backupStorageConfig": {
    "value": {
        "storageModelType": "GeoRedundant",
        "crossRegionRestoreFlag": true
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
backupStorageConfig: {
    value: {
        storageModelType: 'GeoRedundant'
        crossRegionRestoreFlag: true
    }
}
```

</details>
<p>

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

### Parameter Usage: `backupPolicies`

Array of backup policies. They need to be properly formatted and can be VM backup policies, SQL on VM backup policies or fileshare policies. The following example shows all three types of backup policies.

<details>

<summary>Parameter JSON format</summary>

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

</details>

<details>

<summary>Bicep format</summary>

```bicep
backupPolicies: [
    {
      name: 'VMpolicy'
      type: 'Microsoft.RecoveryServices/vaults/backupPolicies'
      properties: {
        backupManagementType: 'AzureIaasVM'
        instantRPDetails: {}
        schedulePolicy: {
          schedulePolicyType: 'SimpleSchedulePolicy'
          scheduleRunFrequency: 'Daily'
          scheduleRunTimes: [
            '2019-11-07T07:00:00Z'
          ]
          scheduleWeeklyFrequency: 0
        }
        retentionPolicy: {
          retentionPolicyType: 'LongTermRetentionPolicy'
          dailySchedule: {
            retentionTimes: [
              '2019-11-07T07:00:00Z'
            ]
            retentionDuration: {
              count: 180
              durationType: 'Days'
            }
          }
          weeklySchedule: {
            daysOfTheWeek: [
              'Sunday'
            ]
            retentionTimes: [
              '2019-11-07T07:00:00Z'
            ]
            retentionDuration: {
              count: 12
              durationType: 'Weeks'
            }
          }
          monthlySchedule: {
            retentionScheduleFormatType: 'Weekly'
            retentionScheduleWeekly: {
              daysOfTheWeek: [
                'Sunday'
              ]
              weeksOfTheMonth: [
                'First'
              ]
            }
            retentionTimes: [
              '2019-11-07T07:00:00Z'
            ]
            retentionDuration: {
              count: 60
              durationType: 'Months'
            }
          }
          yearlySchedule: {
            retentionScheduleFormatType: 'Weekly'
            monthsOfYear: [
              'January'
            ]
            retentionScheduleWeekly: {
              daysOfTheWeek: [
                'Sunday'
              ]
              weeksOfTheMonth: [
                'First'
              ]
            }
            retentionTimes: [
              '2019-11-07T07:00:00Z'
            ]
            retentionDuration: {
              count: 10
              durationType: 'Years'
            }
          }
        }
        instantRpRetentionRangeInDays: 2
        timeZone: 'UTC'
        protectedItemsCount: 0
      }
    }
    {
      name: 'sqlpolicy'
      type: 'Microsoft.RecoveryServices/vaults/backupPolicies'
      properties: {
        backupManagementType: 'AzureWorkload'
        workLoadType: 'SQLDataBase'
        settings: {
          timeZone: 'UTC'
          issqlcompression: true
          isCompression: true
        }
        subProtectionPolicy: [
          {
            policyType: 'Full'
            schedulePolicy: {
              schedulePolicyType: 'SimpleSchedulePolicy'
              scheduleRunFrequency: 'Weekly'
              scheduleRunDays: [
                'Sunday'
              ]
              scheduleRunTimes: [
                '2019-11-07T22:00:00Z'
              ]
              scheduleWeeklyFrequency: 0
            }
            retentionPolicy: {
              retentionPolicyType: 'LongTermRetentionPolicy'
              weeklySchedule: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                retentionTimes: [
                  '2019-11-07T22:00:00Z'
                ]
                retentionDuration: {
                  count: 104
                  durationType: 'Weeks'
                }
              }
              monthlySchedule: {
                retentionScheduleFormatType: 'Weekly'
                retentionScheduleWeekly: {
                  daysOfTheWeek: [
                    'Sunday'
                  ]
                  weeksOfTheMonth: [
                    'First'
                  ]
                }
                retentionTimes: [
                  '2019-11-07T22:00:00Z'
                ]
                retentionDuration: {
                  count: 60
                  durationType: 'Months'
                }
              }
              yearlySchedule: {
                retentionScheduleFormatType: 'Weekly'
                monthsOfYear: [
                  'January'
                ]
                retentionScheduleWeekly: {
                  daysOfTheWeek: [
                    'Sunday'
                  ]
                  weeksOfTheMonth: [
                    'First'
                  ]
                }
                retentionTimes: [
                  '2019-11-07T22:00:00Z'
                ]
                retentionDuration: {
                  count: 10
                  durationType: 'Years'
                }
              }
            }
          }
          {
            policyType: 'Differential'
            schedulePolicy: {
              schedulePolicyType: 'SimpleSchedulePolicy'
              scheduleRunFrequency: 'Weekly'
              scheduleRunDays: [
                'Monday'
              ]
              scheduleRunTimes: [
                '2017-03-07T02:00:00Z'
              ]
              scheduleWeeklyFrequency: 0
            }
            retentionPolicy: {
              retentionPolicyType: 'SimpleRetentionPolicy'
              retentionDuration: {
                count: 30
                durationType: 'Days'
              }
            }
          }
          {
            policyType: 'Log'
            schedulePolicy: {
              schedulePolicyType: 'LogSchedulePolicy'
              scheduleFrequencyInMins: 120
            }
            retentionPolicy: {
              retentionPolicyType: 'SimpleRetentionPolicy'
              retentionDuration: {
                count: 15
                durationType: 'Days'
              }
            }
          }
        ]
        protectedItemsCount: 0
      }
    }
    {
      name: 'filesharepolicy'
      type: 'Microsoft.RecoveryServices/vaults/backupPolicies'
      properties: {
        backupManagementType: 'AzureStorage'
        workloadType: 'AzureFileShare'
        schedulePolicy: {
          schedulePolicyType: 'SimpleSchedulePolicy'
          scheduleRunFrequency: 'Daily'
          scheduleRunTimes: [
            '2019-11-07T04:30:00Z'
          ]
          scheduleWeeklyFrequency: 0
        }
        retentionPolicy: {
          retentionPolicyType: 'LongTermRetentionPolicy'
          dailySchedule: {
            retentionTimes: [
              '2019-11-07T04:30:00Z'
            ]
            retentionDuration: {
              count: 30
              durationType: 'Days'
            }
          }
        }
        timeZone: 'UTC'
        protectedItemsCount: 0
      }
    }
]
```

</details>
<p>

### Parameter Usage: `replicationFabrics`

<details>

<summary>Parameter JSON format</summary>

```json
"replicationFabrics": {
  "value": [
      {
          "location": "NorthEurope",
          "replicationContainers": [
              {
                  "name": "ne-container1",
                  "replicationContainerMappings": [
                    {
                      "policyName": "Default_values",
                      "targetContainerFabricName": "WestEurope-Fabric",
                      "targetContainerName": "we-conainer2"
                    }
                  ]
              }
          ]
      },
      {
          "name": "WestEurope-Fabric", //Optional
          "location": "WestEurope",
          "replicationContainers": [
              {
                  "name": "we-conainer2"
              }
          ]
      }
  ]
},
```

### Parameter Usage: `replicationPolicies`

<details>

<summary>Parameter JSON format</summary>

```json
"replicationPolicies": {
    "value": [
        {
            "name": "Default_values"
        },
        {
            "name": "Custom_values",
            "appConsistentFrequencyInMinutes": 240,
            "crashConsistentFrequencyInMinutes": 7,
            "multiVmSyncStatus": "Disable",
            "recoveryPointHistory": 2880
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
replicationPolicies: [
    {
        name: 'Default_values'
    }
    {
        name: 'Custom_values'
        appConsistentFrequencyInMinutes: 240
        crashConsistentFrequencyInMinutes: 7
        multiVmSyncStatus: 'Disable'
        recoveryPointHistory: 2880
    }
]
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
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`. Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.
- Although not strictly required, it is highly recommended to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

<details>

<summary>Parameter JSON format</summary>

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<serviceName>", // e.g. vault, registry, blob
            "privateDnsZoneGroup": {
                "privateDNSResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                    "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<privateDnsZoneName>" // e.g. privatelink.vaultcore.azure.net, privatelink.azurecr.io, privatelink.blob.core.windows.net
                ]
            },
            "ipConfigurations":[
                {
                    "name": "myIPconfigTest02",
                    "properties": {
                        "groupId": "blob",
                        "memberName": "blob",
                        "privateIPAddress": "10.0.0.30"
                    }
                }
            ],
            "customDnsConfigs": [
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
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<serviceName>" // e.g. vault, registry, blob
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
privateEndpoints:  [
    // Example showing all available fields
    {
        name: 'sxx-az-pe' // Optional: Name will be automatically generated if one is not provided here
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<serviceName>' // e.g. vault, registry, blob
        privateDnsZoneGroup: {
            privateDNSResourceIds: [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<privateDnsZoneName>' // e.g. privatelink.vaultcore.azure.net, privatelink.azurecr.io, privatelink.blob.core.windows.net
            ]
        }
        customDnsConfigs: [
            {
                fqdn: 'customname.test.local'
                ipAddresses: [
                    '10.10.10.10'
                ]
            }
        ]
        ipConfigurations:[
          {
            name: 'myIPconfigTest02'
            properties: {
              groupId: 'blob'
              memberName: 'blob'
              privateIPAddress: '10.0.0.30'
            }
          }
        ]
    }
    // Example showing only mandatory fields
    {
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<serviceName>' // e.g. vault, registry, blob
    }
]
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The Name of the recovery services vault. |
| `resourceGroupName` | string | The name of the resource group the recovery services vault was created in. |
| `resourceId` | string | The resource ID of the recovery services vault. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `network/private-endpoints` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module vaults './recovery-services/vaults/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-rsvcom'
  params: {
    // Required parameters
    name: '<<namePrefix>>rsvcom001'
    // Non-required parameters
    backupConfig: {
      enhancedSecurityState: 'Disabled'
      softDeleteFeatureState: 'Disabled'
    }
    backupPolicies: [
      {
        name: 'VMpolicy'
        properties: {
          backupManagementType: 'AzureIaasVM'
          instantRPDetails: {}
          instantRpRetentionRangeInDays: 2
          protectedItemsCount: 0
          retentionPolicy: {
            dailySchedule: {
              retentionDuration: {
                count: 180
                durationType: 'Days'
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            monthlySchedule: {
              retentionDuration: {
                count: 60
                durationType: 'Months'
              }
              retentionScheduleFormatType: 'Weekly'
              retentionScheduleWeekly: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                weeksOfTheMonth: [
                  'First'
                ]
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            retentionPolicyType: 'LongTermRetentionPolicy'
            weeklySchedule: {
              daysOfTheWeek: [
                'Sunday'
              ]
              retentionDuration: {
                count: 12
                durationType: 'Weeks'
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            yearlySchedule: {
              monthsOfYear: [
                'January'
              ]
              retentionDuration: {
                count: 10
                durationType: 'Years'
              }
              retentionScheduleFormatType: 'Weekly'
              retentionScheduleWeekly: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                weeksOfTheMonth: [
                  'First'
                ]
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
          }
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunFrequency: 'Daily'
            scheduleRunTimes: [
              '2019-11-07T07:00:00Z'
            ]
            scheduleWeeklyFrequency: 0
          }
          timeZone: 'UTC'
        }
      }
      {
        name: 'sqlpolicy'
        properties: {
          backupManagementType: 'AzureWorkload'
          protectedItemsCount: 0
          settings: {
            isCompression: true
            issqlcompression: true
            timeZone: 'UTC'
          }
          subProtectionPolicy: [
            {
              policyType: 'Full'
              retentionPolicy: {
                monthlySchedule: {
                  retentionDuration: {
                    count: 60
                    durationType: 'Months'
                  }
                  retentionScheduleFormatType: 'Weekly'
                  retentionScheduleWeekly: {
                    daysOfTheWeek: [
                      'Sunday'
                    ]
                    weeksOfTheMonth: [
                      'First'
                    ]
                  }
                  retentionTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                }
                retentionPolicyType: 'LongTermRetentionPolicy'
                weeklySchedule: {
                  daysOfTheWeek: [
                    'Sunday'
                  ]
                  retentionDuration: {
                    count: 104
                    durationType: 'Weeks'
                  }
                  retentionTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                }
                yearlySchedule: {
                  monthsOfYear: [
                    'January'
                  ]
                  retentionDuration: {
                    count: 10
                    durationType: 'Years'
                  }
                  retentionScheduleFormatType: 'Weekly'
                  retentionScheduleWeekly: {
                    daysOfTheWeek: [
                      'Sunday'
                    ]
                    weeksOfTheMonth: [
                      'First'
                    ]
                  }
                  retentionTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                }
              }
              schedulePolicy: {
                schedulePolicyType: 'SimpleSchedulePolicy'
                scheduleRunDays: [
                  'Sunday'
                ]
                scheduleRunFrequency: 'Weekly'
                scheduleRunTimes: [
                  '2019-11-07T22:00:00Z'
                ]
                scheduleWeeklyFrequency: 0
              }
            }
            {
              policyType: 'Differential'
              retentionPolicy: {
                retentionDuration: {
                  count: 30
                  durationType: 'Days'
                }
                retentionPolicyType: 'SimpleRetentionPolicy'
              }
              schedulePolicy: {
                schedulePolicyType: 'SimpleSchedulePolicy'
                scheduleRunDays: [
                  'Monday'
                ]
                scheduleRunFrequency: 'Weekly'
                scheduleRunTimes: [
                  '2017-03-07T02:00:00Z'
                ]
                scheduleWeeklyFrequency: 0
              }
            }
            {
              policyType: 'Log'
              retentionPolicy: {
                retentionDuration: {
                  count: 15
                  durationType: 'Days'
                }
                retentionPolicyType: 'SimpleRetentionPolicy'
              }
              schedulePolicy: {
                scheduleFrequencyInMins: 120
                schedulePolicyType: 'LogSchedulePolicy'
              }
            }
          ]
          workLoadType: 'SQLDataBase'
        }
      }
      {
        name: 'filesharepolicy'
        properties: {
          backupManagementType: 'AzureStorage'
          protectedItemsCount: 0
          retentionPolicy: {
            dailySchedule: {
              retentionDuration: {
                count: 30
                durationType: 'Days'
              }
              retentionTimes: [
                '2019-11-07T04:30:00Z'
              ]
            }
            retentionPolicyType: 'LongTermRetentionPolicy'
          }
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunFrequency: 'Daily'
            scheduleRunTimes: [
              '2019-11-07T04:30:00Z'
            ]
            scheduleWeeklyFrequency: 0
          }
          timeZone: 'UTC'
          workloadType: 'AzureFileShare'
        }
      }
    ]
    backupStorageConfig: {
      crossRegionRestoreFlag: true
      storageModelType: 'GeoRedundant'
    }
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: 'CanNotDelete'
    monitoringSettings: {
      azureMonitorAlertSettings: {
        alertsForAllJobFailures: 'Enabled'
      }
      classicAlertSettings: {
        alertsForCriticalOperations: 'Enabled'
      }
    }
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            '<privateDNSResourceId>'
          ]
        }
        service: 'AzureSiteRecovery'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    replicationAlertSettings: {
      customEmailAddresses: [
        'test.user@testcompany.com'
      ]
      locale: 'en-US'
      sendToOwners: 'Send'
    }
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    securitySettings: {
      immutabilitySettings: {
        state: 'Unlocked'
      }
    }
    tags: {
      Environment: 'Non-Prod'
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
      "value": "<<namePrefix>>rsvcom001"
    },
    // Non-required parameters
    "backupConfig": {
      "value": {
        "enhancedSecurityState": "Disabled",
        "softDeleteFeatureState": "Disabled"
      }
    },
    "backupPolicies": {
      "value": [
        {
          "name": "VMpolicy",
          "properties": {
            "backupManagementType": "AzureIaasVM",
            "instantRPDetails": {},
            "instantRpRetentionRangeInDays": 2,
            "protectedItemsCount": 0,
            "retentionPolicy": {
              "dailySchedule": {
                "retentionDuration": {
                  "count": 180,
                  "durationType": "Days"
                },
                "retentionTimes": [
                  "2019-11-07T07:00:00Z"
                ]
              },
              "monthlySchedule": {
                "retentionDuration": {
                  "count": 60,
                  "durationType": "Months"
                },
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
                ]
              },
              "retentionPolicyType": "LongTermRetentionPolicy",
              "weeklySchedule": {
                "daysOfTheWeek": [
                  "Sunday"
                ],
                "retentionDuration": {
                  "count": 12,
                  "durationType": "Weeks"
                },
                "retentionTimes": [
                  "2019-11-07T07:00:00Z"
                ]
              },
              "yearlySchedule": {
                "monthsOfYear": [
                  "January"
                ],
                "retentionDuration": {
                  "count": 10,
                  "durationType": "Years"
                },
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
                ]
              }
            },
            "schedulePolicy": {
              "schedulePolicyType": "SimpleSchedulePolicy",
              "scheduleRunFrequency": "Daily",
              "scheduleRunTimes": [
                "2019-11-07T07:00:00Z"
              ],
              "scheduleWeeklyFrequency": 0
            },
            "timeZone": "UTC"
          }
        },
        {
          "name": "sqlpolicy",
          "properties": {
            "backupManagementType": "AzureWorkload",
            "protectedItemsCount": 0,
            "settings": {
              "isCompression": true,
              "issqlcompression": true,
              "timeZone": "UTC"
            },
            "subProtectionPolicy": [
              {
                "policyType": "Full",
                "retentionPolicy": {
                  "monthlySchedule": {
                    "retentionDuration": {
                      "count": 60,
                      "durationType": "Months"
                    },
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
                    ]
                  },
                  "retentionPolicyType": "LongTermRetentionPolicy",
                  "weeklySchedule": {
                    "daysOfTheWeek": [
                      "Sunday"
                    ],
                    "retentionDuration": {
                      "count": 104,
                      "durationType": "Weeks"
                    },
                    "retentionTimes": [
                      "2019-11-07T22:00:00Z"
                    ]
                  },
                  "yearlySchedule": {
                    "monthsOfYear": [
                      "January"
                    ],
                    "retentionDuration": {
                      "count": 10,
                      "durationType": "Years"
                    },
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
                    ]
                  }
                },
                "schedulePolicy": {
                  "schedulePolicyType": "SimpleSchedulePolicy",
                  "scheduleRunDays": [
                    "Sunday"
                  ],
                  "scheduleRunFrequency": "Weekly",
                  "scheduleRunTimes": [
                    "2019-11-07T22:00:00Z"
                  ],
                  "scheduleWeeklyFrequency": 0
                }
              },
              {
                "policyType": "Differential",
                "retentionPolicy": {
                  "retentionDuration": {
                    "count": 30,
                    "durationType": "Days"
                  },
                  "retentionPolicyType": "SimpleRetentionPolicy"
                },
                "schedulePolicy": {
                  "schedulePolicyType": "SimpleSchedulePolicy",
                  "scheduleRunDays": [
                    "Monday"
                  ],
                  "scheduleRunFrequency": "Weekly",
                  "scheduleRunTimes": [
                    "2017-03-07T02:00:00Z"
                  ],
                  "scheduleWeeklyFrequency": 0
                }
              },
              {
                "policyType": "Log",
                "retentionPolicy": {
                  "retentionDuration": {
                    "count": 15,
                    "durationType": "Days"
                  },
                  "retentionPolicyType": "SimpleRetentionPolicy"
                },
                "schedulePolicy": {
                  "scheduleFrequencyInMins": 120,
                  "schedulePolicyType": "LogSchedulePolicy"
                }
              }
            ],
            "workLoadType": "SQLDataBase"
          }
        },
        {
          "name": "filesharepolicy",
          "properties": {
            "backupManagementType": "AzureStorage",
            "protectedItemsCount": 0,
            "retentionPolicy": {
              "dailySchedule": {
                "retentionDuration": {
                  "count": 30,
                  "durationType": "Days"
                },
                "retentionTimes": [
                  "2019-11-07T04:30:00Z"
                ]
              },
              "retentionPolicyType": "LongTermRetentionPolicy"
            },
            "schedulePolicy": {
              "schedulePolicyType": "SimpleSchedulePolicy",
              "scheduleRunFrequency": "Daily",
              "scheduleRunTimes": [
                "2019-11-07T04:30:00Z"
              ],
              "scheduleWeeklyFrequency": 0
            },
            "timeZone": "UTC",
            "workloadType": "AzureFileShare"
          }
        }
      ]
    },
    "backupStorageConfig": {
      "value": {
        "crossRegionRestoreFlag": true,
        "storageModelType": "GeoRedundant"
      }
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "<diagnosticEventHubAuthorizationRuleId>"
    },
    "diagnosticEventHubName": {
      "value": "<diagnosticEventHubName>"
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
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
    "lock": {
      "value": "CanNotDelete"
    },
    "monitoringSettings": {
      "value": {
        "azureMonitorAlertSettings": {
          "alertsForAllJobFailures": "Enabled"
        },
        "classicAlertSettings": {
          "alertsForCriticalOperations": "Enabled"
        }
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDNSResourceIds": [
              "<privateDNSResourceId>"
            ]
          },
          "service": "AzureSiteRecovery",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "replicationAlertSettings": {
      "value": {
        "customEmailAddresses": [
          "test.user@testcompany.com"
        ],
        "locale": "en-US",
        "sendToOwners": "Send"
      }
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
    "securitySettings": {
      "value": {
        "immutabilitySettings": {
          "state": "Unlocked"
        }
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 2: Dr</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module vaults './recovery-services/vaults/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-rsvdr'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    replicationFabrics: [
      {
        location: 'NorthEurope'
        replicationContainers: [
          {
            name: 'ne-container1'
            replicationContainerMappings: [
              {
                policyName: 'Default_values'
                targetContainerName: 'pluto'
                targetProtectionContainerId: '<targetProtectionContainerId>'
              }
            ]
          }
          {
            name: 'ne-container2'
            replicationContainerMappings: [
              {
                policyName: 'Default_values'
                targetContainerFabricName: 'WE-2'
                targetContainerName: 'we-container1'
              }
            ]
          }
        ]
      }
      {
        location: 'WestEurope'
        name: 'WE-2'
        replicationContainers: [
          {
            name: 'we-container1'
            replicationContainerMappings: [
              {
                policyName: 'Default_values'
                targetContainerFabricName: 'NorthEurope'
                targetContainerName: 'ne-container2'
              }
            ]
          }
        ]
      }
    ]
    replicationPolicies: [
      {
        name: 'Default_values'
      }
      {
        appConsistentFrequencyInMinutes: 240
        crashConsistentFrequencyInMinutes: 7
        multiVmSyncStatus: 'Disable'
        name: 'Custom_values'
        recoveryPointHistory: 2880
      }
    ]
    tags: {
      Environment: 'Non-Prod'
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
      "value": "<name>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "replicationFabrics": {
      "value": [
        {
          "location": "NorthEurope",
          "replicationContainers": [
            {
              "name": "ne-container1",
              "replicationContainerMappings": [
                {
                  "policyName": "Default_values",
                  "targetContainerName": "pluto",
                  "targetProtectionContainerId": "<targetProtectionContainerId>"
                }
              ]
            },
            {
              "name": "ne-container2",
              "replicationContainerMappings": [
                {
                  "policyName": "Default_values",
                  "targetContainerFabricName": "WE-2",
                  "targetContainerName": "we-container1"
                }
              ]
            }
          ]
        },
        {
          "location": "WestEurope",
          "name": "WE-2",
          "replicationContainers": [
            {
              "name": "we-container1",
              "replicationContainerMappings": [
                {
                  "policyName": "Default_values",
                  "targetContainerFabricName": "NorthEurope",
                  "targetContainerName": "ne-container2"
                }
              ]
            }
          ]
        }
      ]
    },
    "replicationPolicies": {
      "value": [
        {
          "name": "Default_values"
        },
        {
          "appConsistentFrequencyInMinutes": 240,
          "crashConsistentFrequencyInMinutes": 7,
          "multiVmSyncStatus": "Disable",
          "name": "Custom_values",
          "recoveryPointHistory": 2880
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<h3>Example 3: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module vaults './recovery-services/vaults/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-rsvmin'
  params: {
    // Required parameters
    name: '<<namePrefix>>rsvmin001'
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
      "value": "<<namePrefix>>rsvmin001"
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
