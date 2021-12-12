var logAnalyticsWorkspaceParameters = {
  name: 'adp-sxx-law-${serviceShort}-01'
}
// Module //
module logAnalyticsWorkspace '../../../../../arm/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-oms'
  params: {
    name: logAnalyticsWorkspaceParameters.name
  }
  dependsOn: [
    resourceGroup
  ]
}
