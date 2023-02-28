@description('Required. The name of the Failover group.')
param name string

@description('Required. The name of the parent SQL Server.')
param serverName string

@description('Required. An array containing a PartnerInfo object. [{id: resourceID}]')
param partnerServerId array

@description('Optional. The name of the databases to include in the failover group.')
param databases array = []

@description('Optional. The failover policy.')
@allowed([
  'Manual'
  'Automatic'
])
param failoverPolicy string = 'Manual'

@description('Optional. The failover data loss grace period.')
param failoverWithDataLossGracePeriodMinutes int = 60

resource server 'Microsoft.Sql/servers@2022-05-01-preview' existing = {
  name: serverName
}

resource failoverGroup 'Microsoft.Sql/servers/failoverGroups@2022-05-01-preview' = {
  name: name
  parent: server
  properties: {
    databases: databases
    partnerServers: partnerServerId
    readWriteEndpoint: {
      failoverPolicy: failoverPolicy
      failoverWithDataLossGracePeriodMinutes: failoverPolicy != 'Manual' ? failoverWithDataLossGracePeriodMinutes : null
    }
  }
}

@description('The resource ID of the deployed azure sql failover group.')
output resourceId string = failoverGroup.id

@description('The name of the deployed azure sql failover group.')
output name string = failoverGroup.name

@description('The resource group of the deployed azure sql failover group.')
output resourceGroupName string = resourceGroup().name
