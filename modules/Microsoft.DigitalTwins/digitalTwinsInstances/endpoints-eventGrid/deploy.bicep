@description('Optional. The name of the Digital Twin Endpoint.')
param name string = 'EventGridEndpoint'

@description('Conditional. The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment.')
param digitalTwinInstanceName string

@description('Optional. Specifies the authentication type being used for connecting to the endpoint. If \'KeyBased\' is selected, a connection string must be specified (at least the primary connection string). If \'IdentityBased\' is selected, the endpointUri and entityPath properties must be specified.')
param authenticationType string = 'KeyBased'

@description('Required. EventGrid Topic Endpoint.')
param topicEndpoint string

@description('Optional. EventGrid secondary accesskey. Will be obfuscated during read.')
@secure()
param accessKey1 string = ''

@description('Optional. EventGrid secondary accesskey. Will be obfuscated during read.')
@secure()
param accessKey2 string = ''

@description('Optional. Dead letter storage secret for key-based authentication. Will be obfuscated during read.')
@secure()
param deadLetterSecret string = ''

@description('Optional. Dead letter storage URL for identity-based authentication.')
param deadLetterUri string = ''

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

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

resource digitalTwinsInstance 'Microsoft.DigitalTwins/digitalTwinsInstances@2022-05-31' existing = {
  name: digitalTwinInstanceName
}

resource endpoint 'Microsoft.DigitalTwins/digitalTwinsInstances/endpoints@2022-10-31' = {
  name: name
  parent: digitalTwinsInstance
  properties: {
    endpointType: 'EventGrid'
    authenticationType: authenticationType
    TopicEndpoint: topicEndpoint
    accessKey1: accessKey1
    accessKey2: accessKey2
    deadLetterSecret: deadLetterSecret
    deadLetterUri: deadLetterUri
  }
}

@description('The resource ID of the Endpoint.')
output resourceId string = endpoint.id

@description('The name of the resource group the resource was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Endpoint.')
output name string = endpoint.name