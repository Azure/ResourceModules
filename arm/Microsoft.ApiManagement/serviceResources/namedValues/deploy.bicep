@description('Required. The name of the of the Api Management service.')
param apiManagementServiceName string = ''

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Required. Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.')
param displayName string = ''

@description('Optional. KeyVault location details of the namedValue. ')
param keyVault object = {}

@description('Required. Named value Name.')
param namedValueName string = ''

@description('Optional. Tags that when provided can be used to filter the NamedValue list. - string')
param namedValueTags array = []

@description('Optional. Determines whether the value is a secret and should be encrypted or not. Default value is false.')
param secret bool = false

@description('Optional. Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on \'GET\' operations! Use \'/listSecrets\' POST request to get the value.')
param value string = newGuid()

var keyVaultEmpty = empty(keyVault)

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource namedValue 'Microsoft.ApiManagement/service/namedValues@2020-06-01-preview' = {
  name: '${apiManagementServiceName}/${namedValueName}'
  properties: {
    tags: ((!empty(namedValueTags)) ? namedValueTags : json('null'))
    secret: secret
    displayName: displayName
    value: (keyVaultEmpty ? value : json('null'))
    keyVault: ((!keyVaultEmpty) ? keyVault : json('null'))
  }
}

output namedValueResourceId string = namedValue.id
output namedValueResourceName string = namedValue.name
output namedValueResourceGroup string = resourceGroup().name
