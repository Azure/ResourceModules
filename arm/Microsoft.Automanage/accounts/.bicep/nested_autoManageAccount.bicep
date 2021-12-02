param location string
param autoManageAccountName string

resource account 'Microsoft.Automanage/accounts@2020-06-30-preview' = {
  name: autoManageAccountName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
}

@description('The name of the auto manage account')
output accountName string = account.name
@description('The resource ID of the auto manage account')
output accountResourceId string = account.id
@description('The principal ID of the system assigned identity')
output principalId string = account.identity.principalId
