@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Deployment Script used to create secrets in the deployed Key Vault.')
param deploymentScriptName string

@description('Required. The name of the secret to create in the Key Vault.')
param passwordSecretName string

@description('Optional. The location to deploy to')
param location string = resourceGroup().location

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource vnet 'Microsoft.Network/virtualNetworks@2022-01-01' = {
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
        name: 'sxx-subnet-pe-01'
        properties: {

          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    accessPolicies: [
      {
        objectId: managedIdentity.properties.principalId
        permissions: {
          secrets: [
            'All'
          ]
        }
        tenantId: tenant().tenantId
      }
    ]
  }
}

resource keyVaultdeploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: deploymentScriptName
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
    arguments: ' -KeyVaultName "${keyVault.name}" -PasswordSecretName "${passwordSecretName}"'
    cleanupPreference: 'OnSuccess'
    scriptContent: '''
      param(
        [string] $KeyVaultName,
        [string] $PasswordSecretName
      )
      $passwordString = (New-Guid).Guid.SubString(0,19)
      $password = ConvertTo-SecureString -String $passwordString -AsPlainText -Force

      Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $PasswordSecretName -SecretValue $password
    '''
  }
}

@description('The principal ID of the created managed identity')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created managed identity')
output managedIdentitResourceId string = managedIdentity.properties.principalId

@description('The resource ID of the created virtual network subnet')
output privateEndpointSubnetResourceId string = vnet.properties.subnets[0].id

@description('The name of the password secret.')
output secretName string = passwordSecretName
