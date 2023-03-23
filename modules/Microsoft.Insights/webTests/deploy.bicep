@description('Required. Name of the webtest.')
param name string

@description('Required. User defined name if this WebTest.')
param webTestName string

@description('Required. Tags of the resource.')
param tags object

@description('Required. The collection of request properties.')
param request object

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. User defined description for this WebTest.')
param descriptionWebTest string = ''

@description('Required. Unique ID of this WebTest. This is typically the same value as the Name field.')
param syntheticMonitorId string

@description('Optional. The kind of WebTest that this web test watches. Choices are ping, multistep and standard.')
@allowed([
  'multistep'
  'ping'
  'standard'
])
param kind string = 'standard'

@description('Optional. List of where to physically run the tests from to give global coverage for accessibility of your application.')
param webTestGeolocation array = [
  {
    Id: 'us-il-ch1-azr'
  }
  {
    Id: 'us-fl-mia-edge'
  }
  {
    Id: 'latam-br-gru-edge'
  }
  {
    Id: 'apac-sg-sin-azr'
  }
  {
    Id: 'emea-nl-ams-azr'
  }
]

@description('Optional. Is the test actively being monitored.')
param enabled bool = true

@description('Optional. Interval in seconds between test runs for this WebTest. Default value is 300.')
param frequency int = 300

@description('Optional. Seconds until this WebTest will timeout and fail. Default value is 30.')
param timeout int = 30

@description('Optional. Allow for retries should this WebTest fail.')
param retryEnabled bool = true

@description('Optional. The collection of validation rule properties.')
param validationRules object = {}

@description('Optional. An XML configuration specification for a WebTest.')
param configuration object = {}

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

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

//https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/webtests?pivots=deployment-language-bicep#webtestproperties

resource webtest 'Microsoft.Insights/webtests@2022-06-15' = {
  name: name
  location: location
  tags: tags
  properties: {
    Kind: kind
    Locations: webTestGeolocation
    Name: webTestName
    Description: descriptionWebTest
    SyntheticMonitorId: syntheticMonitorId
    Enabled: enabled
    Frequency: frequency
    Timeout: timeout
    RetryEnabled: retryEnabled
    Request: request
    ValidationRules: validationRules
    Configuration: configuration
  }
}

module webtest_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-AppInsights-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: webtest.id
  }
}]

@description('The name of the webtest.')
output name string = webtest.name

@description('The resource ID of the webtest.')
output resourceId string = webtest.id

@description('The resource group the application insights component was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = webtest.location
