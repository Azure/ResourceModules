# DBforPostgreSQL FlexibleServers `[Microsoft.DBforPostgreSQL/flexibleServers]`

This module deploys DBforPostgreSQL FlexibleServers.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.DBforPostgreSQL/flexibleServers` | [2022-01-20-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-01-20-preview/flexibleServers) |
| `Microsoft.DBforPostgreSQL/flexibleServers/configurations` | [2022-01-20-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-01-20-preview/flexibleServers/configurations) |
| `Microsoft.DBforPostgreSQL/flexibleServers/databases` | [2022-01-20-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-01-20-preview/flexibleServers/databases) |
| `Microsoft.DBforPostgreSQL/flexibleServers/firewallRules` | [2022-01-20-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-01-20-preview/flexibleServers/firewallRules) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**
| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `administratorLogin` | string |  | The administrator login name of a server. Can only be specified when the PostgreSQL server is being created. |
| `administratorLoginPassword` | secureString |  | The administrator login password. |
| `name` | string |  | The name of the PostgreSQL flexible server. |
| `skuName` | string |  | The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3. |
| `tier` | string | `[Burstable, GeneralPurpose, MemoryOptimized]` | The tier of the particular SKU. Tier must align with the "skuName" property. Example, tier cannot be "Burstable" if skuName is "Standard_D4s_v3". |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `availabilityZone` | string | `''` | `['', 1, 2, 3]` | Availability zone information of the server. Default will have no preference set. |
| `backupRetentionDays` | int | `7` |  | Backup retention days for the server. Default is 7 days. |
| `configurations` | _[configurations](configurations/readme.md)_ array | `[]` |  | The configurations to create in the server. |
| `createMode` | string | `'Default'` | `[Create, Default, PointInTimeRestore, Update]` | The mode to create a new PostgreSQL server. If not provided, will be set to "Default". |
| `databases` | _[databases](databases/readme.md)_ array | `[]` |  | The databases to create in the server. |
| `delegatedSubnetResourceId` | string | `''` |  | Delegated subnet arm resource ID. Used when the desired connectivity mode is "Private Access" - virtual network integration. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[PostgreSQLLogs]` | `[PostgreSQLLogs]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `False` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `firewallRules` | _[firewallRules](firewallRules/readme.md)_ array | `[]` |  | The firewall rules to create in the PostgreSQL flexible server. |
| `geoRedundantBackup` | string | `'Disabled'` | `[Disabled, Enabled]` | A value indicating whether Geo-Redundant backup is enabled on the server. Default is disabled. |
| `highAvailability` | string | `'Disabled'` | `[Disabled, SameZone, ZoneRedundant]` | The mode for high availability. Default is disabled. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `maintenanceWindow` | object | `{object}` |  | Properties for the maintenence window. If provided, "customWindow" property must exist and set to "Enabled". |
| `pointInTimeUTC` | string | `''` |  | Property required if "createMode" is set to "PointInTimeRestore". |
| `privateDnsZoneArmResourceId` | string | `''` |  | Private dns zone arm resource ID. Used when the desired connectivity mode is "Private Access" and required when "delegatedSubnetResourceId" is used. The Private DNS Zone must be lined to the Virtual Network referenced in "delegatedSubnetResourceId". |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sourceServerResourceId` | string | `''` |  | Property required if "createMode" is set to "PointInTimeRestore". |
| `storageSizeGB` | int | `32` | `[32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384]` | Max storage allowed for a server. Default is 32GB. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `version` | string | `'13'` | `[11, 12, 13, 14]` | PostgreSQL Server version. Default is 13. |


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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed PostgreSQL Flexible server. |
| `resourceGroupName` | string | The resource group of the deployed PostgreSQL Flexible server. |
| `resourceId` | string | The resource ID of the deployed PostgreSQL Flexible server. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.
   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
resource kv1 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'adp-<<namePrefix>>-az-kv-x-001'
  scope: resourceGroup('<<subscriptionId>>','validation-rg')
}

module flexibleServers './Microsoft.DBforPostgreSQL/flexibleServers/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-flexibleServers'
  params: {
    // Required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: kv1.getSecret('administratorLoginPassword')
    name: '<<namePrefix>>-az-postgresqlflexserver-min-001'
    skuName: 'Standard_B2s'
    tier: 'Burstable'
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
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "reference": {
        "keyVault": {
          "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001"
        },
        "secretName": "administratorLoginPassword"
      }
    },
    "name": {
      "value": "<<namePrefix>>-az-postgresqlflexserver-min-001"
    },
    "skuName": {
      "value": "Standard_B2s"
    },
    "tier": {
      "value": "Burstable"
    }
  }
}
```

</details>
<p>

<h3>Example 2: Private</h3>

<details>

<summary>via Bicep module</summary>

```bicep
resource kv1 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'adp-<<namePrefix>>-az-kv-x-001'
  scope: resourceGroup('<<subscriptionId>>','validation-rg')
}

module flexibleServers './Microsoft.DBforPostgreSQL/flexibleServers/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-flexibleServers'
  params: {
    // Required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: kv1.getSecret('administratorLoginPassword')
    name: '<<namePrefix>>-az-postgresqlflexserver-private-001'
    skuName: 'Standard_D2s_v3'
    tier: 'GeneralPurpose'
    // Non-required parameters
    configurations: [
      {
        name: 'log_min_messages'
        source: 'user-override'
        value: 'INFO'
      }
      {
        name: 'autovacuum_naptime'
        source: 'user-override'
        value: '80'
      }
    ]
    databases: [
      {
        charset: 'UTF8'
        collation: 'en_US.utf8'
        name: 'testdb1'
      }
      {
        name: 'testdb2'
      }
    ]
    delegatedSubnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-postgres/subnets/<<namePrefix>>-az-subnet-x-postgres'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    geoRedundantBackup: 'Enabled'
    privateDnsZoneArmResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<<namePrefix>>.postgres.database.azure.com'
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
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "reference": {
        "keyVault": {
          "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001"
        },
        "secretName": "administratorLoginPassword"
      }
    },
    "name": {
      "value": "<<namePrefix>>-az-postgresqlflexserver-private-001"
    },
    "skuName": {
      "value": "Standard_D2s_v3"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "configurations": {
      "value": [
        {
          "name": "log_min_messages",
          "source": "user-override",
          "value": "INFO"
        },
        {
          "name": "autovacuum_naptime",
          "source": "user-override",
          "value": "80"
        }
      ]
    },
    "databases": {
      "value": [
        {
          "charset": "UTF8",
          "collation": "en_US.utf8",
          "name": "testdb1"
        },
        {
          "name": "testdb2"
        }
      ]
    },
    "delegatedSubnetResourceId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-postgres/subnets/<<namePrefix>>-az-subnet-x-postgres"
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
    },
    "diagnosticEventHubName": {
      "value": "adp-<<namePrefix>>-az-evh-x-001"
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
    },
    "diagnosticStorageAccountId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
    },
    "diagnosticWorkspaceId": {
      "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
    },
    "geoRedundantBackup": {
      "value": "Enabled"
    },
    "privateDnsZoneArmResourceId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<<namePrefix>>.postgres.database.azure.com"
    }
  }
}
```

</details>
<p>

<h3>Example 3: Public</h3>

<details>

<summary>via Bicep module</summary>

```bicep
resource kv1 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'adp-<<namePrefix>>-az-kv-x-001'
  scope: resourceGroup('<<subscriptionId>>','validation-rg')
}

module flexibleServers './Microsoft.DBforPostgreSQL/flexibleServers/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-flexibleServers'
  params: {
    // Required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: kv1.getSecret('administratorLoginPassword')
    name: '<<namePrefix>>-az-postgresqlflexserver-public-001'
    skuName: 'Standard_D2s_v3'
    tier: 'GeneralPurpose'
    // Non-required parameters
    availabilityZone: '2'
    backupRetentionDays: 20
    configurations: [
      {
        name: 'log_min_messages'
        source: 'user-override'
        value: 'INFO'
      }
    ]
    databases: [
      {
        charset: 'UTF8'
        collation: 'en_US.utf8'
        name: 'testdb1'
      }
      {
        name: 'testdb2'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    firewallRules: [
      {
        endIpAddress: '0.0.0.0'
        name: 'AllowAllWindowsAzureIps'
        startIpAddress: '0.0.0.0'
      }
      {
        endIpAddress: '10.10.10.10'
        name: 'test-rule1'
        startIpAddress: '10.10.10.1'
      }
      {
        endIpAddress: '100.100.100.10'
        name: 'test-rule2'
        startIpAddress: '100.100.100.1'
      }
    ]
    geoRedundantBackup: 'Enabled'
    highAvailability: 'SameZone'
    location: 'westeurope'
    storageSizeGB: 1024
    version: '14'
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
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "reference": {
        "keyVault": {
          "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001"
        },
        "secretName": "administratorLoginPassword"
      }
    },
    "name": {
      "value": "<<namePrefix>>-az-postgresqlflexserver-public-001"
    },
    "skuName": {
      "value": "Standard_D2s_v3"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "availabilityZone": {
      "value": "2"
    },
    "backupRetentionDays": {
      "value": 20
    },
    "configurations": {
      "value": [
        {
          "name": "log_min_messages",
          "source": "user-override",
          "value": "INFO"
        }
      ]
    },
    "databases": {
      "value": [
        {
          "charset": "UTF8",
          "collation": "en_US.utf8",
          "name": "testdb1"
        },
        {
          "name": "testdb2"
        }
      ]
    },
    "diagnosticEventHubAuthorizationRuleId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
    },
    "diagnosticEventHubName": {
      "value": "adp-<<namePrefix>>-az-evh-x-001"
    },
    "diagnosticLogsRetentionInDays": {
      "value": 7
    },
    "diagnosticStorageAccountId": {
      "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
    },
    "diagnosticWorkspaceId": {
      "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001"
    },
    "firewallRules": {
      "value": [
        {
          "endIpAddress": "0.0.0.0",
          "name": "AllowAllWindowsAzureIps",
          "startIpAddress": "0.0.0.0"
        },
        {
          "endIpAddress": "10.10.10.10",
          "name": "test-rule1",
          "startIpAddress": "10.10.10.1"
        },
        {
          "endIpAddress": "100.100.100.10",
          "name": "test-rule2",
          "startIpAddress": "100.100.100.1"
        }
      ]
    },
    "geoRedundantBackup": {
      "value": "Enabled"
    },
    "highAvailability": {
      "value": "SameZone"
    },
    "location": {
      "value": "westeurope"
    },
    "storageSizeGB": {
      "value": 1024
    },
    "version": {
      "value": "14"
    }
  }
}
```

</details>
<p>
