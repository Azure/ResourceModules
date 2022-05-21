# RecoveryServicesVaultsBackupPolicies `[Microsoft.RecoveryServices/vaults/backupPolicies]`

This module deploys a Backup Policy for a Recovery Services Vault

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupPolicies` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2021-08-01/vaults/backupPolicies) |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `backupPolicyProperties` | object | Configuration of the Azure Recovery Service Vault Backup Policy. |
| `name` | string | Name of the Azure Recovery Service Vault Backup Policy. |

**Conditional parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `recoveryVaultName` | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |


### Parameter Usage: `backupPolicyProperties`

Object continaining the configuration for backup policies. It needs to be properly formatted and can be VM backup policies, SQL on VM backup policies or fileshare policies. The following example shows a VM backup policy.

<details>

<summary>Parameter JSON format</summary>

```json
"backupPolicyProperties": {
    "value": {
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
}
```

</details>


<details>

<summary>Bicep format</summary>

```bicep
backupPolicyProperties: {
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
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup policy. |
| `resourceGroupName` | string | The name of the resource group the backup policy was created in. |
| `resourceId` | string | The resource ID of the backup policy. |
