@description('Required. The name of the registry.')
param registryName string

@description('Optional. The name of the registry webhook.')
param webhookName string = '${registryName}-webhook'

@description('Required. Service URI.')
param serviceUri string

@allowed([
  'disabled'
  'enabled'
])
@description('Optional. status of webhook.')
param status string = 'enabled'

@description('Optional. possible actions.')
param action array = [
  'chart_delete'
  'chart_push'
  'delete'
  'push'
  'quarantine'
]

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. custom headers for resources.')
param customHeaders object = {}

@description('Optional. scopes like foo:*.')
param scope string = ''

resource registry 'Microsoft.ContainerRegistry/registries@2021-09-01' existing = {
  name: registryName
}

resource webhook 'Microsoft.ContainerRegistry/registries/webhooks@2021-12-01-preview' = {
  name: webhookName
  parent: registry
  location: location
  tags: tags
  properties: {
    actions: action
    customHeaders: customHeaders
    scope: scope
    serviceUri: serviceUri
    status: status
  }
}

@description('The id of the webhook.')
output webhookId string = webhook.id

@description('The name of the webhook.')
output webhookName string = webhook.name

@description('The actions of the webhook.')
output webhookActions array = webhook.properties.actions

@description('The status of the webhook.')
output webhookStatus string = webhook.properties.status

@description('The provisioning state of the webhook.')
output webhookprovistioningState string = webhook.properties.provisioningState

@description('The location of the webhook.')
output webhookLocation string = webhook.location
