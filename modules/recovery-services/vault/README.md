# Recovery Services Vaults `[Microsoft.RecoveryServices/vaults]`

This module deploys a Recovery Services Vault.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
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

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/recovery-services.vault:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Dr](#example-2-dr)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module vault 'br:bicep/modules/recovery-services.vault:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-rsvmin'
  params: {
    // Required parameters
    name: 'rsvmin001'
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
      "value": "rsvmin001"
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

### Example 2: _Dr_

<details>

<summary>via Bicep module</summary>

```bicep
module vault 'br:bicep/modules/recovery-services.vault:1.0.0' = {
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
module vault 'br:bicep/modules/recovery-services.vault:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-rsvmax'
  params: {
    // Required parameters
    name: 'rsvmax001'
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
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
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
        principalId: '<principalId>'
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
      "value": "rsvmax001"
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
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
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
          "principalId": "<principalId>",
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
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module vault 'br:bicep/modules/recovery-services.vault:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-rsvwaf'
  params: {
    // Required parameters
    name: 'rsvwaf001'
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
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
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
        principalId: '<principalId>'
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
      "value": "rsvwaf001"
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
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
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
          "principalId": "<principalId>",
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
| [`name`](#parameter-name) | string | Name of the Azure Recovery Service Vault. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupConfig`](#parameter-backupconfig) | object | The backup configuration. |
| [`backupPolicies`](#parameter-backuppolicies) | array | List of all backup policies. |
| [`backupStorageConfig`](#parameter-backupstorageconfig) | object | The storage configuration for the Azure Recovery Service Vault. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`monitoringSettings`](#parameter-monitoringsettings) | object | Monitoring Settings of the vault. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`protectionContainers`](#parameter-protectioncontainers) | array | List of all protection containers. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. |
| [`replicationAlertSettings`](#parameter-replicationalertsettings) | object | Replication alert settings. |
| [`replicationFabrics`](#parameter-replicationfabrics) | array | List of all replication fabrics. |
| [`replicationPolicies`](#parameter-replicationpolicies) | array | List of all replication policies. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`securitySettings`](#parameter-securitysettings) | object | Security Settings of the vault. |
| [`tags`](#parameter-tags) | object | Tags of the Recovery Service Vault resource. |

### Parameter: `backupConfig`

The backup configuration.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `backupPolicies`

List of all backup policies.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `backupStorageConfig`

The storage configuration for the Azure Recovery Service Vault.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | No | string | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | No | string | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | No | string | Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | No | array | Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
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

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | No | string | Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | No | string | Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to 'AllLogs' to collect all logs. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to 'AllLogs' to collect all logs.

- Required: No
- Type: string


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

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `monitoringSettings`

Monitoring Settings of the vault.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `name`

Name of the Azure Recovery Service Vault.
- Required: Yes
- Type: string

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
| [`service`](#parameter-privateendpointsservice) | No | string | Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob". |
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

Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".

- Required: No
- Type: string

### Parameter: `privateEndpoints.subnetResourceId`

Required. Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.tags`

Optional. Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `protectionContainers`

List of all protection containers.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled.
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

### Parameter: `replicationAlertSettings`

Replication alert settings.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `replicationFabrics`

List of all replication fabrics.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `replicationPolicies`

List of all replication policies.
- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `securitySettings`

Security Settings of the vault.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `tags`

Tags of the Recovery Service Vault resource.
- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The Name of the recovery services vault. |
| `resourceGroupName` | string | The name of the resource group the recovery services vault was created in. |
| `resourceId` | string | The resource ID of the recovery services vault. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/private-endpoint` | Local reference |
