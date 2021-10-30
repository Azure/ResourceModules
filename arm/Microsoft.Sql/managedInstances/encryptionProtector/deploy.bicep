@description('The name of the encryptionProtector')
param name string = 'current'

@description('Name of the resource.')
param managedInstanceName string

@description('The name of the managed instance key.')
param serverKeyName string

@description('The encryption protector type like "ServiceManaged", "AzureKeyVault".')
@allowed([
  'AzureKeyVault'
  'ServiceManaged'
])
param serverKeyType string = 'AzureKeyVault'

@description('Key auto rotation opt-in flag')
param autoRotationEnabled bool = false

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource encryptionProtector 'Microsoft.Sql/managedInstances/encryptionProtector@2021-05-01-preview' = {
  name: '${managedInstanceName}/${name}'
  properties: {
    autoRotationEnabled: autoRotationEnabled
    serverKeyName: serverKeyName
    serverKeyType: serverKeyType
  }
}

@description('The name of the deployed managed instance')
output encryptionProtectorName string = encryptionProtector.name

@description('The resourceId of the deployed managed instance')
output encryptionProtectorResourceId string = encryptionProtector.id

@description('The resource group of the deployed managed instance')
output encryptionProtectorResourceGroup string = resourceGroup().name
