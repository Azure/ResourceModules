@description('Required. The name of the key vault')
param keyVaultName string

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

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
}

resource key 'Microsoft.KeyVault/vaults/keys@2019-09-01' = {
  name: name
  parent: keyVault
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

module key_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: key.id
  }
}]

@description('The name of the key.')
output keyName string = key.name

@description('The resource ID of the key.')
output keyResourceId string = key.id

@description('The name of the resource group the key was created in.')
output keyResourceGroup string = resourceGroup().name
