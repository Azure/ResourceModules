var location = 'westeurope'

module minimalWebPubSubDeployment '../deploy.bicep' = {
  name: 'minimalWebPubSubDeployment'
  params: {
    name: 'minimalWebPubSubDeployment'
    location: location
  }
}
