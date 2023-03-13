@description('Required. A short identifier for the kind of deployment.')
param serviceShort string

@description('Required. The location to deploy the primary resources to.')
param primaryLocation string = resourceGroup().location

@description('Required. The location to deploy the secondary resources to.')
param secondaryLocation string = 'northeurope'

@description('Optional. The name of the database.')
param databaseName string = '<<namePrefix>>-${serviceShort}db-001'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

module primaryServer '../../deploy.bicep' = {
  name: '${uniqueString(deployment().name, primaryLocation)}-test-${serviceShort}'
  params: {
    name: '<<namePrefix>>-${serviceShort}'
    location: primaryLocation
    administratorLogin: 'adminUserName'
    administratorLoginPassword: password
    databases: [
      {
        name: databaseName
        maxSizeBytes: 2147483648
        skuName: 'Basic'
        skuTier: 'Basic'
        licenseType: 'LicenseIncluded'
      }
    ]
  }
}

module failoverServer '../../deploy.bicep' = {
  name: '${uniqueString(deployment().name, secondaryLocation)}-test-${serviceShort}'
  params: {
    name: '<<namePrefix>>-${serviceShort}-dr'
    administratorLogin: 'adminUserName'
    administratorLoginPassword: password
    location: secondaryLocation
  }
}

@description('The resource ID of the created virtual network subnet.')
output primaryServerName string = primaryServer.outputs.name

@description('The resource ID of the created virtual network subnet.')
output primaryServerId string = primaryServer.outputs.resourceId

@description('The resource ID of the created virtual network subnet.')
output failoverServerName string = failoverServer.outputs.name

@description('The resource ID of the created virtual network subnet.')
output failoverServerId string = failoverServer.outputs.resourceId

@description('The resource ID of the created virtual network subnet.')
output databaseId string = resourceId('Microsoft.Sql/servers/databases', primaryServer.outputs.name, databaseName)
