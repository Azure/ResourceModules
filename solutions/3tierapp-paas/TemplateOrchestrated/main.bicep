targetScope = 'subscription'

//////////////////////////
//   Input Parameters   //
//////////////////////////

@description('Optional. A parameter to control which Front facing deployments should be executed')
@allowed([
  'Enable Web Static App'
])
param deploymentsToPerformFrontFacingLayer string = 'Enable Web Static App'

@description('Optional. A parameter to control which Database deployments should be executed')
@allowed([ // Do storage account later
  'All'
  'Enable Cosmos DB'
  'Enable Serverless SQL'
  'Enable PostresSQL'
])
param deploymentsToPerformDatabaseLayer string = 'All'

@description('Optional. A parameter to control which Application layer deployments should be executed')
@allowed([ //Do Function App later
  'All'
  'Enable Container Group'
  'Enable Container Registry'
])
param deploymentsToPerformApplicationLayer string = 'All'

///////////////////////////////
//   User-defined Deployment Properties //
///////////////////////////////

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock for all resources/resource group defined in this template.')
param lock string = ''

@description('Optional. Resource ID of the storage account to be used for diagnostic logs.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the Log Analytics workspace to be used for diagnostic logs.')
param workspaceId string = ''

@description('Optional. Authorization ID of the Event Hub Namespace to be used for diagnostic logs.')
param eventHubAuthorizationRuleId string = ''

@description('Optional. Name of the Event Hub to be used for diagnostic logs.')
param eventHubName string = ''

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

//Parameters for Resource Group

@description('Required. Name of the Resource Group.')
param frontFacingResourceGroupName string = 'az-front-rg-001'

@description('Required. Name of the Resource Group.')
param dataFacingResourceGroupName string = 'az-data-rg-001'

@description('Required. Name of the Resource Group.')
param appFacingResourceGroupName string = 'az-app-rg-001'

@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags object = {}

@description('Resource Group location')
param location string = 'westeurope'

//Parameters for Static site ALL DEFAULT IN JSON (optional) all REQUIRED IN HERE.

@description('Required. Name of the Static Site.')
param staticSiteName string = 'az-ss-app-002'

@description('Required. Allow Config File Updates of the Static Site.')
param allowConfigFileUpdates bool = true

@description('Required. Emterprise Grade Cdn Status of the Static Site.')
param enterpriseGradeCdnStatus string = 'Disabled'

@description('Required. Private DNS Resource Ids of the Static Site.')
param privateDNSResourceIds string = '/subscriptions/75b1e0ee-d030-43d8-a4bc-35a810096e46/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurestaticapps.net'

@description('Required. Service of the Static Site.')
param service string = 'staticSites'

@description('Required. Subnet Resource Id of the Static Site.')
param subnetResourceId string = '/subscriptions/75b1e0ee-d030-43d8-a4bc-35a810096e46/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-<<namePrefix>>-az-vnet-x-001/subnets/<<namePrefix>>-az-subnet-x-005-privateEndpoints'

// @description('Required. Principal Ids of the Static Site.')
// param principalIds string = '<<deploymentSpId>>'

// @description('Optional. Role Definition or Name of the Static Site.')
// param roleDefinitionIdOrName string = 'Reader'

@description('Optional. Role Assignments of the Static Site.')
param roleAssignments array = []

@description('Optional. Private Endpoints of the Static Site.')
param privateEndpoints array = []

@description('Optional. SKU of the Static Site.')
param sku string = 'Standard'

@description('Optional. Stagimg Environment Policy of the Static Site.')
param stagingEnvironmentPolicy string = 'Enabled'

@description('Optional. System assigned identity of the Static Site.')
param systemAssignedIdentity bool = true

// Resource Group Deployment

resource resourceGroupFront 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: frontFacingResourceGroupName
  location: location
  tags: tags
}

resource resourceGroupData 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: dataFacingResourceGroupName
  location: location
  tags: tags
}

resource resourceGroupApp 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: appFacingResourceGroupName
  location: location
  tags: tags
}

// SHARED CODE

// user managed identity

@description('Optional. Name of the User Assigned Identity.')
param userAssignedMIname string = newGuid()

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param userAssignedMIroleAssignments array = []

module userAssignedManagedIdentity '../../../modules/Microsoft.ManagedIdentity/userAssignedIdentities/deploy.bicep' = {
  name: 'userAssignedMI_deployment'
  scope: resourceGroupFront
  params: {
    name: userAssignedMIname
    location: location
    roleAssignments: userAssignedMIroleAssignments
    lock: lock
    tags: tags
  }
}

@description('Required. Name of the Log Analytics workspace.')
param logAnalyticsWorkspaceName string = 'az-loganalytics-002'

@description('Optional. Service Tier: PerGB2018, Free, Standalone, PerGB or PerNode.')
@allowed([
  'Free'
  'Standalone'
  'PerNode'
  'PerGB2018'
])
param logAnalyticsServiceTier string = 'PerGB2018'

@description('Optional. List of storage accounts to be read by the workspace.')
param storageInsightsConfigs array = []

@description('Optional. List of services to be linked.')
param linkedServices array = []

@description('Conditional. List of Storage Accounts to be linked. Required if \'forceCmkForQuery\' is set to \'true\' and \'savedSearches\' is not empty.')
param linkedStorageAccounts array = []

@description('Optional. Kusto Query Language searches to save.')
param savedSearches array = []

@description('Optional. LAW data sources to configure.')
param dataSources array = []

@description('Optional. List of gallerySolutions to be created in the log analytics workspace.')
param gallerySolutions array = []

@description('Optional. The network access type for accessing Log Analytics ingestion.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForIngestion string = 'Enabled'

@description('Optional. The network access type for accessing Log Analytics query.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForQuery string = 'Enabled'

module LogAnalytics '../../../modules/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  name: 'LogAnalytics_deployment'
  scope: resourceGroupFront
  params: {
    name: logAnalyticsWorkspaceName
    location: location
    serviceTier: logAnalyticsServiceTier
    storageInsightsConfigs: storageInsightsConfigs
    linkedServices: linkedServices
    savedSearches: savedSearches
    dataSources: dataSources
    gallerySolutions: gallerySolutions
    linkedStorageAccounts: linkedStorageAccounts
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticEventHubName: eventHubName
    diagnosticEventHubAuthorizationRuleId: eventHubAuthorizationRuleId
  }
}

// deployment scripts

module passwordGen 'pwdgenerator.bicep' = {
  name: 'passwordGen_deploymentScript'
  scope: resourceGroupFront
}

// key vault

@description('Required. Name of the Key Vault. Must be globally unique.')
@maxLength(24)
param keyvaultName string = 'az-kyv-app-test-001'

@description('Optional. Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored (warning: this is a preview feature). When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. If null or not specified, the vault is created with the default value of false. Note that management actions are always authorized with RBAC.')
param enableRbacAuthorization bool = true

@description('Optional. Array of access policies object.')
param accessPolicies array = []

@description('Optional. All secrets to create.')
@secure()
param secrets object = {}

@description('Optional. Specifies if the vault is enabled for deployment by script or compute.')
@allowed([
  true
  false
])
param enableVaultForDeployment bool = true

@description('Optional. Specifies if the vault is enabled for a template deployment.')
@allowed([
  true
  false
])
param enableVaultForTemplateDeployment bool = true

@description('Optional. Specifies if the azure platform has access to the vault for enabling disk encryption scenarios.')
@allowed([
  true
  false
])
param enableVaultForDiskEncryption bool = true

@description('Optional. Specifies the SKU for the vault.')
@allowed([
  'premium'
  'standard'
])
param vaultSku string = 'premium'

@description('Optional. Service endpoint object information. For security reasons, it is recommended to set the DefaultAction Deny.')
param keyvaultNetworkAcls object = {}

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param keyVaultPublicNetworkAccess string = 'Disabled'

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param keyvaultPrivateEndpoints array = []

module keyvault '../../../modules/Microsoft.KeyVault/vaults/deploy.bicep' = {
  name: 'Keyvault_deployment'
  scope: resourceGroupFront
  params: {
    name: keyvaultName
    enableRbacAuthorization: enableRbacAuthorization
    accessPolicies: accessPolicies
    vaultSku: vaultSku
    enableVaultForDeployment: enableVaultForDeployment
    enableVaultForTemplateDeployment: enableVaultForTemplateDeployment
    enableVaultForDiskEncryption: enableVaultForDiskEncryption
    publicNetworkAccess: keyVaultPublicNetworkAccess
    networkAcls: keyvaultNetworkAcls
    privateEndpoints: keyvaultPrivateEndpoints
    secrets: !empty(secrets) ? secrets : {
      secureList: [
        {
          attributesExp: 1702648632
          attributesNbf: 10000
          contentType: 'postgresql admin credentials'
          name: 'psqladminlogin'
          value: passwordGen.outputs.passwordText_psql
        }
        {
          attributesExp: 1702648632
          attributesNbf: 10000
          contentType: 'sql server admin credentials'
          name: 'sqladminlogin'
          value: passwordGen.outputs.passwordText_sql
        }
      ]
    }
    roleAssignments: [
      {
        principalIds: [
          userAssignedManagedIdentity.outputs.principalId
        ]
        roleDefinitionIdOrName: 'Key Vault Secrets User'
      }
    ]
    diagnosticWorkspaceId: !empty(workspaceId) ? workspaceId : LogAnalytics.outputs.resourceId
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticEventHubName: eventHubName
    diagnosticEventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
  }
  dependsOn: [
    userAssignedManagedIdentity
    LogAnalytics
  ]
}

// FRONT FACING CODE

// Static Site Deployment

@description('Optional. Location for static web app.')
@allowed([
  'westus2'
  'centralus'
  'eastus2'
  'westeurope'
  'eastasia'
  'eastasiastage'
])
param staticAppLocation string = 'eastus2'

module staticSites '../../../modules/Microsoft.Web/staticSites/deploy.bicep' = if (deploymentsToPerformFrontFacingLayer == 'Enable Web Static App') {
  name: '${uniqueString(deployment().name)}-StaticSites'
  scope: resourceGroupFront
  params: {
    // Required parameters
    name: staticSiteName
    // Non-required parameters
    allowConfigFileUpdates: allowConfigFileUpdates
    enterpriseGradeCdnStatus: enterpriseGradeCdnStatus
    lock: lock
    privateEndpoints: privateEndpoints
    roleAssignments: roleAssignments
    sku: sku
    stagingEnvironmentPolicy: stagingEnvironmentPolicy
    systemAssignedIdentity: systemAssignedIdentity
    userAssignedIdentities: {
      '${userAssignedManagedIdentity.outputs.resourceId}': {}
    }
    location: staticAppLocation
  }
}

// DB CODE

// CosmosDB

@description('Optional. Name of cosmosdb account')
param cosmosdbName string = 'az-cosmosdb-sqldb-001'

@description('Optional. Locations enabled for the Cosmos DB account.')
param locations array = []

@description('Optional. SQL Databases configurations.')
param sqlDatabases array = []

@allowed([
  'EnableCassandra'
  'EnableTable'
  'EnableGremlin'
  'EnableMongo'
  'DisableRateLimitingResponses'
  'EnableServerless'
])
@description('Optional. List of Cosmos DB capabilities for the account.')
param capabilitiesToAdd array = [
  'EnableServerless'
]

module Cosmosdb '../../../modules/Microsoft.DocumentDB/databaseAccounts/deploy.bicep' = if (deploymentsToPerformDatabaseLayer == 'Enable Cosmos DB' || deploymentsToPerformDatabaseLayer == 'All') {
  name: 'Deployment_CosmosDB'
  scope: resourceGroupData
  params: {
    name: cosmosdbName
    location: location
    locations: locations
    sqlDatabases: sqlDatabases
    capabilitiesToAdd: capabilitiesToAdd
    tags: tags
    lock: lock
    diagnosticWorkspaceId: workspaceId
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticEventHubName: eventHubName
    diagnosticEventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
    userAssignedIdentities: {
      '${userAssignedManagedIdentity.outputs.resourceId}': {}
    }
  }
  dependsOn: [
    LogAnalytics
  ]
}

// PostgreSql

@description('Optional. The name of the PostgreSQL flexible server.')
param postgreSqlServername string = 'az-postgresql-001'

@description('Required. The administrator login name of a server. Can only be specified when the PostgreSQL server is being created.')
param postgreSqlAdministratorLogin string = 'sqladminlogin'

@description('Required. The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3.')
param postgreSqlSkuName string = 'Standard_D2s_v3'

@allowed([
  'GeneralPurpose'
  'Burstable'
  'MemoryOptimized'
])
@description('Required. The tier of the particular SKU. Tier must align with the "skuName" property. Example, tier cannot be "Burstable" if skuName is "Standard_D4s_v3".')
param postgreSqlTier string = 'GeneralPurpose'

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. A value indicating whether Geo-Redundant backup is enabled on the server. Default is disabled.')
param postgreSqlGeoRedundantBackup string = 'Disabled'

@allowed([
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
])
@description('Optional. Max storage allowed for a server. Default is 32GB.')
param postgreSqlStorageSizeGB int = 32

@description('Optional. Delegated subnet arm resource ID. Used when the desired connectivity mode is "Private Access" - virtual network integration.')
param postgreSqlDelegatedSubnetResourceId string = ''

@description('Optional. Private dns zone arm resource ID. Used when the desired connectivity mode is "Private Access" and required when "delegatedSubnetResourceId" is used. The Private DNS Zone must be lined to the Virtual Network referenced in "delegatedSubnetResourceId".')
param postgreSqlSkuNamePrivateDnsZoneArmResourceId string = ''

@description('Optional. The databases to create in the server.')
param postgreSqlDatabases array = []

@description('Optional. The firewall rules to create in the PostgreSQL flexible server.')
param postgreSqlFirewallRules array = []

@description('Optional. The configurations to create in the server.')
param postgreSqlConfigurations array = []

@allowed([
  ''
  '1'
  '2'
  '3'
])
@description('Optional. Availability zone information of the server. Default will have no preference set.')
param postgreSqlAvailabilityZone string = ''

module PostgreSql '../../../modules/Microsoft.DBforPostgreSQL/flexibleServers/deploy.bicep' = if (deploymentsToPerformDatabaseLayer == 'Enable PostresSQL' || deploymentsToPerformDatabaseLayer == 'All') {
  name: 'PostgreSql_deployment'
  scope: resourceGroupData
  params: {
    name: postgreSqlServername
    location: location
    administratorLogin: postgreSqlAdministratorLogin
    administratorLoginPassword: passwordGen.outputs.passwordText_psql
    skuName: postgreSqlSkuName
    tier: postgreSqlTier
    geoRedundantBackup: postgreSqlGeoRedundantBackup
    storageSizeGB: postgreSqlStorageSizeGB
    delegatedSubnetResourceId: postgreSqlDelegatedSubnetResourceId
    privateDnsZoneArmResourceId: postgreSqlSkuNamePrivateDnsZoneArmResourceId
    databases: postgreSqlDatabases
    firewallRules: postgreSqlFirewallRules
    configurations: postgreSqlConfigurations
    availabilityZone: postgreSqlAvailabilityZone
    diagnosticWorkspaceId: !empty(workspaceId) ? workspaceId : LogAnalytics.outputs.resourceId
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticEventHubName: eventHubName
    diagnosticEventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
  }
  dependsOn: [
    keyvault
    LogAnalytics
  ]
}

// SQL

@description('Optional. Name of SQL server.')
param sqlServerName string = 'az-sqlsrv-01'

@description('Conditional. The administrator username for the server. Required if no `administrators` object for AAD authentication is provided.')
param sqlAdministratorLogin string = 'sqladminlogin'

@description('Conditional. The Azure Active Directory (AAD) administrator authentication. Required if no `administratorLogin` & `administratorLoginPassword` is provided.')
param sqlAdministrators object = {}

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param sqlPrivateEndpoints array = []

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and neither firewall rules nor virtual network rules are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param sqlPublicNetworkAccess string = ''

@description('Optional. The databases to create in the server.')
param sqlServerDatabases array = []

@description('Optional. Enables system assigned managed identity on the resource.')
param sqlSystemAssignedIdentity bool = true

@description('Optional. The firewall rules to create in the server.')
param sqlFirewallRules array = []

@description('Optional. The virtual network rules to create in the server.')
param sqlVirtualNetworkRules array = []

@description('Optional. The security alert policies to create in the server.')
param sqlSecurityAlertPolicies array = []

@description('Optional. The vulnerability assessment configuration.')
param vulnerabilityAssessmentsObj object = {}

@description('Optional. Minimal TLS version allowed.')
param minimalTlsVersion string = '1.2'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param sqlRoleAssignments array = []

module SQL_db '../../../modules/Microsoft.Sql/servers/deploy.bicep' = if (deploymentsToPerformDatabaseLayer == 'Enable Serverless SQL' || deploymentsToPerformDatabaseLayer == 'All') {
  name: 'SQL_deployment'
  scope: resourceGroupData
  params: {
    name: sqlServerName
    location: location
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: passwordGen.outputs.passwordText_sql
    administrators: sqlAdministrators
    publicNetworkAccess: sqlPublicNetworkAccess
    privateEndpoints: sqlPrivateEndpoints
    databases: sqlServerDatabases
    lock: lock
    tags: tags
    systemAssignedIdentity: sqlSystemAssignedIdentity
    userAssignedIdentities: {
      '${userAssignedManagedIdentity.outputs.resourceId}': {}
    }
    firewallRules: sqlFirewallRules
    virtualNetworkRules: sqlVirtualNetworkRules
    securityAlertPolicies: sqlSecurityAlertPolicies
    vulnerabilityAssessmentsObj: vulnerabilityAssessmentsObj
    minimalTlsVersion: minimalTlsVersion
    roleAssignments: sqlRoleAssignments
  }
  dependsOn: [
    keyvault
  ]
}

// Application Deployment

@description('Required. Name for the container group.')
param containerGroupName string = 'az-acg-x-001'

@description('Required. Name for the container.')
param containerName string = 'az-aci-x-001'

@description('Required. Name of the image.')
param image string = 'mcr.microsoft.com/azuredocs/aci-helloworld'

@description('Optional. The operating system type required by the containers in the container group. - Windows or Linux.')
param osType string = 'Linux'

@description('Optional. Specifies if the IP is exposed to the public internet or private VNET. - Public or Private.')
param ipAddressType string = 'Public'

@description('Optional. Port to open on the container and the public IP address.')
param containerPorts array = [
  {
    port: '80'
    protocol: 'Tcp'
  }
  {
    port: '443'
    protocol: 'Tcp'
  }
]
module containerGroups '../../../modules/Microsoft.ContainerInstance/containerGroups/deploy.bicep' = if (deploymentsToPerformApplicationLayer == 'Enable Container Group') {
  name: '${uniqueString(deployment().name)}-ContainerGroups'
  scope: resourceGroupApp
  params: {
    // Required parameters
    containername: containerName
    image: image
    name: containerGroupName
    // Non-required parameters
    lock: lock
    ports: containerPorts
    ipAddressType: ipAddressType
    osType: osType
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '${userAssignedManagedIdentity.outputs.resourceId}': {}
    }
  }
}
