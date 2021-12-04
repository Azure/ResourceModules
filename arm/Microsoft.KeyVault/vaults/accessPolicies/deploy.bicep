@description('Required. The name of the key vault')
param keyVaultName string

@description('Optional. The access policy deployment')
param name string = 'add'

@description('Optional. An array of 0 to 16 identities that have access to the key vault. All identities in the array must use the same tenant ID as the key vault\'s tenant ID.')
param accessPolicies array = []

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

var formattedAccessPolicies = [for accessPolicy in accessPolicies: {
  applicationId: contains(accessPolicy, 'applicationId') ? accessPolicy.applicationId : ''
  objectId: contains(accessPolicy, 'objectId') ? accessPolicy.objectId : ''
  permissions: accessPolicy.permissions
  tenantId: contains(accessPolicy, 'tenantId') ? accessPolicy.tenantId : tenant().tenantId
}]

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
}

resource policies 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
  name: name
  parent: keyVault
  properties: {
    accessPolicies: formattedAccessPolicies
  }
}

@description('The name of the resource group the access policies assignment was created in.')
output accessPolicyResourceGroup string = resourceGroup().name

@description('The name of the access policies assignment')
output accessPolicyName string = policies.name

@description('The resource ID of the access policies assignment')
output accessPolicyResourceId string = policies.id
