param gallerySolution string
param logAnalyticsWorkspaceName string
param location string
param product string = 'OMSGallery'
param publisher string = 'Microsoft'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource solution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: '${gallerySolution}(${logAnalyticsWorkspace.name})'
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: '${gallerySolution}(${logAnalyticsWorkspace.name})'
    product: '${product}/${gallerySolution}'
    promotionCode: ''
    publisher: publisher
  }
}

@description('The resource ID of the deployed solution')
output solutionResourceId string = solution.id
@description('The resource group where the solution will be deployed')
output solutionResourceGroup string = resourceGroup().name
@description('The name of the deployed solution')
output solutionName string = solution.name
