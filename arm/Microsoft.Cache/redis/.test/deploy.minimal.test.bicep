var location = 'westeurope'

module minimalRedisCacheDeployment '../deploy.bicep' = {
  name: 'minimalRedisCacheDeployment'
  params: {
    name: 'redis01'
    location: location
  }
}
