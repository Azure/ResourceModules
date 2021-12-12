var storageAccountParameters = {
  name: 'adpsxxazsa${serviceShort}01'
  storageAccountKind: 'StorageV2'
  storageAccountSku: 'Standard_LRS'
  allowBlobPublicAccess: false
}
// Module //
module storageAccount '../../../../../arm/Microsoft.Storage/storageAccounts/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-sa'
  params: {
    name: storageAccountParameters.name
    storageAccountKind: storageAccountParameters.storageAccountKind
    storageAccountSku: storageAccountParameters.storageAccountSku
    allowBlobPublicAccess: storageAccountParameters.allowBlobPublicAccess
  }
  dependsOn: [
    resourceGroup
  ]
}
