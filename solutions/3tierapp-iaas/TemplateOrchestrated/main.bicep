targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. Name of the Resource Group.')
param resourceGroupNameNetwork string = ''

@description('Optional. Name of the Resource Group web tier.')
param resourceGroupNameWebTier string = ''

@description('Optional. Name of the Resource Group application tier.')
param resourceGroupNameAppTier string = ''

@description('Optional. Name of the Resource Group database tier.')
param resourceGroupNameDbTier string = ''

@description('Optional. Name of deployment.')
param deploymentPrefix string = ''

@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags object = {}

@description('Optional. Resource Group location')
param location string = 'eastus2'

@description('Optional. Name of the virtual network.')
param vnetName string = ''

@description('Required. Virtual network address prefix.')
param vnetAddressPrefix string

@description('Required. Virtual network bastion subnet address space.')
param vnetBastionSubnetAddressPrefix string

@description('Required. Virtual network web tier subnet address space.')
param vnetWebSubnetAddressPrefix string

@description('Required. Virtual network application tier subnet address space.')
param vnetAppSubnetAddressPrefix string

@description('Required. Virtual network database tier subnet address space.')
param vnetDbSubnetAddressPrefix string

@description('Optional. Name of the subnet for the web tier.')
param webTierSubnetName string = ''

@description('Optional. Name of the subnet for the application tier.')
param appTierSubnetName string = ''

@description('Optional. Name of the subnet for the database tier.')
param dbTierSubnetName string = ''

@description('Optional. Name of the network security group for the Azure Bastion Host subnet.')
param nsgBastionSubnetName string = ''

@description('Optional. Name of the network security group for the Azure Bastion Host subnet.')
param nsgWebTierSubnetName string = ''

@description('Optional. Name of the network security group for the Azure Bastion Host subnet.')
param nsgAppTierSubnetName string = ''

@description('Optional. Name of the network security group for the Azure Bastion Host subnet.')
param nsgDbTierSubnetName string = ''

@description('Optional. Name of the route table for the Azure Bastion Host subnet.')
param udrWebTierSubnetName string = ''

@description('Optional. Name of the route table for the Azure Bastion Host subnet.')
param udrAppTierSubnetName string = ''

@description('Optional. Name of the route table for the Azure Bastion Host subnet.')
param udrDbTierSubnetName string = ''

@description('Optional. Name of the application security group for the Azure Bastion Host subnet.')
param asgWebTierSubnetName string = ''

@description('Optional. Name of the application security group for the Azure Bastion Host subnet.')
param asgAppTierSubnetName string = ''

@description('Optional. Name of the application security group for the Azure Bastion Host subnet.')
param asgDbTierSubnetName string = ''

@description('Optional. VM name prefix web tier.')
param webVmNamePrefix string = ''

@description('Optional. VM name prefix application tier.')
param appVmNamePrefix string = ''

@description('Optional. VM name prefix database tier.')
param dbVmNamePrefix string = ''

@description('Optional. VM name prefix web tier.')
param webAvailabilitySetName string = ''

@description('Optional. VM name prefix application tier.')
param appAvailabilitySetName string = ''

@description('Optional. VM name prefix database tier.')
param dbAvailabilitySetName string = ''

@minValue(1)
@maxValue(50)
@description('Optional. Quantity of VMs to deploy for web tier')
param webVmCount int = 1

@minValue(1)
@maxValue(50)
@description('Optional. Quantity of VMs to deploy application tier')
param appVmCount int = 1

@minValue(1)
@maxValue(50)
@description('Optional. Quantity of VMs to deploy database tier')
param dbVmCount int = 1

@allowed([
  'win10_21h2_Enterprise'
  'win11_21h2_Enterprise'
  'winServer_2022_Datacenter'
  'winServer_2019_Datacenter'
])
@description('Optional. OS source image web tier')
param webMarketPlaceGalleryImage string = 'winServer_2022_Datacenter'

@allowed([
  'win10_21h2_Enterprise'
  'win11_21h2_Enterprise'
  'winServer_2022_Datacenter'
  'winServer_2019_Datacenter'
])
@description('Optional. OS source image application tier')
param appMarketPlaceGalleryImage string = 'winServer_2022_Datacenter'

@allowed([
  'win10_21h2_Enterprise'
  'win11_21h2_Enterprise'
  'winServer_2022_Datacenter'
  'winServer_2019_Datacenter'
])
@description('Optional. OS source image database tier')
param dbMarketPlaceGalleryImage string = 'winServer_2022_Datacenter'

@description('Optional. Distribute VMs into availability zones, if set to no availability sets are used. ')
param useAvailabilityZones bool = false

@description('Optional. VM size web tier.')
param webVmSize string = 'Standard_D2s_v3'

@description('Optional. VM size application tier.')
param appVmSize string = 'Standard_D2s_v3'

@description('Optional. VM size database tier.')
param dbVmSize string = 'Standard_D2s_v3'

@description('Optional. OS disk type for VM web tier.')
param webVmOsDiskType string = 'Standard_LRS'

@description('Optional. OS disk type for VM application tier.')
param appVmOsDiskType string = 'Standard_LRS'

@description('Optional. OS disk type for VM database tier.')
param dbVmOsDiskType string = 'Standard_LRS'

@description('Required. Web tier VM local admin user name.')
param webVmLocalUserName string

@description('Required. Web tier VM local admin user password.')
@secure()
param webVmLocalUserPassword string

@description('Required. Application tier VM local admin user name.')
param appVmLocalUserName string

@description('Required. Application tier VM local admin user password.')
@secure()
param appVmLocalUserPassword string

@description('Required. Database tier VM local admin user name.')
param dbVmLocalUserName string

@description('Required. Database tier VM local admin user password.')
@secure()
param dbVmLocalUserPassword string

@description('Optional. Name of keyvault that will contain credentials web tier.')
param webKeyvaultName string = ''

@description('Optional. Name of keyvault that will contain credentials web tier.')
param appKeyvaultName string = ''

@description('Optional. Name of keyvault that will contain credentials web tier.')
param dbKeyvaultName string = ''

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock for all resources/resource group defined in this template.')
param lock string = ''

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
/*
var tiers = {
  Web: {
    deploymentTier: 'web'
    vmLocalUserName: webVmLocalUserName
    vmLocalUserPassword: webVmLocalUserPassword
  }
  Application: {
    deploymentTier: 'app'
    vmLocalUserName: webVmLocalUserName
    vmLocalUserPassword: webVmLocalUserPassword
  }
  Database: {
    deploymentTier: 'db'
    vmLocalUserName: webVmLocalUserName
    vmLocalUserPassword: webVmLocalUserPassword
  }
}
*/
// ========== //
// Deployments//
// ========== //
module networking '../CoreInfra/Network/TemplateOrchestrated/deploy.bicep' = {
  name: 'Deploy-Networking-${time}'
  params: {
    resourceGroupName: resourceGroupNameNetwork
    deploymentPrefix: deploymentPrefix
    tags: tags
    location: location
    lock: lock
    vnetName: vnetName
    vnetAddressPrefix: vnetAddressPrefix
    vnetBastionSubnetAddressPrefix: vnetBastionSubnetAddressPrefix
    vnetWebSubnetAddressPrefix: vnetWebSubnetAddressPrefix
    vnetAppSubnetAddressPrefix: vnetAppSubnetAddressPrefix
    vnetDbSubnetAddressPrefix: vnetDbSubnetAddressPrefix
    webTierSubnetName: webTierSubnetName
    appTierSubnetName: appTierSubnetName
    dbTierSubnetName: dbTierSubnetName
    nsgBastionSubnetName: nsgBastionSubnetName
    nsgWebTierSubnetName: nsgWebTierSubnetName
    nsgAppTierSubnetName: nsgAppTierSubnetName
    nsgDbTierSubnetName: nsgDbTierSubnetName
    udrWebTierSubnetName: udrWebTierSubnetName
    udrAppTierSubnetName: udrAppTierSubnetName
    udrDbTierSubnetName: udrDbTierSubnetName
    asgWebTierSubnetName: asgWebTierSubnetName
    asgAppTierSubnetName: asgAppTierSubnetName
    asgDbTierSubnetName: asgDbTierSubnetName
    diagnosticStorageAccountId: diagnosticStorageAccountId
    workspaceId: workspaceId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
  }

}

module databaseTierDeployment '../CoreInfra/Tiers/TemplateOrchestrated/deploy.bicep' = {
  name: 'Deploy-Database-Tier-${time}'
  params: {
    resourceGroupName: resourceGroupNameDbTier
    deploymentPrefix: deploymentPrefix
    tags: tags
    location: location
    lock: lock
    deploymentTier: 'db'
    subnetId: networking.outputs.dbSubnetId
    asgId: networking.outputs.asgWebId
    vmNamePrefix: dbVmNamePrefix
    availabilitySetName: dbAvailabilitySetName
    vmCount: dbVmCount
    marketPlaceGalleryImage: dbMarketPlaceGalleryImage
    useAvailabilityZones: useAvailabilityZones
    vmSize: dbVmSize
    vmOsDiskType: dbVmOsDiskType
    vmLocalUserName: dbVmLocalUserName
    vmLocalUserPassword: dbVmLocalUserPassword
    keyvaultName: dbKeyvaultName
    diagnosticStorageAccountId: diagnosticStorageAccountId
    workspaceId: workspaceId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
  }
  dependsOn: [
    networking
  ]
}

module applicationTierDeployment '../CoreInfra/Tiers/TemplateOrchestrated/deploy.bicep' = {
  name: 'Deploy-Application-Tier-${time}'
  params: {
    resourceGroupName: resourceGroupNameAppTier
    deploymentPrefix: deploymentPrefix
    tags: tags
    location: location
    lock: lock
    deploymentTier: 'app'
    subnetId: networking.outputs.appSubnetId
    asgId: networking.outputs.asgWebId
    vmNamePrefix: appVmNamePrefix
    availabilitySetName: appAvailabilitySetName
    vmCount: appVmCount
    marketPlaceGalleryImage: appMarketPlaceGalleryImage
    useAvailabilityZones: useAvailabilityZones
    vmSize: appVmSize
    vmOsDiskType: appVmOsDiskType
    vmLocalUserName: appVmLocalUserName
    vmLocalUserPassword: appVmLocalUserPassword
    keyvaultName: appKeyvaultName
    diagnosticStorageAccountId: diagnosticStorageAccountId
    workspaceId: workspaceId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
  }
  dependsOn: [
    databaseTierDeployment
    networking
  ]
}

module webTierDeployment '../CoreInfra/Tiers/TemplateOrchestrated/deploy.bicep' = {
  name: 'Deploy-Web-Tier-${time}'
  params: {
    resourceGroupName: resourceGroupNameWebTier
    deploymentPrefix: deploymentPrefix
    tags: tags
    location: location
    lock: lock
    deploymentTier: 'web'
    subnetId: networking.outputs.webSubnetId
    asgId: networking.outputs.asgWebId
    vmNamePrefix: webVmNamePrefix
    availabilitySetName: webAvailabilitySetName
    vmCount: webVmCount
    marketPlaceGalleryImage: webMarketPlaceGalleryImage
    useAvailabilityZones: useAvailabilityZones
    vmSize: webVmSize
    vmOsDiskType: webVmOsDiskType
    vmLocalUserName: webVmLocalUserName
    vmLocalUserPassword: webVmLocalUserPassword
    keyvaultName: webKeyvaultName
    diagnosticStorageAccountId: diagnosticStorageAccountId
    workspaceId: workspaceId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    eventHubName: eventHubName
  }
  dependsOn: [
    applicationTierDeployment
    networking
  ]
}
