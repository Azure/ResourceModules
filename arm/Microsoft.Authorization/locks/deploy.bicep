targetScope = 'subscription'

@allowed([
  'CanNotDelete'
  'ReadOnly'
])
@description('Required. Set lock level.')
param level string

@description('Optional. The decription attached to the lock.')
param notes string = level == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Name of the Resource Group to assign the lock to. If Resource Group name is provided, and Subscription ID is provided, the module deploys at resource group level, therefore assigns the provided lock to the resource group.')
param resourceGroupName string = ''

@description('Optional. Subscription ID of the subscription to assign the lock to.')
param subscriptionId string = ''

@sys.description('Optional. Location for all resources.')
param location string = deployment().location

var enableReferencedModulesTelemetry = false

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

module lock_rg 'resourceGroup/deploy.bicep' = if (!empty(resourceGroupName) && !empty(subscriptionId)) {
  name: '${uniqueString(deployment().name, location)}-Lock-RG-Module'
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    name: '${resourceGroupName}-${level}-lock'
    level: level
    notes: notes
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

@description('The name of the lock.')
output name string = lock_rg.outputs.name

@description('The resource ID of the lock.')
output resourceId string = lock_rg.outputs.resourceId
