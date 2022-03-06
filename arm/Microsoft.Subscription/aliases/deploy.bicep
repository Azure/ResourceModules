targetScope = 'tenant'

@description('Required. Unique alias name. Primary key for the deployment.')
param name string

@description('Optional. Specify the billing scope for where the subscription should be created.')
param billingScope string = ''

@description('Optional. The friendly name of the subscription.')
param displayName string = ''

@description('Optional. Id of the reseller (MPN ID) to link the subscription to.')
param resellerId string = ''

@description('Optional. Linking alias with an existing subscription.')
param subscriptionId string = ''

@allowed([
  'Production'
  'DevTest'
])
@description('Optional. The workload type of the subscription.')
param workload string = 'Production'

@description('Optional. Group ID of the management group where the subscription should be placed.')
param managementGroupId string = tenant().tenantId

// @allowed([
//   'CanNotDelete'
//   'NotSpecified'
//   'ReadOnly'
// ])
// @description('Optional. Specify the type of lock.')
// param lock string = 'NotSpecified'

// @description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
// param roleAssignments array = []

@description('Optional. Tags of the storage account resource.')
param tags object = {}


resource alias 'Microsoft.Subscription/aliases@2021-10-01' = {
  name: name
  properties: {
    additionalProperties: {
      managementGroupId: '/providers/Microsoft.Management/managementGroups/${managementGroupId}'
      tags: tags
    }
    billingScope: !empty(billingScope) ? billingScope : null
    displayName: !empty(displayName) ? displayName : name
    resellerId: !empty(resellerId) ? resellerId : null
    subscriptionId: !empty(subscriptionId) ? subscriptionId : null
    workload: workload
  }
}

// module subscription_lock '.bicep/nested_lock.bicep' = if (lock != 'NotSpecified') {
//   scope: subscription(alias.properties.subscriptionId)
//   name: '${uniqueString(alias.name)}-Sub-${lock}-Lock'
//   params: {
//     name: '${alias.name}-${lock}-lock'
//     level: lock
//   }
// }

// module subscription_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
//   name: '${uniqueString(alias.name)}-Sub-Rbac-${index}'
//   params: {
//     principalIds: roleAssignment.principalIds
//     roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
//     resourceGroupName: alias.name
//   }
//   scope: az.subscription(alias.id)
// }]

output aliasName string = alias.name
output aliasId string = alias.id
output subscriptionId string = alias.properties.subscriptionId
output subscriptionName string = !empty(displayName) ? displayName : alias.name
