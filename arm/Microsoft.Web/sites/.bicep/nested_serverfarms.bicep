@description('Required. The name of the app service plan to deploy.')
@minLength(1)
@maxLength(40)
param name string

@description('Required. Defines the name, tier, size, family and capacity of the app service plan.')
param sku object

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Kind of server OS.')
@allowed([
  'Windows'
  'Linux'
])
param serverOS string = 'Windows'

@description('Optional. The resource ID of the app service environment to use for this resource.')
param appServiceEnvironmentId string = ''

@description('Optional. Target worker tier assigned to the app service plan.')
param workerTierName string = ''

@description('Optional. If true, apps assigned to this app service plan can be scaled independently. If false, apps assigned to this app service plan will scale to all instances of the plan.')
param perSiteScaling bool = false

@description('Optional. Maximum number of total workers allowed for this ElasticScaleEnabled app service plan.')
param maximumElasticWorkerCount int = 1

@description('Optional. Scaling worker count.')
param targetWorkerCount int = 0

@description('Optional. The instance size of the hosting plan (small, medium, or large).')
@allowed([
  0
  1
  2
])
param targetWorkerSize int = 0

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Tags of the resource.')
param tags object = {}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: name
  kind: serverOS == 'Windows' ? '' : 'linux'
  location: location
  tags: tags
  sku: sku
  properties: {
    workerTierName: workerTierName
    hostingEnvironmentProfile: !empty(appServiceEnvironmentId) ? {
      id: appServiceEnvironmentId
    } : null
    perSiteScaling: perSiteScaling
    maximumElasticWorkerCount: maximumElasticWorkerCount
    reserved: serverOS == 'Linux'
    targetWorkerCount: targetWorkerCount
    targetWorkerSizeId: targetWorkerSize
  }
}

resource appServicePlan_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${appServicePlan.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: appServicePlan
}

@description('The name of the app service plan.')
output appServicePlanName string = appServicePlan.name

@description('The resource ID of the app service plan.')
output appServicePlanResourceId string = appServicePlan.id

@description('The resource group the app service plan was deployed into.')
output appServicePlanResourceGroup string = resourceGroup().name
