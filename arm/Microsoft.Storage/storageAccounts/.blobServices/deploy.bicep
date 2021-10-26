@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Optional. Indicates whether DeleteRetentionPolicy is enabled for the Blob service.')
param deleteRetentionPolicy bool = true

@description('Optional. Indicates the number of days that the deleted blob should be retained. The minimum specified value can be 1 and the maximum value can be 365.')
param deleteRetentionPolicyDays int = 7

@description('Optional. Automatic Snapshot is enabled if set to true.')
param automaticSnapshotPolicyEnabled bool = false

@description('Optional. Blob containers to create.')
param blobContainers array = []

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2021-08-01' = {
  name: '${storageAccountName}/default'
  properties: {
    deleteRetentionPolicy: {
      enabled: deleteRetentionPolicy
      days: deleteRetentionPolicyDays
    }
    automaticSnapshotPolicyEnabled: automaticSnapshotPolicyEnabled
  }
}

module blobServices_container '.containers/deploy.bicep' = [for (blobContainer, index) in blobContainers: {
  name: '${uniqueString(deployment().name)}-Storage-Container-${index}'
  params: {
    name: blobContainer.name
    allowProtectedAppendWrites: blobContainer.allowProtectedAppendWrites
    enableWORM: blobContainer.enableWORM
    immutabilityPeriodSinceCreationInDays: blobContainer.immutabilityPeriodSinceCreationInDays
    publicAccess: blobContainer.publicAccess
    roleAssignments: blobContainer.roleAssignments
    storageAccountName: storageAccountName
  }
  dependsOn: [
    blobServices
  ]
}]

@description('The name of the deployed blob service')
output blobServiceName string = blobServices.name

@description('The id of the deployed blob service')
output blobServiceResourceId string = blobServices.id

@description('The name of the deployed blob service')
output blobServiceResourceGroup string = resourceGroup().name
