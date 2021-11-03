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
var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Avere Cluster Create': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a7b1b19a-0e83-4fe5-935c-faaefbfd18c3')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Azure Service Deploy Release Management Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '21d96096-b162-414a-8302-d8354f9d91b2')
  'CAL-Custom-Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7b266cd7-0bba-4ae2-8423-90ede5e1e898')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'masterreader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a48d7796-14b4-4889-afef-fbb65a93e5a2')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Reservation Purchaser': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f7b75c60-3036-4b75-91c3-6b41c27c1689')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

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
    builtInRoleNames: builtInRoleNames
    resourceName: diskEncryptionSet.name
  }
  dependsOn: [
    diskEncryptionSet
  ]
}]

output diskEncryptionSetResourceId string = diskEncryptionSet.id
output principalId string = reference('Microsoft.Compute/diskEncryptionSets/${diskEncryptionSetName}', '2020-12-01', 'Full').identity.principalId
output keyVaultName string = keyVaultName
output diskEncryptionResourceGroup string = resourceGroup().name
