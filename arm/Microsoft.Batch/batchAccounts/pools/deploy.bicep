@description('Required. The name of the parent Batch Account. Required if the template is used in a standalone deployment.')
param batchAccountName string

@description('Required. The name of the pool.')
param poolName string

@description('Optional. The user identities associated with the Batch pool.')
param userAssignedIdentities object = {}

@description('Optional. The list of application licenses must be a subset of available Batch service application licenses. If a license is requested which is not supported, pool creation will fail.')
param applicationLicenses array = []

@description('Optional. The list of application packages to install on the nodes. There is a maximum of 10 application package references on any given pool.')
@maxLength(10)
param applicationPackages array = []

@description('Optional. The list of certificate objects to install on the pool.')
param certificates array = []

@description('Required. Deployment configuration properties.')
param deploymentConfiguration object

@description('Required. The display name need not be unique and can contain any Unicode characters up to a maximum length of 1024.')
param displayName string

@description('Optional. This imposes restrictions on which nodes can be assigned to the pool.')
@allowed([
  'Enabled'
  'Disabled'
])
param interNodeCommunication string = 'Disabled'

@description('Optional. The List of metadate for the use of user code.')
param metadata array = []

@description('Optional. The List of mount configurations. This supports Azure Files, NFS, CIFS/SMB, and Blobfuse.')
param mountConfiguration array = []

@description('Required. The network configuration for a pool.')
param networkConfiguration object

@description('Required. Defines the desired size of the pool.')
param scaleSettings object

@description('Optional. The start task is executed when a node is started up.')
param startTask object = {}

@description('Optional. Specifies how tasks should be distributed across compute nodes.')
@allowed([
  'Pack'
  'Spread'
])
param taskSchedulingPolicy string = 'Pack'

@description('Optional. Number of tasks slots per node. Cannot be modified after pool creation. The maximum value is the smaller of 4 times the number of cores of the vmSize of the pool or 256.')
param taskSlotsPerNode int = 1

@description('Optional. The list of user accounts to be created on each node in the pool.')
param userAccounts array = []

@description('Required. For information about available sizes of virtual machines for Cloud Services pools (pools created with cloudServiceConfiguration), see Sizes for Cloud Services (https://azure.microsoft.com/documentation/articles/cloud-services-sizes-specs/).')
param vmSize string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

var identityType = !empty(userAssignedIdentities) ? 'UserAssigned' : 'None'

var identity = {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource batchAccount 'Microsoft.Batch/batchAccounts@2022-01-01' existing = {
  name: batchAccountName
}

resource pool 'Microsoft.Batch/batchAccounts/pools@2022-01-01' = {
  name: poolName
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

@description('The name of the deployed batch account pool.')
output name string = pool.name

@description('The resource ID of the deployed batch account pool.')
output resourceId string = pool.id

@description('The resource group of the deployed batch account pool.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = batchAccount.location
