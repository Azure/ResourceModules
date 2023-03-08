@description('Required. The name of the server.')
param serverName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

module serverDeployment '../../deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test'
  params: {
    name: serverName
    administratorLogin: 'adminUserName'
    administratorLoginPassword: password
    databases: [
      {
        name: databaseName
        skuTier: 'Basic'
        skuName: 'Basic'
        maxSizeBytes: 2147483648
      }
    ]
  }
}

@description('The resource ID of the created database.')
output databaseId string = resourceId('Microsoft.Sql/servers/databases', serverDeployment.outputs.name, databaseName)

@description('The name of the created database.')
output databaseName string = databaseName
