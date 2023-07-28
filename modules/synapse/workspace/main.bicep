// Parameters
@maxLength(50)
@description('Required. The name of the Synapse Workspace.')
param name string

@description('Optional. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable or Disable AzureADOnlyAuthentication on All Workspace sub-resource.')
param azureADOnlyAuthentication bool = false

@description('Optional. AAD object ID of initial workspace admin.')
param initialWorkspaceAdminObjectID string = ''

@description('Required. Resource ID of the default ADLS Gen2 storage account.')
param defaultDataLakeStorageAccountResourceId string

@description('Required. The default ADLS Gen2 file system.')
param defaultDataLakeStorageFilesystem string

@description('Optional. Create managed private endpoint to the default storage account or not. If Yes is selected, a managed private endpoint connection request is sent to the workspace\'s primary Data Lake Storage Gen2 account for Spark pools to access data. This must be approved by an owner of the storage account.')
param defaultDataLakeStorageCreateManagedPrivateEndpoint bool = false

@description('Optional. Double encryption using a customer-managed key.')
param encryption bool = false

@description('Conditional. The resource ID of a key vault to reference a customer managed key for encryption from. Required if \'cMKKeyName\' is not empty.')
param cMKKeyVaultResourceId string = ''

@description('Optional. The name of the customer managed key to use for encryption.')
param cMKKeyName string = ''

@description('Optional. Use System Assigned Managed identity that will be used to access your customer-managed key stored in key vault.')
param cMKUseSystemAssignedIdentity bool = false

@description('Optional. The ID of User Assigned Managed identity that will be used to access your customer-managed key stored in key vault.')
param cMKUserAssignedIdentityResourceId string = ''

@description('Optional. Activate workspace by adding the system managed identity in the KeyVault containing the customer managed key and activating the workspace.')
param encryptionActivateWorkspace bool = false

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@maxLength(90)
@description('Optional. Workspace managed resource group. The resource group name uniquely identifies the resource group within the user subscriptionId. The resource group name must be no longer than 90 characters long, and must be alphanumeric characters (Char.IsLetterOrDigit()) and \'-\', \'_\', \'(\', \')\' and\'.\'. Note that the name cannot end with \'.\'.')
param managedResourceGroupName string = ''

@description('Optional. Enable this to ensure that connection from your workspace to your data sources use Azure Private Links. You can create managed private endpoints to your data sources.')
param managedVirtualNetwork bool = false

@description('Optional. The Integration Runtimes to create.')
param integrationRuntimes array = []

@description('Optional. Allowed AAD Tenant IDs For Linking.')
param allowedAadTenantIdsForLinking array = []

@description('Optional. Linked Access Check On Target Resource.')
param linkedAccessCheckOnTargetResource bool = false

@description('Optional. Prevent Data Exfiltration.')
param preventDataExfiltration bool = false

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Enable or Disable public network access to workspace.')
param publicNetworkAccess string = 'Enabled'

@description('Optional. Purview Resource ID.')
param purviewResourceID string = ''

@description('Required. Login for administrator access to the workspace\'s SQL pools.')
param sqlAdministratorLogin string

@description('Optional. Password for administrator access to the workspace\'s SQL pools. If you don\'t provide a password, one will be automatically generated. You can change the password later.')
#disable-next-line secure-secrets-in-params // Not a secret
param sqlAdministratorLoginPassword string = ''

@description('Optional. Git integration settings.')
param workspaceRepositoryConfiguration object = {}

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'SynapseRbacOperations'
  'GatewayApiRequests'
  'BuiltinSqlReqsEnded'
  'IntegrationPipelineRuns'
  'IntegrationActivityRuns'
  'IntegrationTriggerRuns'
  'SQLSecurityAuditEvents'
  'SynapseLinkEvent'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

// Variables
var userAssignedIdentitiesUnion = union(userAssignedIdentities, !empty(cMKUserAssignedIdentityResourceId) ? {
    '${cMKUserAssignedIdentityResourceId}': {}
  } : {})

var identityType = !empty(userAssignedIdentitiesUnion) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned'

var identity = {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentitiesUnion) ? userAssignedIdentitiesUnion : null
}

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs'): {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
] : diagnosticsLogsSpecified

var enableReferencedModulesTelemetry = false

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = if (!empty(cMKKeyVaultResourceId)) {
  name: last(split(cMKKeyVaultResourceId, '/'))!
  scope: resourceGroup(split(cMKKeyVaultResourceId, '/')[2], split(cMKKeyVaultResourceId, '/')[4])
}

resource cMKKeyVaultKey 'Microsoft.KeyVault/vaults/keys@2022-07-01' existing = if (!empty(cMKKeyVaultResourceId) && !empty(cMKKeyName)) {
  name: '${cMKKeyVault.name}/${cMKKeyName}'
  scope: resourceGroup(split(cMKKeyVaultResourceId, '/')[2], split(cMKKeyVaultResourceId, '/')[4])
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: name
  location: location
  identity: identity
  tags: tags
  properties: {
    azureADOnlyAuthentication: azureADOnlyAuthentication ? azureADOnlyAuthentication : null
    cspWorkspaceAdminProperties: !empty(initialWorkspaceAdminObjectID) ? {
      initialWorkspaceAdminObjectId: initialWorkspaceAdminObjectID
    } : null
    defaultDataLakeStorage: {
      resourceId: defaultDataLakeStorageAccountResourceId
      accountUrl: 'https://${last(split(defaultDataLakeStorageAccountResourceId, '/'))!}.dfs.${environment().suffixes.storage}'
      filesystem: defaultDataLakeStorageFilesystem
      createManagedPrivateEndpoint: managedVirtualNetwork ? defaultDataLakeStorageCreateManagedPrivateEndpoint : null
    }
    encryption: encryption ? {
      cmk: {
        kekIdentity: {
          userAssignedIdentity: !empty(cMKUserAssignedIdentityResourceId) ? cMKUserAssignedIdentityResourceId : null
          useSystemAssignedIdentity: cMKUseSystemAssignedIdentity
        }
        key: {
          keyVaultUrl: cMKKeyVaultKey.properties.keyUri
          name: cMKKeyName
        }
      }
    } : null
    managedResourceGroupName: !empty(managedResourceGroupName) ? managedResourceGroupName : null
    managedVirtualNetwork: managedVirtualNetwork ? 'default' : null
    managedVirtualNetworkSettings: managedVirtualNetwork ? {
      allowedAadTenantIdsForLinking: allowedAadTenantIdsForLinking
      linkedAccessCheckOnTargetResource: linkedAccessCheckOnTargetResource
      preventDataExfiltration: preventDataExfiltration
    } : null
    publicNetworkAccess: managedVirtualNetwork ? publicNetworkAccess : null
    purviewConfiguration: !empty(purviewResourceID) ? {
      purviewResourceId: purviewResourceID
    } : null
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: !empty(sqlAdministratorLoginPassword) ? sqlAdministratorLoginPassword : null
    workspaceRepositoryConfiguration: workspaceRepositoryConfiguration
  }
}

// Workspace integration runtimes
module synapse_integrationRuntimes 'integration-runtimes/main.bicep' = [for (integrationRuntime, index) in integrationRuntimes: {
  name: '${uniqueString(deployment().name, location)}-Synapse-IntegrationRuntime-${index}'
  params: {
    workspaceName: workspace.name
    name: integrationRuntime.name
    type: integrationRuntime.type
    typeProperties: contains(integrationRuntime, 'typeProperties') ? integrationRuntime.typeProperties : {}
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

// Workspace encryption with customer managed keys
// - Assign Synapse Workspace MSI access to encryption key
module workspace_cmk_rbac './.bicep/nested_cmkRbac.bicep' = if (encryptionActivateWorkspace) {
  name: '${workspace.name}-cmk-rbac'
  params: {
    workspaceIndentityPrincipalId: workspace.identity.principalId
    keyvaultName: !empty(cMKKeyVaultResourceId) ? cMKKeyVault.name : ''
    usesRbacAuthorization: !empty(cMKKeyVaultResourceId) ? cMKKeyVault.properties.enableRbacAuthorization : true
  }
  scope: encryptionActivateWorkspace ? resourceGroup(split(cMKKeyVaultResourceId, '/')[2], split(cMKKeyVaultResourceId, '/')[4]) : resourceGroup()
}

// - Workspace encryption - Activate Workspace
module workspace_key './keys/main.bicep' = if (encryptionActivateWorkspace) {
  name: '${workspace.name}-cmk-activation'
  params: {
    name: cMKKeyName
    isActiveCMK: true
    keyVaultResourceId: cMKKeyVaultResourceId
    workspaceName: workspace.name
  }
  dependsOn: [
    workspace_cmk_rbac
  ]
}

// Resource Lock
resource workspace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${workspace.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: workspace
}

// RBAC
module workspace_rbac '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Workspace-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: workspace.id
  }
}]

// Endpoints
module workspace_privateEndpoints '../../network/private-endpoints/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-Workspace-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(workspace.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: workspace.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: contains(privateEndpoint, 'lock') ? privateEndpoint.lock : lock
    privateDnsZoneGroup: contains(privateEndpoint, 'privateDnsZoneGroup') ? privateEndpoint.privateDnsZoneGroup : {}
    roleAssignments: contains(privateEndpoint, 'roleAssignments') ? privateEndpoint.roleAssignments : []
    tags: contains(privateEndpoint, 'tags') ? privateEndpoint.tags : {}
    manualPrivateLinkServiceConnections: contains(privateEndpoint, 'manualPrivateLinkServiceConnections') ? privateEndpoint.manualPrivateLinkServiceConnections : []
    customDnsConfigs: contains(privateEndpoint, 'customDnsConfigs') ? privateEndpoint.customDnsConfigs : []
    ipConfigurations: contains(privateEndpoint, 'ipConfigurations') ? privateEndpoint.ipConfigurations : []
    applicationSecurityGroups: contains(privateEndpoint, 'applicationSecurityGroups') ? privateEndpoint.applicationSecurityGroups : []
    customNetworkInterfaceName: contains(privateEndpoint, 'customNetworkInterfaceName') ? privateEndpoint.customNetworkInterfaceName : ''
  }
}]

// Diagnostics Settings
resource workspace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    logs: diagnosticsLogs
  }
  scope: workspace
}

@description('The resource ID of the deployed Synapse Workspace.')
output resourceID string = workspace.id

@description('The name of the deployed Synapse Workspace.')
output name string = workspace.name

@description('The resource group of the deployed Synapse Workspace.')
output resourceGroupName string = resourceGroup().name

@description('The workspace connectivity endpoints.')
output connectivityEndpoints object = workspace.properties.connectivityEndpoints

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = contains(workspace.identity, 'principalId') ? workspace.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = workspace.location
