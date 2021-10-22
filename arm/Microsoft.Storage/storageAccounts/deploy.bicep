@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it\'s fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@allowed([
  'None'
  'SystemAssigned'
  'SystemAssigned,UserAssigned'
  'UserAssigned'
])
@description('Optional. Type of managed service identity.')
param managedServiceIdentity string = 'None'

@description('Optional. Mandatory \'managedServiceIdentity\' contains UserAssigned. The identy to assign to the resource.')
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

@description('Optional. Configuration Details for private endpoints.')
param privateEndpoints array = []

@description('Optional. Networks ACLs, this value contains IPs to whitelist and/or Subnet information.')
param networkAcls object = {}

@description('Optional. Blob containers to create.')
param blobContainers array = []

@description('Optional. Indicates whether DeleteRetentionPolicy is enabled for the Blob service.')
param deleteRetentionPolicy bool = true

@description('Optional. Indicates the number of days that the deleted blob should be retained. The minimum specified value can be 1 and the maximum value can be 365.')
param deleteRetentionPolicyDays int = 7

@description('Optional. Automatic Snapshot is enabled if set to true.')
param automaticSnapshotPolicyEnabled bool = false

@description('Optional. Indicates whether public access is enabled for all blobs or containers in the storage account.')
param allowBlobPublicAccess bool = true

@description('Optional. File shares to create.')
param fileShares array = []

@description('Optional. Queues to create.')
param queues array = []

@description('Optional. Tables to create.')
param tables array = []

@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
@description('Optional. Set the minimum TLS version on request to storage.')
param minimumTlsVersion string = 'TLS1_2'

@description('Optional. If true, enables move to archive tier and auto-delete')
param enableArchiveAndDelete bool = false

@description('Optional. If true, enables Hierarchical Namespace for the storage account')
param enableHierarchicalNamespace bool = false

@description('Optional. Set up the amount of days after which the blobs will be moved to archive tier')
param moveToArchiveAfter int = 30

@description('Optional. Set up the amount of days after which the blobs will be deleted')
param deleteBlobsAfter int = 1096

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Generated. Do not provide a value! This date value is used to generate a SAS token to access the modules.')
param basetime string = utcNow('u')

var virtualNetworkRules = [for index in range(0, (empty(networkAcls) ? 0 : length(networkAcls.virtualNetworkRules))): {
  id: '${vNetId}/subnets/${networkAcls.virtualNetworkRules[index].subnet}'
}]
var networkAcls_var = {
  bypass: (empty(networkAcls) ? json('null') : networkAcls.bypass)
  defaultAction: (empty(networkAcls) ? json('null') : networkAcls.defaultAction)
  virtualNetworkRules: (empty(networkAcls) ? json('null') : virtualNetworkRules)
  ipRules: (empty(networkAcls) ? json('null') : ((length(networkAcls.ipRules) == 0) ? json('null') : networkAcls.ipRules))
}
var azureFilesIdentityBasedAuthentication_var = azureFilesIdentityBasedAuthentication

var maxNameLength = 24
var uniqueStoragenameUntrim = '${uniqueString('Storage Account${basetime}')}'
var uniqueStoragename = length(uniqueStoragenameUntrim) > maxNameLength ? substring(uniqueStoragenameUntrim, 0, maxNameLength) : uniqueStoragenameUntrim
var storageAccountName_var = empty(storageAccountName) ? uniqueStoragename : storageAccountName

var saBaseProperties = {
  encryption: {
    keySource: 'Microsoft.Storage'
    services: {
      blob: (((storageAccountKind == 'BlockBlobStorage') || (storageAccountKind == 'BlobStorage') || (storageAccountKind == 'StorageV2') || (storageAccountKind == 'Storage')) ? json('{"enabled": true}') : json('null'))
      file: (((storageAccountKind == 'FileStorage') || (storageAccountKind == 'StorageV2') || (storageAccountKind == 'Storage')) ? json('{"enabled": true}') : json('null'))
    }
  }
  accessTier: storageAccountAccessTier
  supportsHttpsTrafficOnly: true
  isHnsEnabled: ((!enableHierarchicalNamespace) ? json('null') : enableHierarchicalNamespace)
  minimumTlsVersion: minimumTlsVersion
  networkAcls: (empty(networkAcls) ? json('null') : networkAcls_var)
  allowBlobPublicAccess: allowBlobPublicAccess
}
var saOptIdBasedAuthProperties = {
  azureFilesIdentityBasedAuthentication: azureFilesIdentityBasedAuthentication_var
}
var saProperties = (empty(azureFilesIdentityBasedAuthentication) ? saBaseProperties : union(saBaseProperties, saOptIdBasedAuthProperties))
var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Avere Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c025889f-8102-4ebf-b32c-fc0c6f0c6bd9')
  'Backup Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e467623-bb1f-42f4-a55d-6e525e11384b')
  'Backup Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00c29273-979b-4161-815c-10b084fb9324')
  'DevTest Labs User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '76283e04-6283-4c54-8f91-bcf1374a3c64')
  'Disk Snapshot Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7efff54f-a5b4-42b5-a1c5-5411624893ce')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Logic App Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '87a39d53-fc1b-424a-814c-f7e04687dc9e')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Reader and Data Access': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c12c1c16-33a1-487b-954d-41c89c60f349')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'Site Recovery Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '6670b86e-a3f7-4917-ac9b-5d6ab1be4567')
  'Site Recovery Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '494ae006-db33-4328-bf46-533a6560a3ca')
  'Storage Account Backup Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e5e2a7ff-d759-4cd2-bb51-3152d37e2eb1')
  'Storage Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab')
  'Storage Account Key Operator Service Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '81a9662b-bebf-436f-a333-f67b29880f12')
  'Storage Blob Data Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  'Storage Blob Data Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b')
  'Storage Blob Data Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1')
  'Storage Blob Delegator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'db58b8e5-c6ad-4a2a-8342-4190687cbf4a')
  'Storage File Data SMB Share Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0c867c2a-1d8c-454a-a3db-ab2ea1bdc8bb')
  'Storage File Data SMB Share Elevated Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a7264617-510b-434b-a828-9731dc254ea7')
  'Storage File Data SMB Share Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'aba4ae5f-2193-4029-9191-0cb91df5e314')
  'Storage Queue Data Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '974c5e8b-45b9-4653-ba55-5f855dd0fb88')
  'Storage Queue Data Message Processor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8a0f0c08-91a1-4084-bc3d-661d67233fed')
  'Storage Queue Data Message Sender': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c6a89b2d-59bc-44d0-9896-0f6e12d7b80a')
  'Storage Queue Data Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '19e7f393-937e-4f77-808e-94535e297925')
  'Storage Table Data Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0a9a7e1f-b9d0-4cc4-a60d-0319b160aaa3')
  'Storage Table Data Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '76199698-9eea-4c19-bc75-cec21354c6b6')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName_var
  location: location
  kind: storageAccountKind
  sku: {
    name: storageAccountSku
  }
  identity: {
    type: managedServiceIdentity
    userAssignedIdentities: (empty(userAssignedIdentities) ? json('null') : userAssignedIdentities)
  }
  tags: tags
  properties: saProperties

  // lifecycle policy
  resource storageAccount_managementPolicies 'managementPolicies@2019-06-01' = if (enableArchiveAndDelete) {
    name: 'default'
    properties: {
      policy: {
        rules: [
          {
            enabled: true
            name: 'retention-policy'
            type: 'Lifecycle'
            definition: {
              actions: {
                baseBlob: {
                  tierToArchive: {
                    daysAfterModificationGreaterThan: moveToArchiveAfter
                  }
                  delete: {
                    daysAfterModificationGreaterThan: deleteBlobsAfter
                  }
                }
                snapshot: {
                  delete: {
                    daysAfterCreationGreaterThan: deleteBlobsAfter
                  }
                }
              }
              filters: {
                blobTypes: [
                  'blockBlob'
                ]
              }
            }
          }
        ]
      }
    }
  }
}

resource storageAccount_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${storageAccount.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: storageAccount
}

module storageAccount_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Storage-Rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: storageAccount.name
  }
}]

module storageAccount_privateEndpoints './.bicep/nested_privateEndpoint.bicep' = [for (endpoint, index) in privateEndpoints: if (!empty(privateEndpoints)) {
  name: '${uniqueString(deployment().name, location)}-Storage-PrivateEndpoints-${index}'
  params: {
    privateEndpointResourceId: storageAccount.id
    privateEndpointVnetLocation: (empty(privateEndpoints) ? 'dummy' : reference(split(endpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location)
    privateEndpointObj: endpoint
    tags: tags
  }
  dependsOn: [
    storageAccount
  ]
}]

// Containers
resource storageAccount_nested_blob_services 'Microsoft.Storage/storageAccounts/blobServices@2021-08-01' = if (!empty(blobContainers)) {
  name: 'default'
  parent: storageAccount
  properties: {
    deleteRetentionPolicy: {
      enabled: deleteRetentionPolicy
      days: deleteRetentionPolicyDays
    }
    automaticSnapshotPolicyEnabled: automaticSnapshotPolicyEnabled
  }
}

module storageAccount_nested_blob_container './.bicep/nested_container.bicep' = [for (blobContainer, index) in blobContainers: if (!empty(blobContainers)) {
  name: '${uniqueString(deployment().name, location)}-Storage-Container-${(empty(blobContainers) ? 'dummy' : index)}'
  params: {
    blobContainer: blobContainer
    builtInRoleNames: builtInRoleNames
    storageAccountName: storageAccount.name
  }
  dependsOn: [
    storageAccount_nested_blob_services
  ]
}]

// File Shares
module storageAccount_nested_fileShare './.bicep/nested_fileShare.bicep' = [for (fileShare, index) in fileShares: if (!empty(fileShares)) {
  name: '${uniqueString(deployment().name, location)}-Storage-FileShare-${(empty(fileShares) ? 'dummy' : index)}'
  params: {
    fileShareObj: fileShare
    builtInRoleNames: builtInRoleNames
    storageAccountName: storageAccount.name
  }
}]

// Queue
module storageAccount_nested_queue './.bicep/nested_queue.bicep' = [for (queue, index) in queues: if (!empty(queues)) {
  name: '${uniqueString(deployment().name, location)}-Storage-Queue-${(empty(queues) ? 'dummy' : index)}'
  params: {
    queueObj: queue
    builtInRoleNames: builtInRoleNames
    storageAccountName: storageAccount.name
  }
}]

// Table
resource storageAccount_nested_table 'Microsoft.Storage/storageAccounts/tableServices/tables@2019-06-01' = [for table in tables: if (!empty(tables)) {
  name: (empty(tables) ? '${storageAccount.name}/default/dummy' : '${storageAccount.name}/default/${table}')
}]

output storageAccountResourceId string = storageAccount.id
output storageAccountRegion string = storageAccount.location
output storageAccountName string = storageAccount.name
output storageAccountResourceGroup string = resourceGroup().name
output storageAccountPrimaryBlobEndpoint string = (empty(blobContainers) ? '' : reference('Microsoft.Storage/storageAccounts/${storageAccount.name}', '2019-04-01').primaryEndpoints.blob)
output blobContainers array = blobContainers
output fileShares array = fileShares
output queues array = queues
output tables array = tables
output assignedIdentityID string = (contains(managedServiceIdentity, 'SystemAssigned') ? reference(storageAccount.id, '2019-06-01', 'full').identity.principalId : '')
