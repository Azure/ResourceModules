@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Network Security Group to create.')
param networkSecurityGroupName string

@description('Required. The name of the Route Table to create.')
param routeTableName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow_tds_inbound'
        properties: {
          description: 'Allow access to data'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
      {
        name: 'allow_redirect_inbound'
        properties: {
          description: 'Allow inbound redirect traffic to Managed Instance inside the virtual network'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '11000-11999'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1100
          direction: 'Inbound'
        }
      }
      {
        name: 'deny_all_inbound'
        properties: {
          description: 'Deny all other inbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 4096
          direction: 'Inbound'
        }
      }
      {
        name: 'deny_all_outbound'
        properties: {
          description: 'Deny all other outbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 4096
          direction: 'Outbound'
        }
      }
    ]
  }
}

resource routeTable 'Microsoft.Network/routeTables@2021-08-01' = {
  name: routeTableName
  location: location
  properties: {
    disableBgpRoutePropagation: false
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'ManagedInstance'
        properties: {
          addressPrefix: '10.0.0.0/24'
          routeTable: {
            id: routeTable.id
          }
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
          delegations: [
            {
              name: 'managedInstanceDelegation'
              properties: {
                serviceName: 'Microsoft.Sql/managedInstances'
              }
            }
          ]
        }
      }
    ]
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: null
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }

  resource key 'keys@2022-07-01' = {
    name: 'keyEncryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
}

// resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-Key-Reader-RoleAssignment')
//   scope: keyVault::key
//   properties: {
//     principalId: managedIdentity.properties.principalId
//     roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '12338af0-0e69-4776-bea7-57ae8d297424') // Key Vault Crypto User
//     principalType: 'ServicePrincipal'
//   }
// }

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The principal ID of the created managed identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created managed identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The vault URI of the created Key Vault.')
output keyVaultUri string = keyVault.properties.vaultUri

@description('The name of the created Key Vault encryption key.')
output keyVaultKeyName string = keyVault::key.name

@description('The version of the created Key Vault encryption key.')
output keyVaultKeyVersion string = last(split(keyVault::key.properties.keyUriWithVersion, '/'))
