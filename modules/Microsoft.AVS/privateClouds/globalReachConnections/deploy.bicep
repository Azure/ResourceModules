// ============== //
//   Parameters   //
// ============== //

@description('Required. Name of the global reach connection in the private cloud')
param name string

@description('Conditional. The name of the parent privateClouds. Required if the template is used in a standalone deployment.')
param privateCloudName string

@description('Optional. Authorization key from the peer express route used for the global reach connection')
param authorizationKey string = ''

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The ID of the Private Cloud\'s ExpressRoute Circuit that is participating in the global reach connection')
param expressRouteId string = ''

@description('Optional. Identifier of the ExpressRoute Circuit to peer with in the global reach connection')
param peerExpressRouteCircuit string = ''

// =============== //
//   Deployments   //
// =============== //

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource privateCloud 'Microsoft.AVS/privateClouds@2022-05-01' existing = {
  name: privateCloudName
}

resource globalReachConnection 'Microsoft.AVS/privateClouds/globalReachConnections@2022-05-01' = {
  parent: privateCloud
  name: name
  properties: {
    authorizationKey: authorizationKey
    expressRouteId: expressRouteId
    peerExpressRouteCircuit: peerExpressRouteCircuit
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the globalReachConnection.')
output name string = globalReachConnection.name

@description('The resource ID of the globalReachConnection.')
output resourceId string = globalReachConnection.id

@description('The name of the resource group the globalReachConnection was created in.')
output resourceGroupName string = resourceGroup().name
