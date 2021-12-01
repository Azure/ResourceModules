@description('Required. Name of the Serivce Fabric cluster.')
param serviceFabricClusterName string = ''

@description('Optional. Application type name.')
param applicationTypeName string = 'defaultApplicationType'

@description('Optional. Array of Versions to create.')
param versions array = []

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. The application type name properties.')
param properties object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource serviceFabricCluster 'Microsoft.ServiceFabric/clusters@2021-06-01' existing = {
  name: serviceFabricClusterName
}

resource applicationTypes 'Microsoft.ServiceFabric/clusters/applicationTypes@2021-06-01' = {
  name: applicationTypeName
  location: location
  tags: tags
  properties: !empty(properties) ? properties : null
  parent: serviceFabricCluster
}

module applicationTypes_versions 'versions/deploy.bicep' = [for (version, index) in versions: {
  name: '${deployment().name}-ServiceFabricCluster-Versions-${index}'
  params: {
    appPackageUrl: contains(versions, 'appPackageUrl') ? version.appPackageUrl : null
    applicationTypeVersionName: contains(versions, 'applicationTypeVersionName') ? version.applicationTypeVersionName : null
  }
}]

@description('The resource Id of the application type.')
output applicationTypeResourceId string = applicationTypes.id
