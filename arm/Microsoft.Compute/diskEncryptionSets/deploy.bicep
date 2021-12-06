@description('Required. The name of the disk encryption set that is being created.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Required. Resource ID of the KeyVault containing the key or secret.')
param keyVaultId string

@description('Required. Key URL (with version) pointing to a key or secret in KeyVault.')
param keyUrl string

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the Automation Account resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource keyVaultAccessPolicies 'Microsoft.KeyVault/vaults/accessPolicies@2019-09-01' = {
  name: '${last(split(keyVaultId, '/'))}/add'
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
  }
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
output diskEncryptionSetResourceId string = diskEncryptionSet.id

@description('The name of the disk encryption set')
output diskEncryptionSetName string = diskEncryptionSet.name

@description('The resource group the disk encryption set was deployed into')
output diskEncryptionResourceGroup string = resourceGroup().name

@description('The principal ID of the disk encryption set')
output systemAssignedPrincipalId string = diskEncryptionSet.identity.principalId

@description('The name of the key vault with the disk encryption key')
output keyVaultName string = last(split(keyVaultId, '/'))
