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
