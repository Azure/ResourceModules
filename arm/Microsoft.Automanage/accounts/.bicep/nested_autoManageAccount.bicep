param location string
param autoManageAccountName string

resource account 'Microsoft.Automanage/accounts@2020-06-30-preview' = {
  name: autoManageAccountName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
}

output accountName string = account.name
output accountResourceId string = account.id
output principalId string = account.identity.principalId
