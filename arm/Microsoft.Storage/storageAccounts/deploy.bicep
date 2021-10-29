@maxLength(24)
@description('Optional. Name of the Storage Account.')
param name string = ''

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

@description('Optional. Blob service and containers to deploy')
param blobServices object = {}

@description('Optional. File service and shares to deploy')
param fileServices object = {}

@description('Optional. Queue service and queues to create.')
param queueServices object = {}

@description('Optional. Table service and tables to create.')
param tableServices object = {}

@description('Optional. Indicates whether public access is enabled for all blobs or containers in the storage account.')
param allowBlobPublicAccess bool = true

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
var storageAccountName_var = empty(name) ? uniqueStoragename : name

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

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
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

module storageAccount_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Storage-Rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: storageAccount.name
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

// Containers
module storageAccount_blobService 'blobServices/deploy.bicep' = if (!empty(blobServices)) {
  name: '${uniqueString(deployment().name, location)}-Storage-BlobServices'
  params: {
    storageAccountName: storageAccount.name
    containers: contains(blobServices, 'containers') ? blobServices.containers : []
    automaticSnapshotPolicyEnabled: contains(blobServices, 'automaticSnapshotPolicyEnabled') ? blobServices.automaticSnapshotPolicyEnabled : false
    deleteRetentionPolicy: contains(blobServices, 'deleteRetentionPolicy') ? blobServices.deleteRetentionPolicy : true
    deleteRetentionPolicyDays: contains(blobServices, 'deleteRetentionPolicyDays') ? blobServices.deleteRetentionPolicyDays : 7
  }
}

// File Shares
module storageAccount_fileServices 'fileServices/deploy.bicep' = if (!empty(fileServices)) {
  name: '${uniqueString(deployment().name, location)}-Storage-FileServices'
  params: {
    storageAccountName: storageAccount.name
    protocolSettings: contains(fileServices, 'protocolSettings') ? fileServices.protocolSettings : {}
    shareDeleteRetentionPolicy: contains(fileServices, 'shareDeleteRetentionPolicy') ? fileServices.shareDeleteRetentionPolicy : {
      enabled: true
      days: 7
    }
    shares: contains(fileServices, 'shares') ? fileServices.shares : []
  }
}

// Queue
module storageAccount_queueServices 'queueServices/deploy.bicep' = if (!empty(queueServices)) {
  name: '${uniqueString(deployment().name, location)}-Storage-QueueServices'
  params: {
    storageAccountName: storageAccount.name
    queues: contains(queueServices, 'queues') ? queueServices.queues : []
  }
}

// Table
module storageAccount_tableServices 'tableServices/deploy.bicep' = if (!empty(tableServices)) {
  name: '${uniqueString(deployment().name, location)}-Storage-TableServices'
  params: {
    storageAccountName: storageAccount.name
    tables: contains(tableServices, 'tables') ? tableServices.tables : []
  }
}

@description('The resource Id of the deployed storage account')
output storageAccountResourceId string = storageAccount.id

@description('The name of the deployed storage account')
output storageAccountName string = storageAccount.name

@description('The resource group of the deployed storage account')
output storageAccountResourceGroup string = resourceGroup().name

@description('The primary blob endpoint reference if blob services are deployed.')
output storageAccountPrimaryBlobEndpoint string = (!empty(blobServices) && contains(storageAccount_blobService, 'blobContainers')) ? '' : reference('Microsoft.Storage/storageAccounts/${storageAccount.name}', '2019-04-01').primaryEndpoints.blob

@description('The resource id of the assigned identity, if any')
output assignedIdentityID string = (contains(managedServiceIdentity, 'SystemAssigned') ? reference(storageAccount.id, '2019-06-01', 'full').identity.principalId : '')
