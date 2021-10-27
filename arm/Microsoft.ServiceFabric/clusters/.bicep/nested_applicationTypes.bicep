param applicationType object
param clusterName string
param location string
param tags object
param properties object

resource applicationTypes 'Microsoft.ServiceFabric/clusters/applicationTypes@2021-06-01' = {
  name: '${clusterName}/applicationTypes-${applicationType.name}'
  location: location
  tags: tags
  properties: properties

  resource versions 'versions@2021-06-01' = [for version in applicationType.applicationTypesVersions: {
    name: version.name
    location: location
    tags: tags
    properties: (!empty(version.properties) ? version.properties : json('null'))
  }]
}

// Output
output serviceFabricClusterApplcationTypesId string = applicationTypes.id
