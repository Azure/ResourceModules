targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

// Resource Group
@description('Required. The name of the resource group to deploy for a testing purposes')
param resourceGroupName string

// Shared
var location = deployment().location
var serviceShort = 'vmlinpar'

// =========== //
// Deployments //
// =========== //

module resourceGroup '../../../../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-rg'
  params: {
    name: resourceGroupName
    location: location
  }
}

module diagnoticStorageAccount '../../../../../arm/Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-sa'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: 'adpsxxazsa${serviceShort}01'
    storageAccountKind: 'StorageV2'
    storageAccountSku: 'Standard_LRS'
    allowBlobPublicAccess: false
  }
  dependsOn: [
    resourceGroup
  ]
}

module logAnalyticsWorkspace '../../../../../arm/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-oms'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: 'adp-sxx-law-${serviceShort}-01'
  }
  dependsOn: [
    resourceGroup
  ]
}

module eventHubNamespace '../../../../../arm/Microsoft.EventHub/namespaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-ehn'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: 'adp-sxx-evhns-${serviceShort}-01'
    eventHubs: [
      {
        name: 'adp-sxx-evh-${serviceShort}-01'
        authorizationRules: [
          {
            name: 'RootManageSharedAccessKey'
            rights: [
              'Listen'
              'Manage'
              'Send'
            ]
          }
        ]
      }
    ]
  }
  dependsOn: [
    resourceGroup
  ]
}

module managedIdentity '../../../../../arm/Microsoft.ManagedIdentity/userAssignedIdentities/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-mi'
  params: {
    name: 'adp-sxx-msi-${serviceShort}-01'
  }
  dependsOn: [
    resourceGroup
  ]
}

module networkSecurityGroup '../../../../../arm/Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-nsg'
  params: {
    name: 'adp-sxx-nsg-${serviceShort}-01'
  }
  dependsOn: [
    resourceGroup
  ]
}

module virtualNetwork '../../../../../arm/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-vnet'
  params: {
    name: 'adp-sxx-vnet-${serviceShort}-01'
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'sxx-subnet-x-01'
        addressPrefix: '10.0.0.0/24'
        networkSecurityGroupName: networkSecurityGroup.outputs.networkSecurityGroupName
      }
    ]
  }
  dependsOn: [
    resourceGroup
  ]
}

module recoveryServicesVault '../../../../../arm/Microsoft.RecoveryServices/vaults/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-rsv'
  params: {
    name: 'adp-sxx-rsv-${serviceShort}-01'
    backupPolicies: [
      {
        name: 'VMpolicy'
        type: 'Microsoft.RecoveryServices/vaults/backupPolicies'
        properties: {
          backupManagementType: 'AzureIaasVM'
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunFrequency: 'Daily'
            scheduleRunTimes: [
              '2019-11-07T07:0:0Z'
            ]
            scheduleWeeklyFrequency: 0
          }
          retentionPolicy: {
            retentionPolicyType: 'LongTermRetentionPolicy'
            dailySchedule: {
              retentionTimes: [
                '2019-11-07T04:30:0Z'
              ]
              retentionDuration: {
                count: 30
                durationType: 'Days'
              }
            }
          }
        }
      }
    ]
  }
  dependsOn: [
    resourceGroup
  ]
}

@description('The name of the resource group')
output resourceGroupName string = resourceGroup.outputs.resourceGroupName

@description('The resource ID of the resource group')
output resourceGroupResourceId string = resourceGroup.outputs.resourceGroupResourceId
