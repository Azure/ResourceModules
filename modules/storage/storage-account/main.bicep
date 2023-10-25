metadata name = 'Storage Accounts'
metadata description = 'This module deploys a Storage Account.'
metadata owner = 'Azure/module-maintainers'

@maxLength(24)
@description('Required. Name of the Storage Account.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

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
param kind string = 'StorageV2'

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
param skuName string = 'Standard_GRS'

@allowed([
  'Premium'
  'Hot'
  'Cool'
])
@description('Conditional. Required if the Storage Account kind is set to BlobStorage. The access tier is used for billing. The "Premium" access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type.')
param accessTier string = 'Hot'

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Allow large file shares if sets to \'Enabled\'. It cannot be disabled once it is enabled. Only supported on locally redundant and zone redundant file shares. It cannot be set on FileStorage storage accounts (storage accounts for premium file shares).')
param largeFileSharesState string = 'Disabled'

@description('Optional. Provides the identity based authentication settings for Azure Files.')
param azureFilesIdentityBasedAuthentication object = {}

@description('Optional. A boolean flag which indicates whether the default authentication is OAuth or not.')
param defaultToOAuthAuthentication bool = false

@description('Optional. Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is null, which is equivalent to true.')
param allowSharedKeyAccess bool = true

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. The Storage Account ManagementPolicies Rules.')
param managementPolicyRules array = []

@description('Optional. Networks ACLs, this value contains IPs to whitelist and/or Subnet information. For security reasons, it is recommended to set the DefaultAction Deny.')
param networkAcls object = {}

@description('Optional. A Boolean indicating whether or not the service applies a secondary layer of encryption with platform managed keys for data at rest. For security reasons, it is recommended to set it to true.')
param requireInfrastructureEncryption bool = true

@description('Optional. Allow or disallow cross AAD tenant object replication.')
param allowCrossTenantReplication bool = true

@description('Optional. Sets the custom domain name assigned to the storage account. Name is the CNAME source.')
param customDomainName string = ''

@description('Optional. Indicates whether indirect CName validation is enabled. This should only be set on updates.')
param customDomainUseSubDomainName bool = false

@description('Optional. Allows you to specify the type of endpoint. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier.')
@allowed([
  ''
  'AzureDnsZone'
  'Standard'
])
param dnsEndpointType string = ''

@description('Optional. Blob service and containers to deploy.')
param blobServices object = {}

@description('Optional. File service and shares to deploy.')
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

@description('Conditional. If true, enables Hierarchical Namespace for the storage account. Required if enableSftp or enableNfsV3 is set to true.')
param enableHierarchicalNamespace bool = false

@description('Optional. If true, enables Secure File Transfer Protocol for the storage account. Requires enableHierarchicalNamespace to be true.')
param enableSftp bool = false

@description('Optional. Local users to deploy for SFTP authentication.')
param localUsers array = []

@description('Optional. Enables local users feature, if set to true.')
param isLocalUserEnabled bool = false

@description('Optional. If true, enables NFS 3.0 support for the storage account. Requires enableHierarchicalNamespace to be true.')
param enableNfsV3 bool = false

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet.')
@allowed([
  ''
  'AAD'
  'PrivateLink'
])
param allowedCopyScope string = ''

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@description('Optional. Allows HTTPS traffic only to storage service if sets to true.')
param supportsHttpsTrafficOnly bool = true

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'Transaction'
])
param diagnosticMetricsToEnable array = [
  'Transaction'
]

@description('Conditional. The resource ID of a key vault to reference a customer managed key for encryption from. Required if \'cMKKeyName\' is not empty.')
param cMKKeyVaultResourceId string = ''

@description('Optional. The name of the customer managed key to use for encryption. Cannot be deployed together with the parameter \'systemAssignedIdentity\' enabled.')
param cMKKeyName string = ''

@description('Conditional. User assigned identity to use when fetching the customer managed key. Required if \'cMKKeyName\' is not empty.')
param cMKUserAssignedIdentityResourceId string = ''

@description('Optional. The version of the customer managed key to reference for encryption. If not provided, latest is used.')
param cMKKeyVersion string = ''

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

@description('Optional. The SAS expiration period. DD.HH:MM:SS.')
param sasExpirationPeriod string = ''

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
}]

var supportsBlobService = kind == 'BlockBlobStorage' || kind == 'BlobStorage' || kind == 'StorageV2' || kind == 'Storage'
var supportsFileService = kind == 'FileStorage' || kind == 'StorageV2' || kind == 'Storage'

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')
var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Reader and Data Access': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c12c1c16-33a1-487b-954d-41c89c60f349')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'Storage Account Backup Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e5e2a7ff-d759-4cd2-bb51-3152d37e2eb1')
  'Storage Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab')
  'Storage Account Key Operator Service Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '81a9662b-bebf-436f-a333-f67b29880f12')
  'Storage Blob Data Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  'Storage Blob Data Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b')
  'Storage Blob Data Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1')
  'Storage Blob Delegator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'db58b8e5-c6ad-4a2a-8342-4190687cbf4a')
  'Storage File Data SMB Share Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0c867c2a-1d8c-454a-a3db-ab2ea1bdc8bb')
  'Storage File Data SMB Share Elevated Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a7264617-510b-434b-a828-9731dc254ea7')
  'Storage File Data SMB Share Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'aba4ae5f-2193-4029-9191-0cb91df5e314')
  'Storage Queue Data Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '974c5e8b-45b9-4653-ba55-5f855dd0fb88')
  'Storage Queue Data Message Processor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8a0f0c08-91a1-4084-bc3d-661d67233fed')
  'Storage Queue Data Message Sender': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c6a89b2d-59bc-44d0-9896-0f6e12d7b80a')
  'Storage Queue Data Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '19e7f393-937e-4f77-808e-94535e297925')
  'Storage Table Data Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0a9a7e1f-b9d0-4cc4-a60d-0319b160aaa3')
  'Storage Table Data Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '76199698-9eea-4c19-bc75-cec21354c6b6')
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

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(cMKKeyVaultResourceId)) {
  name: last(split((!empty(cMKKeyVaultResourceId) ? cMKKeyVaultResourceId : 'dummyVault'), '/'))!
  scope: resourceGroup(split((!empty(cMKKeyVaultResourceId) ? cMKKeyVaultResourceId : '//'), '/')[2], split((!empty(cMKKeyVaultResourceId) ? cMKKeyVaultResourceId : '////'), '/')[4])
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: name
  location: location
  kind: kind
  sku: {
    name: skuName
  }
  identity: identity
  tags: tags
  properties: {
    allowSharedKeyAccess: allowSharedKeyAccess
    defaultToOAuthAuthentication: defaultToOAuthAuthentication
    allowCrossTenantReplication: allowCrossTenantReplication
    allowedCopyScope: !empty(allowedCopyScope) ? allowedCopyScope : null
    customDomain: {
      name: customDomainName
      useSubDomainName: customDomainUseSubDomainName
    }
    dnsEndpointType: !empty(dnsEndpointType) ? dnsEndpointType : null
    isLocalUserEnabled: isLocalUserEnabled
    encryption: {
      keySource: !empty(cMKKeyName) ? 'Microsoft.Keyvault' : 'Microsoft.Storage'
      services: {
        blob: supportsBlobService ? {
          enabled: true
        } : null
        file: supportsFileService ? {
          enabled: true
        } : null
        table: {
          enabled: true
        }
        queue: {
          enabled: true
        }
      }
      requireInfrastructureEncryption: kind != 'Storage' ? requireInfrastructureEncryption : null
      keyvaultproperties: !empty(cMKKeyName) ? {
        keyname: cMKKeyName
        keyvaulturi: keyVault.properties.vaultUri
        keyversion: !empty(cMKKeyVersion) ? cMKKeyVersion : null
      } : null
      identity: !empty(cMKKeyName) ? {
        userAssignedIdentity: cMKUserAssignedIdentityResourceId
      } : null
    }
    accessTier: kind != 'Storage' ? accessTier : null
    sasPolicy: !empty(sasExpirationPeriod) ? {
      expirationAction: 'Log'
      sasExpirationPeriod: sasExpirationPeriod
    } : null
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
    isHnsEnabled: enableHierarchicalNamespace ? enableHierarchicalNamespace : null
    isSftpEnabled: enableSftp
    isNfsV3Enabled: enableNfsV3 ? enableNfsV3 : any('')
    largeFileSharesState: (skuName == 'Standard_LRS') || (skuName == 'Standard_ZRS') ? largeFileSharesState : null
    minimumTlsVersion: minimumTlsVersion
    networkAcls: !empty(networkAcls) ? {
      bypass: contains(networkAcls, 'bypass') ? networkAcls.bypass : null
      defaultAction: contains(networkAcls, 'defaultAction') ? networkAcls.defaultAction : null
      virtualNetworkRules: contains(networkAcls, 'virtualNetworkRules') ? networkAcls.virtualNetworkRules : []
      ipRules: contains(networkAcls, 'ipRules') ? networkAcls.ipRules : []
    } : null
    allowBlobPublicAccess: allowBlobPublicAccess
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(privateEndpoints) && empty(networkAcls) ? 'Disabled' : null)
    azureFilesIdentityBasedAuthentication: !empty(azureFilesIdentityBasedAuthentication) ? azureFilesIdentityBasedAuthentication : null
  }
}

resource storageAccount_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
  }
  scope: storageAccount
}

resource storageAccount_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: storageAccount
}

resource storageAccount_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(storageAccount.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: storageAccount
}]

module storageAccount_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in (privateEndpoints ?? []): {
  name: '${uniqueString(deployment().name, location)}-storageAccount-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: privateEndpoint.?name ?? 'pep-${last(split(storageAccount.id, '/'))}-${privateEndpoint.?service ?? privateEndpoint.service}-${index}'
    serviceResourceId: storageAccount.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: privateEndpoint.?enableDefaultTelemetry ?? enableReferencedModulesTelemetry
    location: privateEndpoint.?location ?? reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: privateEndpoint.?lock ?? lock
    privateDnsZoneGroupName: privateEndpoint.?privateDnsZoneGroupName
    privateDnsZoneResourceIds: privateEndpoint.?privateDnsZoneResourceIds
    roleAssignments: privateEndpoint.?roleAssignments
    tags: privateEndpoint.?tags ?? tags
    manualPrivateLinkServiceConnections: privateEndpoint.?manualPrivateLinkServiceConnections
    customDnsConfigs: privateEndpoint.?customDnsConfigs
    ipConfigurations: privateEndpoint.?ipConfigurations
    applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
    customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
  }
}]

// Lifecycle Policy
module storageAccount_managementPolicies 'management-policy/main.bicep' = if (!empty(managementPolicyRules)) {
  name: '${uniqueString(deployment().name, location)}-Storage-ManagementPolicies'
  params: {
    storageAccountName: storageAccount.name
    rules: managementPolicyRules
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    storageAccount_blobServices // To ensure the lastAccessTimeTrackingPolicy is set first (if used in rule)
  ]
}

// SFTP user settings
module storageAccount_localUsers 'local-user/main.bicep' = [for (localUser, index) in localUsers: {
  name: '${uniqueString(deployment().name, location)}-Storage-LocalUsers-${index}'
  params: {
    storageAccountName: storageAccount.name
    name: localUser.name
    hasSshKey: localUser.hasSshKey
    hasSshPassword: localUser.hasSshPassword
    permissionScopes: localUser.permissionScopes
    hasSharedKey: contains(localUser, 'hasSharedKey') ? localUser.hasSharedKey : false
    homeDirectory: contains(localUser, 'homeDirectory') ? localUser.homeDirectory : ''
    sshAuthorizedKeys: contains(localUser, 'sshAuthorizedKeys') ? localUser.sshAuthorizedKeys : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

// Containers
module storageAccount_blobServices 'blob-service/main.bicep' = if (!empty(blobServices)) {
  name: '${uniqueString(deployment().name, location)}-Storage-BlobServices'
  params: {
    storageAccountName: storageAccount.name
    containers: contains(blobServices, 'containers') ? blobServices.containers : []
    automaticSnapshotPolicyEnabled: contains(blobServices, 'automaticSnapshotPolicyEnabled') ? blobServices.automaticSnapshotPolicyEnabled : false
    changeFeedEnabled: contains(blobServices, 'changeFeedEnabled') ? blobServices.changeFeedEnabled : false
    changeFeedRetentionInDays: contains(blobServices, 'changeFeedRetentionInDays') ? blobServices.changeFeedRetentionInDays : 7
    containerDeleteRetentionPolicyEnabled: contains(blobServices, 'containerDeleteRetentionPolicyEnabled') ? blobServices.containerDeleteRetentionPolicyEnabled : false
    containerDeleteRetentionPolicyDays: contains(blobServices, 'containerDeleteRetentionPolicyDays') ? blobServices.containerDeleteRetentionPolicyDays : 7
    containerDeleteRetentionPolicyAllowPermanentDelete: contains(blobServices, 'containerDeleteRetentionPolicyAllowPermanentDelete') ? blobServices.containerDeleteRetentionPolicyAllowPermanentDelete : false
    corsRules: contains(blobServices, 'corsRules') ? blobServices.corsRules : []
    defaultServiceVersion: contains(blobServices, 'defaultServiceVersion') ? blobServices.defaultServiceVersion : ''
    deleteRetentionPolicyAllowPermanentDelete: contains(blobServices, 'deleteRetentionPolicyAllowPermanentDelete') ? blobServices.deleteRetentionPolicyAllowPermanentDelete : false
    deleteRetentionPolicyEnabled: contains(blobServices, 'deleteRetentionPolicyEnabled') ? blobServices.deleteRetentionPolicyEnabled : false
    deleteRetentionPolicyDays: contains(blobServices, 'deleteRetentionPolicyDays') ? blobServices.deleteRetentionPolicyDays : 7
    isVersioningEnabled: contains(blobServices, 'isVersioningEnabled') ? blobServices.isVersioningEnabled : false
    lastAccessTimeTrackingPolicyEnabled: contains(blobServices, 'lastAccessTimeTrackingPolicyEnabled') ? blobServices.lastAccessTimeTrackingPolicyEnabled : false
    restorePolicyEnabled: contains(blobServices, 'restorePolicyEnabled') ? blobServices.restorePolicyEnabled : false
    restorePolicyDays: contains(blobServices, 'restorePolicyDays') ? blobServices.restorePolicyDays : 6
    diagnosticStorageAccountId: contains(blobServices, 'diagnosticStorageAccountId') ? blobServices.diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: contains(blobServices, 'diagnosticEventHubAuthorizationRuleId') ? blobServices.diagnosticEventHubAuthorizationRuleId : ''
    diagnosticEventHubName: contains(blobServices, 'diagnosticEventHubName') ? blobServices.diagnosticEventHubName : ''
    diagnosticLogCategoriesToEnable: contains(blobServices, 'diagnosticLogCategoriesToEnable') ? blobServices.diagnosticLogCategoriesToEnable : []
    diagnosticMetricsToEnable: contains(blobServices, 'diagnosticMetricsToEnable') ? blobServices.diagnosticMetricsToEnable : []
    diagnosticWorkspaceId: contains(blobServices, 'diagnosticWorkspaceId') ? blobServices.diagnosticWorkspaceId : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

// File Shares
module storageAccount_fileServices 'file-service/main.bicep' = if (!empty(fileServices)) {
  name: '${uniqueString(deployment().name, location)}-Storage-FileServices'
  params: {
    storageAccountName: storageAccount.name
    diagnosticStorageAccountId: contains(fileServices, 'diagnosticStorageAccountId') ? fileServices.diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: contains(fileServices, 'diagnosticEventHubAuthorizationRuleId') ? fileServices.diagnosticEventHubAuthorizationRuleId : ''
    diagnosticEventHubName: contains(fileServices, 'diagnosticEventHubName') ? fileServices.diagnosticEventHubName : ''
    diagnosticLogCategoriesToEnable: contains(fileServices, 'diagnosticLogCategoriesToEnable') ? fileServices.diagnosticLogCategoriesToEnable : []
    diagnosticMetricsToEnable: contains(fileServices, 'diagnosticMetricsToEnable') ? fileServices.diagnosticMetricsToEnable : []
    protocolSettings: contains(fileServices, 'protocolSettings') ? fileServices.protocolSettings : {}
    shareDeleteRetentionPolicy: contains(fileServices, 'shareDeleteRetentionPolicy') ? fileServices.shareDeleteRetentionPolicy : {
      enabled: true
      days: 7
    }
    shares: contains(fileServices, 'shares') ? fileServices.shares : []
    diagnosticWorkspaceId: contains(fileServices, 'diagnosticWorkspaceId') ? fileServices.diagnosticWorkspaceId : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

// Queue
module storageAccount_queueServices 'queue-service/main.bicep' = if (!empty(queueServices)) {
  name: '${uniqueString(deployment().name, location)}-Storage-QueueServices'
  params: {
    storageAccountName: storageAccount.name
    diagnosticStorageAccountId: contains(queueServices, 'diagnosticStorageAccountId') ? queueServices.diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: contains(queueServices, 'diagnosticEventHubAuthorizationRuleId') ? queueServices.diagnosticEventHubAuthorizationRuleId : ''
    diagnosticEventHubName: contains(queueServices, 'diagnosticEventHubName') ? queueServices.diagnosticEventHubName : ''
    diagnosticLogCategoriesToEnable: contains(queueServices, 'diagnosticLogCategoriesToEnable') ? queueServices.diagnosticLogCategoriesToEnable : []
    diagnosticMetricsToEnable: contains(queueServices, 'diagnosticMetricsToEnable') ? queueServices.diagnosticMetricsToEnable : []
    queues: contains(queueServices, 'queues') ? queueServices.queues : []
    diagnosticWorkspaceId: contains(queueServices, 'diagnosticWorkspaceId') ? queueServices.diagnosticWorkspaceId : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

// Table
module storageAccount_tableServices 'table-service/main.bicep' = if (!empty(tableServices)) {
  name: '${uniqueString(deployment().name, location)}-Storage-TableServices'
  params: {
    storageAccountName: storageAccount.name
    diagnosticStorageAccountId: contains(tableServices, 'diagnosticStorageAccountId') ? tableServices.diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: contains(tableServices, 'diagnosticEventHubAuthorizationRuleId') ? tableServices.diagnosticEventHubAuthorizationRuleId : ''
    diagnosticEventHubName: contains(tableServices, 'diagnosticEventHubName') ? tableServices.diagnosticEventHubName : ''
    diagnosticLogCategoriesToEnable: contains(tableServices, 'diagnosticLogCategoriesToEnable') ? tableServices.diagnosticLogCategoriesToEnable : []
    diagnosticMetricsToEnable: contains(tableServices, 'diagnosticMetricsToEnable') ? tableServices.diagnosticMetricsToEnable : []
    tables: contains(tableServices, 'tables') ? tableServices.tables : []
    diagnosticWorkspaceId: contains(tableServices, 'diagnosticWorkspaceId') ? tableServices.diagnosticWorkspaceId : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

@description('The resource ID of the deployed storage account.')
output resourceId string = storageAccount.id

@description('The name of the deployed storage account.')
output name string = storageAccount.name

@description('The resource group of the deployed storage account.')
output resourceGroupName string = resourceGroup().name

@description('The primary blob endpoint reference if blob services are deployed.')
output primaryBlobEndpoint string = !empty(blobServices) && contains(blobServices, 'containers') ? reference('Microsoft.Storage/storageAccounts/${storageAccount.name}', '2019-04-01').primaryEndpoints.blob : ''

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(storageAccount.identity, 'principalId') ? storageAccount.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = storageAccount.location

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

type privateEndpointType = {
  @description('Optional. The name of the private endpoint.')
  name: string?

  @description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @description('Required. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".')
  service: string

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.')
  privateDnsZoneGroupName: string?

  @description('Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneResourceIds: string[]?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    fqdn: string?
    ipAddresses: string[]
  }[]?

  @description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: {
    name: string
    groupId: string
    memberName: string
    privateIpAddress: string
  }[]?

  @description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @description('Optional. Specify the type of lock.')
  lock: lockType

  @description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleAssignments: roleAssignmentType

  @description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @description('Optional. Manual PrivateLink Service Connections.')
  manualPrivateLinkServiceConnections: array?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?
}[]?
