# RecoveryServicesVaults

This module deploys Recovery Service Vault, with resource lock.


## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.RecoveryServices/vaults`|2020-10-01|
|`Microsoft.RecoveryServices/vaults/backupstorageconfig` | 2020-02-02 |
|`Microsoft.Resources/deployments`|2019-10-01|
|`providers/locks`|2016-09-01|
|`Microsoft.RecoveryServices/vaults/providers/diagnosticsettings`|2017-05-01-preview|
|`Microsoft.RecoveryServices/vaults/backupPolicies`|2019-05-13|
|`Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers`|2016-12-01|
|`Microsoft.RecoveryServices/vaults/providers/roleAssignments`|2018-09-01-preview|

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `backupPolicies` | array | Optional. List of all backup policies. | System.Object[] |  |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 |  |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  |  |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  |  |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  |  |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] |  |
| `lockForDeletion` | bool | Optional. Switch to lock Recovery Service Vault from deletion. | False | |
| `protectionContainers` | array | Optional. List of all protection containers. | System.Object[] |  |
| `recoveryVaultName` | string | Required. Name of the Azure Recovery Service Vault |  |  |
| `enableCRR` | bool | Optional. Enable CRR (Works if vault has not registered any backup instance) | True |  |
| `vaultStorageType` | string | Optional. Change Vault Storage Type (Works if vault has not registered any backup instance) | GeoRedundant | System.Object[]  |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] |  |
| `tags` | object | Optional. Tags of the Recovery Service Vault resource. |  |  |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  |  |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  |  |

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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `recoveryServicesVaultName` | string | The Name of the Recovery Services Vault. |
| `recoveryServicesVaultResourceGroup` | string | The Resource Group the Recovery Services Vault was deployed to. |
| `recoveryServicesVaultResourceId` | string | The Resource Id of the Recovery Services Vault. |

## Considerations

## Additional resources

- [Recovery Services vaults overview](https://docs.microsoft.com/en-us/azure/backup/backup-azure-recovery-services-vault-overview)
- [Microsoft.RecoveryServices vaults template reference](https://docs.microsoft.com/en-gb/azure/templates/microsoft.recoveryservices/allversions)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)