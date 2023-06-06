@sys.description('Required. Name of the webtest.')
param name string

@sys.description('Required. User defined name if this WebTest.')
param webTestName string

@sys.description('Required. A single hidden-link tag pointing to an existing AI component is required.')
param tags object

@sys.description('Required. The collection of request properties.')
param request object

@sys.description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@sys.description('Optional. User defined description for this WebTest.')
param description string = ''

@sys.description('Optional. Unique ID of this WebTest.')
param syntheticMonitorId string = name

@sys.description('Optional. The kind of WebTest that this web test watches.')
@allowed([
  'multistep'
  'ping'
  'standard'
])
param kind string = 'standard'

@sys.description('Optional. List of where to physically run the tests from to give global coverage for accessibility of your application.')
param locations array = [
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

@sys.description('Optional. Is the test actively being monitored.')
param enabled bool = true

@sys.description('Optional. Interval in seconds between test runs for this WebTest.')
param frequency int = 300

@sys.description('Optional. Seconds until this WebTest will timeout and fail.')
param timeout int = 30

@sys.description('Optional. Allow for retries should this WebTest fail.')
param retryEnabled bool = true

@sys.description('Optional. The collection of validation rule properties.')
param validationRules object = {}

@sys.description('Optional. An XML configuration specification for a WebTest.')
param configuration object = {}

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@sys.description('Optional. Specify the type of lock.')
param lock string = ''

@sys.description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
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

resource webtest 'Microsoft.Insights/webtests@2022-06-15' = {
  name: name
  location: location
  tags: tags
  properties: {
    Kind: kind
    Locations: locations
    Name: webTestName
    Description: description
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

resource webtest_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${webtest.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: webtest
}

module webtest_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-WebTests-Rbac-${index}'
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

@sys.description('The name of the webtest.')
output name string = webtest.name

@sys.description('The resource ID of the webtest.')
output resourceId string = webtest.id

@sys.description('The resource group the resource was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The location the resource was deployed into.')
output location string = webtest.location
