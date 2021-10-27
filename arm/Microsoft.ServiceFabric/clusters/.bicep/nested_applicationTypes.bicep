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

  resource versions 'versions@2021-06-01' = [for version in applicationTypeObj.applicationTypesVersions: {
    name: version.name
    location: location
    tags: tags
    properties: !empty(version.properties) ? version.properties : null
  }]
}

// Output
output applicationTypeResourceId string = applicationType.id
