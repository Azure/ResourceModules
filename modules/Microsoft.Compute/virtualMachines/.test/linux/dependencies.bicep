@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Application Security Group to create.')
param applicationSecurityGroupName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Load Balancer to create.')
param loadBalancerName string

@description('Required. The name of the Recovery Services Vault to create.')
param recoveryServicesVaultName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Deployment Script used to upload data to the Storage Account.')
param storageUploadDeploymentScriptName string

@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

var storageContainerName = 'scripts'
var storageAccountCSEFileName = 'scriptExtensionMasterInstaller.ps1'
var backupPolicyName = 'backupPolicy'

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

resource applicationSecurityGroup 'Microsoft.Network/applicationSecurityGroups@2022-01-01' = {
  name: applicationSecurityGroupName
  location: location
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2022-01-01' = {
  name: loadBalancerName
  location: location
  properties: {
    frontendIPConfigurations: [
      {
        name: 'privateIPConfig1'
        properties: {
          subnet: virtualNetwork.properties.subnets[0]
        }
      }
    ]
  }

  resource backendPool 'backendAddressPools@2022-01-01' = {
    name: 'servers'
  }
}

resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2022-04-01' = {
  name: recoveryServicesVaultName
  location: location
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
  }

  resource backupPolicy 'backupPolicies@2022-03-01' = {
    name: backupPolicyName
    properties: {
      backupManagementType: 'AzureIaasVM'
      instantRPDetails: {}
      schedulePolicy: {
        schedulePolicyType: 'SimpleSchedulePolicy'
        scheduleRunFrequency: 'Weekly'
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
        weeklySchedule: {
          daysOfTheWeek: [
            'Sunday'
          ]
          retentionTimes: [
            '2019-11-07T07:00:00Z'
          ]
          retentionDuration: {
            count: 12
            durationType: 'Weeks'
          }
        }
        monthlySchedule: {
          retentionScheduleFormatType: 'Weekly'
          retentionScheduleWeekly: {
            daysOfTheWeek: [
              'Sunday'
            ]
            weeksOfTheMonth: [
              'First'
            ]
          }
          retentionTimes: [
            '2019-11-07T07:00:00Z'
          ]
          retentionDuration: {
            count: 60
            durationType: 'Months'
          }
        }
        yearlySchedule: {
          retentionScheduleFormatType: 'Weekly'
          monthsOfYear: [
            'January'
          ]
          retentionScheduleWeekly: {
            daysOfTheWeek: [
              'Sunday'
            ]
            weeksOfTheMonth: [
              'First'
            ]
          }
          retentionTimes: [
            '2019-11-07T07:00:00Z'
          ]
          retentionDuration: {
            count: 10
            durationType: 'Years'
          }
        }
      }
      instantRpRetentionRangeInDays: 2
      timeZone: 'UTC'
      protectedItemsCount: 0
    }
  }
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
    enabledForTemplateDeployment: true
    enablePurgeProtection: null
  }

  resource key 'keys@2022-07-01' = {
    name: 'encryptionKey'
    properties: {
    }
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'

  resource blobService 'blobServices@2021-09-01' = {
    name: 'default'

    resource container 'containers@2021-09-01' = {
      name: storageContainerName
    }
  }
}

resource storageUpload 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: storageUploadDeploymentScriptName
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
    arguments: ' -StorageAccountName "${storageAccount.name}" -ResourceGroupName "${resourceGroup().name}" -ContainerName "${storageAccount::blobService::container.name}" -FileName "${storageAccountCSEFileName}"'
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
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created Application Security Group.')
output applicationSecurityGroupResourceId string = applicationSecurityGroup.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.properties.principalId

@description('The resource ID of the created Load Balancer Backend Pool.')
output loadBalancerBackendPoolResourceId string = loadBalancer::backendPool.id

@description('The resource ID of the created Recovery Services Vault.')
output recoveryServicesVaultResourceId string = recoveryServicesVault.id

@description('The name of the Backup Policy created in the Backup Recovery Vault.')
output recoveryServicesVaultBackupPolicyName string = backupPolicyName

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The URL of the created Key Vault.')
output keyVaultUrl string = keyVault.properties.vaultUri

@description('The URL of the created Key Vault Encryption Key.')
output keyVaultEncryptionKeyUrl string = keyVault::key.properties.keyUriWithVersion

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The URL of the Custom Script Extension in the created Storage Account')
output storageAccountCSEFileUrl string = '${storageAccount.properties.primaryEndpoints.blob}${storageContainerName}/${storageAccountCSEFileName}'
