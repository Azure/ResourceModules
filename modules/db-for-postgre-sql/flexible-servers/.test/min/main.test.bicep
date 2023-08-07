targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.dbforpostgresql.flexibleservers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dfpsfsmin'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

@description('Required. The AAD Object Id to add to the AAD Group')
param aadObjectId string = '[[objectId]]'

@description('Required. The AAD Group Name to add the AAD Group')
param aadGroupName string = '[[groupName]]'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}${serviceShort}001'
    activeDirectoryAuth: 'Enabled'
    passwordAuth: 'Disabled'
    backupRetentionDays: 7
    geoRedundantBackup: 'Enabled'
    skuName: 'Standard_B2s'
    tier: 'Burstable'
    administrators: [
      {
        objectId: aadObjectId
        principalType: 'Group'
        principalName: aadGroupName
        tenantId: subscription().tenantId
      }
    ]
  }
}
