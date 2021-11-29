@description('Required. The name of the of the API Management service.')
param apiManagementServiceName string = ''

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Required. Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.')
param displayName string

@description('Optional. KeyVault location details of the namedValue. ')
param keyVault object = {}

@description('Required. Named value Name.')
param name string

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

resource service 'Microsoft.ApiManagement/service@2021-04-01-preview' existing = {
  name: apiManagementServiceName
}

resource namedValue 'Microsoft.ApiManagement/service/namedValues@2020-06-01-preview' = {
  name: name
  parent: service
  properties: {
    tags: !empty(namedValueTags) ? namedValueTags : null
    secret: secret
    displayName: displayName
    value: keyVaultEmpty ? value : null
    keyVault: !keyVaultEmpty ? keyVault : null
  }
}

@description('The resource ID of the named value')
output namedValueResourceId string = namedValue.id

@description('The name of the named value')
output namedValueName string = namedValue.name

@description('The resource group the named value was deployed into')
output namedValueResourceGroup string = resourceGroup().name
