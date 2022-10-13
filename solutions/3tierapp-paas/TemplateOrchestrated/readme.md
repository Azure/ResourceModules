#  `[Microsoft.]`

This module deploys .
// TODO: Replace Resource and fill in description

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2017-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2017-04-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.ContainerInstance/containerGroups` | [2021-10-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ContainerInstance/2021-10-01/containerGroups) |
| `Microsoft.DBforPostgreSQL/flexibleServers` | [2022-01-20-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-01-20-preview/flexibleServers) |
| `Microsoft.DBforPostgreSQL/flexibleServers/configurations` | [2022-01-20-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-01-20-preview/flexibleServers/configurations) |
| `Microsoft.DBforPostgreSQL/flexibleServers/databases` | [2022-01-20-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-01-20-preview/flexibleServers/databases) |
| `Microsoft.DBforPostgreSQL/flexibleServers/firewallRules` | [2022-01-20-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-01-20-preview/flexibleServers/firewallRules) |
| `Microsoft.DocumentDB/databaseAccounts` | [2022-02-15-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2022-02-15-preview/databaseAccounts) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases` | [2022-02-15-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2022-02-15-preview/databaseAccounts/gremlinDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | [2022-02-15-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2022-02-15-preview/databaseAccounts/gremlinDatabases/graphs) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | [2021-07-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-07-01-preview/databaseAccounts/mongodbDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | [2021-07-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-07-01-preview/databaseAccounts/mongodbDatabases/collections) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | [2021-06-15](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-06-15/databaseAccounts/sqlDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | [2021-07-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2021-07-01-preview/databaseAccounts/sqlDatabases/containers) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2021-11-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2021-11-01-preview/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2021-06-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2021-06-01-preview/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2019-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2019-09-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2019-09-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2019-09-01/vaults/secrets) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2018-11-30](https://docs.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2018-11-30/userAssignedIdentities) |
| `Microsoft.Network/privateEndpoints` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2021-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.OperationalInsights/workspaces` | [2021-06-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2021-06-01/workspaces) |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2020-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataSources) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2020-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices) |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2020-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedStorageAccounts) |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2020-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches) |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2020-08-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |
| `Microsoft.Resources/deploymentScripts` | [2020-10-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-10-01/deploymentScripts) |
| `Microsoft.Resources/resourceGroups` | [2021-04-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Resources/2021-04-01/resourceGroups) |
| `Microsoft.Sql/servers` | [2022-02-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/servers) |
| `Microsoft.Sql/servers/databases` | [2022-02-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/servers/databases) |
| `Microsoft.Sql/servers/firewallRules` | [2022-02-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/servers/firewallRules) |
| `Microsoft.Sql/servers/securityAlertPolicies` | [2022-02-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/servers/securityAlertPolicies) |
| `Microsoft.Sql/servers/virtualNetworkRules` | [2022-02-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/servers/virtualNetworkRules) |
| `Microsoft.Sql/servers/vulnerabilityAssessments` | [2022-02-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-02-01-preview/servers/vulnerabilityAssessments) |
| `Microsoft.Web/staticSites` | [2021-03-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Web/2021-03-01/staticSites) |

## Parameters

**Required parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `allowConfigFileUpdates` | bool | `True` |  | Allow Config File Updates of the Static Site. |
| `appFacingResourceGroupName` | string | `'az-app-rg-001'` |  | Name of the Resource Group. |
| `containerGroupName` | string | `'az-acg-x-001'` |  | Name for the container group. |
| `containerName` | string | `'az-aci-x-001'` |  | Name for the container. |
| `dataFacingResourceGroupName` | string | `'az-data-rg-001'` |  | Name of the Resource Group. |
| `enterpriseGradeCdnStatus` | string | `'Disabled'` |  | Emterprise Grade Cdn Status of the Static Site. |
| `frontFacingResourceGroupName` | string | `'az-front-rg-001'` |  | Name of the Resource Group. |
| `image` | string | `'mcr.microsoft.com/azuredocs/aci-helloworld'` |  | Name of the image. |
| `keyvaultName` | string | `'az-kyv-app-test-001'` |  | Name of the Key Vault. Must be globally unique. |
| `logAnalyticsWorkspaceName` | string | `'az-loganalytics-002'` |  | Name of the Log Analytics workspace. |
| `postgreSqlAdministratorLogin` | string | `'sqladminlogin'` |  | The administrator login name of a server. Can only be specified when the PostgreSQL server is being created. |
| `postgreSqlSkuName` | string | `'Standard_D2s_v3'` |  | The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3. |
| `postgreSqlTier` | string | `'GeneralPurpose'` | `[Burstable, GeneralPurpose, MemoryOptimized]` | The tier of the particular SKU. Tier must align with the "skuName" property. Example, tier cannot be "Burstable" if skuName is "Standard_D4s_v3". |
| `privateDNSResourceIds` | string | `'/subscriptions/75b1e0ee-d030-43d8-a4bc-35a810096e46/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurestaticapps.net'` |  | Private DNS Resource Ids of the Static Site. |
| `service` | string | `'staticSites'` |  | Service of the Static Site. |
| `staticSiteName` | string | `'az-ss-app-002'` |  | Name of the Static Site. |
| `subnetResourceId` | string | `'/subscriptions/75b1e0ee-d030-43d8-a4bc-35a810096e46/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints'` |  | Subnet Resource Id of the Static Site. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `linkedStorageAccounts` | array | `[]` | List of Storage Accounts to be linked. Required if 'forceCmkForQuery' is set to 'true' and 'savedSearches' is not empty. |
| `sqlAdministratorLogin` | string | `'sqladminlogin'` | The administrator username for the server. Required if no `administrators` object for AAD authentication is provided. |
| `sqlAdministrators` | object | `{object}` | The Azure Active Directory (AAD) administrator authentication. Required if no `administratorLogin` & `administratorLoginPassword` is provided. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `accessPolicies` | array | `[]` |  | Array of access policies object. |
| `capabilitiesToAdd` | array | `[EnableServerless]` | `[DisableRateLimitingResponses, EnableCassandra, EnableGremlin, EnableMongo, EnableServerless, EnableTable]` | List of Cosmos DB capabilities for the account. |
| `containerPorts` | array | `[System.Collections.Hashtable, System.Collections.Hashtable]` |  | Port to open on the container and the public IP address. |
| `cosmosdbName` | string | `'az-cosmosdb-sqldb-001'` |  | Name of cosmosdb account |
| `dataSources` | array | `[]` |  | LAW data sources to configure. |
| `deploymentsToPerformApplicationLayer` | string | `'All'` | `[All, Enable Container Group, Enable Container Registry]` | A parameter to control which Application layer deployments should be executed |
| `deploymentsToPerformDatabaseLayer` | string | `'All'` | `[All, Enable Cosmos DB, Enable PostresSQL, Enable Serverless SQL]` | A parameter to control which Database deployments should be executed |
| `deploymentsToPerformFrontFacingLayer` | string | `'Enable Web Static App'` | `[Enable Web Static App]` | A parameter to control which Front facing deployments should be executed |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the storage account to be used for diagnostic logs. |
| `enableRbacAuthorization` | bool | `True` |  | Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored (warning: this is a preview feature). When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. If null or not specified, the vault is created with the default value of false. Note that management actions are always authorized with RBAC. |
| `enableVaultForDeployment` | bool | `True` | `[False, True]` | Specifies if the vault is enabled for deployment by script or compute. |
| `enableVaultForDiskEncryption` | bool | `True` | `[False, True]` | Specifies if the azure platform has access to the vault for enabling disk encryption scenarios. |
| `enableVaultForTemplateDeployment` | bool | `True` | `[False, True]` | Specifies if the vault is enabled for a template deployment. |
| `eventHubAuthorizationRuleId` | string | `''` |  | Authorization ID of the Event Hub Namespace to be used for diagnostic logs. |
| `eventHubName` | string | `''` |  | Name of the Event Hub to be used for diagnostic logs. |
| `gallerySolutions` | array | `[]` |  | List of gallerySolutions to be created in the log analytics workspace. |
| `ipAddressType` | string | `'Public'` |  | Specifies if the IP is exposed to the public internet or private VNET. - Public or Private. |
| `keyvaultNetworkAcls` | object | `{object}` |  | Service endpoint object information. For security reasons, it is recommended to set the DefaultAction Deny. |
| `keyvaultPrivateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `keyVaultPublicNetworkAccess` | string | `'Disabled'` | `['', Disabled, Enabled]` | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| `linkedServices` | array | `[]` |  | List of services to be linked. |
| `locations` | array | `[]` |  | Locations enabled for the Cosmos DB account. |
| `lock` | string | `''` | `['', CanNotDelete, ReadOnly]` | Specify the type of lock for all resources/resource group defined in this template. |
| `logAnalyticsServiceTier` | string | `'PerGB2018'` | `[Free, PerGB2018, PerNode, Standalone]` | Service Tier: PerGB2018, Free, Standalone, PerGB or PerNode. |
| `minimalTlsVersion` | string | `'1.2'` |  | Minimal TLS version allowed. |
| `osType` | string | `'Linux'` |  | The operating system type required by the containers in the container group. - Windows or Linux. |
| `postgreSqlAvailabilityZone` | string | `''` | `['', 1, 2, 3]` | Availability zone information of the server. Default will have no preference set. |
| `postgreSqlConfigurations` | array | `[]` |  | The configurations to create in the server. |
| `postgreSqlDatabases` | array | `[]` |  | The databases to create in the server. |
| `postgreSqlDelegatedSubnetResourceId` | string | `''` |  | Delegated subnet arm resource ID. Used when the desired connectivity mode is "Private Access" - virtual network integration. |
| `postgreSqlFirewallRules` | array | `[]` |  | The firewall rules to create in the PostgreSQL flexible server. |
| `postgreSqlGeoRedundantBackup` | string | `'Disabled'` | `[Disabled, Enabled]` | A value indicating whether Geo-Redundant backup is enabled on the server. Default is disabled. |
| `postgreSqlServername` | string | `'az-postgresql-001'` |  | The name of the PostgreSQL flexible server. |
| `postgreSqlSkuNamePrivateDnsZoneArmResourceId` | string | `''` |  | Private dns zone arm resource ID. Used when the desired connectivity mode is "Private Access" and required when "delegatedSubnetResourceId" is used. The Private DNS Zone must be lined to the Virtual Network referenced in "delegatedSubnetResourceId". |
| `postgreSqlStorageSizeGB` | int | `32` | `[32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384]` | Max storage allowed for a server. Default is 32GB. |
| `privateEndpoints` | array | `[]` |  | Private Endpoints of the Static Site. |
| `publicNetworkAccessForIngestion` | string | `'Enabled'` | `[Disabled, Enabled]` | The network access type for accessing Log Analytics ingestion. |
| `publicNetworkAccessForQuery` | string | `'Enabled'` | `[Disabled, Enabled]` | The network access type for accessing Log Analytics query. |
| `roleAssignments` | array | `[]` |  | Role Assignments of the Static Site. |
| `savedSearches` | array | `[]` |  | Kusto Query Language searches to save. |
| `secrets` | secureObject | `{object}` |  | All secrets to create. |
| `sku` | string | `'Standard'` |  | SKU of the Static Site. |
| `sqlDatabases` | array | `[]` |  | SQL Databases configurations. |
| `sqlFirewallRules` | array | `[]` |  | The firewall rules to create in the server. |
| `sqlPrivateEndpoints` | array | `[]` |  | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| `sqlPublicNetworkAccess` | string | `''` | `['', Disabled, Enabled]` | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and neither firewall rules nor virtual network rules are set. |
| `sqlRoleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `sqlSecurityAlertPolicies` | array | `[]` |  | The security alert policies to create in the server. |
| `sqlServerDatabases` | array | `[]` |  | The databases to create in the server. |
| `sqlServerName` | string | `'az-sqlsrv-01'` |  | Name of SQL server. |
| `sqlSystemAssignedIdentity` | bool | `True` |  | Enables system assigned managed identity on the resource. |
| `sqlVirtualNetworkRules` | array | `[]` |  | The virtual network rules to create in the server. |
| `stagingEnvironmentPolicy` | string | `'Enabled'` |  | Stagimg Environment Policy of the Static Site. |
| `staticAppLocation` | string | `'eastus2'` | `[centralus, eastasia, eastasiastage, eastus2, westeurope, westus2]` | Location for static web app. |
| `storageInsightsConfigs` | array | `[]` |  | List of storage accounts to be read by the workspace. |
| `systemAssignedIdentity` | bool | `True` |  | System assigned identity of the Static Site. |
| `tags` | object | `{object}` |  | Tags to be applied on all resources/resource groups in this deployment. |
| `userAssignedMIname` | string | `[newGuid()]` |  | Name of the User Assigned Identity. |
| `userAssignedMIroleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `vaultSku` | string | `'premium'` | `[premium, standard]` | Specifies the SKU for the vault. |
| `vulnerabilityAssessmentsObj` | object | `{object}` |  | The vulnerability assessment configuration. |
| `workspaceId` | string | `''` |  | Resource ID of the Log Analytics workspace to be used for diagnostic logs. |

**Resource Group location parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |


### Parameter Usage: `<ParameterPlaceholder>`

// TODO: Fill in Parameter usage

### Parameter Usage: `privateEndpoints`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`.  Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.
- Although not strictly required, it is highly recommended to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

<details>

<summary>Parameter JSON format</summary>

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<serviceName>", // e.g. vault, registry, blob
            "privateDnsZoneGroup": {
                "privateDNSResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                    "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<privateDnsZoneName>" // e.g. privatelink.vaultcore.azure.net, privatelink.azurecr.io, privatelink.blob.core.windows.net
                ]
            },
            "customDnsConfigs": [ // Optional
                {
                    "fqdn": "customname.test.local",
                    "ipAddresses": [
                        "10.10.10.10"
                    ]
                }
            ]
        },
        // Example showing only mandatory fields
        {
            "subnetResourceId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<serviceName>" // e.g. vault, registry, blob
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
privateEndpoints:  [
    // Example showing all available fields
    {
        name: 'sxx-az-pe' // Optional: Name will be automatically generated if one is not provided here
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<serviceName>' // e.g. vault, registry, blob
        privateDnsZoneGroups: {
            privateDNSResourceIds: [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<privateDnsZoneName>' // e.g. privatelink.vaultcore.azure.net, privatelink.azurecr.io, privatelink.blob.core.windows.net
            ]
        }
        // Optional
        customDnsConfigs: [
            {
                fqdn: 'customname.test.local'
                ipAddresses: [
                    '10.10.10.10'
                ]
            }
        ]
    }
    // Example showing only mandatory fields
    {
        subnetResourceId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<serviceName>' // e.g. vault, registry, blob
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

## Outputs

| Output Name | Type |
| :-- | :-- |

## Cross-referenced modules

_None_
