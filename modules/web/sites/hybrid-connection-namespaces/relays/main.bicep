@description('Required. The resource id of the resource.')
param hybridConnectionResourceId string

@description('Conditional. The name of the parent web site. Required if the template is used in a standalone deployment.')
param webAppName string

@description('Optional. Name of the authorization rule send key to use.')
param sendKeyName string = 'defaultSender'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var splitResourceId = split(hybridConnectionResourceId, '/')

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

resource namespace 'Microsoft.Relay/namespaces@2021-11-01' existing = {
  name: splitResourceId[8]
  scope: resourceGroup(splitResourceId[2], splitResourceId[4])
}

resource hybridConnection 'Microsoft.Relay/namespaces/hybridConnections@2021-11-01' existing = {
  name: splitResourceId[10]
  parent: namespace
}

resource authorizationRule 'Microsoft.Relay/namespaces/hybridConnections/authorizationRules@2021-11-01' existing = {
  name: sendKeyName
  parent: hybridConnection
}

resource hybridConnectionRelay 'Microsoft.Web/sites/hybridConnectionNamespaces/relays@2022-03-01' = {
  name: '${webAppName}/${splitResourceId[8]}/${splitResourceId[10]}'
  properties: {
    serviceBusNamespace: splitResourceId[8]
    serviceBusSuffix: split(substring(namespace.properties.serviceBusEndpoint, indexOf(namespace.properties.serviceBusEndpoint, '.servicebus')), ':')[0]
    relayName: splitResourceId[10]
    relayArmUri: hybridConnection.id
    hostname: split(json(hybridConnection.properties.userMetadata)[0].value, ':')[0]
    port: int(split(json(hybridConnection.properties.userMetadata)[0].value, ':')[1])
    sendKeyName: authorizationRule.name
    sendKeyValue: authorizationRule.listKeys().primaryKey
  }
}

@description('The name of the resource group the resource was deployed into.')
output resourceGroupName string = resourceGroup().name
