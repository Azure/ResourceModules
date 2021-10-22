# SQL Managed Instances `[Microsoft.Sql/managedInstances]`

This template deploys an SQL Managed Instance, with resource lock.


## Resource types

| Resource Type | Api Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | 2016-09-01 |
| `Microsoft.Insights/diagnosticSettings` | 2017-05-01-preview |
| `Microsoft.Sql/managedInstances` | 2020-08-01-preview |
| `Microsoft.Sql/managedInstances/administrators` | 2021-02-01-preview |
| `Microsoft.Sql/managedInstances/encryptionProtector` | 2017-10-01-preview |
| `Microsoft.Sql/managedInstances/keys` | 2017-10-01-preview |
| `Microsoft.Sql/managedInstances/providers/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Sql/managedInstances/securityAlertPolicies` | 2017-03-01-preview |
| `Microsoft.Sql/managedInstances/vulnerabilityAssessments` | 2021-02-01-preview |

### Deployment prerequisites
SQL Managed Instance is deployed on a virtual network. This network is required to satisfy the requirements explained [here](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-managed-instance-connectivity-architecture#network-requirements). In the module is a second ARM template UpdateSubnet.deploy.json, which configures a subnet to be ready for the SQL managed instance.

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `administratorLogin` | string |  |  | Required. The username used to establish jumpbox VMs. |
| `administratorLoginPassword` | secureString |  |  | Required. The password given to the admin user. |
| `azureAdAdmin` | object | `{object}` |  | Optional. An Azure Active Directory administrator account. |
| `collation` | string | `SQL_Latin1_General_CP1_CI_AS` |  | Optional. Collation of the managed instance. |
| `cuaId` | string |  |  | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |
| `customerManagedEnryptionKeyUri` | string |  |  | Optional. The URI of the key (in Azure Key Vault) for transparent data encryption. The key vault must have SoftDelete enabled and must reside in the same region as the SQL MI. The managed identity of the SQL managed instance needs to have the following key permissions in the key vault: Get, Unwrap Key, Wrap Key. If blank, service managed key will be used. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string |  |  | Optional. Resource identifier of the Diagnostic Storage Account. |
| `dnsZonePartner` | string |  |  | Optional. The resource id of another managed instance whose DNS zone this managed instance will share after creation. |
| `enableAdvancedDataSecurity` | bool |  |  | Optional. Enables advanced data security features, like recuring vulnerability assesment scans and ATP. If enabled, storage account must be provided. |
| `enableRecuringVulnerabilityAssessmentsScans` | bool |  |  | Optional. Recurring scans state. |
| `eventHubAuthorizationRuleId` | string |  |  | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string |  |  | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `hardwareFamily` | string | `Gen5` |  | Optional. If the service has different generations of hardware, for the same SKU, then that can be captured here. |
| `instancePoolId` | string |  |  | Optional. The Id of the instance pool this managed server belongs to. |
| `licenseType` | string | `LicenseIncluded` | `[LicenseIncluded, BasePrice]` | Optional. The license type. Possible values are 'LicenseIncluded' (regular price inclusive of a new SQL license) and 'BasePrice' (discounted AHB price for bringing your own SQL licenses). |
| `location` | string | `[resourceGroup().location]` |  | Optional. Location for all resources. |
| `lock` | string | `NotSpecified` | `[CanNotDelete, NotSpecified, ReadOnly]` | Optional. Specify the type of lock. |
| `logsToEnable` | array | `[ResourceUsageStats, SQLSecurityAuditEvents]` | `[ResourceUsageStats, SQLSecurityAuditEvents]` | Optional. The name of logs that will be streamed. |
| `managedInstanceCreateMode` | string | `Default` | `[Default, PointInTimeRestore]` | Optional. Specifies the mode of database creation. Default: Regular instance creation. Restore: Creates an instance by restoring a set of backups to specific point in time. RestorePointInTime and SourceManagedInstanceId must be specified. |
| `managedInstanceName` | string |  |  | Required. The name of the SQL managed instance. |
| `managedServiceIdentity` | string | `SystemAssigned` | `[None, SystemAssigned, UserAssigned]` | Optional. The type of identity used for the managed instance. The type "None" (default) will remove any identities from the managed instance. |
| `metricsToEnable` | array | `[AllMetrics]` | `[AllMetrics]` | Optional. The name of metrics that will be streamed. |
| `proxyOverride` | string | `Proxy` | `[Proxy, Redirect, Default]` | Optional. Connection type used for connecting to the instance. |
| `publicDataEndpointEnabled` | bool |  |  | Optional. Whether or not the public data endpoint is enabled. |
| `restorePointInTime` | string |  |  | Optional. Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. |
| `roleAssignments` | array | `[]` |  | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `sendScanReportEmailsToSubscriptionAdmins` | bool |  |  | Optional. Specifies that the schedule scan notification will be is sent to the subscription administrators. |
| `sendScanReportToEmailAddresses` | array | `[]` |  | Optional. Specifies an array of e-mail addresses to which the scan notification is sent. |
| `skuName` | string | `GP_Gen5` |  | Optional. The name of the SKU, typically, a letter + Number code, e.g. P3. |
| `skuTier` | string | `GeneralPurpose` |  | Optional. The tier or edition of the particular SKU, e.g. Basic, Premium. |
| `sourceManagedInstanceId` | string |  |  | Optional. The resource identifier of the source managed instance associated with create operation of this instance. |
| `storageSizeInGB` | int | `32` |  | Optional. Storage size in GB. Minimum value: 32. Maximum value: 8192. Increments of 32 GB allowed only. |
| `subnetId` | string |  |  | Required. The fully qualified resource ID of the subnet on which the SQL managed instance will be placed. |
| `tags` | object | `{object}` |  | Optional. Tags of the resource. |
| `timezoneId` | string | `UTC` |  | Optional. Id of the timezone. Allowed values are timezones supported by Windows. |
| `userAssignedIdentities` | object | `{object}` |  | Optional. Mandatory if "managedServiceIdentity" contains UserAssigned. The list of user identities associated with the managed instance. |
| `vCores` | int | `4` |  | Optional. The number of vCores. Allowed values: 8, 16, 24, 32, 40, 64, 80. |
| `vulnerabilityAssessmentsStorageAccountId` | string |  |  | Optional. A blob storage to hold the scan results. |
| `workspaceId` | string |  |  | Optional. Resource identifier of Log Analytics. |

### Parameter Usage: `azureAdAdmin`

```json
"azureAdAdmin": {
    "value": {
        "login": "username@contoso.com",
        "sid": "111111-222222-33333-4444-5555555",
        "tenantId": "a8f2ac6f-681f-4361-b51f-c85d86014a17"
    }
}
```

### Parameter Usage: `roleAssignments`

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Desktop Virtualization User",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
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

## Outputs

| Output Name | Type |
| :-- | :-- |
| `managedInstanceName` | string |
| `managedInstanceResourceGroup` | string |
| `managedInstanceResourceId` | string |

## Template references

- [Locks](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2016-09-01/locks)
- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2017-05-01-preview/diagnosticSettings)
- [Managedinstances](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2020-08-01-preview/managedInstances)
- [Managedinstances/Administrators](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/managedInstances/administrators)
- [Managedinstances/Encryptionprotector](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2017-10-01-preview/managedInstances/encryptionProtector)
- [Managedinstances/Keys](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2017-10-01-preview/managedInstances/keys)
- [Managedinstances/Securityalertpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2017-03-01-preview/managedInstances/securityAlertPolicies)
- [Managedinstances/Vulnerabilityassessments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2021-02-01-preview/managedInstances/vulnerabilityAssessments)
