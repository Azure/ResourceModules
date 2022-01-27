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
param serviceShort string = 'vmlinpar'

// ========= //
// Variables //
// ========= //

var managedIdentityParameters = {
  name: 'adp-sxx-msi-${serviceShort}-01'
}

var storageAccountParameters = {
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
        managedIdentity.outputs.msiPrincipalId
      ]
    }
  ]
}

var storageAccountDeploymentScriptParameters = {
  name: 'sxx-ds-sa-${serviceShort}-01'
  userAssignedIdentities: {
    '${managedIdentity.outputs.msiResourceId}': {}
  }
  cleanupPreference: 'OnSuccess'
  arguments: ' -StorageAccountName "${storageAccountParameters.name}" -ResourceGroupName "${resourceGroupName}" -ContainerName "scripts" -FileName "scriptExtensionMasterInstaller.ps1"'
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
}

var logAnalyticsWorkspaceParameters = {
  name: 'adp-sxx-law-${serviceShort}-01'
}

var eventHubNamespaceParameters = {
  name: 'adp-sxx-evhns-${serviceShort}-01'
  eventHubs: [
    {
      name: 'adp-sxx-evh-${serviceShort}-01'
      authorizationRules: [
        {
          name: 'RootManageSharedAccessKey'
          rights: [
            'Listen'
            'Manage'
            'Send'
          ]
        }
      ]
    }
  ]
}

var networkSecurityGroupParameters = {
  name: 'adp-sxx-nsg-${serviceShort}-01'
}

var virtualNetworkParameters = {
  name: 'adp-sxx-vnet-${serviceShort}-01'
  addressPrefixes: [
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

var recoveryServicesVaultParameters = {
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
}

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
    name: managedIdentityParameters.name
  }
  dependsOn: [
    resourceGroup
  ]
}

module storageAccount '../../../Microsoft.Storage/storageAccounts/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-sa'
  params: {
    name: storageAccountParameters.name
    storageAccountKind: storageAccountParameters.storageAccountKind
    storageAccountSku: storageAccountParameters.storageAccountSku
    allowBlobPublicAccess: storageAccountParameters.allowBlobPublicAccess
    blobServices: storageAccountParameters.blobServices
    roleAssignments: storageAccountParameters.roleAssignments
  }
  dependsOn: [
    resourceGroup
    managedIdentity
  ]
}

module storageAccountDeploymentScript '../../../Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-sa-ds'
  params: {
    name: storageAccountDeploymentScriptParameters.name
    arguments: storageAccountDeploymentScriptParameters.arguments
    userAssignedIdentities: storageAccountDeploymentScriptParameters.userAssignedIdentities
    scriptContent: storageAccountDeploymentScriptParameters.scriptContent
    cleanupPreference: storageAccountDeploymentScriptParameters.cleanupPreference
  }
  dependsOn: [
    resourceGroup
    storageAccount
    managedIdentity
  ]
}

module logAnalyticsWorkspace '../../../Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-oms'
  params: {
    name: logAnalyticsWorkspaceParameters.name
  }
  dependsOn: [
    resourceGroup
  ]
}

module eventHubNamespace '../../../Microsoft.EventHub/namespaces/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-ehn'
  params: {
    name: eventHubNamespaceParameters.name
    eventHubs: eventHubNamespaceParameters.eventHubs
  }
  dependsOn: [
    resourceGroup
  ]
}

module networkSecurityGroup '../../../Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-nsg'
  params: {
    name: networkSecurityGroupParameters.name
  }
  dependsOn: [
    resourceGroup
  ]
}

module virtualNetwork '../../../Microsoft.Network/virtualNetworks/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-vnet'
  params: {
    name: virtualNetworkParameters.name
    addressPrefixes: virtualNetworkParameters.addressPrefixes
    subnets: virtualNetworkParameters.subnets
  }
  dependsOn: [
    resourceGroup
    networkSecurityGroup
  ]
}

module recoveryServicesVault '../../../Microsoft.RecoveryServices/vaults/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-rsv'
  params: {
    name: recoveryServicesVaultParameters.name
    backupPolicies: recoveryServicesVaultParameters.backupPolicies
  }
  dependsOn: [
    resourceGroup
  ]
}

// ======= //
// Outputs //
// ======= //

output resourceGroupResourceId string = resourceGroup.outputs.resourceGroupResourceId
output managedIdentityResourceId string = managedIdentity.outputs.msiResourceId
output storageAccountResourceId string = storageAccount.outputs.storageAccountResourceId
output storageAccountDeploymentScriptResourceId string = storageAccountDeploymentScript.outputs.deploymentScriptResourceId
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.outputs.logAnalyticsResourceId
output eventHubNamespaceResourceId string = eventHubNamespace.outputs.namespaceResourceId
output networkSecurityGroupResourceId string = networkSecurityGroup.outputs.networkSecurityGroupResourceId
output virtualNetworkResourceId string = virtualNetwork.outputs.virtualNetworkResourceId
output recoveryServicesVaultResourceId string = recoveryServicesVault.outputs.recoveryServicesVaultResourceId
