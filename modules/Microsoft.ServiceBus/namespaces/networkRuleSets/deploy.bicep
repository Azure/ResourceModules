@description('Conditional. The name of the parent Service Bus Namespace for the Service Bus Network Rule Set. Required if the template is used in a standalone deployment.')
@minLength(6)
@maxLength(50)
param namespaceName string

@description('Optional. The default is the only valid ruleset.')
param name string = 'default'

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. This determines if traffic is allowed over public network. Default it is "Enabled". If set to "Disabled", traffic to this namespace will be restricted over Private Endpoints only.')
param publicNetworkAccess string = 'Enabled'

@allowed([
  'Allow'
  'Deny'
])
@description('Optional. Default Action for Network Rule Set. Default is "Allow". Will be set to "Deny" if ipRules/virtualNetworkRules or are being used. If ipRules/virtualNetworkRules are not used and PublicNetworkAccess is set to "Disabled", setting this to "Deny" would render the namespace resources inaccessible for data-plane requests.')
param defaultAction string = 'Allow'

@allowed([
  true
  false
])
@description('Optional. Value that indicates whether Trusted Service Access is enabled or not. Default is "true".')
param trustedServiceAccessEnabled bool = true

@description('Optional. List virtual network rules. When used, defaultAction will be set to "Deny".')
param virtualNetworkRules array = []

@description('Optional. List of IpRules. When used, defaultAction will be set to "Deny".')
param ipRules array = []

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

var networkRules = [for (virtualNetworkRule, index) in virtualNetworkRules: {
  ignoreMissingVnetServiceEndpoint: contains(virtualNetworkRule, 'ignoreMissingVnetServiceEndpoint') ? virtualNetworkRule.ignoreMissingVnetServiceEndpoint : null
  subnet: contains(virtualNetworkRule, 'subnet') ? {
    id: virtualNetworkRule.subnet
  } : null
}]

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

resource namespace 'Microsoft.ServiceBus/namespaces@2021-11-01' existing = {
  name: namespaceName
}

resource networkRuleSet 'Microsoft.ServiceBus/namespaces/networkRuleSets@2021-11-01' = {
  name: name
  parent: namespace
  properties: {
    publicNetworkAccess: publicNetworkAccess
    defaultAction: !empty(ipRules) || !empty(virtualNetworkRules) ? 'Deny' : defaultAction
    trustedServiceAccessEnabled: trustedServiceAccessEnabled
    ipRules: publicNetworkAccess == 'Disabled' ? null : ipRules
    virtualNetworkRules: publicNetworkAccess == 'Disabled' ? null : networkRules
  }
}

@description('The name of the virtual network rule set deployment.')
output name string = networkRuleSet.name

@description('The Resource ID of the virtual network rule set.')
output resourceId string = networkRuleSet.id

@description('The name of the Resource Group the virtual network rule set was created in.')
output resourceGroupName string = resourceGroup().name
