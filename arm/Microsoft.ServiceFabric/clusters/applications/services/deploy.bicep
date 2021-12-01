@description('Required. Name of the Serivce Fabric cluster.')
param serviceFabricClusterName string = ''

@description('Optional. Application name.')
param applicationName string = 'default'

@description('Optional. Name of the Service.')
param serviceName string = 'default'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource serviceFabricCluster 'Microsoft.ServiceFabric/clusters@2021-06-01' existing = {
  name: serviceFabricClusterName

  resource applications 'applications@2021-06-01' existing = {
    name: applicationName
  }
}

resource services 'Microsoft.ServiceFabric/clusters/applications/services@2021-06-01' = {
  name: serviceName
  location: location
  tags: tags
  parent: serviceFabricCluster::applications
  properties: {}
}
