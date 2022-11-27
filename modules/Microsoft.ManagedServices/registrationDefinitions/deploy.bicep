targetScope = 'subscription'

@description('Required. Specify a unique name for your offer/registration. i.e \'<Managing Tenant> - <Remote Tenant> - <ResourceName>\'.')
param name string

@description('Required. Description of the offer/registration. i.e. \'Managed by <Managing Org Name>\'.')
param registrationDescription string

@description('Required. Specify the tenant ID of the tenant which homes the principals you are delegating permissions to.')
param managedByTenantId string

@description('Required. Specify an array of objects, containing object of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider\'s Active Directory and the principalIdDisplayName is visible to customers.')
param authorizations array

@description('Optional. Specify the name of the Resource Group to delegate access to. If not provided, delegation will be done on the targeted subscription.')
param resourceGroupName string = ''

@description('Optional. Location deployment metadata.')
param location string = deployment().location

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

var registrationId = empty(resourceGroupName) ? guid(managedByTenantId, subscription().tenantId, subscription().subscriptionId) : guid(managedByTenantId, subscription().tenantId, subscription().subscriptionId, resourceGroupName)

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource registrationDefinition 'Microsoft.ManagedServices/registrationDefinitions@2019-09-01' = {
  name: registrationId
  properties: {
    registrationDefinitionName: name
    description: registrationDescription
    managedByTenantId: managedByTenantId
    authorizations: authorizations
  }
}

resource registrationAssignment_sub 'Microsoft.ManagedServices/registrationAssignments@2019-09-01' = if (empty(resourceGroupName)) {
  name: registrationId
  properties: {
    registrationDefinitionId: registrationDefinition.id
  }
}

module registrationAssignment_rg '.bicep/nested_registrationAssignment.bicep' = if (!empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name)}-RegDef-RegAssignment'
  scope: resourceGroup(resourceGroupName)
  params: {
    registrationDefinitionId: registrationDefinition.id
    registrationAssignmentId: registrationId
  }
}

@description('The name of the registration definition.')
output name string = registrationDefinition.name

@description('The resource ID of the registration definition.')
output resourceId string = registrationDefinition.id

@description('The subscription the registration definition was deployed into.')
output subscriptionName string = subscription().displayName

@description('The registration assignment resource ID.')
output assignmentResourceId string = empty(resourceGroupName) ? registrationAssignment_sub.id : registrationAssignment_rg.outputs.resourceId
