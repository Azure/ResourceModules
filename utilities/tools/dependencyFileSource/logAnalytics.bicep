var logAnalyticsWorkspaceParameters = {
  name: 'adp-sxx-law-${serviceShort}-01'
}
// Modules //
module logAnalyticsWorkspace '../../../../Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-oms'
  params: {
    name: logAnalyticsWorkspaceParameters.name
  }
  dependsOn: [
    resourceGroup
  ]
}
// Output //
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.outputs.logAnalyticsResourceId
