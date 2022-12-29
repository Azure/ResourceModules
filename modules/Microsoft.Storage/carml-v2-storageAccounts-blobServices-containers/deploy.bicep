@maxLength(24)
@description('Conditional. The name of the parent Storage Account. Required if the template is used in a standalone deployment.')
param storageAccountName string

@description('Optional. Name of the blob service.')
param blobServicesName string = 'default'

@description('Required. The name of the storage container to deploy.')
param name string

// @description('Optional. Name of the immutable policy.')
// param immutabilityPolicyName string = 'default'

@allowed([
  'Container'
  'Blob'
  'None'
])
@description('Optional. Specifies whether data in the container may be accessed publicly and the level of access.')
param publicAccess string = 'None'

@description('Optional. Configure immutability policy.')
param immutabilityPolicyProperties {
  name?: string
  immutabilityPeriodSinceCreationInDays?: int
  allowProtectedAppendWrites?: bool
}

type roleAssignment = {
  roleDefinitionIdOrName: string
  principalIds: string[]
  description?: string
  principalType?: 'ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device'
  condition?: string
  conditionVersion?: string
  delegatedManagedIdentityResourceId?: string
}

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignment[]

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

module container 'br/carml:microsoft.storage.base-v2-storageaccounts-blobservices-containers:0.1.0' = {
  name: '${deployment().name}-Container'
  params: {
    storageAccountName: storageAccountName
    blobServicesName: blobServicesName
    name: name
    publicAccess: publicAccess
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module immutabilityPolicy 'br/carml:microsoft.storage.base-v2-storageaccounts-blobservices-containers-immutabilitypolicies:0.1' = if (!empty(immutabilityPolicyProperties)) {
  name: '${deployment().name}-ImmutabilityPolicy'
  params: {
    storageAccountName: storageAccountName
    blobServicesName: blobServicesName
    containerName: name
    immutabilityPeriodSinceCreationInDays: contains(immutabilityPolicyProperties, 'immutabilityPeriodSinceCreationInDays') ? immutabilityPolicyProperties.immutabilityPeriodSinceCreationInDays : 365
    allowProtectedAppendWrites: contains(immutabilityPolicyProperties, 'allowProtectedAppendWrites') ? immutabilityPolicyProperties.allowProtectedAppendWrites : true
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module container_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: container.outputs.resourceId
  }
}]

@description('The name of the deployed container.')
output name string = container.outputs.name

@description('The resource ID of the deployed container.')
output resourceId string = container.outputs.resourceId

@description('The resource group of the deployed container.')
output resourceGroupName string = resourceGroup().name
