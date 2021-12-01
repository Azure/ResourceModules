@description('Required. Name of the Serivce Fabric cluster.')
param serviceFabricClusterName string = ''

@description('Optional. Application type name.')
param applicationTypeName string = 'default'

@description('The name of the application type version')
param applicationTypeVersionName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Required. The URL to the application package.')
param appPackageUrl string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource serviceFabricCluster 'Microsoft.ServiceFabric/clusters@2021-06-01' existing = {
  name: serviceFabricClusterName

  resource applicationTypes 'applicationTypes@2021-06-01' existing = {
    name: applicationTypeName
  }
}

resource versions 'Microsoft.ServiceFabric/clusters/applicationTypes/versions@2021-06-01' = {
  name: applicationTypeVersionName
  location: location
  tags: tags
  parent: serviceFabricCluster::applicationTypes
  properties: {
    appPackageUrl: appPackageUrl
  }
}
