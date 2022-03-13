targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Required. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string

@description('Optional. The location to deploy to')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. E.g. "vmpar". Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'vmpar'

// =========== //
// Deployments //
// =========== //

module resourceGroup '../../../Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-rg'
  params: {
    name: resourceGroupName
    location: location
  }
}

module managedIdentity '../../../Microsoft.ManagedIdentity/userAssignedIdentities/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-mi'
  params: {
    name: 'adp-sxx-msi-${serviceShort}-01'
    location: location
  }
  dependsOn: [
    resourceGroup
  ]
}

module storageAccount '../../../Microsoft.Storage/storageAccounts/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-sa'
  params: {
    name: 'adpsxxazsa${serviceShort}01'
    storageAccountKind: 'StorageV2'
    storageAccountSku: 'Standard_LRS'
    allowBlobPublicAccess: false
    blobServices: {
      containers: [
        {
          name: 'scripts'
          publicAccess: 'None'
        }
      ]
    }
    roleAssignments: [
      // Required to allow the MSI to upload files to fetch the storage account context to upload files to the container
      {
        roleDefinitionIdOrName: 'Owner'
        principalIds: [
          managedIdentity.outputs.principalId
        ]
      }
    ]
    location: location
  }
  dependsOn: [
    resourceGroup
  ]
}

module storageAccountDeploymentScript '../../../Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-sa-ds'
  params: {
    name: 'sxx-ds-sa-${serviceShort}-01'
    userAssignedIdentities: {
      '${managedIdentity.outputs.resourceId}': {}
    }
    cleanupPreference: 'OnSuccess'
    arguments: ' -StorageAccountName "${storageAccount.outputs.name}" -ResourceGroupName "${resourceGroup.outputs.name}" -ContainerName "scripts" -FileName "scriptExtensionMasterInstaller.ps1"'
    scriptContent: '''
      param(
        [string] $StorageAccountName,
        [string] $ResourceGroupName,
        [string] $ContainerName,
        [string] $FileName
      )
      Write-Verbose "Create file [$FileName]" -Verbose
      $file = New-Item -Value "Write-Host 'I am content'" -Path $FileName -Force

      Write-Verbose "Getting storage account [$StorageAccountName|$ResourceGroupName] context." -Verbose
      $storageAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -StorageAccountName $StorageAccountName -ErrorAction 'Stop'

      Write-Verbose 'Uploading file [$fileName]' -Verbose
      Set-AzStorageBlobContent -File $file.FullName -Container $ContainerName -Context $storageAccount.Context -Force -ErrorAction 'Stop' | Out-Null
    '''
    location: location
  }
}

module diagnosticDependencies '../../../.global/dependencyConstructs/diagnostic.dependencies.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-diagDep'
  params: {
    resourceGroupName: resourceGroupName
    storageAccountName: storageAccount.outputs.name
    logAnalyticsWorkspaceName: 'adp-sxx-law-${serviceShort}-01'
    eventHubNamespaceEventHubName: 'adp-sxx-evh-${serviceShort}-01'
    eventHubNamespaceName: 'adp-sxx-evhns-${serviceShort}-01'
    location: location
  }
}

module networkSecurityGroup '../../../Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-nsg'
  params: {
    name: 'adp-sxx-nsg-${serviceShort}-01'
    location: location
  }
  dependsOn: [
    resourceGroup
  ]
}

module virtualNetwork '../../../Microsoft.Network/virtualNetworks/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-vnet'
  params: {
    name: 'adp-sxx-vnet-${serviceShort}-01'
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'sxx-subnet-x-01'
        addressPrefix: '10.0.0.0/24'
        networkSecurityGroupName: networkSecurityGroup.outputs.name
      }
    ]
    location: location
  }
  dependsOn: [
    resourceGroup
  ]
}

module recoveryServicesVault '../../../Microsoft.RecoveryServices/vaults/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-rsv'
  params: {
    name: 'adp-sxx-rsv-${serviceShort}-01'
    backupConfig: {
      enhancedSecurityState: 'Disabled'
      softDeleteFeatureState: 'Disabled'
    }
    backupPolicies: [
      {
        name: 'VMpolicy'
        type: 'Microsoft.RecoveryServices/vaults/backupPolicies'
        properties: {
          backupManagementType: 'AzureIaasVM'
          instantRPDetails: {}
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunFrequency: 'Daily'
            scheduleRunTimes: [
              '2019-11-07T07:00:00Z'
            ]
            scheduleWeeklyFrequency: 0
          }
          retentionPolicy: {
            retentionPolicyType: 'LongTermRetentionPolicy'
            dailySchedule: {
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
              retentionDuration: {
                count: 180
                durationType: 'Days'
              }
            }
          }
        }
      }
    ]
    location: location
  }
  dependsOn: [
    resourceGroup
  ]
}

module keyVault '../../../Microsoft.KeyVault/vaults/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-kv'
  params: {
    name: 'adp-sxx-kv-${serviceShort}-01'
    enablePurgeProtection: false
    accessPolicies: [
      // Required so that the MSI can add secrets to the key vault
      {
        objectId: managedIdentity.outputs.principalId
        permissions: {
          secrets: [
            'All'
          ]
        }
      }
    ]
    location: location
  }
  dependsOn: [
    resourceGroup
  ]
}

module keyVaultdeploymentScript '../../../Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-kv-ds'
  params: {
    name: 'sxx-ds-kv-${serviceShort}-01'
    userAssignedIdentities: {
      '${managedIdentity.outputs.resourceId}': {}
    }
    cleanupPreference: 'OnSuccess'
    arguments: ' -keyVaultName "${keyVault.outputs.name}"'
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
    location: location
  }
  dependsOn: [
    resourceGroup
  ]
}

// ======= //
// Outputs //
// ======= //

output resourceGroupResourceId string = resourceGroup.outputs.resourceId
output managedIdentityResourceId string = managedIdentity.outputs.resourceId
output storageAccountResourceId string = storageAccount.outputs.resourceId
output storageAccountDeploymentScriptResourceId string = storageAccountDeploymentScript.outputs.resourceId
output logAnalyticsWorkspaceResourceId string = diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
output eventHubNamespaceResourceId string = diagnosticDependencies.outputs.eventHubNamespaceResourceId
output networkSecurityGroupResourceId string = networkSecurityGroup.outputs.resourceId
output virtualNetworkResourceId string = virtualNetwork.outputs.resourceId
output recoveryServicesVaultResourceId string = recoveryServicesVault.outputs.resourceId
output keyVaultResourceId string = keyVault.outputs.resourceId
output keyVaultdeploymentScriptResourceId string = keyVaultdeploymentScript.outputs.resourceId
