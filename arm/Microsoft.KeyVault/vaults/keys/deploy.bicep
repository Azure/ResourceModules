@description('Required. The name of the key vault')
param vaultName string

@description('Required. The name of the key')
param name string

@description('Optional. Resource tags.')
param tags object = {}

@description('Optional. Determines whether the object is enabled.')
param attributesEnabled bool = true

@description('Optional. Expiry date in seconds since 1970-01-01T00:00:00Z.')
param attributesExp int = -1

@description('Optional. Not before date in seconds since 1970-01-01T00:00:00Z.')
param attributesNbf int = -1

@description('Optional. The elliptic curve name.')
@allowed([
  'P-256'
  'P-256K'
  'P-384'
  'P-521'
])
param curveName string = 'P-256'

@description('Optional. Array of JsonWebKeyOperation')
@allowed([
  'decrypt'
  'encrypt'
  'import'
  'sign'
  'unwrapKey'
  'verify'
  'wrapKey'
])
param keyOps array = []

@description('Optional. The key size in bits. For example: 2048, 3072, or 4096 for RSA.')
param keySize int = -1

@description('Optional. The type of the key.')
@allowed([
  'EC'
  'EC-HSM'
  'RSA'
  'RSA-HSM'
])
param kty string = 'EC'

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource key 'Microsoft.KeyVault/vaults/keys@2019-09-01' = {
  name: '${vaultName}/${name}'
  tags: tags
  properties: {
    attributes: {
      enabled: attributesEnabled
      exp: !(attributesExp == -1) ? attributesExp : null
      nbf: !(attributesNbf == -1) ? attributesNbf : null
    }
    curveName: curveName
    keyOps: keyOps
    keySize: !(keySize == -1) ? keySize : null
    kty: kty
  }
}

@description('The Name of the key.')
output keyName string = key.name

@description('The Resource Id of the key.')
output keyResourceId string = key.id

@description('The name of the Resource Group the key was created in.')
output keyResourceGroup string = resourceGroup().name
