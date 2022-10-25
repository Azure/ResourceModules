@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Shared Image Gallery to create.')
param galleryName string

@description('Required. The name of the Image Definition to create in the Shared Image Gallery.')
param sigImageDefinitionName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource gallery 'Microsoft.Compute/galleries@2022-03-03' = {
  name: galleryName
  location: location
  properties: {
  }
}

resource galleryImageDefinition 'Microsoft.Compute/galleries/images@2022-03-03' = {
  name: sigImageDefinitionName
  location: location
  parent: gallery
  properties: {
    architecture: 'x64'
    hyperVGeneration: 'V1'
    identifier: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2019-Datacenter'
    }
    osState: 'Generalized'
    osType: 'Windows'
    recommended: {
      memory: {
        max: 16
        min: 4
      }
      vCPUs: {
        max: 8
        min: 2
      }
    }
  }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The name of the created Managed Identity.')
output managedIdentityName string = managedIdentity.name

@description('The resource ID of the created Image Definition.')
output sigImageDefinitionId string = galleryImageDefinition.id
