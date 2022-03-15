targetScope = 'subscription'
var rgname = 'scenario2-rg'
var sqlname = 'seklnfkldjrgklj'

module scenario2rg '../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: rgname
  params: {
    name: 'scenario2-rg'
    // location: 'centralus'
  }
}
