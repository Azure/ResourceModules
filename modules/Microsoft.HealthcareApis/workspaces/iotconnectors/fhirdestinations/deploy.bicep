@description('Required. The name of the FHIR destination.')
@maxLength(24)
param name string

@description('Required. The mapping JSON that determines how normalized data is converted to FHIR Observations.')
param destinationMapping object = {
  templateType: 'CollectionFhir'
  template: []
}

@description('Required. The name of the MedTech service to add this destination to.')
param iotConnectorName string

@description('Required. The name of the parent health data services workspace.')
param workspaceName string

@description('Required. The resource identifier of the FHIR Service to connect to.')
param fhirServiceResourceId string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@allowed([
  'Create'
  'Lookup'
])
@description('Optional. Determines how resource identity is resolved on the destination.')
param resourceIdentityResolutionType string = 'Lookup'

// =========== //
// Deployments //
// =========== //
resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource iotConnector 'Microsoft.HealthcareApis/workspaces/iotconnectors@2022-06-01' existing = {
  name: '${workspaceName}/${iotConnectorName}'
}

resource fhirDestination 'Microsoft.HealthcareApis/workspaces/iotconnectors/fhirdestinations@2022-06-01' = {
  name: name
  parent: iotConnector
  location: location
  properties: {
    resourceIdentityResolutionType: resourceIdentityResolutionType
    fhirServiceResourceId: fhirServiceResourceId
    fhirMapping: {
      content: destinationMapping
    }
  }
}

@description('The name of the FHIR destination.')
output name string = fhirDestination.name

@description('The resource ID of the FHIR destination.')
output resourceId string = fhirDestination.id

@description('The resource group where the namespace is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = iotConnector.location

@description('The name of the medtech service.')
output iotConnectorName string = iotConnector.name
