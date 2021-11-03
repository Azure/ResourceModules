targetScope = 'subscription'

@description('Optional. The resource group name where automanage will be created')
param autoManageAccountResourceGroupName string = '${replace(subscription().displayName, ' ', '')}_group'

@description('Optional. The name of automanage account')
param autoManageAccountName string = '${replace(subscription().displayName, ' ', '')}-AutoManage'

@description('Optional. The location of automanage')
param location string = deployment().location

@description('Required. The name of the VM resource group')
param vmResourceGroupName string

@description('Required. The name of the VM to be associated')
param vmName string

@description('Optional. The configuration profile of automanage')
@allowed([
  'Production'
  'Dev/Test'
])
param configurationProfile string = 'Production'

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered.')
param cuaId string = ''

var contributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
var resourcePolicyContributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')

module pidName '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

module autoManageAccount '.bicep/nested_autoManageAccount.bicep' = {
  name: 'autoManageAccount-${uniqueString(subscription().subscriptionId, autoManageAccountResourceGroupName, autoManageAccountName)}'
  scope: resourceGroup(autoManageAccountResourceGroupName)
  params: {
    location: location
    autoManageAccountName: autoManageAccountName
  }
}

//principalId: (createAutoManageAccount ? autoManageAccount.outputs.principalId : 'resource not deployed')
resource autoManageAccount_permissions_contributor 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(autoManageAccountResourceGroupName, autoManageAccountName, contributor)
  properties: {
    roleDefinitionId: contributor
    principalId: autoManageAccount.outputs.principalId
    principalType: 'ServicePrincipal'
  }
}

resource autoManageAccount_permissions_resourcePolicyContributor 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(autoManageAccountResourceGroupName, autoManageAccountName, resourcePolicyContributor)
  properties: {
    roleDefinitionId: resourcePolicyContributor
    principalId: autoManageAccount.outputs.principalId
    principalType: 'ServicePrincipal'
  }
}

module configurationProfileAssignment '.bicep/nested_configurationProfileAssignment.bicep' = {
  name: 'configurationProfileAssignment-${uniqueString(vmResourceGroupName, vmName)}'
  scope: resourceGroup(vmResourceGroupName)
  params: {
    vmName: vmName
    configurationProfile: configurationProfile
    autoManageAccountResourceId: autoManageAccount.outputs.accountResourceId
  }
}

output autoManageAccountResourceId string = autoManageAccount.outputs.accountResourceId
output autoManageAccountName string = autoManageAccount.outputs.accountName
output autoManageAccountResourceGroup string = autoManageAccountResourceGroupName
