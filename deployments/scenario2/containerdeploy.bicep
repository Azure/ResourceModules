//Scenario 2

targetScope = 'subscription'

param prefix string = 'scenario2team5'
param location string = 'centralus'

// container registry
module container_registry '../../arm/Microsoft.ContainerRegistry/registries/deploy.bicep' = {
  scope: resourceGroup('team5-app')
  name: '${prefix}-reg'
  params: {
    name: '${prefix}-container'
    location: location
  }
}
