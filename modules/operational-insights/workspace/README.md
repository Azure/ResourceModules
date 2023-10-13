# Log Analytics Workspaces `[Microsoft.OperationalInsights/workspaces]`

This module deploys a Log Analytics Workspace.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.OperationalInsights/workspaces` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces) |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataExports) |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataSources) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices) |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedStorageAccounts) |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches) |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs) |
| `Microsoft.OperationalInsights/workspaces/tables` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces/tables) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Log Analytics workspace. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `linkedStorageAccounts` | array | List of Storage Accounts to be linked. Required if 'forceCmkForQuery' is set to 'true' and 'savedSearches' is not empty. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `dailyQuotaGb` | int | `-1` |  | The workspace daily quota for ingestion. |
| `dataExports` | array | `[]` |  | LAW data export instances to be deployed. |
| `dataRetention` | int | `365` |  | Number of days data will be retained for. |
| `dataSources` | array | `[]` |  | LAW data sources to configure. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', allLogs, Audit]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of a log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `forceCmkForQuery` | bool | `True` |  | Indicates whether customer managed storage is mandatory for query management. |
| `gallerySolutions` | array | `[]` |  | List of gallerySolutions to be created in the log analytics workspace. |
| `linkedServices` | array | `[]` |  | List of services to be linked. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `publicNetworkAccessForIngestion` | string | `'Enabled'` | `[Disabled, Enabled]` | The network access type for accessing Log Analytics ingestion. |
| `publicNetworkAccessForQuery` | string | `'Enabled'` | `[Disabled, Enabled]` | The network access type for accessing Log Analytics query. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `savedSearches` | array | `[]` |  | Kusto Query Language searches to save. |
| `skuCapacityReservationLevel` | int | `100` |  | The capacity reservation level in GB for this workspace, when CapacityReservation sku is selected. Must be in increments of 100 between 100 and 5000. |
| `skuName` | string | `'PerGB2018'` | `[CapacityReservation, Free, LACluster, PerGB2018, PerNode, Premium, Standalone, Standard]` | The name of the SKU. |
| `storageInsightsConfigs` | array | `[]` |  | List of storage accounts to be read by the workspace. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tables` | array | `[]` |  | LAW custom tables to be deployed. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `useResourcePermissions` | bool | `False` |  | Set to 'true' to use resource or workspace permissions and 'false' (or leave empty) to require workspace permissions. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `logAnalyticsWorkspaceId` | string | The ID associated with the workspace. |
| `name` | string | The name of the deployed log analytics workspace. |
| `resourceGroupName` | string | The resource group of the deployed log analytics workspace. |
| `resourceId` | string | The resource ID of the deployed log analytics workspace. |
| `systemAssignedIdentityPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `operations-management/solution` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Adv</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspace './operational-insights/workspace/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-oiwadv'
  params: {
    // Required parameters
    name: 'oiwadv001'
    // Non-required parameters
    dailyQuotaGb: 10
    dataExports: [
      {
        destination: {
          metaData: {
            eventHubName: '<eventHubName>'
          }
          resourceId: '<resourceId>'
        }
        enable: true
        name: 'eventHubExport'
        tableNames: [
          'Alert'
          'InsightsMetrics'
        ]
      }
      {
        destination: {
          resourceId: '<resourceId>'
        }
        enable: true
        name: 'storageAccountExport'
        tableNames: [
          'Operation'
        ]
      }
    ]
    dataSources: [
      {
        eventLogName: 'Application'
        eventTypes: [
          {
            eventType: 'Error'
          }
          {
            eventType: 'Warning'
          }
          {
            eventType: 'Information'
          }
        ]
        kind: 'WindowsEvent'
        name: 'applicationEvent'
      }
      {
        counterName: '% Processor Time'
        instanceName: '*'
        intervalSeconds: 60
        kind: 'WindowsPerformanceCounter'
        name: 'windowsPerfCounter1'
        objectName: 'Processor'
      }
      {
        kind: 'IISLogs'
        name: 'sampleIISLog1'
        state: 'OnPremiseEnabled'
      }
      {
        kind: 'LinuxSyslog'
        name: 'sampleSyslog1'
        syslogName: 'kern'
        syslogSeverities: [
          {
            severity: 'emerg'
          }
          {
            severity: 'alert'
          }
          {
            severity: 'crit'
          }
          {
            severity: 'err'
          }
          {
            severity: 'warning'
          }
        ]
      }
      {
        kind: 'LinuxSyslogCollection'
        name: 'sampleSyslogCollection1'
        state: 'Enabled'
      }
      {
        instanceName: '*'
        intervalSeconds: 10
        kind: 'LinuxPerformanceObject'
        name: 'sampleLinuxPerf1'
        objectName: 'Logical Disk'
        syslogSeverities: [
          {
            counterName: '% Used Inodes'
          }
          {
            counterName: 'Free Megabytes'
          }
          {
            counterName: '% Used Space'
          }
          {
            counterName: 'Disk Transfers/sec'
          }
          {
            counterName: 'Disk Reads/sec'
          }
          {
            counterName: 'Disk Writes/sec'
          }
        ]
      }
      {
        kind: 'LinuxPerformanceCollection'
        name: 'sampleLinuxPerfCollection1'
        state: 'Enabled'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    gallerySolutions: [
      {
        name: 'AzureAutomation'
        product: 'OMSGallery'
        publisher: 'Microsoft'
      }
    ]
    linkedServices: [
      {
        name: 'Automation'
        resourceId: '<resourceId>'
      }
    ]
    linkedStorageAccounts: [
      {
        name: 'Query'
        resourceId: '<resourceId>'
      }
    ]
    lock: 'CanNotDelete'
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Disabled'
    savedSearches: [
      {
        category: 'VDC Saved Searches'
        displayName: 'VMSS Instance Count2'
        name: 'VMSSQueries'
        query: 'Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer'
      }
    ]
    storageInsightsConfigs: [
      {
        storageAccountResourceId: '<storageAccountResourceId>'
        tables: [
          'LinuxsyslogVer2v0'
          'WADETWEventTable'
          'WADServiceFabric*EventTable'
          'WADWindowsEventLogsTable'
        ]
      }
    ]
    tables: [
      {
        name: 'CustomTableBasic_CL'
        retentionInDays: 60
        schema: {
          columns: [
            {
              name: 'TimeGenerated'
              type: 'DateTime'
            }
            {
              name: 'RawData'
              type: 'String'
            }
          ]
          name: 'CustomTableBasic_CL'
        }
        totalRetentionInDays: 90
      }
      {
        name: 'CustomTableAdvanced_CL'
        schema: {
          columns: [
            {
              name: 'TimeGenerated'
              type: 'DateTime'
            }
            {
              name: 'EventTime'
              type: 'DateTime'
            }
            {
              name: 'EventLevel'
              type: 'String'
            }
            {
              name: 'EventCode'
              type: 'Int'
            }
            {
              name: 'Message'
              type: 'String'
            }
            {
              name: 'RawData'
              type: 'String'
            }
          ]
          name: 'CustomTableAdvanced_CL'
        }
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
    }
    useResourcePermissions: true
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
      "value": "oiwadv001"
    },
    // Non-required parameters
    "dailyQuotaGb": {
      "value": 10
    },
    "dataExports": {
      "value": [
        {
          "destination": {
            "metaData": {
              "eventHubName": "<eventHubName>"
            },
            "resourceId": "<resourceId>"
          },
          "enable": true,
          "name": "eventHubExport",
          "tableNames": [
            "Alert",
            "InsightsMetrics"
          ]
        },
        {
          "destination": {
            "resourceId": "<resourceId>"
          },
          "enable": true,
          "name": "storageAccountExport",
          "tableNames": [
            "Operation"
          ]
        }
      ]
    },
    "dataSources": {
      "value": [
        {
          "eventLogName": "Application",
          "eventTypes": [
            {
              "eventType": "Error"
            },
            {
              "eventType": "Warning"
            },
            {
              "eventType": "Information"
            }
          ],
          "kind": "WindowsEvent",
          "name": "applicationEvent"
        },
        {
          "counterName": "% Processor Time",
          "instanceName": "*",
          "intervalSeconds": 60,
          "kind": "WindowsPerformanceCounter",
          "name": "windowsPerfCounter1",
          "objectName": "Processor"
        },
        {
          "kind": "IISLogs",
          "name": "sampleIISLog1",
          "state": "OnPremiseEnabled"
        },
        {
          "kind": "LinuxSyslog",
          "name": "sampleSyslog1",
          "syslogName": "kern",
          "syslogSeverities": [
            {
              "severity": "emerg"
            },
            {
              "severity": "alert"
            },
            {
              "severity": "crit"
            },
            {
              "severity": "err"
            },
            {
              "severity": "warning"
            }
          ]
        },
        {
          "kind": "LinuxSyslogCollection",
          "name": "sampleSyslogCollection1",
          "state": "Enabled"
        },
        {
          "instanceName": "*",
          "intervalSeconds": 10,
          "kind": "LinuxPerformanceObject",
          "name": "sampleLinuxPerf1",
          "objectName": "Logical Disk",
          "syslogSeverities": [
            {
              "counterName": "% Used Inodes"
            },
            {
              "counterName": "Free Megabytes"
            },
            {
              "counterName": "% Used Space"
            },
            {
              "counterName": "Disk Transfers/sec"
            },
            {
              "counterName": "Disk Reads/sec"
            },
            {
              "counterName": "Disk Writes/sec"
            }
          ]
        },
        {
          "kind": "LinuxPerformanceCollection",
          "name": "sampleLinuxPerfCollection1",
          "state": "Enabled"
        }
      ]
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
    "gallerySolutions": {
      "value": [
        {
          "name": "AzureAutomation",
          "product": "OMSGallery",
          "publisher": "Microsoft"
        }
      ]
    },
    "linkedServices": {
      "value": [
        {
          "name": "Automation",
          "resourceId": "<resourceId>"
        }
      ]
    },
    "linkedStorageAccounts": {
      "value": [
        {
          "name": "Query",
          "resourceId": "<resourceId>"
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "publicNetworkAccessForIngestion": {
      "value": "Disabled"
    },
    "publicNetworkAccessForQuery": {
      "value": "Disabled"
    },
    "savedSearches": {
      "value": [
        {
          "category": "VDC Saved Searches",
          "displayName": "VMSS Instance Count2",
          "name": "VMSSQueries",
          "query": "Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer"
        }
      ]
    },
    "storageInsightsConfigs": {
      "value": [
        {
          "storageAccountResourceId": "<storageAccountResourceId>",
          "tables": [
            "LinuxsyslogVer2v0",
            "WADETWEventTable",
            "WADServiceFabric*EventTable",
            "WADWindowsEventLogsTable"
          ]
        }
      ]
    },
    "tables": {
      "value": [
        {
          "name": "CustomTableBasic_CL",
          "retentionInDays": 60,
          "schema": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "DateTime"
              },
              {
                "name": "RawData",
                "type": "String"
              }
            ],
            "name": "CustomTableBasic_CL"
          },
          "totalRetentionInDays": 90
        },
        {
          "name": "CustomTableAdvanced_CL",
          "schema": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "DateTime"
              },
              {
                "name": "EventTime",
                "type": "DateTime"
              },
              {
                "name": "EventLevel",
                "type": "String"
              },
              {
                "name": "EventCode",
                "type": "Int"
              },
              {
                "name": "Message",
                "type": "String"
              },
              {
                "name": "RawData",
                "type": "String"
              }
            ],
            "name": "CustomTableAdvanced_CL"
          }
        }
      ]
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
    },
    "useResourcePermissions": {
      "value": true
    }
  }
}
```

</details>
<p>

<h3>Example 2: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module workspace './operational-insights/workspace/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-oiwcom'
  params: {
    // Required parameters
    name: 'oiwcom001'
    // Non-required parameters
    dailyQuotaGb: 10
    dataSources: [
      {
        eventLogName: 'Application'
        eventTypes: [
          {
            eventType: 'Error'
          }
          {
            eventType: 'Warning'
          }
          {
            eventType: 'Information'
          }
        ]
        kind: 'WindowsEvent'
        name: 'applicationEvent'
      }
      {
        counterName: '% Processor Time'
        instanceName: '*'
        intervalSeconds: 60
        kind: 'WindowsPerformanceCounter'
        name: 'windowsPerfCounter1'
        objectName: 'Processor'
      }
      {
        kind: 'IISLogs'
        name: 'sampleIISLog1'
        state: 'OnPremiseEnabled'
      }
      {
        kind: 'LinuxSyslog'
        name: 'sampleSyslog1'
        syslogName: 'kern'
        syslogSeverities: [
          {
            severity: 'emerg'
          }
          {
            severity: 'alert'
          }
          {
            severity: 'crit'
          }
          {
            severity: 'err'
          }
          {
            severity: 'warning'
          }
        ]
      }
      {
        kind: 'LinuxSyslogCollection'
        name: 'sampleSyslogCollection1'
        state: 'Enabled'
      }
      {
        instanceName: '*'
        intervalSeconds: 10
        kind: 'LinuxPerformanceObject'
        name: 'sampleLinuxPerf1'
        objectName: 'Logical Disk'
        syslogSeverities: [
          {
            counterName: '% Used Inodes'
          }
          {
            counterName: 'Free Megabytes'
          }
          {
            counterName: '% Used Space'
          }
          {
            counterName: 'Disk Transfers/sec'
          }
          {
            counterName: 'Disk Reads/sec'
          }
          {
            counterName: 'Disk Writes/sec'
          }
        ]
      }
      {
        kind: 'LinuxPerformanceCollection'
        name: 'sampleLinuxPerfCollection1'
        state: 'Enabled'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    gallerySolutions: [
      {
        name: 'AzureAutomation'
        product: 'OMSGallery'
        publisher: 'Microsoft'
      }
    ]
    linkedServices: [
      {
        name: 'Automation'
        resourceId: '<resourceId>'
      }
    ]
    linkedStorageAccounts: [
      {
        name: 'Query'
        resourceId: '<resourceId>'
      }
    ]
    lock: 'CanNotDelete'
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Disabled'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    savedSearches: [
      {
        category: 'VDC Saved Searches'
        displayName: 'VMSS Instance Count2'
        name: 'VMSSQueries'
        query: 'Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer'
      }
    ]
    storageInsightsConfigs: [
      {
        storageAccountResourceId: '<storageAccountResourceId>'
        tables: [
          'LinuxsyslogVer2v0'
          'WADETWEventTable'
          'WADServiceFabric*EventTable'
          'WADWindowsEventLogsTable'
        ]
      }
    ]
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    useResourcePermissions: true
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
      "value": "oiwcom001"
    },
    // Non-required parameters
    "dailyQuotaGb": {
      "value": 10
    },
    "dataSources": {
      "value": [
        {
          "eventLogName": "Application",
          "eventTypes": [
            {
              "eventType": "Error"
            },
            {
              "eventType": "Warning"
            },
            {
              "eventType": "Information"
            }
          ],
          "kind": "WindowsEvent",
          "name": "applicationEvent"
        },
        {
          "counterName": "% Processor Time",
          "instanceName": "*",
          "intervalSeconds": 60,
          "kind": "WindowsPerformanceCounter",
          "name": "windowsPerfCounter1",
          "objectName": "Processor"
        },
        {
          "kind": "IISLogs",
          "name": "sampleIISLog1",
          "state": "OnPremiseEnabled"
        },
        {
          "kind": "LinuxSyslog",
          "name": "sampleSyslog1",
          "syslogName": "kern",
          "syslogSeverities": [
            {
              "severity": "emerg"
            },
            {
              "severity": "alert"
            },
            {
              "severity": "crit"
            },
            {
              "severity": "err"
            },
            {
              "severity": "warning"
            }
          ]
        },
        {
          "kind": "LinuxSyslogCollection",
          "name": "sampleSyslogCollection1",
          "state": "Enabled"
        },
        {
          "instanceName": "*",
          "intervalSeconds": 10,
          "kind": "LinuxPerformanceObject",
          "name": "sampleLinuxPerf1",
          "objectName": "Logical Disk",
          "syslogSeverities": [
            {
              "counterName": "% Used Inodes"
            },
            {
              "counterName": "Free Megabytes"
            },
            {
              "counterName": "% Used Space"
            },
            {
              "counterName": "Disk Transfers/sec"
            },
            {
              "counterName": "Disk Reads/sec"
            },
            {
              "counterName": "Disk Writes/sec"
            }
          ]
        },
        {
          "kind": "LinuxPerformanceCollection",
          "name": "sampleLinuxPerfCollection1",
          "state": "Enabled"
        }
      ]
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
    "gallerySolutions": {
      "value": [
        {
          "name": "AzureAutomation",
          "product": "OMSGallery",
          "publisher": "Microsoft"
        }
      ]
    },
    "linkedServices": {
      "value": [
        {
          "name": "Automation",
          "resourceId": "<resourceId>"
        }
      ]
    },
    "linkedStorageAccounts": {
      "value": [
        {
          "name": "Query",
          "resourceId": "<resourceId>"
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "publicNetworkAccessForIngestion": {
      "value": "Disabled"
    },
    "publicNetworkAccessForQuery": {
      "value": "Disabled"
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
    "savedSearches": {
      "value": [
        {
          "category": "VDC Saved Searches",
          "displayName": "VMSS Instance Count2",
          "name": "VMSSQueries",
          "query": "Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer"
        }
      ]
    },
    "storageInsightsConfigs": {
      "value": [
        {
          "storageAccountResourceId": "<storageAccountResourceId>",
          "tables": [
            "LinuxsyslogVer2v0",
            "WADETWEventTable",
            "WADServiceFabric*EventTable",
            "WADWindowsEventLogsTable"
          ]
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
    },
    "useResourcePermissions": {
      "value": true
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
module workspace './operational-insights/workspace/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-oiwmin'
  params: {
    // Required parameters
    name: 'oiwmin001'
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
      "value": "oiwmin001"
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
