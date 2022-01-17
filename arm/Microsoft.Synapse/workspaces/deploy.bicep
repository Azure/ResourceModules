// Parameters
@maxLength(50)
@description('Required. The name of the Synapse Workspace.')
param name string

@description('Optional. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable or Disable AzureADOnlyAuthentication on All Workspace subresource')
param azureADOnlyAuthentication bool = false

@description('Optional. AAD object Id of initial workspace admin.')
param initialWorkspaceAdminObjectId string = ''

@description('Required. Name of the default ADLS Gen2 storage account.')
param defaultDataLakeStorageAccountName string

@description('Required. The default ADLS Gen2 file system.')
param defaultDataLakeStorageFilesystem string

@description('Optional. Create managed private endpoint to the default storage account or not. If Yes is selected, a managed private endpoint connection request is sent to the workspace\'s primary Data Lake Storage Gen2 account for Spark pools to access data. This must be approved by an owner of the storage account.')
param defaultDataLakeStorageCreateManagedPrivateEndpoint bool = false

@description('Optional. Double encryption using a customer-managed key.')
param encryption bool = false

@description('Optional. Keyvault where the encryption key is stored.')
param encryptionKeyVaultName string = ''

@description('Optional. Keyvault resource group name.')
param encryptionKeyVaultResourceGroupName string = ''

@description('Optional. The encryption key name in KeyVault.')
param encryptionKeyName string = ''

@description('Optional. Use System Assigned Managed identity that will be used to access your customer-managed key stored in key vault.')
param encryptionUseSystemAssignedIdentity bool = false

@description('Optional. The ID of User Assigned Managed identity that will be used to access your customer-managed key stored in key vault.')
param encryptionUserAssignedIdentity string = ''

@description('Optional. Activate workspace by adding the system managed identity in the KeyVault containing the customer managed key and activating the workspace.')
param encryptionActivateWorkspace bool = false

@maxLength(90)
@description('Optional. Workspace managed resource group. The resource group name uniquely identifies the resource group within the user subscriptionId. The resource group name must be no longer than 90 characters long, and must be alphanumeric characters (Char.IsLetterOrDigit()) and \'-\', \'_\', \'(\', \')\' and\'.\'. Note that the name cannot end with \'.\'')
param managedResourceGroupName string = ''

@description('Optional. Enable this to ensure that connection from your workspace to your data sources use Azure Private Links. You can create managed private endpoints to your data sources.')
param managedVirtualNetwork bool = false

@description('Optional. Allowed Aad Tenant Ids For Linking.')
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
param purviewResourceId string = ''

@description('Required. Login for administrator access to the workspace\'s SQL pools.')
param sqlAdministratorLogin string

@description('Optional. Password for administrator access to the workspace\'s SQL pools. If you don\'t provide a password, one will be automatically generated. You can change the password later.')
param sqlAdministratorLoginPassword string = ''

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of log analytics.')
param workspaceId string = ''

@description('Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param eventHubAuthorizationRuleId string = ''

@description('Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param eventHubName string = ''

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'SynapseRbacOperations'
  'GatewayApiRequests'
  'BuiltinSqlReqsEnded'
  'IntegrationPipelineRuns'
  'IntegrationActivityRuns'
  'IntegrationTriggerRuns'
])
param logsToEnable array = [
  'SynapseRbacOperations'
  'GatewayApiRequests'
  'BuiltinSqlReqsEnded'
  'IntegrationPipelineRuns'
  'IntegrationActivityRuns'
  'IntegrationTriggerRuns'
]

// Variables
var userAssignedIdentitiesUnion = union(userAssignedIdentities, !empty(encryptionUserAssignedIdentity) ? {
  '${encryptionUserAssignedIdentity}': {}
} : {})

var identityType = (!empty(userAssignedIdentitiesUnion) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')

var identity = {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentitiesUnion) ? userAssignedIdentitiesUnion : null
}

var keyVaultUrl = 'https://${encryptionKeyVaultName}.vault.azure.net/keys/${encryptionKeyName}'

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: name
  location: location
  identity: identity
  tags: tags
  properties: {
    azureADOnlyAuthentication: (azureADOnlyAuthentication) ? azureADOnlyAuthentication : null
    cspWorkspaceAdminProperties: (!empty(initialWorkspaceAdminObjectId)) ? {
      initialWorkspaceAdminObjectId: initialWorkspaceAdminObjectId
    } : null
    defaultDataLakeStorage: {
      accountUrl: 'https://${defaultDataLakeStorageAccountName}.dfs.core.windows.net'
      filesystem: defaultDataLakeStorageFilesystem
      createManagedPrivateEndpoint: (managedVirtualNetwork) ? defaultDataLakeStorageCreateManagedPrivateEndpoint : null
    }
    encryption: (encryption) ? {
      cmk: {
        kekIdentity: {
          userAssignedIdentity: (!empty(encryptionUserAssignedIdentity)) ? encryptionUserAssignedIdentity : null
          useSystemAssignedIdentity: (encryptionUseSystemAssignedIdentity) ? true : false
        }
        key: {
          keyVaultUrl: keyVaultUrl
          name: encryptionKeyName
        }
      }
    } : null
    managedResourceGroupName: (!empty(managedResourceGroupName)) ? managedResourceGroupName : null
    managedVirtualNetwork: (managedVirtualNetwork) ? 'default' : null
    managedVirtualNetworkSettings: (managedVirtualNetwork) ? {
      allowedAadTenantIdsForLinking: allowedAadTenantIdsForLinking
      linkedAccessCheckOnTargetResource: linkedAccessCheckOnTargetResource
      preventDataExfiltration: preventDataExfiltration
    } : null
    publicNetworkAccess: (managedVirtualNetwork) ? publicNetworkAccess : null
    purviewConfiguration: (!empty(purviewResourceId)) ? {
      purviewResourceId: purviewResourceId
    } : null
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: (!empty(sqlAdministratorLoginPassword)) ? sqlAdministratorLoginPassword : null
  }
}

// // Workspace encryption - Assign Workspace System Identity Keyvault Crypto Reader at Encryption Keyvault
// resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = if (encryptionActivateWorkspace) {
//   name: encryptionKeyVaultName
//   scope: az.resourceGroup(encryptionKeyVaultResourceGroupName, encryptionKeyVaultName)
// }

// // Assign role Key Vault Crypto User
// resource workspace_cmk_rbac 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = if (encryptionActivateWorkspace) {
//   name: guid(workspace.name, deployment().name)
//   properties: {
//     roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '12338af0-0e69-4776-bea7-57ae8d297424')
//     principalId: workspace.identity.principalId
//   }
//   scope: keyVault
// }

module workspace_cmk_rbac '.bicep/nested_cmkRbac.bicep' = if (encryptionActivateWorkspace) {
  name: '${workspace.name}-cmk-rbac'
  params: {
    workspaceIdentity: workspace.identity.principalId
    keyvaultName: encryptionKeyVaultName
  }
  scope: az.resourceGroup(encryptionKeyVaultResourceGroupName, encryptionKeyVaultName)
}

// Workspace encryption - Activate Workspace
module workspace_cmk 'keys/deploy.bicep' = if (encryptionActivateWorkspace) {
  name: '${workspace.name}-cmk-activation'
  params: {
    isActiveCMK: true
    keyVaultUrl: keyVaultUrl
    name: encryptionKeyName
    workspaceName: workspace.name
  }
  dependsOn: [
    workspace_cmk_rbac
  ]
}

// Resource Lock
resource workspace_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${workspace.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: workspace
}

// RBAC
module workspace_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: workspace.id
  }
}]

// Private Endpoints
module workspace_privateEndpoints '.bicep/nested_privateEndpoint.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-PrivateEndpoint-${index}'
  params: {
    privateEndpointResourceId: workspace.id
    privateEndpointVnetLocation: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    privateEndpointObj: privateEndpoint
    tags: tags
  }
}]

// Diagnostics Settings
resource workspace_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(workspaceId) || !empty(eventHubAuthorizationRuleId) || !empty(eventHubName)) {
  name: '${workspace.name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(workspaceId) ? workspaceId : null
    eventHubAuthorizationRuleId: !empty(eventHubAuthorizationRuleId) ? eventHubAuthorizationRuleId : null
    eventHubName: !empty(eventHubName) ? eventHubName : null
    logs: diagnosticsLogs
  }
  scope: workspace
}

@description('The resource ID of the deployed Synapse Workspace.')
output workspaceResourceId string = workspace.id

@description('The name of the deployed Synapse Workspace.')
output workspaceName string = workspace.name

@description('The resource group of the deployed Synapse Workspace.')
output workspaceResourceGroup string = resourceGroup().name

@description('Connectivity endpoints.')
output workspaceConnectivityEndpoints object = workspace.properties.connectivityEndpoints
