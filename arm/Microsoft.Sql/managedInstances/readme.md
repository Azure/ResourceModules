# SQL Managed Instances

This template deploys an SQL Managed Instance, with resource lock. 


## Resource types

|Resource Type|ApiVersion|
|:--|:--|
|`Microsoft.Sql/managedInstances`|2018-06-01-preview|
|`Microsoft.Sql/managedInstances/keys`|2017-10-01-preview|
|`Microsoft.Sql/managedInstances/encryptionProtector`|2017-10-01-preview|
|`Microsoft.Sql/managedInstances/securityAlertPolicies`|2017-03-01-preview|
|`Microsoft.Sql/managedInstances/vulnerabilityAssessments`|2018-06-01-preview|
|`Microsoft.Sql/managedInstances/administrators`|2017-03-01-preview|
|`Microsoft.Sql/managedInstances/providers/diagnosticsettings`|2017-05-01-preview|
|`providers/locks`|1900-01-00|
|`Microsoft.Sql/managedInstances/providers/roleAssignments`|2018-09-01-preview|
|`Microsoft.Resources/deployments`|2019-10-01|

### Deployment prerequisites
SQL Managed Instance is deployed on a virtual network. This network is required to satisfy the requirements explained [here](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-managed-instance-connectivity-architecture#network-requirements). In the module is a second ARM template UpdateSubnet.deploy.json, which configures a subnet to be ready for the SQL managed instance.

## Parameters

| Parameter Name | Type | Description | DefaultValue | Possible values |
| :-- | :-- | :-- | :-- | :-- |
| `administratorLogin` | string | Required. The username used to establish jumpbox VMs. |  | |
| `administratorLoginPassword` | securestring | Required. The password given to the admin user. |  | |
| `azureAdAdmin` | object | Optional. An Azure Active Directory administrator account. |  | |
| `collation` | string | Optional. Collation of the managed instance. | SQL_Latin1_General_CP1_CI_AS | |
| `cuaId` | string | Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered |  | |
| `customerManagedEnryptionKeyUri` | string | Optional. The URI of the key (in Azure Key Vault) for transparent data encryption. The key vault must have SoftDelete enabled and must reside in the same region as the SQL MI. The managed identity of the SQL managed instance needs to have the following key permissions in the key vault: Get, Unwrap Key, Wrap Key. If blank, service managed key will be used. |  | |
| `diagnosticLogsRetentionInDays` | int | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. | 365 | |
| `diagnosticStorageAccountId` | string | Optional. Resource identifier of the Diagnostic Storage Account. |  | |
| `dnsZonePartner` | string | Optional. The resource id of another managed instance whose DNS zone this managed instance will share after creation. |  | |
| `enableAdvancedDataSecurity` | bool | Optional. Enables advanced data security features, like recuring vulnerability assesment scans and ATP. If enabled, storage account must be provided. | False | |
| `enableRecuringVulnerabilityAssessmentsScans` | bool | Optional. Recurring scans state. | False | |
| `eventHubAuthorizationRuleId` | string | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |  | |
| `eventHubName` | string | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |  | |
| `hardwareFamily` | string | Optional. If the service has different generations of hardware, for the same SKU, then that can be captured here. | Gen5 | |
| `instancePoolId` | string | Optional. The Id of the instance pool this managed server belongs to. |  | |
| `licenseType` | string | Optional. The license type. Possible values are 'LicenseIncluded' (regular price inclusive of a new SQL license) and 'BasePrice' (discounted AHB price for bringing your own SQL licenses). | LicenseIncluded | |
| `location` | string | Optional. Location for all resources. | [resourceGroup().location] | |
| `lockForDeletion` | bool | Optional. Switch to lock Key Vault from deletion. | False | |
| `managedInstanceCreateMode` | string | Optional. Specifies the mode of database creation. Default: Regular instance creation. Restore: Creates an instance by restoring a set of backups to specific point in time. RestorePointInTime and SourceManagedInstanceId must be specified. | Default | |
| `managedInstanceName` | string | Required. The name of the SQL managed instance. |  | |
| `proxyOverride` | string | Optional. Connection type used for connecting to the instance. | Proxy |
| `publicDataEndpointEnabled` | bool | Optional. Whether or not the public data endpoint is enabled. | False | |
| `restorePointInTime` | string | Optional. Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. |  | |
| `roleAssignments` | array | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' | System.Object[] | |
| `sendScanReportEmailsToSubscriptionAdmins` | bool | Optional. Specifies that the schedule scan notification will be is sent to the subscription administrators. | False | |
| `sendScanReportToEmailAddresses` | array | Optional. Specifies an array of e-mail addresses to which the scan notification is sent. | System.Object[] | |
| `skuName` | string | Optional. The name of the SKU, typically, a letter + Number code, e.g. P3. | GP_Gen5 | |
| `skuTier` | string | Optional. The tier or edition of the particular SKU, e.g. Basic, Premium. | GeneralPurpose | |
| `sourceManagedInstanceId` | string | Optional. The resource identifier of the source managed instance associated with create operation of this instance. |  | |
| `storageSizeInGB` | int | Optional. Storage size in GB. Minimum value: 32. Maximum value: 8192. Increments of 32 GB allowed only. | 32 | |
| `subnetId` | string | Required. The fully qualified resource ID of the subnet on which the SQL managed instance will be placed. |  | |
| `tags` | object | Optional. Tags of the resource. |  | |
| `timezoneId` | string | Optional. Id of the timezone. Allowed values are timezones supported by Windows. | UTC | |
| `vCores` | int | Optional. The number of vCores. Allowed values: 8, 16, 24, 32, 40, 64, 80. | 4 | |
| `vulnerabilityAssessmentsStorageAccountId` | string | Optional. A blob storage to hold the scan results. |  | |
| `workspaceId` | string | Optional. Resource identifier of Log Analytics. |  | |

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

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `managedInstanceName` | string | The name of the SQL managed instance. |
| `managedInstanceResourceGroup` | string | The Resource grpup in which this resource has been created. |
| `managedInstanceResourceId` | string | The Resource ID of the Managed instance. |

## Considerations

*N/A*

## Additional resources

- [Introduction to Azure SQL Managed Instance](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-managed-instance-index)
- [ARM Template schema for SQL Managed Instance](https://docs.microsoft.com/en-us/azure/templates/microsoft.sql/2018-06-01-preview/managedinstances)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)