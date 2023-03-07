targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Required. The name of the resource group to deploy')
param resourceGroupName string = 'workload-rg'

@description('Optional. The location to deploy into')
param location string = deployment().location

@description('Required. The name of the storage account to deploy')
param storageAccountName string

@description('Required. The name of the key vault to deploy')
param keyVaultName string

@description('Required. The name of the log analytics workspace to deploy')
param logAnalyticsWorkspaceName string

// =========== //
// Deployments //
// =========== //

module rg '../modules/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: 'workload-rg'
  params: {
    name: resourceGroupName
    location: location
  }
}

module sa '../modules/Microsoft.Storage/storageAccounts/deploy.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'workload-sa'
  params: {
    name: storageAccountName
  }
  dependsOn: [
    rg
  ]
}

module kv '../modules/Microsoft.KeyVault/vaults/deploy.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'workload-kv'
  params: {
    name: keyVaultName
  }
  dependsOn: [
    rg
  ]
}

module law '../modules/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'workload-law'
  params: {
    name: logAnalyticsWorkspaceName
  }
  dependsOn: [
    rg
  ]
}

// ======= //
// Outputs //
// ======= //

@description('The resource ID of the deployed resource group')
output resourceGroupResourceId string = rg.outputs.resourceId

@description('The resource ID of the deployed storage account')
output storageAccountResourceId string = sa.outputs.resourceId

@description('The resource ID of the deployed key vault')
output keyVaultResourceId string = kv.outputs.resourceId

@description('The resource ID of the deployed log analytics workspace')
output logAnalyticsWorkspaceResourceId string = law.outputs.resourceId
