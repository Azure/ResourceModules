@description('Required. The name of the VM to be associated')
param vmName string

@description('Optional. The configuration profile of automanage')
@allowed([
  '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction'
  '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesDevTest'
])
param configurationProfile string = '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction'

resource configurationProfileAssignment 'Microsoft.Compute/virtualMachines/providers/configurationProfileAssignments@2021-04-30-preview' = {
  name: '${vmName}/Microsoft.Automanage/default'
  properties: {
    configurationProfile: configurationProfile
  }
}

@description('The resource ID of the configuration profile assignment')
output configurationProfileAssignmentResourceId string = configurationProfileAssignment.id

@description('The name of the configuration profile assignment')
output configurationProfileAssignmentName string = configurationProfileAssignment.name

@description('The resource group the configuration profile assignment was deployed into')
output configurationProfileAssignmentResourceGroup string = resourceGroup().name
