targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Required. The name of the resource group to deploy')
param resourceGroupName string = 'carml-rg'

@description('Optional. The location to deploy into')
param location string = deployment().location

@description('Required. The name of the storage account to deploy')
param storageAccountName string

@description('Required. The name of the key vault to deploy')
param keyVaultName string

@description('Required. The name of the log analytics workspace to deploy')
param LogAnalyticsWorkspaceName string

// =========== //
// Deployments //
// =========== //

module rg '../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: 'workload-rg'
  params: {
    name: resourceGroupName
    location: location
  }
}

module sa '../arm/Microsoft.Storage/storageAccounts/deploy.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'workload-sa'
  params: {
    name: storageAccountName
  }
  dependsOn: [
    rg
  ]
}

module kv '../arm/Microsoft.KeyVault/vaults/deploy.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'workload-kv'
  params: {
    name: keyVaultName
  }
  dependsOn: [
    rg
  ]
}

module la '../arm/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'workload-law'
  params: {
    name: LogAnalyticsWorkspaceName
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
output logAnalyticsWorkspaceResourceId string = la.outputs.resourceId
