targetScope = 'managementGroup'

@sys.description('Required. You can provide either the display name of the role definition, or it\'s fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleDefinitionIdOrName string

@sys.description('Required. The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity)')
param principalId string

@sys.description('Optional. Name of the Resource Group to assign the RBAC role to. If no Resource Group name is provided, and Subscription ID is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.')
param resourceGroupName string = ''

@sys.description('Optional. Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.')
param subscriptionId string = ''

@sys.description('Optional. Group ID of the Management Group to assign the RBAC role to. If no Subscription is provided, the module deploys at management group level, therefore assigns the provided RBAC role to the management group.')
param managementGroupId string = ''

@sys.description('Optional. Location for all resources.')
param location string = deployment().location

@sys.description('Optional. Description of role assignment')
param description string = ''

@sys.description('Optional. Id of the delegated managed identity resource')
param delegatedManagedIdentityResourceId string = ''

@sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to')
param condition string = ''

@sys.description('Optional. Version of the condition. Currently accepted value is "2.0"')
@allowed([
  '2.0'
])
param conditionVersion string = '2.0'

@sys.description('Optional. The principal type of the assigned principal ID. Allowed Values "ServicePrincipal", "Group", "User", "ForeignGroup", "Device"')
param principalType string = 'ServicePrincipal'

module roleAssignment_mg '.bicep/nested_rbac_mg.bicep' = if (!empty(managementGroupId) && empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-roleAssignment-mg-Module'
  scope: managementGroup(managementGroupId)
  params: {
    roleDefinitionIdOrName: roleDefinitionIdOrName
    principalId: principalId
    managementGroupId: managementGroupId
    description: description
    principalType: principalType
    delegatedManagedIdentityResourceId: delegatedManagedIdentityResourceId
    conditionVersion: conditionVersion
    condition: condition
  }
}

module roleAssignment_sub '.bicep/nested_rbac_sub.bicep' = if (empty(managementGroupId) && !empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-roleAssignment-sub-Module'
  scope: subscription(subscriptionId)
  params: {
    roleDefinitionIdOrName: roleDefinitionIdOrName
    principalId: principalId
    subscriptionId: subscriptionId
    description: description
    principalType: principalType
    delegatedManagedIdentityResourceId: delegatedManagedIdentityResourceId
    conditionVersion: conditionVersion
    condition: condition
  }
}

module roleAssignment_rg '.bicep/nested_rbac_rg.bicep' = if (empty(managementGroupId) && !empty(resourceGroupName) && !empty(subscriptionId)) {
  name: '${uniqueString(deployment().name, location)}-roleAssignment-rg-Module'
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    roleDefinitionIdOrName: roleDefinitionIdOrName
    principalId: principalId
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroupName
    description: description
    principalType: principalType
    delegatedManagedIdentityResourceId: delegatedManagedIdentityResourceId
    conditionVersion: conditionVersion
    condition: condition
  }
}

@sys.description('The GUID of the Role Assignment')
output roleAssignmentName string = !empty(managementGroupId) ? roleAssignment_mg.outputs.roleAssignmentName : (!empty(resourceGroupName) ? roleAssignment_rg.outputs.roleAssignmentName : roleAssignment_sub.outputs.roleAssignmentName)
@sys.description('The Resource ID of the Role Assignment')
output roleAssignmentResourceId string = !empty(managementGroupId) ? roleAssignment_mg.outputs.roleAssignmentResourceId : (!empty(resourceGroupName) ? roleAssignment_rg.outputs.roleAssignmentResourceId : roleAssignment_sub.outputs.roleAssignmentResourceId)
@sys.description('The scope this Role Assignment applies to')
output roleAssignmentScope string = !empty(managementGroupId) ? roleAssignment_mg.outputs.roleAssignmentScope : (!empty(resourceGroupName) ? roleAssignment_rg.outputs.roleAssignmentScope : roleAssignment_sub.outputs.roleAssignmentScope)
