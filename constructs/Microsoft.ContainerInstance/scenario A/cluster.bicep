param rgResourceId string

param lawResourceId string

param vnetResourceId string

@description('The hub\'s regional affinity.')
param location string

@secure()
param dbLogin string

@secure()
param dbPwd string

param kubernetesVersion string = '1.22.4'

var subRgUniqueString = uniqueString('aks', subscription().subscriptionId, rg.name)
var nodeResourceGroupName = 'rg-${clusterName}-nodepools'
var clusterName = 'aks-${subRgUniqueString}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  scope: subscription()
  name: '${split(rgResourceId, '/')[4]}'
}

resource law 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: '${split(lawResourceId, '/')[4]}'
}

module sql '../../../arm/Microsoft.Sql/servers/deploy.bicep' = {
  name: 'sql'
  params: {
    name: 'sql'
    location: location
    administratorLogin: dbLogin
    administratorLoginPassword: dbPwd
    databases: [
      {
        name: '<<namePrefix>>-az-sqldb-x-001'
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        tier: 'GeneralPurpose'
        skuName: 'GP_Gen5_2'
        maxSizeBytes: 34359738368
        licenseType: 'LicenseIncluded'
        workspaceId: law.id
      }
    ]
  }
  scope: resourceGroup(rg.name)
  dependsOn: [
    rg
  ]
}

resource spokeVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  scope: rg
  name: '${last(split(vnetResourceId, '/'))}'

  resource snetClusterNodes 'subnets@2021-05-01' existing = {
    name: 'snet-clusternodes'
  }
}

module acrAks '../../../arm/Microsoft.ContainerRegistry/registries/deploy.bicep' = {
  name: 'acraks'
  params: {
    name: 'acraks'
    location: location
    acrSku: 'Basic'
    diagnosticWorkspaceId: law.id
  }
  scope: resourceGroup(rg.name)
  dependsOn: [
    rg
    law
  ]
}

module cluster '../../../arm/Microsoft.ContainerService/managedClusters/deploy.bicep' = {
  name: 'cluster'
  params: {
    name: 'cluster'
    location: location
    aksClusterSkuTier: 'Paid'
    aksClusterKubernetesVersion: kubernetesVersion
    aksClusterDnsPrefix: uniqueString(rg.name)
    primaryAgentPoolProfile: [
      {
        name: 'npsystem'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osDiskSizeGB: 80
        osDiskType: 'Ephemeral'
        osType: 'Linux'
        minCount: 3
        maxCount: 4
        vnetSubnetID: spokeVirtualNetwork::snetClusterNodes.id
        enableAutoScaling: true
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        scaleSetPriority: 'Regular'
        scaleSetEvictionPolicy: 'Delete'
        orchestratorVersion: kubernetesVersion
        enableNodePublicIP: false
        maxPods: 30
        availabilityZones: [
          '1'
          '2'
          '3'
        ]
        upgradeSettings: {
          maxSurge: '33%'
        }
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
      }
    ]
    agentPools: [
      {
        name: 'npuser01'
        count: 2
        vmSize: 'Standard_DS3_v2'
        osDiskSizeGB: 120
        osDiskType: 'Ephemeral'
        osType: 'Linux'
        minCount: 2
        maxCount: 5
        vnetSubnetID: spokeVirtualNetwork::snetClusterNodes.id
        enableAutoScaling: true
        type: 'VirtualMachineScaleSets'
        mode: 'User'
        scaleSetPriority: 'Regular'
        scaleSetEvictionPolicy: 'Delete'
        orchestratorVersion: kubernetesVersion
        enableNodePublicIP: false
        maxPods: 30
        availabilityZones: [
          '1'
          '2'
          '3'
        ]
        upgradeSettings: {
          maxSurge: '33%'
        }
      }
    ]
    aksServicePrincipalProfile: {
      clientId: 'msi'
    }
    httpApplicationRoutingEnabled: false
    monitoringWorkspaceId: law.id
    aciConnectorLinuxEnabled: false
    azurePolicyEnabled: true
    azurePolicyVersion: 'v2'
    enableKeyvaultSecretsProvider: true
    enableSecretRotation: 'false'
    nodeResourceGroup: nodeResourceGroupName
    aksClusterNetworkPlugin: 'azure'
    aksClusterNetworkPolicy: 'azure'
    aksClusterOutboundType: 'userDefinedRouting'
    aksClusterLoadBalancerSku: 'standard'
    aksClusterServiceCidr: '172.16.0.0/16'
    aksClusterDnsServiceIP: '172.16.0.10'
    aksClusterDockerBridgeCidr: '172.18.0.1/16'
    aadProfileManaged: true
    aadProfileEnableAzureRBAC: isUsingAzureRBACasKubernetesRBAC
    aadProfileAdminGroupObjectIDs: ((!isUsingAzureRBACasKubernetesRBAC) ? array(clusterAdminAadGroupObjectId) : [])
    aadProfileTenantId: k8sControlPlaneAuthorizationTenantId
    autoScalerProfileBalanceSimilarNodeGroups: 'false'
    autoScalerProfileExpander: 'random'
    autoScalerProfileMaxEmptyBulkDelete: '10'
    autoScalerProfileMaxNodeProvisionTime: '15m'
    autoScalerProfileMaxTotalUnreadyPercentage: '45'
    autoScalerProfileNewPodScaleUpDelay: '0s'
    autoScalerProfileOkTotalUnreadyCount: '3'
    autoScalerProfileSkipNodesWithLocalStorage: 'true'
    autoScalerProfileSkipNodesWithSystemPods: 'true'
    autoScalerProfileScanInterval: '10s'
    autoScalerProfileScaleDownDelayAfterAdd: '10m'
    autoScalerProfileScaleDownDelayAfterDelete: '20s'
    autoScalerProfileScaleDownDelayAfterFailure: '3m'
    autoScalerProfileScaleDownUnneededTime: '10m'
    autoScalerProfileScaleDownUnreadyTime: '20m'
    autoScalerProfileUtilizationThreshold: '0.5'
    autoScalerProfileMaxGracefulTerminationSec: '600'
    enablePrivateCluster: false
    authorizedIPRanges: clusterAuthorizedIPRanges
    // maxAgentPools: 2
    disableLocalAccounts: true
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Azure Kubernetes Service RBAC Cluster Admin'
        principalIds: [
          clusterAdminAadGroupObjectId
        ]
      }
      {
        roleDefinitionIdOrName: 'Azure Kubernetes Service Cluster User Role'
        principalIds: [
          clusterAdminAadGroupObjectId
        ]
      }
      {
        roleDefinitionIdOrName: 'Azure Kubernetes Service RBAC Reader'
        principalIds: [
          a0008NamespaceReaderAadGroupObjectId
        ]
      }
      {
        roleDefinitionIdOrName: 'Azure Kubernetes Service Cluster User Role'
        principalIds: [
          a0008NamespaceReaderAadGroupObjectId
        ]
      }
    ]
    userAssignedIdentities: {
      '${clusterControlPlaneIdentity.outputs.resourceId}': {}
    }
    diagnosticWorkspaceId: law.id
    tags: {
      'Business unit': 'BU0001'
      'Application identifier': 'a0008'
    }
  }
  scope: resourceGroup(rg.name)
  dependsOn: [
    rg
    law
  ]
}
