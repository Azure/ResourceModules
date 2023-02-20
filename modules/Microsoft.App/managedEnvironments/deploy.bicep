@description('Required. Environment name for Container Apps.')
param name string

@description('Required. Existing Log Analytics Workspace name.')
param logAnalticsWorkspaceName string

@description('Required. Existing resource group name of the Log Analytics Workspace .')
param resourceGroupLAWorkspace string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@allowed([
  'Consumption'
  'Premium'
])
@description('Optional. Managed environment Sku.')
param skuName string = 'Consumption'

@description('Optional. Logs destination.')
param logsDestination string = 'log-analytics'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool

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

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalticsWorkspaceName
  scope: resourceGroup('${resourceGroupLAWorkspace}')
}

resource managedEnvironment 'Microsoft.App/managedEnvironments@2022-06-01-preview' = {
  name: name
  location: location
  sku: {
    name: skuName
  }
  properties: {
    appLogsConfiguration: {
      destination: logsDestination
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
      }
    }
  }
}

module managedEnvironment_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Domain-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: managedEnvironment.id
  }
}]

@description('The name of the resource group the Container Apps was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = managedEnvironment.location

@description('Managed Envrionment Name.')
output name string = managedEnvironment.name

@description('Managed environment ID.')
output resourceId string = managedEnvironment.id

@description('The name of the Log analytics workspace name.')
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name
