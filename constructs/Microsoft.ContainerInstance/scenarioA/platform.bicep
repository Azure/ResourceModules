targetScope = 'subscription'

@description('Name of the resource group')
param resourceGroupName string

@description('A /16 to contain the cluster')
@minLength(10)
@maxLength(18)
param clusterVnetAddressSpace string

@description('The location for all platform resources.')
param location string

var orgAppId = 'contoso'
var clusterVNetName = 'vnet-spoke-${orgAppId}-00'
var nsgNodePoolsName = 'nsg-${clusterVNetName}-nodepools'
var nsgAksiLbName = 'nsg-${clusterVNetName}-aksilbs'
var routeTableName = 'route-${location}-default'
var primaryClusterPipName = 'pip-${orgAppId}-00'
var subRgUniqueString = uniqueString('aks', subscription().subscriptionId, resourceGroupName)
var clusterName = 'aks-${subRgUniqueString}'
var logAnalyticsWorkspaceName = 'la-${clusterName}'
var clusterControlPlaneIdentityName = 'mi-${clusterName}-controlplane'
var keyVaultName = 'kv-${clusterName}'

var keyVaultDeploymentScriptParameters = {
  name: 'sxx-ds-kv-${orgAppId}-01'
  userAssignedIdentities: {
    '${podmi_ingress_controller.outputs.resourceId}': {}
  }
  cleanupPreference: 'OnSuccess'
  arguments: ' -keyVaultName "${keyVault.name}"'
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

module rg '../../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: resourceGroupName
  params: {
    name: resourceGroupName
    location: location
  }
}

module law '../../../arm/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  name: logAnalyticsWorkspaceName
  params: {
    name: logAnalyticsWorkspaceName
    location: location
    serviceTier: 'PerGB2018'
    dataRetention: 30
    gallerySolutions: [
      {
        name: 'ContainerInsights'
        product: 'OMSGallery'
        publisher: 'Microsoft'
      }
      {
        name: 'KeyVaultAnalytics'
        product: 'OMSGallery'
        publisher: 'Microsoft'
      }
    ]
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module nsgNodePools '../../../arm/Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  name: nsgNodePoolsName
  params: {
    name: nsgNodePoolsName
    location: location
    networkSecurityGroupSecurityRules: []
    diagnosticWorkspaceId: law.outputs.resourceId
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module nsgAksiLb '../../../arm/Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  name: nsgAksiLbName
  params: {
    name: nsgAksiLbName
    location: location
    networkSecurityGroupSecurityRules: []
    diagnosticWorkspaceId: law.outputs.resourceId
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module routeTable '../../../arm/Microsoft.Network/routeTables/deploy.bicep' = {
  name: routeTableName
  params: {
    name: routeTableName
    location: location
    routes: [
      {
        name: 'r-nexthop-to-fw'
        properties: {
          nextHopType: 'VirtualAppliance'
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: '192.168.0.0'
        }
      }
    ]
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module clusterVNet '../../../arm/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  name: clusterVNetName
  params: {
    name: clusterVNetName
    location: location
    addressPrefixes: array(clusterVnetAddressSpace)
    diagnosticWorkspaceId: law.outputs.resourceId
    subnets: [
      {
        name: 'snet-clusternodes'
        addressPrefix: '10.240.0.0/22'
        routeTableName: routeTable.outputs.name
        networkSecurityGroupName: nsgNodePools.outputs.name
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
      {
        name: 'snet-clusteringressservices'
        addressPrefix: '10.240.4.0/28'
        routeTableName: routeTable.outputs.name
        networkSecurityGroupName: nsgAksiLb.outputs.name
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Disabled'
      }
    ]
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module primaryClusterPip '../../../arm/Microsoft.Network/publicIPAddresses/deploy.bicep' = {
  name: primaryClusterPipName
  params: {
    name: primaryClusterPipName
    location: location
    skuName: 'Standard'
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
    zones: [
      '1'
      '2'
      '3'
    ]
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module clusterControlPlaneIdentity '../../../arm/Microsoft.ManagedIdentity/userAssignedIdentities/deploy.bicep' = {
  name: clusterControlPlaneIdentityName
  params: {
    name: clusterControlPlaneIdentityName
    location: location
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module podmi_ingress_controller '../../../arm/Microsoft.ManagedIdentity/userAssignedIdentities/deploy.bicep' = {
  name: 'podmi-ingress-controller'
  params: {
    name: 'podmi-ingress-controller'
    location: location
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module keyVault '../../../arm/Microsoft.KeyVault/vaults/deploy.bicep' = {
  name: keyVaultName
  params: {
    name: keyVaultName
    location: location
    accessPolicies: []
    vaultSku: 'standard'
    enableRbacAuthorization: true
    enableVaultForDeployment: false
    enableVaultForDiskEncryption: false
    enableVaultForTemplateDeployment: true
    enableSoftDelete: false
    diagnosticWorkspaceId: law.outputs.resourceId
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Key Vault Secrets User'
        principalIds: [
          podmi_ingress_controller.outputs.principalId
        ]
      }
      {
        roleDefinitionIdOrName: 'Key Vault Reader'
        principalIds: [
          podmi_ingress_controller.outputs.principalId
        ]
      }
      {
        roleDefinitionIdOrName: 'Key Vault Secrets Officer'
        principalIds: [
          podmi_ingress_controller.outputs.principalId
        ]
      }
    ]
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
    podmi_ingress_controller
  ]
}

module keyVaultdeploymentScript '../../../arm/Microsoft.Resources/deploymentScripts/deploy.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-kv-ds'
  params: {
    name: keyVaultDeploymentScriptParameters.name
    location: location
    arguments: keyVaultDeploymentScriptParameters.arguments
    userAssignedIdentities: keyVaultDeploymentScriptParameters.userAssignedIdentities
    scriptContent: keyVaultDeploymentScriptParameters.scriptContent
    cleanupPreference: keyVaultDeploymentScriptParameters.cleanupPreference
  }
  dependsOn: [
    rg
    keyVault
    podmi_ingress_controller
  ]
}

output rgResourceId string = rg.outputs.resourceId
output lawResourceId string = law.outputs.resourceId
output vnetResourceId string = clusterVNet.outputs.resourceId
output clusterControlPlaneIdentityResourceId string = clusterControlPlaneIdentity.outputs.resourceId
