@description('Required. Name of the Azure Recovery Service Vault')
param recoveryVaultName string

@description('Required. The name of the replication policy')
param name string

@description('Optional. The app consistent snapshot frequency (in minutes).')
param appConsistentFrequencyInMinutes int = 60

@description('Optional. The crash consistent snapshot frequency (in minutes).')
param crashConsistentFrequencyInMinutes int = 5

@description('Optional. A value indicating whether multi-VM sync has to be enabled.')
@allowed([
  'Enable'
  'Disable'
])
param multiVmSyncStatus string = 'Enable'

@description('Optional. The duration in minutes until which the recovery points need to be stored.')
param recoveryPointHistory int = 1440

resource replicationPolicy 'Microsoft.RecoveryServices/vaults/replicationPolicies@2021-12-01' = {
  name: '${recoveryVaultName}/${name}'
  properties: {
    providerSpecificInput: {
      instanceType: 'A2A'
      appConsistentFrequencyInMinutes: appConsistentFrequencyInMinutes
      crashConsistentFrequencyInMinutes: crashConsistentFrequencyInMinutes
      multiVmSyncStatus: multiVmSyncStatus
      recoveryPointHistory: recoveryPointHistory
    }
  }
}
@description('The name of the replication policy.')
output name string = replicationPolicy.name

@description('The resource ID of the replication policy.')
output resourceId string = replicationPolicy.id

@description('The name of the resource group the replication policy was created in.')
output resourceGroupName string = resourceGroup().name
