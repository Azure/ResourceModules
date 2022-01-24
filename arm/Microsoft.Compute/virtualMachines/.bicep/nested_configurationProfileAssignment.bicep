@description('Optional. The name of the configuration profile assignment')
param name string = 'default'

@description('Required. The name of the VM to be associated')
param virtualMachineName string

@description('Required. The configuration profile of automanage')
@allowed([
  '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction'
  '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesDevTest'
])
param configurationProfile string

resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-07-01' existing = {
  name: virtualMachineName
}

resource configurationProfileAssignment 'Microsoft.Automanage/configurationProfileAssignments@2021-04-30-preview' = {
  name: name
  properties: {
    configurationProfile: configurationProfile
  }
  scope: virtualMachine
}

@description('The resource ID of the configuration profile assignment')
output resourceId string = configurationProfileAssignment.id

@description('The name of the configuration profile assignment')
output name string = configurationProfileAssignment.name

@description('The resource group the configuration profile assignment was deployed into')
output resourceGroupName string = resourceGroup().name
