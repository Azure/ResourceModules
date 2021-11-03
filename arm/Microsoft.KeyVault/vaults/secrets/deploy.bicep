@description('Required. The name of the key vault')
param vaultName string

@description('Required. The name of the secret')
param name string

@description('Optional. Resource tags.')
param tags object = {}

@description('Optional. Determines whether the object is enabled.')
param attributesEnabled bool = true

@description('Optional. Expiry date in seconds since 1970-01-01T00:00:00Z.')
param attributesExp int = -1

@description('Optional. Not before date in seconds since 1970-01-01T00:00:00Z.')
param attributesNbf int = -1

@description('Optional. The content type of the secret.')
@secure()
param contentType string = ''

@description('Required. The value of the secret. NOTE: "value" will never be returned from the service, as APIs using this model are is intended for internal use in ARM deployments. Users should use the data-plane REST service for interaction with vault secrets.')
@secure()
param value string

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${vaultName}/${name}'
  tags: tags
  properties: {
    contentType: contentType
    attributes: {
      enabled: attributesEnabled
      exp: !(attributesExp == -1) ? attributesExp : null
      nbf: !(attributesNbf == -1) ? attributesNbf : null
    }
    value: value
  }
}

@description('The Name of the secret.')
output secretName string = secret.name

@description('The Resource Id of the secret.')
output secretResourceId string = secret.id

@description('The name of the Resource Group the secret was created in.')
output secretResourceGroup string = resourceGroup().name
