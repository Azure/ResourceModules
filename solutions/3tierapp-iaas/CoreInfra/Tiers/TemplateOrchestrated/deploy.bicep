targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. Name of the Resource Group.')
param resourceGroupName string = ''

@description('Required. deployment tier.')
param deploymentTier string

@description('Optional. Name of deployment.')
param deploymentPrefix string = ''

@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags object = {}

@description('Optional. Resource Group location')
param location string = 'eastus2'

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock for all resources/resource group defined in this template.')
param lock string = ''

@description('Required. Subnet resource ID.')
param subnetId string

@description('Required. Applization security group resource ID.')
param asgId string

@description('Optional. VM name prefix.')
param vmNamePrefix string = ''

@description('Optional. VM name prefix.')
param availabilitySetName string = ''

@minValue(1)
@maxValue(50)
@description('Optional. Quantity of session hosts to deploy')
param vmCount int = 1

@description('Optional. Existing VM count index')
param vmCountIndex int = 0

@allowed([
  'win10_21h2_Enterprise'
  'win11_21h2_Enterprise'
  'winServer_2022_Datacenter'
  'winServer_2019_Datacenter'
])
@description('Optional. OS source image')
param marketPlaceGalleryImage string = 'winServer_2022_Datacenter'

@description('Optional. Distribute VMs into availability zones, if set to no availability sets are used. ')
param useAvailabilityZones bool = false

@description('Optional. VM size.')
param vmSize string = 'Standard_D2s_v3'

@description('Optional. OS disk type for session host.')
param vmOsDiskType string = 'Standard_LRS'

@description('Required. VM local admin user name.')
param vmLocalUserName string

@description('Required. VM local admin user password.')
@secure()
param vmLocalUserPassword string

@description('Optional. Name of keyvault that will contain credentials.')
param keyvaultName string = ''

@description('Optional. Name of load balancer to deploy.')
param loadBalancerName string = ''

@description('Optional. Resource ID of the storage account to be used for diagnostic logs.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the Log Analytics workspace to be used for diagnostic logs.')
param workspaceId string = ''

@description('Optional. Authorization ID of the Event Hub Namespace to be used for diagnostic logs.')
param eventHubAuthorizationRuleId string = ''

@description('Optional. Name of the Event Hub to be used for diagnostic logs.')
param eventHubName string = ''

@description('Do not modify, used to set unique value for resource deployment.')
param time string = utcNow()

// ========== //
// variables  //
// ========== //
var varLocationLowercase = toLower(location)
var uniqueStringSixChar = take('${uniqueString(deploymentPrefix, deploymentTier, time)}', 6)
var varDeploymentTierLowerCase = toLower(deploymentTier)
var varDeploymentPrefixLowerCase = toLower(varDeploymentPrefix)
var varDeploymentPrefix = !empty(deploymentPrefix) ? deploymentPrefix : '3tier'
var varResourceGroupName = !empty(resourceGroupName) ? resourceGroupName : 'rg-${varDeploymentPrefixLowerCase}-${varLocationLowercase}-${varDeploymentTierLowerCase}'
var varKeyvaultName = !empty(keyvaultName) ? keyvaultName : 'kv-${varDeploymentTierLowerCase}-${varLocationLowercase}-${uniqueStringSixChar}' // max length limit 24 characters
var varLoadBalancerName = !empty(loadBalancerName) ? loadBalancerName : 'lb-${varDeploymentPrefixLowerCase}-${varDeploymentTierLowerCase}-${varLocationLowercase}-001'
var varAllAvailabilityZones = pickZones('Microsoft.Compute', 'virtualMachines', location, 3)
var varVmNamePrefix = !empty(vmNamePrefix) ? vmNamePrefix : 'vm-${varDeploymentTierLowerCase}'
var varAvailabilitySetName = !empty(availabilitySetName) ? availabilitySetName : 'avail-${varDeploymentPrefixLowerCase}-${varDeploymentTierLowerCase}-${varLocationLowercase}-001'
var varMarketPlaceGalleryImages = {
  win10_21h2_Enterprise: {
    publisher: 'MicrosoftWindowsDesktop'
    offer: 'Windows-10'
    sku: 'win10-21h2-ent'
    version: 'latest'
  }
  win11_21h2_Enterprise: {
    publisher: 'MicrosoftWindowsDesktop'
    offer: 'windows-11'
    sku: 'win11-21h2-ent'
    version: 'latest'
  }
  winServer_2022_Datacenter: {
    publisher: 'MicrosoftWindowsServer'
    offer: 'WindowsServer'
    sku: '2022-datacenter'
    version: 'latest'
  }
  winServer_2019_Datacenter: {
    publisher: 'MicrosoftWindowsServer'
    offer: 'WindowsServer'
    sku: '2019-datacenter'
    version: 'latest'
  }
}

// ========== //
// Deployments//
// ========== //
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: varResourceGroupName
  location: varLocationLowercase
  tags: !empty(tags) ? tags : {}
}

module keyVault '../../../../../modules/Microsoft.KeyVault/vaults/deploy.bicep' = {
  scope: resourceGroup
  name: '${varDeploymentTierLowerCase}-KeyVault-${time}'
  params: {
    name: varKeyvaultName
    location: location
    enableRbacAuthorization: false
    enablePurgeProtection: true
    softDeleteRetentionInDays: 7
    //networkAcls: {
    //  bypass: 'AzureServices'
    //  defaultAction: 'Deny'
    //  virtualNetworkRules: []
    //  ipRules: []
    //}
    secrets: {
      secureList: [
        {
          name: 'VmLocalUserPassword'
          value: vmLocalUserPassword
          contentType: 'VM local user credentials'
        }
        {
          name: 'VmLocalUserName'
          value: vmLocalUserName
          contentType: 'VM local user credentials'
        }
      ]
    }
    tags: !empty(tags) ? tags : {}
    lock: !empty(lock) ? lock : ''
    diagnosticWorkspaceId: !empty(workspaceId) ? workspaceId : ''
    diagnosticStorageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: !empty(eventHubAuthorizationRuleId) ? eventHubAuthorizationRuleId : ''
    diagnosticEventHubName: !empty(eventHubName) ? eventHubName : ''
  }
}

resource getkeyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVault.outputs.name
  scope: resourceGroup
}

module availabilitySet '../../../../../modules/Microsoft.Compute/availabilitySets/deploy.bicep' = if (!useAvailabilityZones) {
  name: 'Availability-Set-${time}'
  scope: resourceGroup
  params: {
    name: varAvailabilitySetName
    location: location
    availabilitySetFaultDomain: 2
    availabilitySetUpdateDomain: 5
    tags: !empty(tags) ? tags : {}
    lock: !empty(lock) ? lock : ''
  }
}

module virtualMachines '../../../../../modules/Microsoft.Compute/virtualMachines/deploy.bicep' = [for i in range(1, vmCount): {
  scope: resourceGroup
  name: 'VM-${padLeft((i + vmCountIndex), 3, '0')}-${time}'
  params: {
    name: '${varVmNamePrefix}-${padLeft((i + vmCountIndex), 3, '0')}'
    location: location
    //availabilityZone: useAvailabilityZones ? take(skip(varAllAvailabilityZones, i % length(varAllAvailabilityZones)), 1) : 0
    availabilitySetResourceId: !useAvailabilityZones ? availabilitySet.outputs.resourceId : ''
    osType: 'Windows'
    vmSize: vmSize
    encryptionAtHost: false
    imageReference: varMarketPlaceGalleryImages[marketPlaceGalleryImage]
    osDisk: {
      createOption: 'fromImage'
      deleteOption: 'Delete'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: vmOsDiskType
      }
    }
    adminUsername: vmLocalUserName
    adminPassword: getkeyVault.getSecret('VmLocalUserPassword')
    nicConfigurations: [
      {
        nicSuffix: '-nic-001'
        deleteOption: 'Delete'
        asgId: asgId
        enableAcceleratedNetworking: false
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: subnetId
          }
        ]
      }
    ]
    tags: !empty(tags) ? tags : {}
    lock: !empty(lock) ? lock : ''
    diagnosticWorkspaceId: !empty(workspaceId) ? workspaceId : ''
    diagnosticStorageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: !empty(eventHubAuthorizationRuleId) ? eventHubAuthorizationRuleId : ''
    diagnosticEventHubName: !empty(eventHubName) ? eventHubName : ''
  }
  dependsOn: []
}]

module loadBalancer '../../../../../modules/Microsoft.Network/loadBalancers/deploy.bicep' = [for i in range(1, vmCount): {
  scope: resourceGroup
  name: '${varDeploymentTierLowerCase}-LoadBalancer-${i}-${time}'
  params: {
    name: varLoadBalancerName
    location: location
    frontendIPConfigurations: [
      {
        name: 'ipconfig01'
        subnetId: subnetId
      }
    ]
    //backendAddressPools: [
    //  {
    //      name: 'Backend-${varDeploymentTierLowerCase}'
    //      properties: {
    //          virtualNetwork: {
    //              id: subnetId
    //          }
    //          ipAddress:
    //      }
    //  }
    //]
    tags: !empty(tags) ? tags : {}
    lock: !empty(lock) ? lock : ''
    diagnosticWorkspaceId: !empty(workspaceId) ? workspaceId : ''
    diagnosticStorageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: !empty(eventHubAuthorizationRuleId) ? eventHubAuthorizationRuleId : ''
    diagnosticEventHubName: !empty(eventHubName) ? eventHubName : ''

  }
}]

// ========== //
// Outputs    //
// ========== //
