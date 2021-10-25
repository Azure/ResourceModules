@description('Required. Name of the Database Account')
param databaseAccountName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the Database Account resource.')
param tags object = {}

@description('Optional. The type of identity used for the database account. The type \'SystemAssigned, UserAssigned\' includes both an implicitly created identity and a set of user assigned identities. The type \'None\' (default) will remove any identities from the database account.')
@allowed([
  'None'
  'SystemAssigned'
  'SystemAssigned, UserAssigned'
  'UserAssigned'
])
param managedServiceIdentity string = 'None'

@description('Optional. Mandatory if \'managedServiceIdentity\' contains UserAssigned. The list of user identities associated with the database account.')
param userAssignedIdentities object = {}

param sqlDatabases array = []

param mongodbDatabases array = []

var identity = {
  type: managedServiceIdentity
  userAssignedIdentities: (empty(userAssignedIdentities) ? json('null') : userAssignedIdentities)
}

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2021-06-15' = {
  name: databaseAccountName
  location: location
  tags: tags
  identity: identity
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        failoverPriority: int
        isZoneRedundant: bool
        locationName: 'string'
      }
    ]
  }
}
