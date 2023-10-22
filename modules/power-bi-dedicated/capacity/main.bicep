metadata name = 'Power BI Dedicated Capacities'
metadata description = 'This module deploys a Power BI Dedicated Capacity.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the PowerBI Embedded.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Required. SkuCapacity of the resource.')
param skuCapacity int

@allowed([
  'A1'
  'A2'
  'A3'
  'A4'
  'A5'
  'A6'
])
@description('Optional. SkuCapacity of the resource.')
param skuName string = 'A1'

@allowed([
  'AutoPremiumHost'
  'PBIE_Azure'
  'Premium'
])
@description('Optional. SkuCapacity of the resource.')
param skuTier string = 'PBIE_Azure'

@description('Required. Members of the resource.')
param members array

@allowed([
  'Gen1'
  'Gen2'
])
@description('Optional. Mode of the resource.')
param mode string = 'Gen2'

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

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

resource powerbi 'Microsoft.PowerBIDedicated/capacities@2021-01-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    capacity: skuCapacity
    name: skuName
    tier: skuTier
  }
  properties: {
    administration: {
      members: members
    }
    mode: mode
  }
}

resource powerbi_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: powerbi
}

module server_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-PowerBI-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: powerbi.id
  }
}]

@description('The resource ID of the PowerBi Embedded.')
output resourceId string = powerbi.id

@description('The name of the resource group the PowerBi Embedded was created in.')
output resourceGroupName string = resourceGroup().name

@description('The Name of the PowerBi Embedded.')
output name string = powerbi.name

@description('The location the resource was deployed into.')
output location string = powerbi.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?
