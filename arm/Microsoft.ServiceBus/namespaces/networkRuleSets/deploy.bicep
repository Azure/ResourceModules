@description('Conditional. The name of the parent Service Bus Namespace for the Service Bus Network Rule Set. Required if the template is used in a standalone deployment.')
@minLength(6)
@maxLength(50)
param namespaceName string

@description('Required. The default is the only valid ruleset.')
param name string = 'default'

@description('Optional. Public Network Access for Premium Sku.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('Optional. Trusted Services Bypass for Premium Sku.')
param allowTrustedServices bool = true

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

resource namespace 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' existing = {
  name: namespaceName
}

resource networkACL 'Microsoft.ServiceBus/namespaces/networkRuleSets@2021-11-01' = {
  name: name
  parent: namespace
  properties: {
    publicNetworkAccess: publicNetworkAccess
    trustedServiceAccessEnabled: allowTrustedServices
  }
}

@description('The name of the Network ACL Deployment.')
output name string = networkACL.name

@description('The Resource ID of the virtual network rule.')
output resourceId string = networkACL.id

@description('The name of the Resource Group the virtual network rule was created in.')
output resourceGroupName string = resourceGroup().name
