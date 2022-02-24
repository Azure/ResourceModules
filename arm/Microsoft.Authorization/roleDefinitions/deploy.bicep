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

@sys.description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered. Use when scope target is resource group.')
param cuaId string = ''

module roleDefinition_mg 'managementGroup/deploy.bicep' = if (!empty(managementGroupId) && empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-RoleDefinition-MG-Module'
  scope: managementGroup(managementGroupId)
  params: {
    roleName: roleName
    description: !empty(description) ? description : ''
    actions: !empty(actions) ? actions : []
    notActions: !empty(notActions) ? notActions : []
    assignableScopes: !empty(assignableScopes) ? assignableScopes : []
    managementGroupId: managementGroupId
  }
}

module roleDefinition_sub 'subscription/deploy.bicep' = if (empty(managementGroupId) && !empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-RoleDefinition-Sub-Module'
  scope: subscription(subscriptionId)
  params: {
    roleName: roleName
    description: !empty(description) ? description : ''
    actions: !empty(actions) ? actions : []
    notActions: !empty(notActions) ? notActions : []
    dataActions: !empty(dataActions) ? dataActions : []
    notDataActions: !empty(notDataActions) ? notDataActions : []
    assignableScopes: !empty(assignableScopes) ? assignableScopes : []
    subscriptionId: subscriptionId
  }
}

module roleDefinition_rg 'resourceGroup/deploy.bicep' = if (empty(managementGroupId) && !empty(resourceGroupName) && !empty(subscriptionId)) {
  name: '${uniqueString(deployment().name, location)}-RoleDefinition-RG-Module'
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    roleName: roleName
    description: !empty(description) ? description : ''
    actions: !empty(actions) ? actions : []
    notActions: !empty(notActions) ? notActions : []
    dataActions: !empty(dataActions) ? dataActions : []
    notDataActions: !empty(notDataActions) ? notDataActions : []
    assignableScopes: !empty(assignableScopes) ? assignableScopes : []
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroupName
    cuaId: !empty(cuaId) ? cuaId : ''
  }
}

@sys.description('The GUID of the Role Definition')
output name string = !empty(managementGroupId) ? roleDefinition_mg.outputs.name : (!empty(resourceGroupName) ? roleDefinition_rg.outputs.name : roleDefinition_sub.outputs.name)

@sys.description('The resource ID of the Role Definition')
output resourceId string = !empty(managementGroupId) ? roleDefinition_mg.outputs.resourceId : (!empty(resourceGroupName) ? roleDefinition_rg.outputs.resourceId : roleDefinition_sub.outputs.resourceId)

@sys.description('The scope this Role Definition applies to')
output roleDefinitionScope string = !empty(managementGroupId) ? roleDefinition_mg.outputs.scope : (!empty(resourceGroupName) ? roleDefinition_rg.outputs.scope : roleDefinition_sub.outputs.scope)
