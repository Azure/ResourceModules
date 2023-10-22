metadata name = 'Synapse Workspaces'
metadata description = 'This module deploys a Synapse Workspace.'
metadata owner = 'Azure/module-maintainers'

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

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
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

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs' && item != ''): {
  category: category
  enabled: true
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
  }
] : contains(diagnosticLogCategoriesToEnable, '') ? [] : diagnosticsLogsSpecified

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(cMKKeyVaultResourceId)) {
  name: last(split((!empty(cMKKeyVaultResourceId) ? cMKKeyVaultResourceId : 'dummyVault'), '/'))!
  scope: resourceGroup(split((!empty(cMKKeyVaultResourceId) ? cMKKeyVaultResourceId : '//'), '/')[2], split((!empty(cMKKeyVaultResourceId) ? cMKKeyVaultResourceId : '////'), '/')[4])

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(cMKKeyName)) {
    name: !empty(cMKKeyName) ? cMKKeyName : 'dummyKey'
  }
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
          keyVaultUrl: cMKKeyVault::cMKKey.properties.keyUri
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
module synapse_integrationRuntimes 'integration-runtime/main.bicep' = [for (integrationRuntime, index) in integrationRuntimes: {
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
module workspace_cmk_rbac 'modules/nested_cmkRbac.bicep' = if (encryptionActivateWorkspace) {
  name: '${workspace.name}-cmk-rbac'
  params: {
    workspaceIndentityPrincipalId: workspace.identity.principalId
    keyvaultName: !empty(cMKKeyVaultResourceId) ? cMKKeyVault.name : ''
    usesRbacAuthorization: !empty(cMKKeyVaultResourceId) ? cMKKeyVault.properties.enableRbacAuthorization : true
  }
  scope: encryptionActivateWorkspace ? resourceGroup(split(cMKKeyVaultResourceId, '/')[2], split(cMKKeyVaultResourceId, '/')[4]) : resourceGroup()
}

// - Workspace encryption - Activate Workspace
module workspace_key 'key/main.bicep' = if (encryptionActivateWorkspace) {
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
resource workspace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: workspace
}

// RBAC
resource workspace_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(workspace.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: workspace
}]

// Endpoints
module workspace_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-Workspace-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(workspace.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: workspace.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: contains(privateEndpoint, 'location') ? privateEndpoint.location : reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: privateEndpoint.?lock ?? lock
    privateDnsZoneGroupName: contains(privateEndpoint, 'privateDnsZoneGroupName') ? privateEndpoint.privateDnsZoneGroupName : 'default'
    privateDnsZoneResourceIds: contains(privateEndpoint, 'privateDnsZoneResourceIds') ? privateEndpoint.privateDnsZoneResourceIds : []
    roleAssignments: contains(privateEndpoint, 'roleAssignments') ? privateEndpoint.roleAssignments : []
    tags: contains(privateEndpoint, 'tags') ? privateEndpoint.tags : {}
    manualPrivateLinkServiceConnections: contains(privateEndpoint, 'manualPrivateLinkServiceConnections') ? privateEndpoint.manualPrivateLinkServiceConnections : []
    customDnsConfigs: contains(privateEndpoint, 'customDnsConfigs') ? privateEndpoint.customDnsConfigs : []
    ipConfigurations: contains(privateEndpoint, 'ipConfigurations') ? privateEndpoint.ipConfigurations : []
    applicationSecurityGroupResourceIds: contains(privateEndpoint, 'applicationSecurityGroupResourceIds') ? privateEndpoint.applicationSecurityGroupResourceIds : []
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

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device' | null)?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
