@sys.description('Conditional. The name of the parent lab. Required if the template is used in a standalone deployment.')
param labName string

@sys.description('Required. The name of the virtual network.')
param name string

@sys.description('Required. The resource ID of the virtual network.')
param externalProviderResourceId string

@sys.description('Optional. Tags of the resource.')
param tags object = {}

@sys.description('Optional. The description of the virtual network.')
param description string = ''

@sys.description('Optional. The allowed subnets of the virtual network.')
param allowedSubnets array = []

@sys.description('Optional. The subnet overrides of the virtual network.')
param subnetOverrides array = []

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

resource lab 'Microsoft.DevTestLab/labs@2018-09-15' existing = {
  name: labName
}

resource virtualNetwork 'Microsoft.DevTestLab/labs/virtualnetworks@2018-09-15' = {
  name: name
  parent: lab
  tags: tags
  properties: {
    description: description
    externalProviderResourceId: externalProviderResourceId
    allowedSubnets: allowedSubnets
    subnetOverrides: subnetOverrides
  }
}

@sys.description('The name of the lab virtual network.')
output name string = virtualNetwork.name

@sys.description('The resource ID of the lab virtual network.')
output resourceId string = virtualNetwork.id

@sys.description('The name of the resource group the lab virtual network was created in.')
output resourceGroupName string = resourceGroup().name
