@sys.description('Conditional. The name of the parent network manager. Required if the template is used in a standalone deployment.')
param networkManagerName string

@sys.description('Conditional. The name of the parent security admin configuration. Required if the template is used in a standalone deployment.')
param securityAdminConfigurationName string

@sys.description('Conditional. The name of the parent rule collection. Required if the template is used in a standalone deployment.')
param ruleCollectionName string

@maxLength(64)
@sys.description('Required. The name of the rule. A security admin configuration contains a set of rule collections. Each rule collection contains one or more security admin rules.')
param name string

@maxLength(500)
@sys.description('Optional. A description of the rule.')
param description string = ''

@allowed([
  'Allow'
  'AlwaysAllow'
  'Deny'
])
@sys.description('Required. Indicates the access allowed for this particular rule. "Allow" means traffic matching this rule will be allowed. "Deny" means traffic matching this rule will be blocked. "AlwaysAllow" means that traffic matching this rule will be allowed regardless of other rules with lower priority or user-defined NSGs.')
param access string

@sys.description('Optional. List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535.')
param destinationPortRanges array = []

@allowed([
  ''
  'IPPrefix'
  'ServiceTag'
])
@sys.description('Optional. The destination filter can be an IP Address or a service tag. It specifies the outgoing traffic for a specific destination IP address range that will be allowed or denied by this rule.')
param destinationsAddressPrefixType string = ''

@sys.description('Optional. Provide the destination address prefix range using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64), or a service tag (e.g. AppService.WestEurope). You can also provide a comma-separated list of IP addresses or address ranges using either IPv4 or IPv6.')
param destinationsAddressPrefix string = ''

@allowed([
  'Inbound'
  'Outbound'
])
@sys.description('Required. Indicates if the traffic matched against the rule in inbound or outbound.')
param direction string

@minValue(1)
@maxValue(4096)
@sys.description('Required. The priority of the rule. The value can be between 1 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.')
param priority int

@allowed([
  'Ah'
  'Any'
  'Esp'
  'Icmp'
  'Tcp'
  'Udp'
])
@sys.description('Required. Network protocol this rule applies to.')
param protocol string

@sys.description('Optional. List of destination port ranges. This specifies on which ports traffic will be allowed or denied by this rule. Provide an (*) to allow traffic on any port. Port ranges are between 1-65535.')
param sourcePortRanges array = []

@allowed([
  ''
  'IPPrefix'
  'ServiceTag'
])
@sys.description('Optional. The source filter can be an IP Address or a service tag. It specifies the incoming traffic from a specific source IP addresses range that will be allowed or denied by this rule.')
param sourcesAddressPrefixType string = ''

@sys.description('Optional. Provide an address range using CIDR notation (e.g. 192.168.99.0/24 or 2001:1234::/64), or an IP address (e.g. 192.168.99.0 or 2001:1234::), or a service tag (e.g. AppService.WestEurope). You can also provide a comma-separated list of IP addresses or address ranges using either IPv4 or IPv6.')
param sourcesAddressPrefix string = ''

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
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

resource networkManager 'Microsoft.Network/networkManagers@2022-07-01' existing = {
  name: networkManagerName

  resource securityAdminConfiguration 'securityAdminConfigurations@2022-07-01' existing = {
    name: securityAdminConfigurationName

    resource ruleCollection 'ruleCollections@2022-07-01' existing = {
      name: ruleCollectionName
    }
  }
}

resource rule 'Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules@2022-07-01' = {
  name: name
  parent: networkManager::securityAdminConfiguration::ruleCollection
  kind: 'Custom'
  properties: {
    access: access
    description: description
    destinationPortRanges: destinationPortRanges
    destinations: !empty(destinationsAddressPrefix) && !empty(destinationsAddressPrefixType) ? [
      {
        addressPrefix: destinationsAddressPrefix
        addressPrefixType: destinationsAddressPrefixType
      }
    ] : []
    direction: direction
    priority: priority
    protocol: protocol
    sourcePortRanges: sourcePortRanges
    sources: !empty(sourcesAddressPrefix) && !empty(sourcesAddressPrefixType) ? [
      {
        addressPrefix: sourcesAddressPrefix
        addressPrefixType: sourcesAddressPrefixType
      }
    ] : []
  }
}

@sys.description('The name of the deployed rule.')
output name string = rule.name

@sys.description('The resource ID of the deployed rule.')
output resourceId string = rule.id

@sys.description('The resource group the rule was deployed into.')
output resourceGroupName string = resourceGroup().name
