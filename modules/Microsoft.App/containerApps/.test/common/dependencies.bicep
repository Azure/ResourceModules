@description('Required. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Log Analytics Workspace.')
param logAnalticsWorkspaceName string

@description('Required. The name of the managed environment for Container Apps.')
param managedEnvironmentName string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: logAnalticsWorkspaceName
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

resource managedEnvironment 'Microsoft.App/managedEnvironments@2022-10-01' = {
  name: managedEnvironmentName
  location: location
  sku: {
    name: 'Consumption'
  }
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
      }
    }
  }
}

@description('The unique guid for this managedIdentity')
param managedIdentityId string = newGuid()

@description('Optional. Identity name')
param miName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: miName
  location: location
}

@description('The ManagedIdenitty ID of the created container apps.')
output managedIdentityId string = managedIdentity.id

@description('The principal ID of the created Managed Environment.')
output managedEnvironmentId string = managedEnvironment.id

@description('The principal ID of the created Managed Environment.')
output logAnaltyicsWorkspaceId string = logAnalyticsWorkspace.id
