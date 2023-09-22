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
| `` | [](https://learn.microsoft.com/en-us/azure/templates///) |

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
| `diagnosticSettings` |  |  |  | The diagnostic settings of the service. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `forceCmkForQuery` | bool | `True` |  | Indicates whether customer managed storage is mandatory for query management. |
| `gallerySolutions` | array | `[]` |  | List of gallerySolutions to be created in the log analytics workspace. |
| `linkedServices` | array | `[]` |  | List of services to be linked. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` |  |  |  | The lock settings of the service. |
| `managedIdentities` |  |  |  | The managed identity definition for this resource |
| `publicNetworkAccessForIngestion` | string | `'Enabled'` | `[Disabled, Enabled]` | The network access type for accessing Log Analytics ingestion. |
| `publicNetworkAccessForQuery` | string | `'Enabled'` | `[Disabled, Enabled]` | The network access type for accessing Log Analytics query. |
| `roleAssignments` |  |  |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `savedSearches` | array | `[]` |  | Kusto Query Language searches to save. |
| `skuCapacityReservationLevel` | int | `100` |  | The capacity reservation level in GB for this workspace, when CapacityReservation sku is selected. Must be in increments of 100 between 100 and 5000. |
| `skuName` | string | `'PerGB2018'` | `[CapacityReservation, Free, LACluster, PerGB2018, PerNode, Premium, Standalone, Standard]` | The name of the SKU. |
| `storageInsightsConfigs` | array | `[]` |  | List of storage accounts to be read by the workspace. |
| `tables` | array | `[]` |  | LAW custom tables to be deployed. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `useResourcePermissions` | bool | `False` |  | Set to 'true' to use resource or workspace permissions and 'false' (or leave empty) to require workspace permissions. |


### Parameter Usage: `gallerySolutions`

Ref cross-referenced _[solution](../../operations-management/solution/README.md)_

<details>

<summary>Parameter JSON format</summary>

```json
"gallerySolutions": {
    "value": [
        {
            "name": "AgentHealthAssessment",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AlertManagement",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AntiMalware",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureActivity",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureAutomation",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureCdnCoreAnalytics",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureDataFactoryAnalytics",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureNSGAnalytics",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "AzureSQLAnalytics",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "ChangeTracking",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "Containers",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "InfrastructureInsights",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "KeyVaultAnalytics",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "LogicAppsManagement",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "NetworkMonitoring",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "Security",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "SecurityCenterFree",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "ServiceFabric",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "ServiceMap",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "SQLAssessment",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "Updates",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "VMInsights",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "WireData2",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        },
        {
            "name": "WaaSUpdateInsights",
            "product": "OMSGallery",
            "publisher": "Microsoft"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
gallerySolutions: [
    {
        name: 'AgentHealthAssessment'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AlertManagement'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AntiMalware'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AzureActivity'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AzureAutomation'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AzureCdnCoreAnalytics'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AzureDataFactoryAnalytics'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AzureNSGAnalytics'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'AzureSQLAnalytics'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'ChangeTracking'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'Containers'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'InfrastructureInsights'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'KeyVaultAnalytics'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'LogicAppsManagement'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'NetworkMonitoring'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'Security'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'SecurityCenterFree'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'ServiceFabric'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'ServiceMap'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'SQLAssessment'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'Updates'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'VMInsights'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'WireData2'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
    {
        name: 'WaaSUpdateInsights'
        product: 'OMSGallery'
        publisher: 'Microsoft'
    }
]
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

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/[[subscriptionId]]/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/[[subscriptionId]]/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/[[subscriptionId]]/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/[[subscriptionId]]/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `logAnalyticsWorkspaceId` | string | The ID associated with the workspace. |
| `name` | string | The name of the deployed log analytics workspace. |
| `resourceGroupName` | string | The resource group of the deployed log analytics workspace. |
| `resourceId` | string | The resource ID of the deployed log analytics workspace. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

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
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            category: 'Audit'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'Log Analytics Workspace Lock - Do Not Delete'
    }
    managedIdentities: {
      userAssignedResourcesIds: [
        '<managedIdentityResourceId>'
      ]
    }
    name: 'oiwadv001'
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
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "category": "Audit"
            }
          ],
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        },
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    // Non-required parameters
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "Log Analytics Workspace Lock - Do Not Delete"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourcesIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "name": {
      "value": "oiwadv001"
    },
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
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            category: 'Audit'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    lock: {
      kind: 'CanNotDelete'
    }
    managedIdentities: {
      systemAssigned: true
    }
    name: 'oiwcom001'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
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
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "category": "Audit"
            }
          ],
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        },
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "name": {
      "value": "oiwcom001"
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>
