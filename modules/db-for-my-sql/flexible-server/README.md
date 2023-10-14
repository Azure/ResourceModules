# DBforMySQL Flexible Servers `[Microsoft.DBforMySQL/flexibleServers]`

This module deploys a DBforMySQL Flexible Server.

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
| `Microsoft.DBforMySQL/flexibleServers` | [2022-09-30-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2022-09-30-preview/flexibleServers) |
| `Microsoft.DBforMySQL/flexibleServers/administrators` | [2022-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2022-01-01/flexibleServers/administrators) |
| `Microsoft.DBforMySQL/flexibleServers/databases` | [2022-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2022-01-01/flexibleServers/databases) |
| `Microsoft.DBforMySQL/flexibleServers/firewallRules` | [2022-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2022-01-01/flexibleServers/firewallRules) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `name` | string |  | The name of the MySQL flexible server. |
| `skuName` | string |  | The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3. |
| `tier` | string | `[Burstable, GeneralPurpose, MemoryOptimized]` | The tier of the particular SKU. Tier must align with the "skuName" property. Example, tier cannot be "Burstable" if skuName is "Standard_D4s_v3". |

**Conditional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `cMKKeyVaultResourceId` | string | `''` |  | The resource ID of a key vault to reference a customer managed key for encryption from. Required if "cMKKeyName" is not empty. |
| `cMKUserAssignedIdentityResourceId` | string | `''` |  | User assigned identity to use when fetching the customer managed key. The identity should have key usage permissions on the Key Vault Key. Required if "cMKKeyName" is not empty. |
| `geoBackupCMKKeyVaultResourceId` | string | `''` |  | The resource ID of a key vault to reference a customer managed key for encryption from. Required if "cMKKeyName" is not empty and geoRedundantBackup is "Enabled". |
| `geoBackupCMKUserAssignedIdentityResourceId` | string | `''` |  | Geo backup user identity resource ID as identity cant cross region, need identity in same region as geo backup. The identity should have key usage permissions on the Key Vault Key. Required if "cMKKeyName" is not empty and geoRedundantBackup is "Enabled". |
| `privateDnsZoneResourceId` | string | `''` |  | Private dns zone arm resource ID. Used when the desired connectivity mode is "Private Access". Required if "delegatedSubnetResourceId" is used and the Private DNS Zone name must end with mysql.database.azure.com in order to be linked to the MySQL Flexible Server. |
| `restorePointInTime` | string | `''` |  | Restore point creation time (ISO8601 format), specifying the time to restore from. Required if "createMode" is set to "PointInTimeRestore". |
| `sourceServerResourceId` | string | `''` |  | The source MySQL server ID. Required if "createMode" is set to "PointInTimeRestore". |
| `storageAutoGrow` | string | `'Disabled'` | `[Disabled, Enabled]` | Enable Storage Auto Grow or not. Storage auto-growth prevents a server from running out of storage and becoming read-only. Required if "highAvailability" is not "Disabled". |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. Required if "cMKKeyName" is not empty. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `administratorLogin` | string | `''` |  | The administrator login name of a server. Can only be specified when the MySQL server is being created. |
| `administratorLoginPassword` | securestring | `''` |  | The administrator login password. |
| `administrators` | array | `[]` |  | The Azure AD administrators when AAD authentication enabled. |
| `availabilityZone` | string | `''` | `['', 1, 2, 3]` | Availability zone information of the server. Default will have no preference set. |
| `backupRetentionDays` | int | `7` |  | Backup retention days for the server. |
| `cMKKeyName` | string | `''` |  | The name of the customer managed key to use for encryption. |
| `cMKKeyVersion` | string | `''` |  | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| `createMode` | string | `'Default'` | `[Default, GeoRestore, PointInTimeRestore, Replica]` | The mode to create a new MySQL server. |
| `databases` | array | `[]` |  | The databases to create in the server. |
| `delegatedSubnetResourceId` | string | `''` |  | Delegated subnet arm resource ID. Used when the desired connectivity mode is "Private Access" - virtual network integration. Delegation must be enabled on the subnet for MySQL Flexible Servers and subnet CIDR size is /29. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `['', allLogs, MySqlAuditLogs, MySqlSlowLogs]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `firewallRules` | array | `[]` |  | The firewall rules to create in the MySQL flexible server. |
| `geoBackupCMKKeyName` | string | `''` |  | The name of the customer managed key to use for encryption when geoRedundantBackup is "Enabled". |
| `geoBackupCMKKeyVersion` | string | `''` |  | The version of the customer managed key to reference for encryption when geoRedundantBackup is "Enabled". If not provided, the latest key version is used. |
| `geoRedundantBackup` | string | `'Disabled'` | `[Disabled, Enabled]` | A value indicating whether Geo-Redundant backup is enabled on the server. If "Enabled" and "cMKKeyName" is not empty, then "geoBackupCMKKeyVaultResourceId" and "cMKUserAssignedIdentityResourceId" are also required. |
| `highAvailability` | string | `'Disabled'` | `[Disabled, SameZone, ZoneRedundant]` | The mode for High Availability (HA). It is not supported for the Burstable pricing tier and Zone redundant HA can only be set during server provisioning. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `maintenanceWindow` | object | `{object}` |  | Properties for the maintenence window. If provided, "customWindow" property must exist and set to "Enabled". |
| `replicationRole` | string | `'None'` | `[None, Replica, Source]` | The replication role. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11". |
| `storageAutoIoScaling` | string | `'Disabled'` | `[Disabled, Enabled]` | Enable IO Auto Scaling or not. The server scales IOPs up or down automatically depending on your workload needs. |
| `storageIOPS` | int | `1000` |  | Storage IOPS for a server. Max IOPS are determined by compute size. |
| `storageSizeGB` | int | `64` | `[20, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384]` | Max storage allowed for a server. In all compute tiers, the minimum storage supported is 20 GiB and maximum is 16 TiB. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `version` | string | `'5.7'` | `[5.7, 8.0.21]` | MySQL Server version. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed MySQL Flexible server. |
| `resourceGroupName` | string | The resource group of the deployed MySQL Flexible server. |
| `resourceId` | string | The resource ID of the deployed MySQL Flexible server. |

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
module flexibleServer './db-for-my-sql/flexible-server/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dfmsfsmin'
  params: {
    // Required parameters
    name: 'dfmsfsmin001'
    skuName: 'Standard_B1ms'
    tier: 'Burstable'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
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
      "value": "dfmsfsmin001"
    },
    "skuName": {
      "value": "Standard_B1ms"
    },
    "tier": {
      "value": "Burstable"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
module flexibleServer './db-for-my-sql/flexible-server/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dfmsfspvt'
  params: {
    // Required parameters
    name: 'dfmsfspvt001'
    skuName: 'Standard_D2ds_v4'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    administrators: [
      {
        identityResourceId: '<identityResourceId>'
        login: '<login>'
        sid: '<sid>'
      }
    ]
    backupRetentionDays: 10
    databases: [
      {
        name: 'testdb1'
      }
    ]
    delegatedSubnetResourceId: '<delegatedSubnetResourceId>'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    highAvailability: 'SameZone'
    location: '<location>'
    lock: 'CanNotDelete'
    privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
    roleAssignments: [
      {
        principalIds: [
          '<managedIdentityPrincipalId>'
        ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    storageAutoGrow: 'Enabled'
    storageAutoIoScaling: 'Enabled'
    storageIOPS: 400
    storageSizeGB: 64
    tags: {
      'hidden-title': 'This is visible in the resource name'
      resourceType: 'MySQL Flexible Server'
      serverName: 'dfmsfspvt001'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
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
      "value": "dfmsfspvt001"
    },
    "skuName": {
      "value": "Standard_D2ds_v4"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "administrators": {
      "value": [
        {
          "identityResourceId": "<identityResourceId>",
          "login": "<login>",
          "sid": "<sid>"
        }
      ]
    },
    "backupRetentionDays": {
      "value": 10
    },
    "databases": {
      "value": [
        {
          "name": "testdb1"
        }
      ]
    },
    "delegatedSubnetResourceId": {
      "value": "<delegatedSubnetResourceId>"
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
    "highAvailability": {
      "value": "SameZone"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "privateDnsZoneResourceId": {
      "value": "<privateDnsZoneResourceId>"
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
    "storageAutoGrow": {
      "value": "Enabled"
    },
    "storageAutoIoScaling": {
      "value": "Enabled"
    },
    "storageIOPS": {
      "value": 400
    },
    "storageSizeGB": {
      "value": 64
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "resourceType": "MySQL Flexible Server",
        "serverName": "dfmsfspvt001"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
      }
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
module flexibleServer './db-for-my-sql/flexible-server/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dfmsfsp'
  params: {
    // Required parameters
    name: 'dfmsfsp001'
    skuName: 'Standard_D2ds_v4'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    availabilityZone: '1'
    backupRetentionDays: 20
    cMKKeyName: '<cMKKeyName>'
    cMKKeyVaultResourceId: '<cMKKeyVaultResourceId>'
    cMKUserAssignedIdentityResourceId: '<cMKUserAssignedIdentityResourceId>'
    databases: [
      {
        name: 'testdb1'
      }
      {
        charset: 'ascii'
        collation: 'ascii_general_ci'
        name: 'testdb2'
      }
    ]
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    geoBackupCMKKeyName: '<geoBackupCMKKeyName>'
    geoBackupCMKKeyVaultResourceId: '<geoBackupCMKKeyVaultResourceId>'
    geoBackupCMKUserAssignedIdentityResourceId: '<geoBackupCMKUserAssignedIdentityResourceId>'
    geoRedundantBackup: 'Enabled'
    highAvailability: 'SameZone'
    location: '<location>'
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
    storageAutoGrow: 'Enabled'
    storageAutoIoScaling: 'Enabled'
    storageIOPS: 400
    storageSizeGB: 32
    tags: {
      'hidden-title': 'This is visible in the resource name'
      resourceType: 'MySQL Flexible Server'
      serverName: 'dfmsfsp001'
    }
    userAssignedIdentities: {
      '<geoBackupManagedIdentityResourceId>': {}
      '<managedIdentityResourceId>': {}
    }
    version: '8.0.21'
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
      "value": "dfmsfsp001"
    },
    "skuName": {
      "value": "Standard_D2ds_v4"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "availabilityZone": {
      "value": "1"
    },
    "backupRetentionDays": {
      "value": 20
    },
    "cMKKeyName": {
      "value": "<cMKKeyName>"
    },
    "cMKKeyVaultResourceId": {
      "value": "<cMKKeyVaultResourceId>"
    },
    "cMKUserAssignedIdentityResourceId": {
      "value": "<cMKUserAssignedIdentityResourceId>"
    },
    "databases": {
      "value": [
        {
          "name": "testdb1"
        },
        {
          "charset": "ascii",
          "collation": "ascii_general_ci",
          "name": "testdb2"
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
    "geoBackupCMKKeyName": {
      "value": "<geoBackupCMKKeyName>"
    },
    "geoBackupCMKKeyVaultResourceId": {
      "value": "<geoBackupCMKKeyVaultResourceId>"
    },
    "geoBackupCMKUserAssignedIdentityResourceId": {
      "value": "<geoBackupCMKUserAssignedIdentityResourceId>"
    },
    "geoRedundantBackup": {
      "value": "Enabled"
    },
    "highAvailability": {
      "value": "SameZone"
    },
    "location": {
      "value": "<location>"
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
    "storageAutoGrow": {
      "value": "Enabled"
    },
    "storageAutoIoScaling": {
      "value": "Enabled"
    },
    "storageIOPS": {
      "value": 400
    },
    "storageSizeGB": {
      "value": 32
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "resourceType": "MySQL Flexible Server",
        "serverName": "dfmsfsp001"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<geoBackupManagedIdentityResourceId>": {},
        "<managedIdentityResourceId>": {}
      }
    },
    "version": {
      "value": "8.0.21"
    }
  }
}
```

</details>
<p>
