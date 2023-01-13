@description('Required. The name of the Event Grid Topic.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Required. Name of the Event Grid Topic.')
param eventGridTopicName string

@description('Optional. Dead Letter Destination. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deadletterdestination-objects for more information).')
param deadLetterDestination object = {}

@description('Optional. Dead Letter with Resource Identity Configuration. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deadletterwithresourceidentity-objects for more information).')
param deadLetterWithResourceIdentity object = {}

@description('Optional. Delivery with Resource Identity Configuration. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deliverywithresourceidentity-objects for more information).')
param deliveryWithResourceIdentity object = {}

@description('Required. The destination for the event subscription. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#eventsubscriptiondestination-objects for more information).')
param destination object

@description('Optional. The event delivery schema for the event subscription.')
param eventDeliverySchema string = 'EventGridSchema'

@description('Optional. The expiration time for the event subscription.')
param expirationTimeUtc string = ''

@description('Optional. The filter for the event subscription.')
param filter object = {}

@description('Optional. The list of user defined labels.')
param labels array = []

@description('Optional. Configuration of the retry Policy.')
param retryPolicy object = {}

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

resource eventGridTopic 'Microsoft.EventGrid/topics@2022-06-15' existing = {
  name: eventGridTopicName
}

resource eventSubscription 'Microsoft.EventGrid/eventSubscriptions@2022-06-15' = {
  name: name
  scope: eventGridTopic
  properties: {
    deadLetterDestination: !empty(deadLetterDestination) ? deadLetterDestination : null
    deadLetterWithResourceIdentity: !empty(deadLetterWithResourceIdentity) ? deadLetterWithResourceIdentity : null
    deliveryWithResourceIdentity: !empty(deliveryWithResourceIdentity) ? deliveryWithResourceIdentity : null
    destination: destination
    eventDeliverySchema: eventDeliverySchema
    expirationTimeUtc: !empty(expirationTimeUtc) ? expirationTimeUtc : ''
    filter: !empty(filter) ? filter : {}
    labels: !empty(labels) ? labels : []
    retryPolicy: !empty(retryPolicy) ? retryPolicy : null
  }
}

@description('The name of the event grid topic.')
output name string = eventSubscription.name

@description('The resource ID of the event grid topic.')
output resourceId string = eventSubscription.id

@description('The name of the resource group the event grid topic was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = eventGridTopic.location
