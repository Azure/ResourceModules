targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Required. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string

@description('Optional. The location to deploy to')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. E.g. "vwwinpar". Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'vmwinmin'

// ========= //
// Variables //
// ========= //

var managedIdentityParameters = {
  name: 'adp-sxx-msi-${serviceShort}-01'
}

var networkSecurityGroupParameters = {
  name: 'adp-sxx-nsg-${serviceShort}-01'
}

var virtualNetworkParameters = {
  name: 'adp-sxx-vnet-${serviceShort}-01'
  addressPrefix: [
    '10.0.0.0/16'
  ]
  subnets: [
    {
      name: 'sxx-subnet-x-01'
      addressPrefix: '10.0.0.0/24'
      networkSecurityGroupName: networkSecurityGroupParameters.name
    }
  ]
}

var keyVaultParameters = {
  name: 'adp-sxx-kv-${serviceShort}-01'
  enablePurgeProtection: false
  accessPolicies: [
    // Required so that the MSI can add secrets to the key vault
    {
      objectId: managedIdentity.outputs.msiPrincipalId
      permissions: {
        secrets: [
          'All'
        ]
      }
    }
  ]
}

var keyVaultDeploymentScriptParameters = {
  name: 'sxx-ds-kv-${serviceShort}-01'
  userAssignedIdentities: {
    '${managedIdentity.outputs.msiResourceId}': {}
  }
  cleanupPreference: 'OnSuccess'
  arguments: ' -keyVaultName "${keyVaultParameters.name}"'
  scriptContent: '''
      param(
        [string] $keyVaultName
      )

      $usernameString = (-join ((65..90) + (97..122) | Get-Random -Count 9 -SetSeed 1 | % {[char]$_ + "$_"})).substring(0,19) # max length
      $passwordString = (New-Guid).Guid.SubString(0,19)

      $userName = ConvertTo-SecureString -String $usernameString -AsPlainText -Force
      $password = ConvertTo-SecureString -String $passwordString -AsPlainText -Force

      # VirtualMachines and VMSS
      Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'adminUsername' -SecretValue $username
      Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'adminPassword' -SecretValue $password
    '''
}

// =========== //
// Deployments //
// =========== //

module resourceGroup '../../../../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-rg'
  params: {
    name: resourceGroupName
    location: location
  }
}

module managedIdentity '../../../../../arm/Microsoft.ManagedIdentity/userAssignedIdentities/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-mi'
  params: {
    name: managedIdentityParameters.name
  }
  dependsOn: [
    resourceGroup
  ]
}

module networkSecurityGroup '../../../../../arm/Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-nsg'
  params: {
    name: networkSecurityGroupParameters.name
  }
  dependsOn: [
    resourceGroup
  ]
}

module virtualNetwork '../../../../../arm/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-vnet'
  params: {
    name: virtualNetworkParameters.name
    addressPrefixes: virtualNetworkParameters.addressPrefix
    subnets: virtualNetworkParameters.subnets
  }
  dependsOn: [
    resourceGroup
    networkSecurityGroup
  ]
}

module keyVault '../../../../../arm/Microsoft.KeyVault/vaults/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-kv'
  params: {
    name: keyVaultParameters.name
    enablePurgeProtection: keyVaultParameters.enablePurgeProtection
    accessPolicies: keyVaultParameters.accessPolicies
  }
  dependsOn: [
    resourceGroup
  ]
}

module keyVaultdeploymentScript '../../../../../arm/Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-kv-ds'
  params: {
    name: keyVaultDeploymentScriptParameters.name
    arguments: keyVaultDeploymentScriptParameters.arguments
    userAssignedIdentities: keyVaultDeploymentScriptParameters.userAssignedIdentities
    scriptContent: keyVaultDeploymentScriptParameters.scriptContent
    cleanupPreference: keyVaultDeploymentScriptParameters.cleanupPreference
  }
  dependsOn: [
    resourceGroup
    keyVault
    managedIdentity
  ]
}

// ======= //
// Outputs //
// ======= //

output resourceGroupResourceId string = resourceGroup.outputs.resourceGroupResourceId
output managedIdentityResourceId string = managedIdentity.outputs.msiResourceId
output networkSecurityGroupResourceId string = networkSecurityGroup.outputs.networkSecurityGroupResourceId
output virtualNetworkResourceId string = virtualNetwork.outputs.virtualNetworkResourceId
output keyVaultResourceId string = keyVault.outputs.keyVaultResourceId
output keyVaultdeploymentScriptResourceId string = keyVaultdeploymentScript.outputs.deploymentScriptResourceId
