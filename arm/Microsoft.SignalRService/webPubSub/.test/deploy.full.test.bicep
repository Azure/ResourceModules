var location = 'westeurope'

module fullWebPubSubDeployment '../deploy.bicep' = {
  name: 'fullWebPubSubDeployment'
  params: {
    name: 'fullWebPubSubDeployment'
    location: location
    capacity: 2
    clientCertEnabled: false
    disableAadAuth: false
    disableLocalAuth: true
    lock: 'CanNotDelete'
    sku: 'Standard_S1'
    systemAssignedIdentity: true
    tags: {
      purpose: 'test'
    }
    resourceLogConfigurationsToEnable: [
      'ConnectivityLogs'
    ]
  }
}
