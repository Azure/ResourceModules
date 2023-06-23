# DBforPostgreSQL Flexible Servers `[Microsoft.DBforPostgreSQL/flexibleServers]`

This module deploys a DBforPostgreSQL Flexible Server.

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
| `Microsoft.DBforPostgreSQL/flexibleServers` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-12-01/flexibleServers) |
| `Microsoft.DBforPostgreSQL/flexibleServers/configurations` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-12-01/flexibleServers/configurations) |
| `Microsoft.DBforPostgreSQL/flexibleServers/databases` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-12-01/flexibleServers/databases) |
| `Microsoft.DBforPostgreSQL/flexibleServers/firewallRules` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-12-01/flexibleServers/firewallRules) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `administratorLogin` | string |  | The administrator login name of a server. Can only be specified when the PostgreSQL server is being created. |
| `administratorLoginPassword` | securestring |  | The administrator login password. |
| `name` | string |  | The name of the PostgreSQL flexible server. |
| `skuName` | string |  | The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3. |
| `tier` | string | `[Burstable, GeneralPurpose, MemoryOptimized]` | The tier of the particular SKU. Tier must align with the "skuName" property. Example, tier cannot be "Burstable" if skuName is "Standard_D4s_v3". |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `cMKKeyVaultResourceId` | string | `''` | The resource ID of a key vault to reference a customer managed key for encryption from. Required if 'cMKKeyName' is not empty. |
| `cMKUserAssignedIdentityResourceId` | string | `''` | User assigned identity to use when fetching the customer managed key. The identity should have key usage permissions on the Key Vault Key. Required if 'cMKKeyName' is not empty. |
| `pointInTimeUTC` | string | `''` | Required if "createMode" is set to "PointInTimeRestore". |
| `sourceServerResourceId` | string | `''` | Required if "createMode" is set to "PointInTimeRestore". |
| `userAssignedIdentities` | object | `{object}` | The ID(s) to assign to the resource. Required if 'cMKKeyName' is not empty. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `availabilityZone` | string | `''` | `['', 1, 2, 3]` | Availability zone information of the server. Default will have no preference set. |
| `backupRetentionDays` | int | `7` |  | Backup retention days for the server. |
| `cMKKeyName` | string | `''` |  | The name of the customer managed key to use for encryption. |
| `cMKKeyVersion` | string | `''` |  | The version of the customer managed key to reference for encryption. If not provided, the latest key version is used. |
| `configurations` | _[configurations](configurations/README.md)_ array | `[]` |  | The configurations to create in the server. |
| `createMode` | string | `'Default'` | `[Create, Default, PointInTimeRestore, Update]` | The mode to create a new PostgreSQL server. |
| `databases` | _[databases](databases/README.md)_ array | `[]` |  | The databases to create in the server. |
| `delegatedSubnetResourceId` | string | `''` |  | Delegated subnet arm resource ID. Used when the desired connectivity mode is "Private Access" - virtual network integration. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[allLogs]` | `[allLogs, PostgreSQLFlexDatabaseXacts, PostgreSQLFlexQueryStoreRuntime, PostgreSQLFlexQueryStoreWaitStats, PostgreSQLFlexSessions, PostgreSQLFlexTableStats, PostgreSQLLogs]` | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `''` |  | The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings". |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `firewallRules` | _[firewallRules](firewall-rules/README.md)_ array | `[]` |  | The firewall rules to create in the PostgreSQL flexible server. |
| `geoRedundantBackup` | string | `'Disabled'` | `[Disabled, Enabled]` | A value indicating whether Geo-Redundant backup is enabled on the server. Should be left disabled if 'cMKKeyName' is not empty. |
| `highAvailability` | string | `'Disabled'` | `[Disabled, SameZone, ZoneRedundant]` | The mode for high availability. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `maintenanceWindow` | object | `{object}` |  | Properties for the maintenence window. If provided, "customWindow" property must exist and set to "Enabled". |
| `privateDnsZoneArmResourceId` | string | `''` |  | Private dns zone arm resource ID. Used when the desired connectivity mode is "Private Access" and required when "delegatedSubnetResourceId" is used. The Private DNS Zone must be lined to the Virtual Network referenced in "delegatedSubnetResourceId". |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `storageSizeGB` | int | `32` | `[32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384]` | Max storage allowed for a server. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `version` | string | `'13'` | `[11, 12, 13, 14]` | PostgreSQL Server version. |


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

### Parameter Usage: `firewallRules`

To enable firewall rules on the PostgreSQL flexible server:

- Used when the desired connectivity mode is "Public Access" only.

<details>

<summary>Parameter JSON format</summary>

```json
"firewallRules": {
    // Example showing all available fields
    "value": [
        {
            "name": "AllowAllWindowsAzureIps", //Use this rule to allow Trusted Azure services to access the server
            "endIpAddress": "0.0.0.0",
            "startIpAddress": "0.0.0.0"
        },
        {
            "name": "test-rule1",
            "startIpAddress": "10.10.10.1", //Start IP address for the firewall rule. Must be IPv4 format
            "endIpAddress": "10.10.10.10" //End IP address for the firewall rule. Must be IPv4 format
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
firewallRules:  [
    // Example showing all available fields
  {
      name: 'AllowAllWindowsAzureIps', //Use this rule to allow Trusted Azure services to access the server
      endIpAddress: '0.0.0.0'
      startIpAddress: '0.0.0.0'
  }
  {
      name: "test-rule1",
      startIpAddress: '10.10.10.1' //Start IP address for the firewall rule. Must be IPv4 format
      endIpAddress: '10.10.10.10' //End IP address for the firewall rule. Must be IPv4 format
  }
]
```

</details>
<p>

### Parameter Usage: `configurations`

To override default server configurations on the PostgreSQL flexible server:

- Use the following documentation as guidance for the available configurations: [PostgreSQL Server Configurations](https://learn.microsoft.com/en-us/azure/postgresql/single-server/how-to-configure-server-parameters-using-cli).

<details>

<summary>Parameter JSON format</summary>

```json
"configurations": {
  // Example showing all available fields
  "value": [
      {
          "name": "log_min_messages", // Name of the configuration
          "source": "user-override", // user-override, dynamic, system-default
          "value": "INFO" // Value of the configuration
      }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
configurations:  [
    // Example showing all available fields
      {
          name: 'log_min_messages' // Name of the configuration
          source: 'user-override' // user-override, dynamic, system-default
          value: 'INFO' // Value of the configuration
      }
]
```

</details>
<p>

### Parameter Usage: `databases`

To create databases on the PostgreSQL flexible server:

<details>

<summary>Parameter JSON format</summary>

```json
"databases": {
  // Example showing all available fields
  "value": [
      {
          "name": "testdb1", // Name of the database
          "collation": "en_US.utf8", // Collation of the database
          "charset": "UTF8" // Character set of the database
      },
      {
          "name": "testdb2" // Name of the database only which implements the default collation and charset
      }
  ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
databases:  [
    // Example showing all available fields
      {
          name: 'testdb1' // Name of the database
          collation: 'en_US.utf8' // Collation of the database
          charset: 'UTF8' // Character set of the database
      }
      {
          name: 'testdb2' // Name of the database only which implements the default collation and charset
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
module flexibleServers './db-for-postgre-sql/flexible-servers/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dfpsfsmin'
  params: {
    // Required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    name: '<<namePrefix>>dfpsfsmin001'
    skuName: 'Standard_B2s'
    tier: 'Burstable'
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
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "name": {
      "value": "<<namePrefix>>dfpsfsmin001"
    },
    "skuName": {
      "value": "Standard_B2s"
    },
    "tier": {
      "value": "Burstable"
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

<h3>Example 2: Private</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServers './db-for-postgre-sql/flexible-servers/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dfpsfspvt'
  params: {
    // Required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    name: '<<namePrefix>>dfpsfspvt001'
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
    delegatedSubnetResourceId: '<delegatedSubnetResourceId>'
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '<diagnosticStorageAccountId>'
    diagnosticWorkspaceId: '<diagnosticWorkspaceId>'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    geoRedundantBackup: 'Enabled'
    privateDnsZoneArmResourceId: '<privateDnsZoneArmResourceId>'
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
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "name": {
      "value": "<<namePrefix>>dfpsfspvt001"
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
      "value": "<delegatedSubnetResourceId>"
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
    "geoRedundantBackup": {
      "value": "Enabled"
    },
    "privateDnsZoneArmResourceId": {
      "value": "<privateDnsZoneArmResourceId>"
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

<h3>Example 3: Public</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServers './db-for-postgre-sql/flexible-servers/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-dfpsfsp'
  params: {
    // Required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    name: '<<namePrefix>>dfpsfsp001'
    skuName: 'Standard_D2s_v3'
    tier: 'GeneralPurpose'
    // Non-required parameters
    availabilityZone: '1'
    backupRetentionDays: 20
    cMKKeyName: '<cMKKeyName>'
    cMKKeyVaultResourceId: '<cMKKeyVaultResourceId>'
    cMKUserAssignedIdentityResourceId: '<cMKUserAssignedIdentityResourceId>'
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
    diagnosticEventHubAuthorizationRuleId: '<diagnosticEventHubAuthorizationRuleId>'
    diagnosticEventHubName: '<diagnosticEventHubName>'
    diagnosticLogsRetentionInDays: 7
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
    geoRedundantBackup: 'Disabled'
    highAvailability: 'SameZone'
    location: '<location>'
    storageSizeGB: 1024
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    userAssignedIdentities: {
      '<managedIdentityResourceId>': {}
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
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "name": {
      "value": "<<namePrefix>>dfpsfsp001"
    },
    "skuName": {
      "value": "Standard_D2s_v3"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
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
    "storageSizeGB": {
      "value": 1024
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    },
    "userAssignedIdentities": {
      "value": {
        "<managedIdentityResourceId>": {}
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
