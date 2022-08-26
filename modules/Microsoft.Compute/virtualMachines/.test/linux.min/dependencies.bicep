@description('Required. The name of the managed identity to create')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Deployment Script to create for the SSH Key generation.')
param sshDeploymentScriptName string

@description('Required. The name of the SSH Key to create.')
param sshKeyName string

@description('Optional. The location to deploy to')
param location string = resourceGroup().location

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
    azPowerShellVersion: '3.0'
    retentionInterval: 'P1D'
    scriptContent: '''
      ssh-keygen -f scratch -N (Get-Random -Maximum 99999)

      $DeploymentScriptOutputs = @{
        # privateKey = cat scratch | Out-String
        publicKey = cat 'scratch.pub'
      }
    '''
  }
}

resource sshKey 'Microsoft.Compute/sshPublicKeys@2022-03-01' = {
  name: sshKeyName
  location: location
  properties: {
    publicKey: sshDeploymentScript.properties.outputs.publicKey
  }
}

@description('The resource ID of the created Virtual Network Subnet')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created SSH Key')
output SSHKeyResourceID string = sshKey.id
