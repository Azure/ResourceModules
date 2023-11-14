metadata name = 'Container App Jobs'
metadata description = 'This module deploys a Container App Job.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Container App.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. Resource ID of environment.')
param environmentId string

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Collection of private container registry credentials for containers used by the Container app.')
param registries array = []

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute.')
param roleAssignments roleAssignmentType

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Required. List of container definitions for the Container App.')
param containers array

@description('Optional. List of specialized containers that run before app containers.')
param initContainersTemplate array = []

@description('Optional. Required if TriggerType is Event. Configuration of an event driven job.')
param eventTriggerConfig object = {}

@description('Optional. Required if TriggerType is Schedule. Configuration of a schedule based job.')
param scheduleTriggerConfig object = {}

@description('Optional. Required if TriggerType is Manual. Configuration of a manual job.')
param manualTriggerConfig object = {}

@description('Optional. The maximum number of times a replica can be retried.')
param replicaRetryLimit int = 0

@description('Optional. The name of the workload profile to use.')
param workloadProfileName string = 'Consumption'

@description('Optional. The secrets of the Container App.')
@secure()
param secrets object = {}

@description('Optional. List of volume definitions for the Container App.')
param volumes array = []

@description('Optional. Maximum number of seconds a replica is allowed to run.')
param replicaTimeout int = 1800

@allowed([
  'Event'
  'Manual'
  'Schedule'
])
@description('Optional. Trigger type of the job.')
param triggerType string

var secretList = !empty(secrets) ? secrets.secureList : []

var formattedUserAssignedIdentities = reduce(map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }), {}, (cur, next) => union(cur, next)) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }
var identity = !empty(managedIdentities) ? {
  type: (managedIdentities.?systemAssigned ?? false) ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
} : null

var builtInRoleNames = {
  'ContainerApp Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ad2dd5fb-cd4b-4fd4-a9b6-4fed3630980b')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

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

resource containerAppJob 'Microsoft.App/jobs@2023-05-01' = {
  name: name
  tags: tags
  location: location
  identity: identity
  properties: {
    environmentId: environmentId
    configuration: {
      eventTriggerConfig: triggerType == 'Event' ? eventTriggerConfig : null
      manualTriggerConfig: triggerType == 'Manual' ? manualTriggerConfig : null
      scheduleTriggerConfig: triggerType == 'Schedule' ? scheduleTriggerConfig : null
      replicaRetryLimit: replicaRetryLimit
      replicaTimeout: replicaTimeout
      registries: !empty(registries) ? registries : null
      secrets: secretList
      triggerType: triggerType
    }
    template: {
      containers: containers
      initContainers: !empty(initContainersTemplate) ? initContainersTemplate : null
      volumes: !empty(volumes) ? volumes : null
    }
    workloadProfileName: workloadProfileName
  }
}

resource containerAppJob_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: containerAppJob
}

resource containerAppJob_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(containerAppJob.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: containerAppJob
}]

@description('The resource ID of the Container App Job.')
output resourceId string = containerAppJob.id

@description('The name of the resource group the Container App Job was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Container App Job.')
output name string = containerAppJob.name

@description('The location the resource was deployed into.')
output location string = containerAppJob.location

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = (managedIdentities.?systemAssigned ?? false) && contains(containerAppJob.identity, 'principalId') ? containerAppJob.identity.principalId : ''

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource ID of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.')
  userAssignedResourceIds: string[]?
}?
