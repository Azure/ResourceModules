@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Optional. The name of the blob service')
param name string = 'default'

@description('Optional. Indicates whether DeleteRetentionPolicy is enabled for the Blob service.')
param deleteRetentionPolicy bool = true

@description('Optional. Indicates the number of days that the deleted blob should be retained. The minimum specified value can be 1 and the maximum value can be 365.')
param deleteRetentionPolicyDays int = 7

@description('Optional. Automatic Snapshot is enabled if set to true.')
param automaticSnapshotPolicyEnabled bool = false

@description('Optional. Blob containers to create.')
param containers array = []

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  name: name
  parent: storageAccount
  properties: {
    deleteRetentionPolicy: {
      enabled: deleteRetentionPolicy
      days: deleteRetentionPolicyDays
    }
    automaticSnapshotPolicyEnabled: automaticSnapshotPolicyEnabled
  }
}

module blobServices_container 'containers/deploy.bicep' = [for (container, index) in containers: {
  name: '${deployment().name}-Container-${index}'
  params: {
    storageAccountName: storageAccount.name
    blobServicesName: blobServices.name
    name: container.name
    publicAccess: contains(container, 'publicAccess') ? container.publicAccess : 'None'
    roleAssignments: contains(container, 'roleAssignments') ? container.roleAssignments : []
    immutabilityPolicyProperties: contains(container, 'immutabilityPolicyProperties') ? container.immutabilityPolicyProperties : {}
  }
}]

@description('The name of the deployed blob service')
output blobServicesName string = blobServices.name

@description('The resource ID of the deployed blob service')
output blobServicesResourceId string = blobServices.id

@description('The name of the deployed blob service')
output blobServicesResourceGroup string = resourceGroup().name
