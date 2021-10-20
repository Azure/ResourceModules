param name string
param location string
param tags object
param properties object

resource serviceFabricClusterApplicationsServices_resource 'Microsoft.ServiceFabric/clusters/applications/services@2021-06-01' = {
  name: name
  location: location
  tags: tags
  properties: properties
}

// Output
output serviceFabricClusterApplicationsServicesResourceId string = serviceFabricClusterApplicationsServices_resource.id
