# SQL Managed Instances `[Microsoft.Sql/managedInstances]`

This module deploys a SQL Managed Instance.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Sql/managedInstances` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances) |
| `Microsoft.Sql/managedInstances/administrators` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances/administrators) |
| `Microsoft.Sql/managedInstances/databases` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances/databases) |
| `Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances/databases/backupLongTermRetentionPolicies) |
| `Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances/databases/backupShortTermRetentionPolicies) |
| `Microsoft.Sql/managedInstances/encryptionProtector` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances/encryptionProtector) |
| `Microsoft.Sql/managedInstances/keys` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances/keys) |
| `Microsoft.Sql/managedInstances/securityAlertPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances/securityAlertPolicies) |
| `Microsoft.Sql/managedInstances/vulnerabilityAssessments` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances/vulnerabilityAssessments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/sql.managed-instance:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [Vulnassm](#example-3-vulnassm)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module managedInstance 'br:bicep/modules/sql.managed-instance:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-sqlmimin'
  params: {
    // Required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    name: 'sqlmimin'
    subnetId: '<subnetId>'
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
      "value": "sqlmimin"
    },
    "subnetId": {
      "value": "<subnetId>"
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

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module managedInstance 'br:bicep/modules/sql.managed-instance:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-sqlmimax'
  params: {
    // Required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    name: 'sqlmimax'
    subnetId: '<subnetId>'
    // Non-required parameters
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    databases: [
      {
        backupLongTermRetentionPolicies: {
          name: 'default'
        }
        backupShortTermRetentionPolicies: {
          name: 'default'
        }
        diagnosticSettings: [
          {
            eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
            eventHubName: '<eventHubName>'
            name: 'customSetting'
            storageAccountResourceId: '<storageAccountResourceId>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
        name: 'sqlmimax-db-001'
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
    dnsZonePartner: ''
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    encryptionProtectorObj: {
      serverKeyName: '<serverKeyName>'
      serverKeyType: 'AzureKeyVault'
    }
    hardwareFamily: 'Gen5'
    keys: [
      {
        name: '<name>'
        serverKeyType: 'AzureKeyVault'
        uri: '<uri>'
      }
    ]
    licenseType: 'LicenseIncluded'
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
    primaryUserAssignedIdentityId: '<primaryUserAssignedIdentityId>'
    proxyOverride: 'Proxy'
    publicDataEndpointEnabled: false
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    securityAlertPoliciesObj: {
      emailAccountAdmins: true
      name: 'default'
      state: 'Enabled'
    }
    servicePrincipal: 'SystemAssigned'
    skuName: 'GP_Gen5'
    skuTier: 'GeneralPurpose'
    storageSizeInGB: 32
    timezoneId: 'UTC'
    vCores: 4
    vulnerabilityAssessmentsObj: {
      emailSubscriptionAdmins: true
      name: 'default'
      recurringScansEmails: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      recurringScansIsEnabled: true
      storageAccountResourceId: '<storageAccountResourceId>'
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
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
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "name": {
      "value": "sqlmimax"
    },
    "subnetId": {
      "value": "<subnetId>"
    },
    "collation": {
      "value": "SQL_Latin1_General_CP1_CI_AS"
    },
    "databases": {
      "value": [
        {
          "backupLongTermRetentionPolicies": {
            "name": "default"
          },
          "backupShortTermRetentionPolicies": {
            "name": "default"
          },
          "diagnosticSettings": [
            {
              "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
              "eventHubName": "<eventHubName>",
              "name": "customSetting",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ],
          "name": "sqlmimax-db-001"
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
    "dnsZonePartner": {
      "value": ""
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "encryptionProtectorObj": {
      "value": {
        "serverKeyName": "<serverKeyName>",
        "serverKeyType": "AzureKeyVault"
      }
    },
    "hardwareFamily": {
      "value": "Gen5"
    },
    "keys": {
      "value": [
        {
          "name": "<name>",
          "serverKeyType": "AzureKeyVault",
          "uri": "<uri>"
        }
      ]
    },
    "licenseType": {
      "value": "LicenseIncluded"
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
    "primaryUserAssignedIdentityId": {
      "value": "<primaryUserAssignedIdentityId>"
    },
    "proxyOverride": {
      "value": "Proxy"
    },
    "publicDataEndpointEnabled": {
      "value": false
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
    "securityAlertPoliciesObj": {
      "value": {
        "emailAccountAdmins": true,
        "name": "default",
        "state": "Enabled"
      }
    },
    "servicePrincipal": {
      "value": "SystemAssigned"
    },
    "skuName": {
      "value": "GP_Gen5"
    },
    "skuTier": {
      "value": "GeneralPurpose"
    },
    "storageSizeInGB": {
      "value": 32
    },
    "timezoneId": {
      "value": "UTC"
    },
    "vCores": {
      "value": 4
    },
    "vulnerabilityAssessmentsObj": {
      "value": {
        "emailSubscriptionAdmins": true,
        "name": "default",
        "recurringScansEmails": [
          "test1@contoso.com",
          "test2@contoso.com"
        ],
        "recurringScansIsEnabled": true,
        "storageAccountResourceId": "<storageAccountResourceId>",
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    }
  }
}
```

</details>
<p>

### Example 3: _Vulnassm_

<details>

<summary>via Bicep module</summary>

```bicep
module managedInstance 'br:bicep/modules/sql.managed-instance:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-sqlmivln'
  params: {
    // Required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    name: 'sqlmivln'
    subnetId: '<subnetId>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    managedIdentities: {
      systemAssigned: true
    }
    securityAlertPoliciesObj: {
      emailAccountAdmins: true
      name: 'default'
      state: 'Enabled'
    }
    vulnerabilityAssessmentsObj: {
      createStorageRoleAssignment: true
      emailSubscriptionAdmins: true
      name: 'default'
      recurringScansEmails: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      recurringScansIsEnabled: true
      storageAccountResourceId: '<storageAccountResourceId>'
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
      useStorageAccountAccessKey: false
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
      "value": "sqlmivln"
    },
    "subnetId": {
      "value": "<subnetId>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "securityAlertPoliciesObj": {
      "value": {
        "emailAccountAdmins": true,
        "name": "default",
        "state": "Enabled"
      }
    },
    "vulnerabilityAssessmentsObj": {
      "value": {
        "createStorageRoleAssignment": true,
        "emailSubscriptionAdmins": true,
        "name": "default",
        "recurringScansEmails": [
          "test1@contoso.com",
          "test2@contoso.com"
        ],
        "recurringScansIsEnabled": true,
        "storageAccountResourceId": "<storageAccountResourceId>",
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        },
        "useStorageAccountAccessKey": false
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
module managedInstance 'br:bicep/modules/sql.managed-instance:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-sqlmiwaf'
  params: {
    // Required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    name: 'sqlmiwaf'
    subnetId: '<subnetId>'
    // Non-required parameters
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    databases: [
      {
        backupLongTermRetentionPolicies: {
          name: 'default'
        }
        backupShortTermRetentionPolicies: {
          name: 'default'
        }
        diagnosticSettings: [
          {
            eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
            eventHubName: '<eventHubName>'
            name: 'customSetting'
            storageAccountResourceId: '<storageAccountResourceId>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
        name: 'sqlmiwaf-db-001'
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
    dnsZonePartner: ''
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    encryptionProtectorObj: {
      serverKeyName: '<serverKeyName>'
      serverKeyType: 'AzureKeyVault'
    }
    hardwareFamily: 'Gen5'
    keys: [
      {
        name: '<name>'
        serverKeyType: 'AzureKeyVault'
        uri: '<uri>'
      }
    ]
    licenseType: 'LicenseIncluded'
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
    primaryUserAssignedIdentityId: '<primaryUserAssignedIdentityId>'
    proxyOverride: 'Proxy'
    publicDataEndpointEnabled: false
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    securityAlertPoliciesObj: {
      emailAccountAdmins: true
      name: 'default'
      state: 'Enabled'
    }
    servicePrincipal: 'SystemAssigned'
    skuName: 'GP_Gen5'
    skuTier: 'GeneralPurpose'
    storageSizeInGB: 32
    timezoneId: 'UTC'
    vCores: 4
    vulnerabilityAssessmentsObj: {
      emailSubscriptionAdmins: true
      name: 'default'
      recurringScansEmails: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      recurringScansIsEnabled: true
      storageAccountResourceId: '<storageAccountResourceId>'
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
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
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "name": {
      "value": "sqlmiwaf"
    },
    "subnetId": {
      "value": "<subnetId>"
    },
    "collation": {
      "value": "SQL_Latin1_General_CP1_CI_AS"
    },
    "databases": {
      "value": [
        {
          "backupLongTermRetentionPolicies": {
            "name": "default"
          },
          "backupShortTermRetentionPolicies": {
            "name": "default"
          },
          "diagnosticSettings": [
            {
              "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
              "eventHubName": "<eventHubName>",
              "name": "customSetting",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ],
          "name": "sqlmiwaf-db-001"
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
    "dnsZonePartner": {
      "value": ""
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "encryptionProtectorObj": {
      "value": {
        "serverKeyName": "<serverKeyName>",
        "serverKeyType": "AzureKeyVault"
      }
    },
    "hardwareFamily": {
      "value": "Gen5"
    },
    "keys": {
      "value": [
        {
          "name": "<name>",
          "serverKeyType": "AzureKeyVault",
          "uri": "<uri>"
        }
      ]
    },
    "licenseType": {
      "value": "LicenseIncluded"
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
    "primaryUserAssignedIdentityId": {
      "value": "<primaryUserAssignedIdentityId>"
    },
    "proxyOverride": {
      "value": "Proxy"
    },
    "publicDataEndpointEnabled": {
      "value": false
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
    "securityAlertPoliciesObj": {
      "value": {
        "emailAccountAdmins": true,
        "name": "default",
        "state": "Enabled"
      }
    },
    "servicePrincipal": {
      "value": "SystemAssigned"
    },
    "skuName": {
      "value": "GP_Gen5"
    },
    "skuTier": {
      "value": "GeneralPurpose"
    },
    "storageSizeInGB": {
      "value": 32
    },
    "timezoneId": {
      "value": "UTC"
    },
    "vCores": {
      "value": 4
    },
    "vulnerabilityAssessmentsObj": {
      "value": {
        "emailSubscriptionAdmins": true,
        "name": "default",
        "recurringScansEmails": [
          "test1@contoso.com",
          "test2@contoso.com"
        ],
        "recurringScansIsEnabled": true,
        "storageAccountResourceId": "<storageAccountResourceId>",
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
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
| [`administratorLogin`](#parameter-administratorlogin) | string | The username used to establish jumpbox VMs. |
| [`administratorLoginPassword`](#parameter-administratorloginpassword) | securestring | The password given to the admin user. |
| [`name`](#parameter-name) | string | The name of the SQL managed instance. |
| [`subnetId`](#parameter-subnetid) | string | The fully qualified resource ID of the subnet on which the SQL managed instance will be placed. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`primaryUserAssignedIdentityId`](#parameter-primaryuserassignedidentityid) | string | The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`administratorsObj`](#parameter-administratorsobj) | object | The administrator configuration. |
| [`collation`](#parameter-collation) | string | Collation of the managed instance. |
| [`databases`](#parameter-databases) | array | Databases to create in this server. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`dnsZonePartner`](#parameter-dnszonepartner) | string | The resource ID of another managed instance whose DNS zone this managed instance will share after creation. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`encryptionProtectorObj`](#parameter-encryptionprotectorobj) | object | The encryption protection configuration. |
| [`hardwareFamily`](#parameter-hardwarefamily) | string | If the service has different generations of hardware, for the same SKU, then that can be captured here. |
| [`instancePoolResourceId`](#parameter-instancepoolresourceid) | string | The resource ID of the instance pool this managed server belongs to. |
| [`keys`](#parameter-keys) | array | The keys to configure. |
| [`licenseType`](#parameter-licensetype) | string | The license type. Possible values are 'LicenseIncluded' (regular price inclusive of a new SQL license) and 'BasePrice' (discounted AHB price for bringing your own SQL licenses). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`managedInstanceCreateMode`](#parameter-managedinstancecreatemode) | string | Specifies the mode of database creation. Default: Regular instance creation. Restore: Creates an instance by restoring a set of backups to specific point in time. RestorePointInTime and SourceManagedInstanceId must be specified. |
| [`minimalTlsVersion`](#parameter-minimaltlsversion) | string | Minimal TLS version allowed. |
| [`proxyOverride`](#parameter-proxyoverride) | string | Connection type used for connecting to the instance. |
| [`publicDataEndpointEnabled`](#parameter-publicdataendpointenabled) | bool | Whether or not the public data endpoint is enabled. |
| [`requestedBackupStorageRedundancy`](#parameter-requestedbackupstorageredundancy) | string | The storage account type used to store backups for this database. |
| [`restorePointInTime`](#parameter-restorepointintime) | string | Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`securityAlertPoliciesObj`](#parameter-securityalertpoliciesobj) | object | The security alert policy configuration. |
| [`servicePrincipal`](#parameter-serviceprincipal) | string | Service principal type. If using AD Authentication and applying Admin, must be set to `SystemAssigned`. Then Global Admin must allow Reader access to Azure AD for the Service Principal. |
| [`skuName`](#parameter-skuname) | string | The name of the SKU, typically, a letter + Number code, e.g. P3. |
| [`skuTier`](#parameter-skutier) | string | The tier or edition of the particular SKU, e.g. Basic, Premium. |
| [`sourceManagedInstanceId`](#parameter-sourcemanagedinstanceid) | string | The resource identifier of the source managed instance associated with create operation of this instance. |
| [`storageSizeInGB`](#parameter-storagesizeingb) | int | Storage size in GB. Minimum value: 32. Maximum value: 8192. Increments of 32 GB allowed only. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`timezoneId`](#parameter-timezoneid) | string | ID of the timezone. Allowed values are timezones supported by Windows. |
| [`vCores`](#parameter-vcores) | int | The number of vCores. Allowed values: 8, 16, 24, 32, 40, 64, 80. |
| [`vulnerabilityAssessmentsObj`](#parameter-vulnerabilityassessmentsobj) | object | The vulnerability assessment configuration. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Whether or not multi-az is enabled. |

### Parameter: `administratorLogin`

The username used to establish jumpbox VMs.
- Required: Yes
- Type: string

### Parameter: `administratorLoginPassword`

The password given to the admin user.
- Required: Yes
- Type: securestring

### Parameter: `administratorsObj`

The administrator configuration.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `collation`

Collation of the managed instance.
- Required: No
- Type: string
- Default: `'SQL_Latin1_General_CP1_CI_AS'`

### Parameter: `databases`

Databases to create in this server.
- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `dnsZonePartner`

The resource ID of another managed instance whose DNS zone this managed instance will share after creation.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `encryptionProtectorObj`

The encryption protection configuration.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `hardwareFamily`

If the service has different generations of hardware, for the same SKU, then that can be captured here.
- Required: No
- Type: string
- Default: `'Gen5'`

### Parameter: `instancePoolResourceId`

The resource ID of the instance pool this managed server belongs to.
- Required: No
- Type: string
- Default: `''`

### Parameter: `keys`

The keys to configure.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `licenseType`

The license type. Possible values are 'LicenseIncluded' (regular price inclusive of a new SQL license) and 'BasePrice' (discounted AHB price for bringing your own SQL licenses).
- Required: No
- Type: string
- Default: `'LicenseIncluded'`
- Allowed:
  ```Bicep
  [
    'BasePrice'
    'LicenseIncluded'
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

### Parameter: `managedInstanceCreateMode`

Specifies the mode of database creation. Default: Regular instance creation. Restore: Creates an instance by restoring a set of backups to specific point in time. RestorePointInTime and SourceManagedInstanceId must be specified.
- Required: No
- Type: string
- Default: `'Default'`
- Allowed:
  ```Bicep
  [
    'Default'
    'PointInTimeRestore'
  ]
  ```

### Parameter: `minimalTlsVersion`

Minimal TLS version allowed.
- Required: No
- Type: string
- Default: `'1.2'`
- Allowed:
  ```Bicep
  [
    '1.0'
    '1.1'
    '1.2'
    'None'
  ]
  ```

### Parameter: `name`

The name of the SQL managed instance.
- Required: Yes
- Type: string

### Parameter: `primaryUserAssignedIdentityId`

The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty.
- Required: No
- Type: string
- Default: `''`

### Parameter: `proxyOverride`

Connection type used for connecting to the instance.
- Required: No
- Type: string
- Default: `'Proxy'`
- Allowed:
  ```Bicep
  [
    'Default'
    'Proxy'
    'Redirect'
  ]
  ```

### Parameter: `publicDataEndpointEnabled`

Whether or not the public data endpoint is enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `requestedBackupStorageRedundancy`

The storage account type used to store backups for this database.
- Required: No
- Type: string
- Default: `'Geo'`
- Allowed:
  ```Bicep
  [
    'Geo'
    'GeoZone'
    'Local'
    'Zone'
  ]
  ```

### Parameter: `restorePointInTime`

Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database.
- Required: No
- Type: string
- Default: `''`

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

### Parameter: `securityAlertPoliciesObj`

The security alert policy configuration.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `servicePrincipal`

Service principal type. If using AD Authentication and applying Admin, must be set to `SystemAssigned`. Then Global Admin must allow Reader access to Azure AD for the Service Principal.
- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'None'
    'SystemAssigned'
  ]
  ```

### Parameter: `skuName`

The name of the SKU, typically, a letter + Number code, e.g. P3.
- Required: No
- Type: string
- Default: `'GP_Gen5'`

### Parameter: `skuTier`

The tier or edition of the particular SKU, e.g. Basic, Premium.
- Required: No
- Type: string
- Default: `'GeneralPurpose'`

### Parameter: `sourceManagedInstanceId`

The resource identifier of the source managed instance associated with create operation of this instance.
- Required: No
- Type: string
- Default: `''`

### Parameter: `storageSizeInGB`

Storage size in GB. Minimum value: 32. Maximum value: 8192. Increments of 32 GB allowed only.
- Required: No
- Type: int
- Default: `32`

### Parameter: `subnetId`

The fully qualified resource ID of the subnet on which the SQL managed instance will be placed.
- Required: Yes
- Type: string

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object

### Parameter: `timezoneId`

ID of the timezone. Allowed values are timezones supported by Windows.
- Required: No
- Type: string
- Default: `'UTC'`

### Parameter: `vCores`

The number of vCores. Allowed values: 8, 16, 24, 32, 40, 64, 80.
- Required: No
- Type: int
- Default: `4`

### Parameter: `vulnerabilityAssessmentsObj`

The vulnerability assessment configuration.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `zoneRedundant`

Whether or not multi-az is enabled.
- Required: No
- Type: bool
- Default: `False`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed managed instance. |
| `resourceGroupName` | string | The resource group of the deployed managed instance. |
| `resourceId` | string | The resource ID of the deployed managed instance. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

_None_

## Notes

### Considerations

#### Networking

SQL Managed Instance is deployed on a virtual network to a subnet that is delagated to the SQL MI service. This network is required to satisfy the requirements explained [here](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/connectivity-architecture-overview?view=azuresql#network-requirements).

SQL MI requires that the subnet have a Route Table and NSG assigned to it. The SQL MI service will automatically add Routes to the Route Table and Rules to the NSG once the SQL MI has been deployed. As a result, the parameter file for the Route Table and NSG will have to be updated afterwards with the created Routes & Rules, otherwise redeployment of the Route Table & NSG via Bicep/ARM will fail.

#### Azure AD Authentication

SQL MI allows for Azure AD Authentication via an [Azure AD Admin](https://learn.microsoft.com/en-us/azure/azure-sql/database/authentication-aad-configure?tabs=azure-powershell#provision-azure-ad-admin-sql-managed-instance). This requires a Service Principal to be assigned and granted Reader rights to Azure AD by an AD Admin. To do so via this module, the `servicePrincipal` parameter must be set to `SystemAssigned` and deploy the SQL MI. Afterwards an Azure AD Admin must go to the SQL MI Azure Active Directory admin page in the Azure Portal and assigned the Reader rights. Next the `administratorsObj` must be configured in the parameter file and be redeployed.
