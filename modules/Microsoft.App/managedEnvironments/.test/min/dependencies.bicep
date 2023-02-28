@description('Required. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Log Analytics Workspace to create.')
param logAnalyticsWorkspaceName string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

@description('The principal ID of the created Managed Environment.')
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name

@description('The principal ID of the created Managed Environment.')
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
