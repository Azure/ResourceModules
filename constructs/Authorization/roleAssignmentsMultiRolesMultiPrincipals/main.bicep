targetScope = 'managementGroup'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalIds\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Name of the Resource Group to assign the RBAC role to. If no Resource Group name is provided, and Subscription ID is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.')
param resourceGroupName string = ''

@description('Optional. Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.')
param subscriptionId string = ''

@description('Optional. Group ID of the Management Group to assign the RBAC role to. If no Subscription is provided, the module deploys at management group level, therefore assigns the provided RBAC role to the management group.')
param managementGroupId string = ''

@description('Optional. Location for all resources.')
param location string = deployment().location

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

module nested_role_assignments_mg '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: if (!empty(managementGroupId) && empty(subscriptionId) && empty(resourceGroupName)) {
  name: 'roleAssignment-mg-${guid(roleAssignment.roleDefinitionIdOrName)}-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    managementGroupId: managementGroupId
    location: location
  }
}]

module nested_role_assignments_sub '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: if (empty(managementGroupId) && !empty(subscriptionId) && empty(resourceGroupName)) {
  name: 'roleAssignment-sub-${guid(roleAssignment.roleDefinitionIdOrName)}-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    subscriptionId: subscriptionId
    location: location
  }
}]

module nested_role_assignments_rg '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: if (empty(managementGroupId) && !empty(resourceGroupName) && !empty(subscriptionId)) {
  name: 'roleAssignment-rg-${guid(roleAssignment.roleDefinitionIdOrName)}-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroupName
    location: location
  }
}]

@description('The scope of the deployed role assignments.')
output roleAssignmentScope string = !empty(managementGroupId) ? nested_role_assignments_mg[0].outputs.roleAssignmentScope : (!empty(resourceGroupName) ? nested_role_assignments_rg[0].outputs.roleAssignmentScope : nested_role_assignments_sub[0].outputs.roleAssignmentScope)

@description('The names of the deployed role assignments.')
output roleAssignments array = roleAssignments
