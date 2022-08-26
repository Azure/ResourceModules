targetScope = 'subscription'

@description('Required. The location to deploy to')
param location string

@description('Required. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string

@description('Required. The name of the managed identity to create')
param managedIdentityName string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resourceGroupResources 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    managedIdentityName: managedIdentityName
  }
}

@description('The principal ID of the created managed identity')
output managedIdentityPrincipalId string = resourceGroupResources.outputs.managedIdentityPrincipalId
