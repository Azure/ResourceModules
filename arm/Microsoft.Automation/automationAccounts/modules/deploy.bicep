@description('Required. Name of the Automation Account')
param name string

@description('Required. Name of the parent Automation Account')
param parent string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Module version or specify latest to get the latest version')
param version string = 'latest'

@description('Required. Module package uri, e.g. https://www.powershellgallery.com/api/v2/package')
param uri string

@description('Optional. Tags of the Automation Account resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource module_automationAccount 'Microsoft.Automation/automationAccounts@2020-01-13-preview' existing = {
  name: parent
}

resource module 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: name
  parent: module_automationAccount
  location: location
  tags: tags
  properties: {
    contentLink: {
      uri: version == 'latest' ? '${uri}/${name}' : '${uri}/${name}/${version}'
      version: version == 'latest' ? null : version
    }
  }
}

@description('The name of the deployed module')
output moduleName string = module.name

@description('The id of the deployed module')
output moduleResourceId string = module.id

@description('The resource group of the deployed module')
output moduleResourceGroup string = resourceGroup().name
