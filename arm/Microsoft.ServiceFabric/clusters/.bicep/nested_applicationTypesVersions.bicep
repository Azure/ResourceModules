param name string
param location string
param tags object
param properties object

resource serviceFabricClusterApplcationTypesVersion_resource 'Microsoft.ServiceFabric/clusters/applicationTypes/versions@2021-06-01' = {
  name: name
  location: location
  tags: tags
  properties: properties
}

// Output
output serviceFabricClusterApplcationTypesVersionId string = serviceFabricClusterApplcationTypesVersion_resource.id
