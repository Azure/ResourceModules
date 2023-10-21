metadata name = 'Machine Learning Services Workspaces'
metadata description = 'This module deploys a Machine Learning Services Workspace.'
metadata owner = 'Azure/module-maintainers'

// ================ //
// Parameters       //
// ================ //
@sys.description('Required. The name of the machine learning workspace.')
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Required. Specifies the SKU, also referred as \'edition\' of the Azure Machine Learning workspace.')
@allowed([
  'Free'
  'Basic'
  'Standard'
  'Premium'
])
param sku string

@sys.description('Required. The resource ID of the associated Storage Account.')
param associatedStorageAccountResourceId string

@sys.description('Required. The resource ID of the associated Key Vault.')
param associatedKeyVaultResourceId string

@sys.description('Required. The resource ID of the associated Application Insights.')
param associatedApplicationInsightsResourceId string

@sys.description('Optional. The resource ID of the associated Container Registry.')
param associatedContainerRegistryResourceId string = ''

@sys.description('Optional. The lock settings of the service.')
param lock lockType

@sys.description('Optional. The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service.')
param hbiWorkspace bool = false

@sys.description('Optional. The flag to indicate whether to allow public access when behind VNet.')
param allowPublicAccessWhenBehindVnet bool = false

@sys.description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@sys.description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@sys.description('Optional. Computes to create respectively attach to the workspace.')
param computes array = []

@sys.description('Optional. Resource tags.')
param tags object = {}

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// Identity
@sys.description('Conditional. Enables system assigned managed identity on the resource. Required if `userAssignedIdentities` is not provided.')
param systemAssignedIdentity bool = false

@sys.description('Conditional. The ID(s) to assign to the resource. Required if `systemAssignedIdentity` is set to false.')
param userAssignedIdentities object = {}

// Diagnostic Settings
@sys.description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@sys.description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@sys.description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@sys.description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@sys.description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
  'allLogs'
  'AmlComputeClusterEvent'
  'AmlComputeClusterNodeEvent'
  'AmlComputeJobEvent'
  'AmlComputeCpuGpuUtilization'
  'AmlRunStatusChangedEvent'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@sys.description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@sys.description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

@sys.description('Optional. The description of this workspace.')
param description string = ''

@sys.description('Optional. URL for the discovery service to identify regional endpoints for machine learning experimentation services.')
param discoveryUrl string = ''

@sys.description('Conditional. The resource ID of a key vault to reference a customer managed key for encryption from. Required if \'cMKKeyName\' is not empty.')
param cMKKeyVaultResourceId string = ''

@sys.description('Optional. The name of the customer managed key to use for encryption.')
param cMKKeyName string = ''

@sys.description('Optional. The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.')
param cMKKeyVersion string = ''

@sys.description('Optional. User assigned identity to use when fetching the customer managed key. If not provided, a system-assigned identity can be used - but must be given access to the referenced key vault first.')
param cMKUserAssignedIdentityResourceId string = ''

@sys.description('Optional. The compute name for image build.')
param imageBuildCompute string = ''

@sys.description('Conditional. The user assigned identity resource ID that represents the workspace identity. Required if \'userAssignedIdentities\' is not empty and may not be used if \'systemAssignedIdentity\' is enabled.')
param primaryUserAssignedIdentity string = ''

@sys.description('Optional. The service managed resource settings.')
param serviceManagedResourcesSettings object = {}

@sys.description('Optional. The list of shared private link resources in this workspace.')
param sharedPrivateLinkResources array = []

@sys.description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

// ================//
// Variables       //
// ================//
var enableReferencedModulesTelemetry = false

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : any(null)
} : any(null)

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

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
}]

// ================//
// Deployments     //
// ================//
var builtInRoleNames = {
  'AzureML Compute Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e503ece1-11d0-4e8e-8e2c-7a6c3bf38815')
  'AzureML Data Scientist': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f6c7c914-8db3-469d-8ca1-694a8f32e121')
  'AzureML Metrics Writer (preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '635dd51f-9968-44d3-b7fb-6d9a6bd613ae')
  'AzureML Registry User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1823dd4f-9b8c-4ab6-ab4e-7397a3684615')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Data Labeling - Labeler': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c6decf44-fd0a-444c-a844-d653c394e7ab')
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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(cMKKeyVaultResourceId)) {
  name: last(split((!empty(cMKKeyVaultResourceId) ? cMKKeyVaultResourceId : 'dummyVault'), '/'))!
  scope: resourceGroup(split((!empty(cMKKeyVaultResourceId) ? cMKKeyVaultResourceId : '//'), '/')[2], split((!empty(cMKKeyVaultResourceId) ? cMKKeyVaultResourceId : '////'), '/')[4])

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(cMKKeyName)) {
    name: !empty(cMKKeyName) ? cMKKeyName : 'dummyKey'
  }
}

resource workspace 'Microsoft.MachineLearningServices/workspaces@2022-10-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
    tier: sku
  }
  identity: identity
  properties: {
    friendlyName: name
    storageAccount: associatedStorageAccountResourceId
    keyVault: associatedKeyVaultResourceId
    applicationInsights: associatedApplicationInsightsResourceId
    containerRegistry: !empty(associatedContainerRegistryResourceId) ? associatedContainerRegistryResourceId : null
    hbiWorkspace: hbiWorkspace
    allowPublicAccessWhenBehindVnet: allowPublicAccessWhenBehindVnet
    description: description
    discoveryUrl: discoveryUrl
    encryption: !empty(cMKKeyName) ? {
      status: 'Enabled'
      identity: !empty(cMKUserAssignedIdentityResourceId) ? {
        userAssignedIdentity: cMKUserAssignedIdentityResourceId
      } : null
      keyVaultProperties: {
        keyVaultArmId: cMKKeyVaultResourceId
        keyIdentifier: !empty(cMKKeyVersion) ? '${cMKKeyVault::cMKKey.properties.keyUri}/${cMKKeyVersion}' : cMKKeyVault::cMKKey.properties.keyUriWithVersion
      }
    } : null
    imageBuildCompute: imageBuildCompute
    primaryUserAssignedIdentity: primaryUserAssignedIdentity
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(privateEndpoints) ? 'Disabled' : 'Enabled')
    serviceManagedResourcesSettings: serviceManagedResourcesSettings
    sharedPrivateLinkResources: sharedPrivateLinkResources // Note: This property is not idempotent. Neither with [] or `null`
  }
}

module workspace_computes 'compute/main.bicep' = [for compute in computes: {
  name: '${workspace.name}-${compute.name}-compute'
  params: {
    machineLearningWorkspaceName: workspace.name
    name: compute.name
    location: compute.location
    sku: contains(compute, 'sku') ? compute.sku : ''
    systemAssignedIdentity: contains(compute, 'systemAssignedIdentity') ? compute.systemAssignedIdentity : false
    userAssignedIdentities: contains(compute, 'userAssignedIdentities') ? compute.userAssignedIdentities : {}
    tags: contains(compute, 'tags') ? compute.tags : {}
    deployCompute: contains(compute, 'deployCompute') ? compute.deployCompute : true
    computeLocation: contains(compute, 'computeLocation') ? compute.computeLocation : ''
    description: contains(compute, 'description') ? compute.description : ''
    disableLocalAuth: compute.disableLocalAuth
    resourceId: contains(compute, 'resourceId') ? compute.resourceId : ''
    computeType: compute.computeType
    properties: contains(compute, 'properties') ? compute.properties : {}
  }
  dependsOn: [
    workspace_privateEndpoints
  ]
}]

resource workspace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: workspace
}

resource workspace_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: workspace
}

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
  }
}]

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
}]

// ================//
// Outputs         //
// ================//

@sys.description('The resource ID of the machine learning service.')
output resourceId string = workspace.id

@sys.description('The resource group the machine learning service was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The name of the machine learning service.')
output name string = workspace.name

@sys.description('The principal ID of the system assigned identity.')
output principalId string = (!empty(identity) && contains(identity.type, 'SystemAssigned')) ? workspace.identity.principalId : ''

@sys.description('The location the resource was deployed into.')
output location string = workspace.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @sys.description('Optional. Specify the name of lock.')
  name: string?

  @sys.description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @sys.description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
  roleDefinitionIdOrName: string

  @sys.description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @sys.description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device' | null)?

  @sys.description('Optional. The description of the role assignment.')
  description: string?

  @sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @sys.description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @sys.description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
