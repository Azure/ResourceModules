targetScope = 'managementGroup'

@description('Required. Name of the custom RBAC role to be created.')
param roleName string

@description('Optional. Description of the custom RBAC role to be created.')
param roleDescription string = ''

@description('Optional. List of allowed actions.')
param actions array = []

@description('Optional. List of denied actions.')
param notActions array = []

@description('Optional. List of allowed data actions.')
param dataActions array = []

@description('Optional. List of denied data actions.')
param notDataActions array = []

@description('Optional. The group ID of the Management Group where the Role Definition and Target Scope will be applied to. Cannot use when Subscription or Resource Groups Parameters are used.')
param managementGroupId string = ''

@description('Optional. The subscription ID where the Role Definition and Target Scope will be applied to. Use for both Subscription level and Resource Group Level.')
param subscriptionId string = ''

@description('Optional. The name of the Resource Group where the Role Definition and Target Scope will be applied to.')
param resourceGroupName string = ''

@description('Optional. Location for all resources.')
param location string = deployment().location

module roleDefinition_mg '.bicep/nested_roleDefinitions_mg.bicep' = if (!empty(managementGroupId) && empty(subscriptionId) && empty(resourceGroupName)) {
  name: 'roleDefinition-mg-${guid(roleName, managementGroupId, location)}'
  scope: managementGroup(managementGroupId)
  params: {
    roleName: roleName
    roleDescription: roleDescription
    actions: actions
    notActions: notActions
    dataActions: dataActions
    notDataActions: notDataActions
    managementGroupId: managementGroupId
    location: location
  }
}

module roleDefinition_sub '.bicep/nested_roleDefinitions_sub.bicep' = if (empty(managementGroupId) && !empty(subscriptionId) && empty(resourceGroupName)) {
  name: 'roleDefinition-sub-${guid(roleName, subscriptionId, location)}'
  scope: subscription(subscriptionId)
  params: {
    roleName: roleName
    roleDescription: roleDescription
    actions: actions
    notActions: notActions
    dataActions: dataActions
    notDataActions: notDataActions
    subscriptionId: subscriptionId
    location: location
  }
}

module roleDefinition_rg '.bicep/nested_roleDefinitions_rg.bicep' = if (empty(managementGroupId) && !empty(resourceGroupName) && !empty(subscriptionId)) {
  name: 'roleDefinition-rg-${guid(roleName, subscriptionId, resourceGroupName, location)}'
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    roleName: roleName
    roleDescription: roleDescription
    actions: actions
    notActions: notActions
    dataActions: dataActions
    notDataActions: notDataActions
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroupName
    location: location
  }
}

output roleDefinitionName string = !empty(managementGroupId) ? roleDefinition_mg.outputs.roleDefinitionName : (!empty(resourceGroupName) ? roleDefinition_rg.outputs.roleDefinitionName : roleDefinition_sub.outputs.roleDefinitionName)
output roleDefinitionId string = !empty(managementGroupId) ? roleDefinition_mg.outputs.roleDefinitionId : (!empty(resourceGroupName) ? roleDefinition_rg.outputs.roleDefinitionId : roleDefinition_sub.outputs.roleDefinitionId)
output roleDefinitionScope string = !empty(managementGroupId) ? roleDefinition_mg.outputs.roleDefinitionScope : (!empty(resourceGroupName) ? roleDefinition_rg.outputs.roleDefinitionScope : roleDefinition_sub.outputs.roleDefinitionScope)
