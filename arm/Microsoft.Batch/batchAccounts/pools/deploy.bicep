@description('Conditional. The name of the parent Batch Account. Required if the template is used in a standalone deployment.')
param batchAccountName string = ''

@description('Optional. The list of user identities associated with the Batch pool.')
param userAssignedIdentities object = {}

@description('The list of application licenses must be a subset of available Batch service application licenses. If a license is requested which is not supported, pool creation will fail.')
param applicationLicenses array = []

@description('The list of application packages to install on the nodes. There is a maximum of 10 application package references on any given pool.')
@maxLength(10)
param applicationPackages array = []

@description('')
param certificates array = []

var identityType = !empty(userAssignedIdentities) ? 'UserAssigned' : 'None'

var identity = {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
}

resource batchAccount 'Microsoft.Batch/batchAccounts@2022-01-01' existing = {
  name: batchAccountName
}

resource pool 'Microsoft.Batch/batchAccounts/pools@2022-01-01' = {
  name: 'string'
  parent: batchAccount.name
  identity: identity
  properties: {
    applicationLicenses: applicationLicenses []
    applicationPackages: applicationPackages []
    certificates: certificates []
    deploymentConfiguration: deploymentConfiguration {}
    displayName: poolDisplayName 'string'
    interNodeCommunication: interNodeCommunication 'string'
    metadata: metadata []
    mountConfiguration: mountConfiguration []
    networkConfiguration: networkConfiguration {}
    scaleSettings: scaleSettings {}
    startTask: startTask {}
    taskSchedulingPolicy: {
      nodeFillType: taskSchedulingPolicy 'Pack','Spread'
    }
    taskSlotsPerNode: taskSlotsPerNode int
    userAccounts: userAccounts []
    vmSize: vmSize 'string'
  }
}
