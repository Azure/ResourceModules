targetScope = 'managementGroup'

@sys.description('Required. Name of the custom RBAC role to be created.')
param roleName string

@sys.description('Optional. Description of the custom RBAC role to be created.')
param description string = ''

@sys.description('Optional. List of allowed actions.')
param actions array = []

@sys.description('Optional. List of denied actions.')
param notActions array = []

@sys.description('Optional. List of allowed data actions. This is not supported if the assignableScopes contains Management Group Scopes')
param dataActions array = []

@sys.description('Optional. List of denied data actions. This is not supported if the assignableScopes contains Management Group Scopes')
param notDataActions array = []

@sys.description('Optional. The group ID of the Management Group where the Role Definition and Target Scope will be applied to. Cannot use when Subscription or Resource Groups Parameters are used.')
param managementGroupId string = ''

@sys.description('Optional. The subscription ID where the Role Definition and Target Scope will be applied to. Use for both Subscription level and Resource Group Level.')
param subscriptionId string = ''

@sys.description('Optional. The name of the Resource Group where the Role Definition and Target Scope will be applied to.')
param resourceGroupName string = ''

@sys.description('Optional. Location for all resources.')
param location string = deployment().location

@sys.description('Optional. Role definition assignable scopes. If not provided, will use the current scope provided.')
param assignableScopes array = []

module roleDefinition_mg '.bicep/nested_roleDefinitions_mg.bicep' = if (!empty(managementGroupId) && empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-roleDefinition-mg-Module'
  scope: managementGroup(managementGroupId)
  params: {
    roleName: roleName
    description: description
    actions: actions
    notActions: notActions
    managementGroupId: managementGroupId
    assignableScopes: assignableScopes
  }
}

module roleDefinition_sub '.bicep/nested_roleDefinitions_sub.bicep' = if (empty(managementGroupId) && !empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-roleDefinition-sub-Module'
  scope: subscription(subscriptionId)
  params: {
    roleName: roleName
    description: description
    actions: actions
    notActions: notActions
    dataActions: dataActions
    notDataActions: notDataActions
    subscriptionId: subscriptionId
    assignableScopes: assignableScopes
  }
}

module roleDefinition_rg '.bicep/nested_roleDefinitions_rg.bicep' = if (empty(managementGroupId) && !empty(resourceGroupName) && !empty(subscriptionId)) {
  name: '${uniqueString(deployment().name, location)}-roleDefinition-rg-Module'
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    roleName: roleName
    description: description
    actions: actions
    notActions: notActions
    dataActions: dataActions
    notDataActions: notDataActions
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroupName
    assignableScopes: assignableScopes
  }
}

@sys.description('The GUID of the Role Definition')
output roleDefinitionName string = !empty(managementGroupId) ? roleDefinition_mg.outputs.roleDefinitionName : (!empty(resourceGroupName) ? roleDefinition_rg.outputs.roleDefinitionName : roleDefinition_sub.outputs.roleDefinitionName)
@sys.description('The Resource ID of the Role Definition')
output roleDefinitionResourceId string = !empty(managementGroupId) ? roleDefinition_mg.outputs.roleDefinitionResourceId : (!empty(resourceGroupName) ? roleDefinition_rg.outputs.roleDefinitionResourceId : roleDefinition_sub.outputs.roleDefinitionResourceId)
@sys.description('The scope this Role Definition applies to')
output roleDefinitionScope string = !empty(managementGroupId) ? roleDefinition_mg.outputs.roleDefinitionScope : (!empty(resourceGroupName) ? roleDefinition_rg.outputs.roleDefinitionScope : roleDefinition_sub.outputs.roleDefinitionScope)
