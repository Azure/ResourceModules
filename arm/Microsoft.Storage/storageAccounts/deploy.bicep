@maxLength(24)
@description('Optional. Name of the Storage Account.')
param name string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@allowed([
  'Storage'
  'StorageV2'
  'BlobStorage'
  'FileStorage'
  'BlockBlobStorage'
])
@description('Optional. Type of Storage Account to create.')
param storageAccountKind string = 'StorageV2'

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
@description('Optional. Storage Account Sku Name.')
param storageAccountSku string = 'Standard_GRS'

@allowed([
  'Hot'
  'Cool'
])
@description('Optional. Storage Account Access Tier.')
param storageAccountAccessTier string = 'Hot'

@description('Optional. Provides the identity based authentication settings for Azure Files.')
param azureFilesIdentityBasedAuthentication object = {}

@description('Optional. Virtual Network Identifier used to create a service endpoint.')
param vNetId string = ''

@description('Optional. Configuration Details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible')
param privateEndpoints array = []

@description('Optional. The Storage Account ManagementPolicies Rules.')
param managementPolicyRules array = []

@description('Optional. Networks ACLs, this value contains IPs to whitelist and/or Subnet information. For security reasons, it is recommended to set the DefaultAction Deny')
param networkAcls object = {}

@description('Optional. A boolean indicating whether or not the service applies a secondary layer of encryption with platform managed keys for data at rest. For security reasons, it is recommended to set it to true.')
param requireInfrastructureEncryption bool = true

@description('Optional. Blob service and containers to deploy')
param blobServices object = {}

@description('Optional. File service and shares to deploy')
param fileServices object = {}

@description('Optional. Queue service and queues to create.')
param queueServices object = {}

@description('Optional. Table service and tables to create.')
param tableServices object = {}

@description('Optional. Indicates whether public access is enabled for all blobs or containers in the storage account. For security reasons, it is recommended to set it to false.')
param allowBlobPublicAccess bool = false

@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
@description('Optional. Set the minimum TLS version on request to storage.')
param minimumTlsVersion string = 'TLS1_2'

@description('Optional. If true, enables Hierarchical Namespace for the storage account')
param enableHierarchicalNamespace bool = false

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

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Generated. Do not provide a value! This date value is used to generate a SAS token to access the modules.')
param basetime string = utcNow('u')

@description('Optional. Allows https traffic only to storage service if sets to true.')
param supportsHttpsTrafficOnly bool = true

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'Transaction'
])
param metricsToEnable array = [
  'Transaction'
]

var diagnosticsMetrics = [for metric in metricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var virtualNetworkRules = [for index in range(0, (empty(networkAcls) ? 0 : length(networkAcls.virtualNetworkRules))): {
  id: '${vNetId}/subnets/${networkAcls.virtualNetworkRules[index].subnet}'
}]
var networkAcls_var = {
  bypass: (empty(networkAcls) ? null : networkAcls.bypass)
  defaultAction: (empty(networkAcls) ? null : networkAcls.defaultAction)
  virtualNetworkRules: (empty(networkAcls) ? null : virtualNetworkRules)
  ipRules: (empty(networkAcls) ? null : ((length(networkAcls.ipRules) == 0) ? null : networkAcls.ipRules))
}
var azureFilesIdentityBasedAuthentication_var = azureFilesIdentityBasedAuthentication

var maxNameLength = 24
var uniqueStoragenameUntrim = '${uniqueString('Storage Account${basetime}')}'
var uniqueStoragename = length(uniqueStoragenameUntrim) > maxNameLength ? substring(uniqueStoragenameUntrim, 0, maxNameLength) : uniqueStoragenameUntrim

var saBaseProperties = {
  encryption: {
    keySource: 'Microsoft.Storage'
    services: {
      blob: (((storageAccountKind == 'BlockBlobStorage') || (storageAccountKind == 'BlobStorage') || (storageAccountKind == 'StorageV2') || (storageAccountKind == 'Storage')) ? json('{"enabled": true}') : null)
      file: (((storageAccountKind == 'FileStorage') || (storageAccountKind == 'StorageV2') || (storageAccountKind == 'Storage')) ? json('{"enabled": true}') : null)
    }
  }
  accessTier: (storageAccountKind == 'Storage') ? null : storageAccountAccessTier
  supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
  isHnsEnabled: ((!enableHierarchicalNamespace) ? null : enableHierarchicalNamespace)
  minimumTlsVersion: minimumTlsVersion
  networkAcls: (empty(networkAcls) ? null : networkAcls_var)
  allowBlobPublicAccess: allowBlobPublicAccess
  requireInfrastructureEncryption: requireInfrastructureEncryption
}
var saOptIdBasedAuthProperties = {
  azureFilesIdentityBasedAuthentication: azureFilesIdentityBasedAuthentication_var
}
var saProperties = (empty(azureFilesIdentityBasedAuthentication) ? saBaseProperties : union(saBaseProperties, saOptIdBasedAuthProperties))

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: !empty(name) ? name : uniqueStoragename
  location: location
  kind: storageAccountKind
  sku: {
    name: storageAccountSku
  }
  identity: identity
  tags: tags
  properties: saProperties
}

resource storageAccount_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: '${storageAccount.name}-diagnosticSettings'
  properties: {
    storageAccountId: empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId
    workspaceId: empty(diagnosticWorkspaceId) ? null : diagnosticWorkspaceId
    eventHubAuthorizationRuleId: empty(diagnosticEventHubAuthorizationRuleId) ? null : diagnosticEventHubAuthorizationRuleId
    eventHubName: empty(diagnosticEventHubName) ? null : diagnosticEventHubName
    metrics: diagnosticsMetrics
  }
  scope: storageAccount
}

resource storageAccount_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${storageAccount.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: storageAccount
}

module storageAccount_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Storage-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: storageAccount.id
  }
}]

module storageAccount_privateEndpoints '.bicep/nested_privateEndpoint.bicep' = [for (endpoint, index) in privateEndpoints: if (!empty(privateEndpoints)) {
  name: '${uniqueString(deployment().name, location)}-Storage-PrivateEndpoints-${index}'
  params: {
    privateEndpointResourceId: storageAccount.id
    privateEndpointVnetLocation: (empty(privateEndpoints) ? 'dummy' : reference(split(endpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location)
    privateEndpointObj: endpoint
    tags: tags
  }
}]

// Lifecycle Policy
module storageAccount_managementPolicies 'managementPolicies/deploy.bicep' = if (!empty(managementPolicyRules)) {
  name: '${uniqueString(deployment().name, location)}-Storage-ManagementPolicies'
  params: {
    storageAccountName: storageAccount.name
    rules: managementPolicyRules
  }
}

// Containers
module storageAccount_blobServices 'blobServices/deploy.bicep' = if (!empty(blobServices)) {
  name: '${uniqueString(deployment().name, location)}-Storage-BlobServices'
  params: {
    storageAccountName: storageAccount.name
    containers: contains(blobServices, 'containers') ? blobServices.containers : []
    automaticSnapshotPolicyEnabled: contains(blobServices, 'automaticSnapshotPolicyEnabled') ? blobServices.automaticSnapshotPolicyEnabled : false
    deleteRetentionPolicy: contains(blobServices, 'deleteRetentionPolicy') ? blobServices.deleteRetentionPolicy : true
    deleteRetentionPolicyDays: contains(blobServices, 'deleteRetentionPolicyDays') ? blobServices.deleteRetentionPolicyDays : 7
    diagnosticLogsRetentionInDays: contains(blobServices, 'diagnosticLogsRetentionInDays') ? blobServices.diagnosticLogsRetentionInDays : 365
    diagnosticStorageAccountId: contains(blobServices, 'diagnosticStorageAccountId') ? blobServices.diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: contains(blobServices, 'diagnosticEventHubAuthorizationRuleId') ? blobServices.diagnosticEventHubAuthorizationRuleId : ''
    diagnosticEventHubName: contains(blobServices, 'diagnosticEventHubName') ? blobServices.diagnosticEventHubName : ''
    logsToEnable: contains(blobServices, 'logsToEnable') ? blobServices.logsToEnable : []
    metricsToEnable: contains(blobServices, 'metricsToEnable') ? blobServices.metricsToEnable : []
    diagnosticWorkspaceId: contains(blobServices, 'diagnosticWorkspaceId') ? blobServices.diagnosticWorkspaceId : ''
  }
}

// File Shares
module storageAccount_fileServices 'fileServices/deploy.bicep' = if (!empty(fileServices)) {
  name: '${uniqueString(deployment().name, location)}-Storage-FileServices'
  params: {
    storageAccountName: storageAccount.name
    diagnosticLogsRetentionInDays: contains(fileServices, 'diagnosticLogsRetentionInDays') ? fileServices.diagnosticLogsRetentionInDays : 365
    diagnosticStorageAccountId: contains(fileServices, 'diagnosticStorageAccountId') ? fileServices.diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: contains(fileServices, 'diagnosticEventHubAuthorizationRuleId') ? fileServices.diagnosticEventHubAuthorizationRuleId : ''
    diagnosticEventHubName: contains(fileServices, 'diagnosticEventHubName') ? fileServices.diagnosticEventHubName : ''
    logsToEnable: contains(fileServices, 'logsToEnable') ? fileServices.logsToEnable : []
    metricsToEnable: contains(fileServices, 'metricsToEnable') ? fileServices.metricsToEnable : []
    protocolSettings: contains(fileServices, 'protocolSettings') ? fileServices.protocolSettings : {}
    shareDeleteRetentionPolicy: contains(fileServices, 'shareDeleteRetentionPolicy') ? fileServices.shareDeleteRetentionPolicy : {
      enabled: true
      days: 7
    }
    shares: contains(fileServices, 'shares') ? fileServices.shares : []
    diagnosticWorkspaceId: contains(fileServices, 'diagnosticWorkspaceId') ? fileServices.diagnosticWorkspaceId : ''
  }
}

// Queue
module storageAccount_queueServices 'queueServices/deploy.bicep' = if (!empty(queueServices)) {
  name: '${uniqueString(deployment().name, location)}-Storage-QueueServices'
  params: {
    storageAccountName: storageAccount.name
    diagnosticLogsRetentionInDays: contains(queueServices, 'diagnosticLogsRetentionInDays') ? queueServices.diagnosticLogsRetentionInDays : 365
    diagnosticStorageAccountId: contains(queueServices, 'diagnosticStorageAccountId') ? queueServices.diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: contains(queueServices, 'diagnosticEventHubAuthorizationRuleId') ? queueServices.diagnosticEventHubAuthorizationRuleId : ''
    diagnosticEventHubName: contains(queueServices, 'diagnosticEventHubName') ? queueServices.diagnosticEventHubName : ''
    logsToEnable: contains(queueServices, 'logsToEnable') ? queueServices.logsToEnable : []
    metricsToEnable: contains(queueServices, 'metricsToEnable') ? queueServices.metricsToEnable : []
    queues: contains(queueServices, 'queues') ? queueServices.queues : []
    diagnosticWorkspaceId: contains(queueServices, 'diagnosticWorkspaceId') ? queueServices.diagnosticWorkspaceId : ''
  }
}

// Table
module storageAccount_tableServices 'tableServices/deploy.bicep' = if (!empty(tableServices)) {
  name: '${uniqueString(deployment().name, location)}-Storage-TableServices'
  params: {
    storageAccountName: storageAccount.name
    diagnosticLogsRetentionInDays: contains(tableServices, 'diagnosticLogsRetentionInDays') ? tableServices.diagnosticLogsRetentionInDays : 365
    diagnosticStorageAccountId: contains(tableServices, 'diagnosticStorageAccountId') ? tableServices.diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: contains(tableServices, 'diagnosticEventHubAuthorizationRuleId') ? tableServices.diagnosticEventHubAuthorizationRuleId : ''
    diagnosticEventHubName: contains(tableServices, 'diagnosticEventHubName') ? tableServices.diagnosticEventHubName : ''
    logsToEnable: contains(tableServices, 'logsToEnable') ? tableServices.logsToEnable : []
    metricsToEnable: contains(tableServices, 'metricsToEnable') ? tableServices.metricsToEnable : []
    tables: contains(tableServices, 'tables') ? tableServices.tables : []
    diagnosticWorkspaceId: contains(tableServices, 'diagnosticWorkspaceId') ? tableServices.diagnosticWorkspaceId : ''
  }
}

@description('The resource ID of the deployed storage account')
output resourceId string = storageAccount.id

@description('The name of the deployed storage account')
output name string = storageAccount.name

@description('The resource group of the deployed storage account')
output resourceGroupName string = resourceGroup().name

@description('The primary blob endpoint reference if blob services are deployed.')
output primaryBlobEndpoint string = !empty(blobServices) && contains(blobServices, 'containers') ? reference('Microsoft.Storage/storageAccounts/${storageAccount.name}', '2019-04-01').primaryEndpoints.blob : ''

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(storageAccount.identity, 'principalId') ? storageAccount.identity.principalId : ''
