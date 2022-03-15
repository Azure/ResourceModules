targetScope = 'subscription'
var rgname = 'scenario1-rg'

module workspaces '../arm/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  scope: resourceGroup(rgname)
  name: 'scenario1-law'
  params: {
    name: 'scenario1-law'
  }
}

module components '../arm/Microsoft.Insights/components/deploy.bicep' = {
  scope: resourceGroup(rgname)
  name: 'scenario1-ai'
  params: {
    name: 'scenario1-ai'
    workspaceResourceId: workspaces.outputs.logAnalyticsWorkspaceId
  }
  dependsOn: [
    workspaces
  ]
}
