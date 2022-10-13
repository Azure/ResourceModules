
targetScope = 'subscription'

@description('Required. Resource Group Name.')
param resourceGroupName string

module resourceGroup '../../modules/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: 'resourceGroup_Test'
  params: {
    name: resourceGroupName
  }
}
