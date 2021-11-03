@description('Required. The name of the disk encryption set that is being created.')
param diskEncryptionSetName string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Required. Resource id of the KeyVault containing the key or secret.')
param keyVaultId string

@description('Required. Key Url (with version) pointing to a key or secret in KeyVault.')
param keyUrl string

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the Automation Account resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var keyVaultName = last(split(keyVaultId, '/'))

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource keyVaultAccessPolicies 'Microsoft.KeyVault/vaults/accessPolicies@2019-09-01' = {
  name: '${keyVaultName}/add'
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: reference('Microsoft.Compute/diskEncryptionSets/${diskEncryptionSet.name}', '2020-12-01', 'Full').identity.principalId
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
}

resource diskEncryptionSet 'Microsoft.Compute/diskEncryptionSets@2020-12-01' = {
  name: diskEncryptionSetName
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
  }
}

module diskEncryptionSet_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: diskEncryptionSet.name
  }
}]

output diskEncryptionSetResourceId string = diskEncryptionSet.id
output principalId string = reference('Microsoft.Compute/diskEncryptionSets/${diskEncryptionSetName}', '2020-12-01', 'Full').identity.principalId
output keyVaultName string = keyVaultName
output diskEncryptionResourceGroup string = resourceGroup().name
