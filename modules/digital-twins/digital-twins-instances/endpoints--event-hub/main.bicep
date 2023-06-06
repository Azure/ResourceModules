@description('Optional. The name of the Digital Twin Endpoint.')
param name string = 'EventHubEndpoint'

@description('Conditional. The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment.')
param digitalTwinInstanceName string

@allowed([
  'IdentityBased'
  'KeyBased'
])
@description('Optional. Specifies the authentication type being used for connecting to the endpoint. If \'KeyBased\' is selected, a connection string must be specified (at least the primary connection string). If \'IdentityBased\' is selected, the endpointUri and entityPath properties must be specified.')
param authenticationType string = 'IdentityBased'

@description('Optional. Dead letter storage secret for key-based authentication. Will be obfuscated during read.')
@secure()
param deadLetterSecret string = ''

@description('Optional. Dead letter storage URL for identity-based authentication.')
param deadLetterUri string = ''

@description('Conditional. PrimaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read. Required if the `authenticationType` is "KeyBased".')
@secure()
param connectionStringPrimaryKey string = ''

@description('Optional. SecondaryConnectionString of the endpoint for key-based authentication. Will be obfuscated during read.')
@secure()
param connectionStringSecondaryKey string = ''

@description('Optional. The EventHub name in the EventHub namespace for identity-based authentication.')
param entityPath string = ''

@description('Optional. The URL of the EventHub namespace for identity-based authentication. It must include the protocol \'sb://\'.')
param endpointUri string = ''

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID to assign to the resource.')
param userAssignedIdentity string = ''

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentity) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentity) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentity: !empty(userAssignedIdentity) ? userAssignedIdentity : null
} : null


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

resource digitalTwinsInstance 'Microsoft.DigitalTwins/digitalTwinsInstances@2023-01-31' existing = {
  name: digitalTwinInstanceName
}

resource endpoint 'Microsoft.DigitalTwins/digitalTwinsInstances/endpoints@2023-01-31' = {
  name: name
  parent: digitalTwinsInstance
  properties: {
    endpointType: 'EventHub'
    authenticationType: authenticationType
    connectionStringPrimaryKey: connectionStringPrimaryKey
    connectionStringSecondaryKey: connectionStringSecondaryKey
    deadLetterSecret: deadLetterSecret
    deadLetterUri: deadLetterUri
    endpointUri: endpointUri
    entityPath: entityPath
    identity: identity
  }
}

@description('The resource ID of the Endpoint.')
output resourceId string = endpoint.id

@description('The name of the resource group the resource was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Endpoint.')
output name string = endpoint.name
