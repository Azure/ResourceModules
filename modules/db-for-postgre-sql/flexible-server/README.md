# DBforPostgreSQL Flexible Servers `[Microsoft.DBforPostgreSQL/flexibleServers]`

> This module has already been migrated to [AVM](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res). Only the AVM version is expected to receive updates / new features. Please do not work on improving this module in [CARML](https://aka.ms/carml).

This module deploys a DBforPostgreSQL Flexible Server.

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
| `Microsoft.DBforPostgreSQL/flexibleServers` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-12-01/flexibleServers) |
| `Microsoft.DBforPostgreSQL/flexibleServers/administrators` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-12-01/flexibleServers/administrators) |
| `Microsoft.DBforPostgreSQL/flexibleServers/configurations` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-12-01/flexibleServers/configurations) |
| `Microsoft.DBforPostgreSQL/flexibleServers/databases` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-12-01/flexibleServers/databases) |
| `Microsoft.DBforPostgreSQL/flexibleServers/firewallRules` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-12-01/flexibleServers/firewallRules) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/db-for-postgre-sql.flexible-server:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Private](#example-2-private)
- [Public](#example-3-public)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br:bicep/modules/db-for-postgre-sql.flexible-server:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dfpsfsmin'
  params: {
    // Required parameters
    name: 'dfpsfsmin001'
    skuName: 'Standard_B2s'
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
      "value": "dfpsfsmin001"
    },
    "skuName": {
      "value": "Standard_B2s"
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

### Example 2: _Private_

<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br:bicep/modules/db-for-postgre-sql.flexible-server:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dfpsfspvt'
  params: {
    // Required parameters
    name: 'dfpsfspvt001'
    skuName: 'Standard_D2s_v3'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
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
    delegatedSubnetResourceId: '<delegatedSubnetResourceId>'
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
    geoRedundantBackup: 'Enabled'
    privateDnsZoneArmResourceId: '<privateDnsZoneArmResourceId>'
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
      "value": "dfpsfspvt001"
    },
    "skuName": {
      "value": "Standard_D2s_v3"
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
      "value": "<delegatedSubnetResourceId>"
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
    "geoRedundantBackup": {
      "value": "Enabled"
    },
    "privateDnsZoneArmResourceId": {
      "value": "<privateDnsZoneArmResourceId>"
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

### Example 3: _Public_

<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br:bicep/modules/db-for-postgre-sql.flexible-server:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-dfpsfsp'
  params: {
    // Required parameters
    name: 'dfpsfsp001'
    skuName: 'Standard_D2s_v3'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administrators: [
      {
        objectId: '<objectId>'
        principalName: '<principalName>'
        principalType: 'ServicePrincipal'
      }
    ]
    availabilityZone: '1'
    backupRetentionDays: 20
    configurations: [
      {
        name: 'log_min_messages'
        source: 'user-override'
        value: 'INFO'
      }
    ]
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
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
    geoRedundantBackup: 'Disabled'
    highAvailability: 'SameZone'
    location: '<location>'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    storageSizeGB: 1024
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
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
    "name": {
      "value": "dfpsfsp001"
    },
    "skuName": {
      "value": "Standard_D2s_v3"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "administrators": {
      "value": [
        {
          "objectId": "<objectId>",
          "principalName": "<principalName>",
          "principalType": "ServicePrincipal"
        }
      ]
    },
    "availabilityZone": {
      "value": "1"
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
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
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
      "value": "Disabled"
    },
    "highAvailability": {
      "value": "SameZone"
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "storageSizeGB": {
      "value": 1024
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "version": {
      "value": "14"
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
| [`name`](#parameter-name) | string | The name of the PostgreSQL flexible server. |
| [`skuName`](#parameter-skuname) | string | The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3. |
| [`tier`](#parameter-tier) | string | The tier of the particular SKU. Tier must align with the "skuName" property. Example, tier cannot be "Burstable" if skuName is "Standard_D4s_v3". |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. Required if 'cMKKeyName' is not empty. |
| [`pointInTimeUTC`](#parameter-pointintimeutc) | string | Required if "createMode" is set to "PointInTimeRestore". |
| [`sourceServerResourceId`](#parameter-sourceserverresourceid) | string | Required if "createMode" is set to "PointInTimeRestore". |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`activeDirectoryAuth`](#parameter-activedirectoryauth) | string | If Enabled, Azure Active Directory authentication is enabled. |
| [`administratorLogin`](#parameter-administratorlogin) | string | The administrator login name of a server. Can only be specified when the PostgreSQL server is being created. |
| [`administratorLoginPassword`](#parameter-administratorloginpassword) | securestring | The administrator login password. |
| [`administrators`](#parameter-administrators) | array | The Azure AD administrators when AAD authentication enabled. |
| [`availabilityZone`](#parameter-availabilityzone) | string | Availability zone information of the server. Default will have no preference set. |
| [`backupRetentionDays`](#parameter-backupretentiondays) | int | Backup retention days for the server. |
| [`configurations`](#parameter-configurations) | array | The configurations to create in the server. |
| [`createMode`](#parameter-createmode) | string | The mode to create a new PostgreSQL server. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`databases`](#parameter-databases) | array | The databases to create in the server. |
| [`delegatedSubnetResourceId`](#parameter-delegatedsubnetresourceid) | string | Delegated subnet arm resource ID. Used when the desired connectivity mode is "Private Access" - virtual network integration. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`firewallRules`](#parameter-firewallrules) | array | The firewall rules to create in the PostgreSQL flexible server. |
| [`geoRedundantBackup`](#parameter-georedundantbackup) | string | A value indicating whether Geo-Redundant backup is enabled on the server. Should be left disabled if 'cMKKeyName' is not empty. |
| [`highAvailability`](#parameter-highavailability) | string | The mode for high availability. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maintenanceWindow`](#parameter-maintenancewindow) | object | Properties for the maintenence window. If provided, "customWindow" property must exist and set to "Enabled". |
| [`passwordAuth`](#parameter-passwordauth) | string | If Enabled, password authentication is enabled. |
| [`privateDnsZoneArmResourceId`](#parameter-privatednszonearmresourceid) | string | Private dns zone arm resource ID. Used when the desired connectivity mode is "Private Access" and required when "delegatedSubnetResourceId" is used. The Private DNS Zone must be lined to the Virtual Network referenced in "delegatedSubnetResourceId". |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`storageSizeGB`](#parameter-storagesizegb) | int | Max storage allowed for a server. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`tenantId`](#parameter-tenantid) | string | Tenant id of the server. |
| [`version`](#parameter-version) | string | PostgreSQL Server version. |

### Parameter: `name`

The name of the PostgreSQL flexible server.

- Required: Yes
- Type: string

### Parameter: `skuName`

The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3.

- Required: Yes
- Type: string

### Parameter: `tier`

The tier of the particular SKU. Tier must align with the "skuName" property. Example, tier cannot be "Burstable" if skuName is "Standard_D4s_v3".

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Burstable'
    'GeneralPurpose'
    'MemoryOptimized'
  ]
  ```

### Parameter: `managedIdentities`

The managed identity definition for this resource. Required if 'cMKKeyName' is not empty.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

- Required: Yes
- Type: array

### Parameter: `pointInTimeUTC`

Required if "createMode" is set to "PointInTimeRestore".

- Required: No
- Type: string
- Default: `''`

### Parameter: `sourceServerResourceId`

Required if "createMode" is set to "PointInTimeRestore".

- Required: No
- Type: string
- Default: `''`

### Parameter: `activeDirectoryAuth`

If Enabled, Azure Active Directory authentication is enabled.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `administratorLogin`

The administrator login name of a server. Can only be specified when the PostgreSQL server is being created.

- Required: No
- Type: string
- Default: `''`

### Parameter: `administratorLoginPassword`

The administrator login password.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `administrators`

The Azure AD administrators when AAD authentication enabled.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `availabilityZone`

Availability zone information of the server. Default will have no preference set.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    '1'
    '2'
    '3'
  ]
  ```

### Parameter: `backupRetentionDays`

Backup retention days for the server.

- Required: No
- Type: int
- Default: `7`

### Parameter: `configurations`

The configurations to create in the server.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `createMode`

The mode to create a new PostgreSQL server.

- Required: No
- Type: string
- Default: `'Default'`
- Allowed:
  ```Bicep
  [
    'Create'
    'Default'
    'PointInTimeRestore'
    'Update'
  ]
  ```

### Parameter: `customerManagedKey`

The customer managed key definition.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-customermanagedkeykeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-customermanagedkeykeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using 'latest'. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, using 'latest'.

- Required: No
- Type: string

### Parameter: `databases`

The databases to create in the server.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `delegatedSubnetResourceId`

Delegated subnet arm resource ID. Used when the desired connectivity mode is "Private Access" - virtual network integration.

- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

### Parameter: `diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `firewallRules`

The firewall rules to create in the PostgreSQL flexible server.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `geoRedundantBackup`

A value indicating whether Geo-Redundant backup is enabled on the server. Should be left disabled if 'cMKKeyName' is not empty.

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

### Parameter: `highAvailability`

The mode for high availability.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'SameZone'
    'ZoneRedundant'
  ]
  ```

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `maintenanceWindow`

Properties for the maintenence window. If provided, "customWindow" property must exist and set to "Enabled".

- Required: No
- Type: object
- Default: `{}`

### Parameter: `passwordAuth`

If Enabled, password authentication is enabled.

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

### Parameter: `privateDnsZoneArmResourceId`

Private dns zone arm resource ID. Used when the desired connectivity mode is "Private Access" and required when "delegatedSubnetResourceId" is used. The Private DNS Zone must be lined to the Virtual Network referenced in "delegatedSubnetResourceId".

- Required: No
- Type: string
- Default: `''`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `storageSizeGB`

Max storage allowed for a server.

- Required: No
- Type: int
- Default: `32`
- Allowed:
  ```Bicep
  [
    32
    64
    128
    256
    512
    1024
    2048
    4096
    8192
    16384
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `tenantId`

Tenant id of the server.

- Required: No
- Type: string
- Default: `''`

### Parameter: `version`

PostgreSQL Server version.

- Required: No
- Type: string
- Default: `'15'`
- Allowed:
  ```Bicep
  [
    '11'
    '12'
    '13'
    '14'
    '15'
  ]
  ```


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed PostgreSQL Flexible server. |
| `resourceGroupName` | string | The resource group of the deployed PostgreSQL Flexible server. |
| `resourceId` | string | The resource ID of the deployed PostgreSQL Flexible server. |

## Cross-referenced modules

_None_
