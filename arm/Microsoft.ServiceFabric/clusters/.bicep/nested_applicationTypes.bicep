param applicationTypeObj object
param clusterName string
param location string
param tags object
param properties object

resource applicationType 'Microsoft.ServiceFabric/clusters/applicationTypes@2021-06-01' = {
  name: '${clusterName}/applicationTypes-${applicationTypeObj.name}'
  location: location
  tags: tags
  properties: properties

  resource versions 'versions@2021-06-01' = [for applicationTypesVersion in applicationTypeObj.applicationTypesVersions: {
    name: applicationTypesVersion.name
    location: location
    tags: tags
    properties: !empty(applicationTypesVersion.properties) ? applicationTypesVersion.properties : null
  }]
}

// Output
output applicationTypeResourceId string = applicationType.id
