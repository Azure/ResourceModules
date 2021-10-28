param applicationObj object
param clusterName string
param location string
param tags object
param identity object
param properties object

resource application 'Microsoft.ServiceFabric/clusters/applications@2021-06-01' = {
  name: '${clusterName}/application-${applicationObj.name}'
  location: location
  tags: tags
  identity: identity
  properties: properties

  resource services 'services@2021-06-01' = [for service in applicationObj.applicationsServices: {
    name: service.name
    location: location
    tags: tags
    properties: !empty(service.properties) ? service.properties : null
  }]
}

// Output
output applicationResourceId string = application.id
