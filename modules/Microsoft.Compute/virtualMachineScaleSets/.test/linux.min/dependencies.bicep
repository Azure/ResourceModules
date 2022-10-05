@description('Optional. The location to deploy to')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Deployment Script to create for the SSH Key generation.')
param sshDeploymentScriptName string

@description('Required. The name of the SSH Key to create.')
param sshKeyName string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
    name: virtualNetworkName
    location: location
    properties: {
        addressSpace: {
            addressPrefixes: [
                '10.0.0.0/24'
            ]
        }
        subnets: [
            {
                name: 'defaultSubnet'
                properties: {
                    addressPrefix: '10.0.0.0/24'
                }
            }
        ]
    }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

resource msiRGContrRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
    name: guid('msi-${resourceGroup().id}-${location}-${managedIdentity.id}-RG-Reader-RoleAssignment')
    scope: resourceGroup()
    properties: {
        principalId: managedIdentity.properties.principalId
        roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Contributor
        principalType: 'ServicePrincipal'
    }
}

resource sshDeploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
    name: sshDeploymentScriptName
    location: location
    kind: 'AzurePowerShell'
    identity: {
        type: 'UserAssigned'
        userAssignedIdentities: {
            '${managedIdentity.id}': {}
        }
    }
    properties: {
        azPowerShellVersion: '6.2.1'
        retentionInterval: 'P1D'
        arguments: ' -SSHKeyName "${sshKeyName}" -ResourceGroupName "${resourceGroup().name}"'
        scriptContent: loadTextContent('../.scripts/New-SSHKey.ps1')
    }
    dependsOn: [
        msiRGContrRoleAssignment
    ]
}

resource sshKey 'Microsoft.Compute/sshPublicKeys@2022-03-01' = {
    name: sshKeyName
    location: location
    properties: {
        publicKey: sshDeploymentScript.properties.outputs.publicKey
    }
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created SSH Key')
output SSHKeyResourceID string = sshKey.id

@description('The Public Key of the created SSH Key')
output SSHKey string = sshKey.properties.publicKey
