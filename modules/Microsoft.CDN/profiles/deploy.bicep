@description('Required. Name of the CDN profile which is unique within the resource group.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@allowed([
  'Standard_Verizon'
  'Standard_Akamai'
  'Standard_ChinaCdn'
  'Standard_Microsoft'
  'Premium_Verizon'
  'Premium_Akamai'
  'Premium_ChinaCdn'
  'Premium_Microsoft'
  'Custom_Verizon'
  'Custom_Akamai'
  'Custom_ChinaCdn'
  'Custom_Microsoft'
  'Standard_Microsoft_AzureFrontDoor'
  'Premium_Microsoft_AzureFrontDoor'
  'Custom_Microsoft_AzureFrontDoor'
])
@description('Required. The pricing tier (defines a CDN provider, feature list and rate) of the CDN profile.')
param sku string

@description('Optional. Profile properties.')
param profileProperties object = {}

@description('Optional. Name of the endpoint under the profile which is unique globally.')
param endpointName string = ''

@description('Optional. Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details).')
param endpointProperties object = {}

@description('Optional. Endpoint tags.')
param tags object = {}

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

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

resource profile 'microsoft.cdn/profiles@2021-06-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  properties: {
    originResponseTimeoutSeconds: contains(profileProperties, 'originResponseTimeoutSeconds') ? profileProperties.originResponseTimeoutSeconds : 60
  }
  tags: tags
}

resource profile_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${profile.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: profile
}

module profile_rbac '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-AppGateway-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: profile.id
  }
}]

module profile_Endpoint 'endpoints/deploy.bicep' = if (!empty(endpointProperties)) {
  name: '${uniqueString(deployment().name, location)}-Endpoint'
  params: {
    endpointName: !empty(endpointName) ? endpointName : '${profile.name}-endpoint'
    endpointProperties: endpointProperties
    location: location
    profileName: profile.name
    enableDefaultTelemetry: enableReferencedModulesTelemetry

  }
}

@description('Name of the CDN profile.')
output name string = profile.name

@description('Resource ID of the CDN profile.')
output resourceId string = profile.id

@description('Resource group of the CDN profile.')
output resourceGroupName string = resourceGroup().name

@description('Type of the CDN profile.')
output profileType string = profile.type

@description('Resource location of the CDN profile.')
output location string = profile.location
