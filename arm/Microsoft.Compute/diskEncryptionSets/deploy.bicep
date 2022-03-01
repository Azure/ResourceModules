@description('Required. The name of the disk encryption set that is being created.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Required. Resource ID of the KeyVault containing the key or secret.')
param keyVaultId string

@description('Required. Key URL (with version) pointing to a key or secret in KeyVault.')
param keyUrl string

@description('Optional. The type of key used to encrypt the data of the disk. For security reasons, it is recommended to set encryptionType to EncryptionAtRestWithPlatformAndCustomerKeys')
@allowed([
  'EncryptionAtRestWithCustomerKey'
  'EncryptionAtRestWithPlatformAndCustomerKeys'
])
param encryptionType string = 'EncryptionAtRestWithPlatformAndCustomerKeys'

@description('Optional. Set this flag to true to enable auto-updating of this disk encryption set to the latest key version.')
param rotationToLatestKeyVersionEnabled bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the disk encryption resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource diskEncryptionSet 'Microsoft.Compute/diskEncryptionSets@2021-04-01' = {
  name: name
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    activeKey: {
      sourceVault: {
        id: keyVaultId
      }
      keyUrl: keyUrl
    }
    encryptionType: encryptionType
    rotationToLatestKeyVersionEnabled: rotationToLatestKeyVersionEnabled
  }
}

module keyVaultAccessPolicies '.bicep/nested_kvAccessPolicy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-DiskEncrSet-KVAccessPolicies'
  params: {
    keyVaultName: last(split(keyVaultId, '/'))
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: diskEncryptionSet.identity.principalId
        permissions: {
          keys: [
            'get'
            'wrapKey'
            'unwrapKey'
          ]
          secrets: []
          certificates: []
        }
      }
    ]
  }
  // This is to support access policies to KV in different subscription and resource group than the disk encryption set.
  scope: resourceGroup(split(keyVaultId, '/')[2], split(keyVaultId, '/')[4])
}

module diskEncryptionSet_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-DiskEncrSet-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: diskEncryptionSet.id
  }
}]

@description('The resource ID of the disk encryption set')
output resourceId string = diskEncryptionSet.id

@description('The name of the disk encryption set')
output name string = diskEncryptionSet.name

@description('The resource group the disk encryption set was deployed into')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the disk encryption set')
output systemAssignedPrincipalId string = diskEncryptionSet.identity.principalId

@description('The name of the key vault with the disk encryption key')
output keyVaultName string = last(split(keyVaultId, '/'))
