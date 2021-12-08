# SQL Managed Instances `[Microsoft.Sql/managedInstances]`

This template deploys a SQL managed instance.

## Resource types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Authorization/roleAssignments` | 2020-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Sql/managedInstances` | 2021-05-01-preview |
| `Microsoft.Sql/managedInstances/administrators` | 2021-02-01-preview |
| `Microsoft.Sql/managedInstances/databases` | 2021-05-01-preview |
| `Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies` | 2021-02-01-preview |
| `Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies` | 2017-03-01-preview |
| `Microsoft.Sql/managedInstances/encryptionProtector` | 2021-05-01-preview |
| `Microsoft.Sql/managedInstances/keys` | 2021-05-01-preview |
| `Microsoft.Sql/managedInstances/securityAlertPolicies` | 2017-03-01-preview |
| `Microsoft.Sql/managedInstances/vulnerabilityAssessments` | 2021-02-01-preview |

### Deployment prerequisites

SQL Managed Instance is deployed on a virtual network. This network is required to satisfy the requirements explained [here](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-managed-instance-connectivity-architecture#network-requirements). In the module is a second ARM template UpdateSubnet.deploy.json, which configures a subnet to be ready for the SQL managed instance.

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `administratorLogin` | string |  |  | Required. The username used to establish jumpbox VMs. |
| `administratorLoginPassword` | secureString |  |  | Required. The password given to the admin user. |
| `administratorsObj` | _[administrators](administrators/readme.md)_ object | `{object}` |  | Optional. The administrator configuration |
| `collation` | string | `SQL_Latin1_General_CP1_CI_AS` |  | Optional. Collation of the managed instance. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered |
| `databases` | _[databases](databases/readme.md)_ array | `[]` |  | Optional. Databases to create in this server. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource ID of the diagnostic storage account. |
| `dnsZonePartner` | string |  |  | Optional. The resource ID of another managed instance whose DNS zone this managed instance will share after creation. |
| `encryptionProtectorObj` | _[encryptionProtector](encryptionProtector/readme.md)_ object | `{object}` |  | Optional. The encryption protection configuration |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `hardwareFamily` | string | `Gen5` |  | Optional. If the service has different generations of hardware, for the same SKU, then that can be captured here. |
| `instancePoolResourceId` | string |  |  | Optional. The resource ID of the instance pool this managed server belongs to. |
| `keys` | _[keys](keys/readme.md)_ array | `[]` |  | Optional. The keys to configure |
| `licenseType` | string | `LicenseIncluded` | `[LicenseIncluded, BasePrice]` | Optional. The license type. Possible values are 'LicenseIncluded' (regular price inclusive of a new SQL license) and 'BasePrice' (discounted AHB price for bringing your own SQL licenses). |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[ResourceUsageStats, SQLSecurityAuditEvents]` | `[ResourceUsageStats, SQLSecurityAuditEvents]` | Optional. The name of logs that will be streamed. |
| `managedInstanceCreateMode` | string | `Default` | `[Default, PointInTimeRestore]` | Optional. Specifies the mode of database creation. Default: Regular instance creation. Restore: Creates an instance by restoring a set of backups to specific point in time. RestorePointInTime and SourceManagedInstanceId must be specified. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `name` | string |  |  | Required. The name of the SQL managed instance. |
| `primaryUserAssignedIdentityId` | string |  |  | Optional. Mandatory if "managedServiceIdentity" contains UserAssigned. The resource ID of a user assigned identity to be used by default. |
| `proxyOverride` | string | `Proxy` | `[Proxy, Redirect, Default]` | Optional. Connection type used for connecting to the instance. |
| `publicDataEndpointEnabled` | bool |  |  | Optional. Whether or not the public data endpoint is enabled. |
| `restorePointInTime` | string |  |  | Optional. Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `securityAlertPoliciesObj` | _[securityAlertPolicies](securityAlertPolicies/readme.md)_ object | `{object}` |  | Optional. The security alert policy configuration |
| `skuName` | string | `GP_Gen5` |  | Optional. The name of the SKU, typically, a letter + Number code, e.g. P3. |
| `skuTier` | string | `GeneralPurpose` |  | Optional. The tier or edition of the particular SKU, e.g. Basic, Premium. |
| `sourceManagedInstanceId` | string |  |  | Optional. The resource identifier of the source managed instance associated with create operation of this instance. |
| `storageSizeInGB` | int | `32` |  | Optional. Storage size in GB. Minimum value: 32. Maximum value: 8192. Increments of 32 GB allowed only. |
| `subnetId` | string |  |  | Required. The fully qualified resource ID of the subnet on which the SQL managed instance will be placed. |
| `systemAssignedIdentity` | bool |  |  | Optional. Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `timezoneId` | string | `UTC` |  | Optional. ID of the timezone. Allowed values are timezones supported by Windows. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. The ID(s) to assign to the resource. |
| `vCores` | int | `4` |  | Optional. The number of vCores. Allowed values: 8, 16, 24, 32, 40, 64, 80. |
| `vulnerabilityAssessmentsObj` | _[vulnerabilityAssessments](vulnerabilityAssessments/readme.md)_ object | `{object}` |  | Optional. The vulnerability assessment configuration |
| `workspaceId` | string |  |  | Optional. Resource ID of a log analytics workspace. |

### Parameter Usage : `userAssignedIdentities`

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
},
```

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ]
        }
    ]
}
```

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

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

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
},
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `managedInstanceName` | string | The name of the deployed managed instance |
| `managedInstanceResourceGroup` | string | The resource group of the deployed managed instance |
| `managedInstanceResourceId` | string | The resource ID of the deployed managed instance |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Managedinstances](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/managedInstances)
- [Managedinstances/Administrators](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/managedInstances/administrators)
- [Managedinstances/Databases](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/managedInstances/databases)
- [Managedinstances/Databases/Backuplongtermretentionpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/managedInstances/databases/backupLongTermRetentionPolicies)
- [Managedinstances/Databases/Backupshorttermretentionpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2017-03-01-preview/managedInstances/databases/backupShortTermRetentionPolicies)
- [Managedinstances/Encryptionprotector](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/managedInstances/encryptionProtector)
- [Managedinstances/Keys](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-05-01-preview/managedInstances/keys)
- [Managedinstances/Securityalertpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2017-03-01-preview/managedInstances/securityAlertPolicies)
- [Managedinstances/Vulnerabilityassessments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/managedInstances/vulnerabilityAssessments)
