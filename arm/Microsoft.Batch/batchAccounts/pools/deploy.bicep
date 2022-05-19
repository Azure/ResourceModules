@description('Conditional. The name of the parent Batch Account. Required if the template is used in a standalone deployment.')
param batchAccountName string = ''

@description('Optional. The list of user identities associated with the Batch pool.')
param userAssignedIdentities object = {}

@description('Optional. The list of application licenses must be a subset of available Batch service application licenses. If a license is requested which is not supported, pool creation will fail.')
param applicationLicenses array = []

@description('Optional. The list of application packages to install on the nodes. There is a maximum of 10 application package references on any given pool.')
@maxLength(10)
param applicationPackages array = []

@description('Optional.')
param certificates array = []

@description('Required.')
param deploymentConfiguration object

@description('Required.')
param displayName string

@description('Optional.')
@allowed([
  'Enabled'
  'Disabled'
])
param interNodeCommunication string = 'Disabled'

@description('Optional.')
param metadata array = []

@description('Optional.')
param mountConfiguration array = []

@description('Required.')
param networkConfiguration object

@description('Required.')
param scaleSettings object

@description('Optional.')
param startTask object = {}

@description('Optional.')
@allowed([
  'Pack'
  'Spread'
])
param taskSchedulingPolicy string = 'Pack'

@description('Optional.')
param taskSlotsPerNode int = 1

@description('Optional.')
param userAccounts array = []

@description('Required.')
param vmSize string


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
  parent: batchAccount
  identity: identity
  properties: {
    applicationLicenses: applicationLicenses
    applicationPackages: applicationPackages
    certificates: certificates
    deploymentConfiguration: deploymentConfiguration
    displayName: displayName
    interNodeCommunication: interNodeCommunication
    metadata: metadata
    mountConfiguration: mountConfiguration
    networkConfiguration: networkConfiguration
    scaleSettings: scaleSettings
    startTask: startTask
    taskSchedulingPolicy: {
      nodeFillType: taskSchedulingPolicy
    }
    taskSlotsPerNode: taskSlotsPerNode
    userAccounts: userAccounts
    vmSize: vmSize
  }
}
