targetScope = 'subscription'
var rgname = 'scenario2-rg'

module containerRegistry '../arm/Microsoft.ContainerRegistry/registries/deploy.bicep' = {
  scope: resourceGroup(rgname)
  name: 'scenario2-cr'
  params: {
    name: 'scenario2cr'
    acrAdminUserEnabled: true
    acrSku: 'Basic'
  }
}
