targetScope = 'subscription'

@description('Required. Specify a unique name for your offer/registration. i.e \'<Managing Tenant> - <Remote Tenant> - <ResourceName>\'')
param registrationDefinitionName string

@description('Required. Description of the offer/registration. i.e. \'Managed by <Managing Org Name>\'')
param registrationDescription string

@description('Required. Specify the tenant ID of the tenant which homes the principals you are delegating permissions to.')
param managedByTenantId string

@description('Required. Specify an array of objects, containing object of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider\'s Active Directory and the principalIdDisplayName is visible to customers.')
param authorizations array

@description('Optional. Specify the name of the Resource Group to delegate access to. If not provided, delegation will be done on the targeted subscription.')
param resourceGroupName string = ''

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = if (!empty(resourceGroupName)) {
  name: resourceGroupName
}

resource registrationDefinition 'Microsoft.ManagedServices/registrationDefinitions@2019-06-01' = {
  name: guid(registrationDefinitionName)
  properties: {
    registrationDefinitionName: registrationDefinitionName
    description: registrationDescription
    managedByTenantId: managedByTenantId
    authorizations: authorizations
  }
}

resource registrationAssignment 'Microsoft.ManagedServices/registrationAssignments@2019-06-01' = if (empty(resourceGroupName)) {
  name: guid(managedByTenantId, subscription().subscriptionId)
  properties: {
    registrationDefinitionId: registrationDefinition.id
  }
}

module rgAssignment_resourceGroupName './nested_rgAssignment_resourceGroupName.bicep' = if (!empty(resourceGroupName)) {
  name: guid(managedByTenantId, subscription().subscriptionId, resourceGroupName)
  scope: resourceGroup(resourceGroupName)
  params: {
    resourceId_Microsoft_ManagedServices_registrationDefinitions_variables_registrationDefinitionId: registrationDefinitionId.id
    variables_assignmentId: assignmentId
  }
}

output registrationDefinitionName string = registrationDefinition.name
output registrationDefinitionId string = registrationDefinition.id
output registrationAssignmentId string = registrationAssignment.id
output authorizations array = authorizations
output subscriptionId string = subscription().id
output resourceGroupId string = resourceGroup.id
