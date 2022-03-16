@description('Required. The name of the frontDoor.')
@minLength(1)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Resource tags.')
param tags object = {}

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Backend address pool of the frontdoor resource.')
param backendPools array = []

@description('Optional. Enforce certificate name check of the frontdoor resource.')
param enforceCertificateNameCheck string = 'Disabled'

@description('Optional. Certificate name check time of the frontdoor resource.')
param sendRecvTimeoutSeconds int = 600

@description('Optional. State of the frontdoor resource.')
param enabledState string = 'Enabled'

@description('Optional. Friendly name of the frontdoor resource.')
param friendlyName string = ''

@description('Optional. Frontend endpoints of the frontdoor resource.')
param frontendEndpoints array = []

@description('Optional. Heath probe settings of the frontdoor resource.')
param healthProbeSettings array = []

@description('Optional. Load balancing settings of the frontdoor resource.')
param loadBalancingSettings array = []

@description('Optional. Routing rules settings of the frontdoor resource.')
param routingRules array = []

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

resource frontDoor 'Microsoft.Network/frontDoors@2020-05-01' = {
  name: name
  location: 'global'
  tags: tags
  properties: {
    backendPools: backendPools
    backendPoolsSettings: {
      enforceCertificateNameCheck: enforceCertificateNameCheck
      sendRecvTimeoutSeconds: sendRecvTimeoutSeconds
    }
    enabledState: enabledState
    friendlyName: friendlyName
    frontendEndpoints: frontendEndpoints
    healthProbeSettings: healthProbeSettings
    loadBalancingSettings: loadBalancingSettings
    routingRules: routingRules
  }
}

resource frontDoor_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${frontDoor.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: frontDoor
}

@description('The name of the front door')
output name string = frontDoor.name

@description('The resource ID of the front door')
output resourceId string = frontDoor.id

@description('The resource group the front door was deployed into')
output resourceGroupName string = resourceGroup().name
