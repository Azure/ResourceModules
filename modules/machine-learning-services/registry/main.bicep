// ============== //
//   Parameters   //
// ============== //

@description('Required. Name of Azure Machine Learning registry. This is case-insensitive')
param name string

@description('Optional. Discovery URL for the Registry')
param discoveryUrl string = ''

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Managed service identity (system assigned and/or user assigned identities)')
param identity object = {}

@description('Optional. IntellectualPropertyPublisher for the registry')
param intellectualPropertyPublisher string = ''

@description('Optional. Metadata used by portal/tooling/etc to render different UX experiences for resources of the same type.')
param kind string = ''

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Specify the type of lock.')
@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
param lock string = ''

@description('Optional. ARM ResourceId of a resource')
param managedResourceGroup object = {}

@description('Optional. MLFlow Registry URI for the Registry')
param mlFlowRegistryUri string = ''

@description('Optional. Private endpoint connections info used for pending connections in private link portal')
param privateEndpointConnections array = []

@description('Optional. Is the Registry accessible from the internet?')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('Optional. Details of each region the registry is in')
param regionDetails array = []

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. The resource model definition representing SKU')
param sku object = {}

@description('Optional. Resource tags.')
param tags object = {}

// =============== //
//   Deployments   //
// =============== //

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

resource registry 'Microsoft.MachineLearningServices/registries@2023-04-01' = {
  identity: identity
  kind: kind
  location: location
  name: name
  sku: sku
  tags: tags
  properties: {
    discoveryUrl: discoveryUrl
    intellectualPropertyPublisher: intellectualPropertyPublisher
    managedResourceGroup: managedResourceGroup
    mlFlowRegistryUri: mlFlowRegistryUri
    privateEndpointConnections: privateEndpointConnections
    publicNetworkAccess: publicNetworkAccess
    regionDetails: regionDetails
  }
}

resource registry_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${registry.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: registry
}

module registry_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-registry-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: registry.id
  }
}]

// =========== //
//   Outputs   //
// =========== //

@description('The name of the registry.')
output name string = registry.name

@description('The resource ID of the registry.')
output resourceId string = registry.id

@description('The name of the resource group the registry was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = registry.location
