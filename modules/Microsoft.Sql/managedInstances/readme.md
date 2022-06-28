# SQL Managed Instances `[Microsoft.Sql/managedInstances]`

This template deploys a SQL managed instance.

## Navigation

- [Resource types](#Resource-types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Sql/managedInstances` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/managedInstances) |
| `Microsoft.Sql/managedInstances/administrators` | [2021-02-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/managedInstances/administrators) |
| `Microsoft.Sql/managedInstances/databases` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/managedInstances/databases) |
| `Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies` | [2021-02-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/managedInstances/databases/backupLongTermRetentionPolicies) |
| `Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies` | [2017-03-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2017-03-01-preview/managedInstances/databases/backupShortTermRetentionPolicies) |
| `Microsoft.Sql/managedInstances/encryptionProtector` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/managedInstances/encryptionProtector) |
| `Microsoft.Sql/managedInstances/keys` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/managedInstances/keys) |
| `Microsoft.Sql/managedInstances/securityAlertPolicies` | [2017-03-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2017-03-01-preview/managedInstances/securityAlertPolicies) |
| `Microsoft.Sql/managedInstances/vulnerabilityAssessments` | [2021-02-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/managedInstances/vulnerabilityAssessments) |

### Deployment prerequisites

#### Networking

SQL Managed Instance is deployed on a virtual network to a subnet that is delagated to the SQL MI service. This network is required to satisfy the requirements explained [here](https://docs.microsoft.com/en-us/azure/azure-sql/managed-instance/connectivity-architecture-overview?view=azuresql#network-requirements).

SQL MI requires that the subnet have a Route Table and NSG assigned to it. The SQL MI service will automatically add Routes to the Route Table and Rules to the NSG once the SQL MI has been deployed. As a result, the parameter file for the Route Table and NSG will have to be updated afterwards with the created Routes & Rules, otherwise redeployment of the Route Table & NSG via Bicep/ARM will fail.

#### Azure AD Authentication

SQL MI allows for Azure AD Authentication via an [Azure AD Admin](https://docs.microsoft.com/en-us/azure/azure-sql/database/authentication-aad-configure?tabs=azure-powershell#provision-azure-ad-admin-sql-managed-instance). This requires a Service Principal to be assigned and granted Reader rights to Azure AD by an AD Admin. To do so via this module, the `servicePrincipal` parameter must be set to `SystemAssigned` and deploy the SQL MI. Afterwards an Azure AD Admin must go to the SQL MI Azure Active Directory admin page in the Azure Portal and assigned the Reader rights. Next the `administratorsObj` must be configured in the parameter file and be redeployed.

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `administratorLogin` | string | The username used to establish jumpbox VMs. |
| `administratorLoginPassword` | secureString | The password given to the admin user. |
| `name` | string | The name of the SQL managed instance. |
| `subnetId` | string | The fully qualified resource ID of the subnet on which the SQL managed instance will be placed. |

**Conditional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `primaryUserAssignedIdentityId` | string | `''` | The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `administratorsObj` | _[administrators](administrators/readme.md)_ object | `{object}` |  | The administrator configuration. |
| `collation` | string | `'SQL_Latin1_General_CP1_CI_AS'` |  | Collation of the managed instance. |
| `databases` | _[databases](databases/readme.md)_ array | `[]` |  | Databases to create in this server. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[ResourceUsageStats, SQLSecurityAuditEvents]` | `[ResourceUsageStats, SQLSecurityAuditEvents]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of the diagnostic log analytics workspace. |
| `dnsZonePartner` | string | `''` |  | The resource ID of another managed instance whose DNS zone this managed instance will share after creation. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `encryptionProtectorObj` | _[encryptionProtector](encryptionProtector/readme.md)_ object | `{object}` |  | The encryption protection configuration. |
| `hardwareFamily` | string | `'Gen5'` |  | If the service has different generations of hardware, for the same SKU, then that can be captured here. |
| `instancePoolResourceId` | string | `''` |  | The resource ID of the instance pool this managed server belongs to. |
| `keys` | _[keys](keys/readme.md)_ array | `[]` |  | The keys to configure. |
| `licenseType` | string | `'LicenseIncluded'` | `[LicenseIncluded, BasePrice]` | The license type. Possible values are 'LicenseIncluded' (regular price inclusive of a new SQL license) and 'BasePrice' (discounted AHB price for bringing your own SQL licenses). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `lock` | string | `''` | `[, CanNotDelete, ReadOnly]` | Specify the type of lock. |
| `managedInstanceCreateMode` | string | `'Default'` | `[Default, PointInTimeRestore]` | Specifies the mode of database creation. Default: Regular instance creation. Restore: Creates an instance by restoring a set of backups to specific point in time. RestorePointInTime and SourceManagedInstanceId must be specified. |
| `proxyOverride` | string | `'Proxy'` | `[Proxy, Redirect, Default]` | Connection type used for connecting to the instance. |
| `publicDataEndpointEnabled` | bool | `False` |  | Whether or not the public data endpoint is enabled. |
| `requestedBackupStorageRedundancy` | string | `'Geo'` | `[Geo, GeoZone, Local, Zone]` | The storage account type used to store backups for this database. |
| `restorePointInTime` | string | `''` |  | Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `securityAlertPoliciesObj` | _[securityAlertPolicies](securityAlertPolicies/readme.md)_ object | `{object}` |  | The security alert policy configuration. |
| `servicePrincipal` | string | `'None'` | `[None, SystemAssigned]` | Service principal type. If using AD Authentication and applying Admin, must be set to `SystemAssigned`. Then Global Admin must allow Reader access to Azure AD for the Service Principal. |
| `skuName` | string | `'GP_Gen5'` |  | The name of the SKU, typically, a letter + Number code, e.g. P3. |
| `skuTier` | string | `'GeneralPurpose'` |  | The tier or edition of the particular SKU, e.g. Basic, Premium. |
| `sourceManagedInstanceId` | string | `''` |  | The resource identifier of the source managed instance associated with create operation of this instance. |
| `storageSizeInGB` | int | `32` |  | Storage size in GB. Minimum value: 32. Maximum value: 8192. Increments of 32 GB allowed only. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `timezoneId` | string | `'UTC'` |  | ID of the timezone. Allowed values are timezones supported by Windows. |
| `userAssignedIdentities` | object | `{object}` |  | The ID(s) to assign to the resource. |
| `vCores` | int | `4` |  | The number of vCores. Allowed values: 8, 16, 24, 32, 40, 64, 80. |
| `vulnerabilityAssessmentsObj` | _[vulnerabilityAssessments](vulnerabilityAssessments/readme.md)_ object | `{object}` |  | The vulnerability assessment configuration. |
| `zoneRedundant` | bool | `False` |  | Whether or not multi-az is enabled. |


### Parameter Usage : `userAssignedIdentities`

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
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed managed instance. |
| `resourceGroupName` | string | The resource group of the deployed managed instance. |
| `resourceId` | string | The resource ID of the deployed managed instance. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-sqlmi-x-002"
        },
        "lock": {
            "value": "CanNotDelete"
        },
        "administratorLogin": {
            "reference": {
                "keyVault": {
                    "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001"
                },
                "secretName": "administratorLogin"
            }
        },
        "administratorLoginPassword": {
            "reference": {
                "keyVault": {
                    "id": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/adp-<<namePrefix>>-az-kv-x-001"
                },
                "secretName": "administratorLoginPassword"
            }
        },
        "subnetId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-sqlmi/subnets/<<namePrefix>>-az-subnet-x-sqlmi"
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
        "vCores": {
            "value": 4
        },
        "licenseType": {
            "value": "LicenseIncluded"
        },
        "hardwareFamily": {
            "value": "Gen5"
        },
        "servicePrincipal": {
            "value": "SystemAssigned"
        },
        "dnsZonePartner": {
            "value": ""
        },
        "timezoneId": {
            "value": "UTC"
        },
        "collation": {
            "value": "SQL_Latin1_General_CP1_CI_AS"
        },
        "proxyOverride": {
            "value": "Proxy"
        },
        "systemAssignedIdentity": {
            "value": true
        },
        "userAssignedIdentities": {
            "value": {
                "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001": {}
            }
        },
        "primaryUserAssignedIdentityId": {
            "value": "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001"
        },
        "publicDataEndpointEnabled": {
            "value": false
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        },
        "keys": {
            "value": [
                {
                    "name": "adp-<<namePrefix>>-az-kv-x-sqlmi_keyEncryptionKeySqlMi_4bf367f64c914d8ba698700fb598ad07", // ID must be updated for new keys
                    "uri": "https://adp-<<namePrefix>>-az-kv-x-sqlmi.vault.azure.net/keys/keyEncryptionKeySqlMi/4bf367f64c914d8ba698700fb598ad07", // ID must be updated for new keys
                    "serverKeyType": "AzureKeyVault"
                }
            ]
        },
        "encryptionProtectorObj": {
            "value": {
                "serverKeyName": "adp-<<namePrefix>>-az-kv-x-sqlmi_keyEncryptionKeySqlMi_4bf367f64c914d8ba698700fb598ad07", // ID must be updated for new keys
                "serverKeyType": "AzureKeyVault"
            }
        },
        "securityAlertPoliciesObj": {
            "value": {
                "name": "default",
                "state": "Enabled",
                "emailAccountAdmins": true
            }
        },
        "vulnerabilityAssessmentsObj": {
            "value": {
                "name": "default",
                "emailSubscriptionAdmins": true,
                "recurringScansIsEnabled": true,
                "recurringScansEmails": [
                    "test1@contoso.com",
                    "test2@contoso.com"
                ],
                "vulnerabilityAssessmentsStorageAccountId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001"
            }
        },
        "databases": {
            "value": [
                {
                    "name": "<<namePrefix>>-az-sqlmidb-x-001",
                    "backupShortTermRetentionPolicies": {
                        "name": "default"
                    },
                    "backupLongTermRetentionPolicies": {
                        "name": "default"
                    }
                }
            ]
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
        "diagnosticEventHubAuthorizationRuleId": {
            "value": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey"
        },
        "diagnosticEventHubName": {
            "value": "adp-<<namePrefix>>-az-evh-x-001"
        }
    }
}
```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
resource kv1 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'adp-<<namePrefix>>-az-kv-x-001'
  scope: resourceGroup('<<subscriptionId>>','validation-rg')
}

module managedInstances './Microsoft.Sql/managedInstances/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-managedInstances'
  params: {
    name: '<<namePrefix>>-az-sqlmi-x-002'
    lock: 'CanNotDelete'
    administratorLogin: kv1.getSecret('administratorLogin')
    administratorLoginPassword: kv1.getSecret('administratorLoginPassword')
    subnetId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-sqlmi/subnets/<<namePrefix>>-az-subnet-x-sqlmi'
    skuName: 'GP_Gen5'
    skuTier: 'GeneralPurpose'
    storageSizeInGB: 32
    vCores: 4
    licenseType: 'LicenseIncluded'
    hardwareFamily: 'Gen5'
    servicePrincipal: 'SystemAssigned'
    dnsZonePartner: ''
    timezoneId: 'UTC'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    proxyOverride: 'Proxy'
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001': {}
    }
    primaryUserAssignedIdentityId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-<<namePrefix>>-az-msi-x-001'
    publicDataEndpointEnabled: false
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
    keys: [
      {
        name: 'adp-<<namePrefix>>-az-kv-x-sqlmi_keyEncryptionKeySqlMi_4bf367f64c914d8ba698700fb598ad07'
        uri: 'https://adp-<<namePrefix>>-az-kv-x-sqlmi.vault.azure.net/keys/keyEncryptionKeySqlMi/4bf367f64c914d8ba698700fb598ad07'
        serverKeyType: 'AzureKeyVault'
      }
    ]
    encryptionProtectorObj: {
      serverKeyName: 'adp-<<namePrefix>>-az-kv-x-sqlmi_keyEncryptionKeySqlMi_4bf367f64c914d8ba698700fb598ad07'
      serverKeyType: 'AzureKeyVault'
    }
    securityAlertPoliciesObj: {
      name: 'default'
      state: 'Enabled'
      emailAccountAdmins: true
    }
    vulnerabilityAssessmentsObj: {
      name: 'default'
      emailSubscriptionAdmins: true
      recurringScansIsEnabled: true
      recurringScansEmails: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      vulnerabilityAssessmentsStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    }
    databases: [
      {
        name: '<<namePrefix>>-az-sqlmidb-x-001'
        backupShortTermRetentionPolicies: {
          name: 'default'
        }
        backupLongTermRetentionPolicies: {
          name: 'default'
        }
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adp<<namePrefix>>azsax001'
    diagnosticWorkspaceId: '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-<<namePrefix>>-az-law-x-001'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-<<namePrefix>>-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-<<namePrefix>>-az-evh-x-001'
  }
}
```

</details>
<p>
