@description('Required. Name of the solution')
param name string

@description('Required. Name of the Log Analytics workspace')
param logAnalyticsWorkspaceName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The product of the deployed solution. For gallery solution, it is OMSGallery.')
param product string = 'OMSGallery'

@description('Optional. The publisher name of the deployed solution. For gallery solution, it is Microsoft.')
param publisher string = 'Microsoft'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: logAnalyticsWorkspaceName
}

var solutionName = '${name}(${logAnalyticsWorkspace.name})'

resource solution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: solutionName
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: solutionName
    promotionCode: ''
    product: '${product}/${name}'
    publisher: publisher
  }
}

@description('The name of the deployed solution')
output solutionName string = solution.name

@description('The resource ID of the deployed solution')
output solutionResourceId string = solution.id

@description('The resource group where the solution is deployed')
output solutionResourceGroup string = resourceGroup().name
