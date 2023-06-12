@description('Conditional. The name of the parent NetApp account. Required if the template is used in a standalone deployment.')
param netAppAccountName string

@description('Required. The name of the capacity pool.')
param name string

@description('Optional. Location of the pool volume.')
param location string = resourceGroup().location

@description('Optional. Tags for all resources.')
param tags object = {}

@description('Optional. The pool service level.')
@allowed([
  'Premium'
  'Standard'
  'StandardZRS'
  'Ultra'
])
param serviceLevel string = 'Standard'

@description('Required. Provisioned size of the pool (in bytes). Allowed values are in 4TiB chunks (value must be multiply of 4398046511104).')
param size int

@description('Optional. The qos type of the pool.')
@allowed([
  'Auto'
  'Manual'
])
param qosType string = 'Auto'

@description('Optional. List of volumnes to create in the capacity pool.')
param volumes array = []

@description('Optional. If enabled (true) the pool can contain cool Access enabled volumes.')
param coolAccess bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

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

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2022-09-01' existing = {
  name: netAppAccountName
}

resource capacityPool 'Microsoft.NetApp/netAppAccounts/capacityPools@2022-09-01' = {
  name: name
  parent: netAppAccount
  location: location
  tags: tags
  properties: {
    serviceLevel: serviceLevel
    size: size
    qosType: qosType
    coolAccess: coolAccess
  }
}

@batchSize(1)
module capacityPool_volumes 'volumes/main.bicep' = [for (volume, index) in volumes: {
  name: '${deployment().name}-Vol-${index}'
  params: {
    netAppAccountName: netAppAccount.name
    capacityPoolName: capacityPool.name
    name: volume.name
    location: location
    serviceLevel: serviceLevel
    creationToken: contains(volume, 'creationToken') ? volume.creationToken : volume.name
    usageThreshold: volume.usageThreshold
    protocolTypes: contains(volume, 'protocolTypes') ? volume.protocolTypes : []
    subnetResourceId: volume.subnetResourceId
    exportPolicyRules: contains(volume, 'exportPolicyRules') ? volume.exportPolicyRules : []
    roleAssignments: contains(volume, 'roleAssignments') ? volume.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module capacityPool_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: capacityPool.id
  }
}]

@description('The name of the Capacity Pool.')
output name string = capacityPool.name

@description('The resource ID of the Capacity Pool.')
output resourceId string = capacityPool.id

@description('The name of the Resource Group the Capacity Pool was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = capacityPool.location
