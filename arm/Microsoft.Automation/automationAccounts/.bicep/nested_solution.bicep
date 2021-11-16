param name string
param logAnalyticsWorkspaceName string
param location string
// param product string = 'OMSGallery'
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
    product: name
    publisher: publisher
  }
}

output solutionResourceId string = solution.id
output solutionResourceGroup string = resourceGroup().name
output solutionName string = solution.name
