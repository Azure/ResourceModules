@description('Required. Name of the Automation Account module.')
param name string

@description('Required. Name of the parent Automation Account.')
param automationAccountName string

@description('Required. Module package uri, e.g. https://www.powershellgallery.com/api/v2/package.')
param uri string

@description('Optional. Module version or specify latest to get the latest version.')
param version string = 'latest'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the Automation Account resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered.')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource automationAccount 'Microsoft.Automation/automationAccounts@2020-01-13-preview' existing = {
  name: automationAccountName
}

resource module 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: name
  parent: automationAccount
  location: location
  tags: tags
  properties: {
    contentLink: {
      uri: version != 'latest' ? '${uri}/${name}/${version}' : '${uri}/${name}'
      version: version != 'latest' ? version : null
    }
  }
}

@description('The name of the deployed module')
output moduleName string = module.name

@description('The resource ID of the deployed module')
output moduleResourceId string = module.id

@description('The resource group of the deployed module')
output moduleResourceGroup string = resourceGroup().name
