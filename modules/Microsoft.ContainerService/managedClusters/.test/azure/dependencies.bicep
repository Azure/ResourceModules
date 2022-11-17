@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Disk Encryption Set to create.')
param diskEncryptionSetName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
    name: virtualNetworkName
    location: location
    properties: {
        addressSpace: {
            addressPrefixes: [
                '10.1.0.0/22'
            ]
        }
        subnets: [
            {
                name: 'systemSubnet'
                properties: {
                    addressPrefix: '10.1.0.0/24'
                }
            }
            {
                name: 'userSubnet1'
                properties: {
                    addressPrefix: '10.1.1.0/24'
                }
            }
            {
                name: 'userSubnet2'
                properties: {
                    addressPrefix: '10.1.2.0/24'
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
        enablePurgeProtection: true // Required by nodepool vmss
        softDeleteRetentionInDays: 7
        enabledForTemplateDeployment: true
        enabledForDiskEncryption: true
        enabledForDeployment: true
        enableRbacAuthorization: true
        accessPolicies: []
    }

    resource key 'keys@2022-07-01' = {
        name: 'encryptionKey'
        properties: {
            kty: 'RSA'
        }
    }
}

resource diskEncryptionSet 'Microsoft.Compute/diskEncryptionSets@2021-04-01' = {
    name: diskEncryptionSetName
    location: location
    identity: {
        type: 'SystemAssigned'
    }
    properties: {
        activeKey: {
            sourceVault: {
                id: keyVault.id
            }
            keyUrl: keyVault::key.properties.keyUriWithVersion
        }
        encryptionType: 'EncryptionAtRestWithCustomerKey'
    }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
    name: guid('msi-${keyVault.id}-${location}-${managedIdentity.id}-KeyVault-Key-Read-RoleAssignment')
    scope: keyVault
    properties: {
        principalId: diskEncryptionSet.identity.principalId
        roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e147488a-f6f5-4113-8e2d-b22465e65bf6') // Key Vault Crypto Service Encryption User
        principalType: 'ServicePrincipal'
    }
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceIds array = [
    virtualNetwork.properties.subnets[0].id
    virtualNetwork.properties.subnets[1].id
    virtualNetwork.properties.subnets[2].id
]

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Disk Encryption Set.')
output diskEncryptionSetResourceId string = diskEncryptionSet.id
