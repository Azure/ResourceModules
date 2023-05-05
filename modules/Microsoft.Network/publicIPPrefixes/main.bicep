@description('Required. Name of the Public IP Prefix.')
@minLength(1)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Length of the Public IP Prefix.')
@minValue(28)
@maxValue(31)
param prefixLength int

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. The customIpPrefix that this prefix is associated with. A custom IP address prefix is a contiguous range of IP addresses owned by an external customer and provisioned into a subscription. When a custom IP prefix is in Provisioned, Commissioning, or Commissioned state, a linked public IP prefix can be created. Either as a subset of the custom IP prefix range or the entire range.')
param customIPPrefix object = {}

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

resource publicIpPrefix 'Microsoft.Network/publicIPPrefixes@2022-07-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    customIPPrefix: !empty(customIPPrefix) ? customIPPrefix : null
    publicIPAddressVersion: 'IPv4'
    prefixLength: prefixLength
  }
}

resource publicIpPrefix_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${publicIpPrefix.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: publicIpPrefix
}

module publicIpPrefix_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-PIPPrefix-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: publicIpPrefix.id
  }
}]

@description('The resource ID of the public IP prefix.')
output resourceId string = publicIpPrefix.id

@description('The resource group the public IP prefix was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the public IP prefix.')
output name string = publicIpPrefix.name

@description('The location the resource was deployed into.')
output location string = publicIpPrefix.location
