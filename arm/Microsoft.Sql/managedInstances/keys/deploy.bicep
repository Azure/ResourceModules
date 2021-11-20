@description('Optional. The name of the key')
param name string = ''

@description('Required. Name of the SQL managed instance.')
param managedInstanceName string

@description('Optional. The encryption protector type like "ServiceManaged", "AzureKeyVault"')
@allowed([
  'AzureKeyVault'
  'ServiceManaged'
])
param serverKeyType string = 'ServiceManaged'

@description('Optional. The URI of the key. If the ServerKeyType is AzureKeyVault, then either the URI or the keyVaultName/keyName combination is required.')
param uri string = ''

@description('Optional. The name of the key vault with the key. If the ServerKeyType is AzureKeyVault, then either the URI or the keyVaultName/keyName combination is required')
param keyVaultName string = ''

@description('Optional. The name of the key in the key vault. If the ServerKeyType is AzureKeyVault, then either the URI or the keyVaultName/keyName combination is required')
param keyName string = ''

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var splittedKeyUri = split(uri, '/')
var serverKeyName = (empty(uri) ? 'ServiceManaged' : '${split(splittedKeyUri[2], '.')[0]}_${splittedKeyUri[4]}_${splittedKeyUri[5]}')

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource keyVault 'Microsoft.KeyVault/vaults/keys@2021-06-01-preview' existing = if (empty(uri)) {
  name: (!empty(uri)) ? '${keyVaultName}/${keyName}' : 'dummyVault/dummyKey'
}

resource managedInstance 'Microsoft.Sql/managedInstances@2021-05-01-preview' existing = {
  name: managedInstanceName
}

resource key 'Microsoft.Sql/managedInstances/keys@2017-10-01-preview' = {
  name: !empty(name) ? name : serverKeyName
  properties: {
    serverKeyType: serverKeyType
    uri: (!empty(uri)) ? uri : keyVault.properties.keyUri
  }
  parent: managedInstance
}

@description('The name of the deployed managed instance')
output keyName string = key.name

@description('The resourceId of the deployed managed instance')
output keyResourceId string = key.id

@description('The resource group of the deployed managed instance')
output keyResourceGroup string = resourceGroup().name
