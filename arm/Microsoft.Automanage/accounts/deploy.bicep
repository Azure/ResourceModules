@description('Optional. The name of automanage account')
param name string = '${replace(subscription().displayName, ' ', '')}-AutoManage'

@description('Optional. The location of automanage')
param location string = resourceGroup().location

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

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered.')
param cuaId string = ''

var contributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
var resourcePolicyContributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')

module pidName '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource account 'Microsoft.Automanage/accounts@2020-06-30-preview' = {
  name: name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
}

resource autoManageAccount_permissions_contributor 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(name, contributor)
  properties: {
    roleDefinitionId: contributor
    principalId: account.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource autoManageAccount_permissions_resourcePolicyContributor 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(name, resourcePolicyContributor)
  properties: {
    roleDefinitionId: resourcePolicyContributor
    principalId: account.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

module configurationProfileAssignment '.bicep/nested_configurationProfileAssignment.bicep' = {
  name: '${uniqueString(deployment().name, location)}-ConfigurationProfileAssignment'
  scope: resourceGroup(vmResourceGroupName)
  params: {
    vmName: vmName
    configurationProfile: configurationProfile
    autoManageAccountResourceId: account.id
  }
}

@description('The resource ID of the auto manage account')
output autoManageAccountResourceId string = account.id

@description('The name of the auto manage account')
output autoManageAccountName string = account.name

@description('The resource group the auto manage account was deployed into')
output autoManageAccountResourceGroup string = resourceGroup().name

@description('The principal ID of the system assigned identity')
output principalId string = account.identity.principalId
