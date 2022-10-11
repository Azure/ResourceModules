@description('Required. The name of the Action Group to create.')
param actionGroupName string

@description('Optional. The location to deploy to.')
param location string = 'global'

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/identities@2022-01-31-preview' = {
  name: managedIdentityName
}

resource actionGroup 'Microsoft.Insights/actionGroups@2022-06-01' = {
  name: actionGroupName
  location: location
}

@description('The resource ID of the created Action Group.')
output actionGroupResourceId string = actionGroup.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
