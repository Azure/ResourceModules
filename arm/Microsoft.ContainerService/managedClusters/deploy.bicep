@description('Required. Specifies the name of the AKS cluster.')
param name string

@description('Optional. Specifies the location of AKS cluster. It picks up Resource Group\'s location by default.')
param location string = resourceGroup().location

@description('Optional. Specifies the DNS prefix specified when creating the managed cluster.')
param aksClusterDnsPrefix string = name

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Specifies the network plugin used for building Kubernetes network. - azure or kubenet.')
@allowed([
  ''
  'azure'
  'kubenet'
])
param aksClusterNetworkPlugin string = ''

@description('Optional. Specifies the network policy used for building Kubernetes network. - calico or azure')
@allowed([
  ''
  'azure'
  'calico'
])
param aksClusterNetworkPolicy string = ''

@description('Optional. Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used.')
param aksClusterPodCidr string = ''

@description('Optional. A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges.')
param aksClusterServiceCidr string = ''

@description('Optional. Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr.')
param aksClusterDnsServiceIP string = ''

@description('Optional. Specifies the CIDR notation IP range assigned to the Docker bridge network. It must not overlap with any Subnet IP ranges or the Kubernetes service address range.')
param aksClusterDockerBridgeCidr string = ''

@description('Optional. Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools.')
@allowed([
  'basic'
  'standard'
])
param aksClusterLoadBalancerSku string = 'standard'

@description('Optional. Outbound IP Count for the Load balancer.')
param managedOutboundIPCount int = 0

@description('Optional. Specifies outbound (egress) routing method. - loadBalancer or userDefinedRouting.')
@allowed([
  'loadBalancer'
  'userDefinedRouting'
])
param aksClusterOutboundType string = 'loadBalancer'

@description('Optional. Tier of a managed cluster SKU. - Free or Paid')
@allowed([
  'Free'
  'Paid'
])
param aksClusterSkuTier string = 'Free'

@description('Optional. Version of Kubernetes specified when creating the managed cluster.')
param aksClusterKubernetesVersion string = ''

@description('Optional. Specifies the administrator username of Linux virtual machines.')
param aksClusterAdminUsername string = 'azureuser'

@description('Optional. Specifies the SSH RSA public key string for the Linux nodes.')
param aksClusterSshPublicKey string = ''

@description('Optional. Information about a service principal identity for the cluster to use for manipulating Azure APIs.')
param aksServicePrincipalProfile object = {}

@description('Optional. The client AAD application ID.')
param aadProfileClientAppID string = ''

@description('Optional. The server AAD application ID.')
param aadProfileServerAppID string = ''

@description('Optional. The server AAD application secret.')
param aadProfileServerAppSecret string = ''

@description('Optional. Specifies the tenant ID of the Azure Active Directory used by the AKS cluster for authentication.')
param aadProfileTenantId string = subscription().tenantId

@description('Optional. Specifies the AAD group object IDs that will have admin role of the cluster.')
param aadProfileAdminGroupObjectIDs array = []

@description('Optional. Specifies whether to enable managed AAD integration.')
param aadProfileManaged bool = true

@description('Optional. Specifies whether to enable Azure RBAC for Kubernetes authorization.')
param aadProfileEnableAzureRBAC bool = true

@description('Optional. If set to true, getting static credentials will be disabled for this cluster. This must only be used on Managed Clusters that are AAD enabled.')
param disableLocalAccounts bool = false

@description('Optional. Name of the resource group containing agent pool nodes.')
param nodeResourceGroup string = '${resourceGroup().name}_aks_${name}_nodes'

@description('Optional. IP ranges are specified in CIDR format, e.g. 137.117.106.88/29. This feature is not compatible with clusters that use Public IP Per Node, or clusters that are using a Basic Load Balancer.')
param authorizedIPRanges array = []

@description('Optional. Whether to disable run command for the cluster or not.')
param disableRunCommand bool = false

@description('Optional. Specifies whether to create the cluster as a private cluster or not.')
param enablePrivateCluster bool = false

@description('Optional. Whether to create additional public FQDN for private cluster or not.')
param enablePrivateClusterPublicFQDN bool = false

@description('Optional. If AKS will create a Private DNS Zone in the Node Resource Group.')
param usePrivateDNSZone bool = false

@description('Required. Properties of the primary agent pool.')
param primaryAgentPoolProfile array

@description('Optional. Define one or more secondary/additional agent pools')
param agentPools array = []

@description('Optional. Specifies whether the httpApplicationRouting add-on is enabled or not.')
param httpApplicationRoutingEnabled bool = false

@description('Optional. Specifies whether the aciConnectorLinux add-on is enabled or not.')
param aciConnectorLinuxEnabled bool = false

@description('Optional. Specifies whether the azurepolicy add-on is enabled or not.')
param azurePolicyEnabled bool = true

@description('Optional. Specifies the azure policy version to use.')
param azurePolicyVersion string = 'v2'

@description('Optional. Specifies whether the kubeDashboard add-on is enabled or not.')
param kubeDashboardEnabled bool = false

@description('Optional. Specifies whether the KeyvaultSecretsProvider add-on is enabled or not.')
param enableKeyvaultSecretsProvider bool = false

@allowed([
  'false'
  'true'
])
@description('Optional. Specifies whether the KeyvaultSecretsProvider add-on uses secret rotation.')
param enableSecretRotation string = 'false'

@description('Optional. Specifies the scan interval of the auto-scaler of the AKS cluster.')
param autoScalerProfileScanInterval string = '10s'

@description('Optional. Specifies the scale down delay after add of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownDelayAfterAdd string = '10m'

@description('Optional. Specifies the scale down delay after delete of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownDelayAfterDelete string = '20s'

@description('Optional. Specifies scale down delay after failure of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownDelayAfterFailure string = '3m'

@description('Optional. Specifies the scale down unneeded time of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownUnneededTime string = '10m'

@description('Optional. Specifies the scale down unready time of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownUnreadyTime string = '20m'

@description('Optional. Specifies the utilization threshold of the auto-scaler of the AKS cluster.')
param autoScalerProfileUtilizationThreshold string = '0.5'

@description('Optional. Specifies the max graceful termination time interval in seconds for the auto-scaler of the AKS cluster.')
param autoScalerProfileMaxGracefulTerminationSec string = '600'

@allowed([
  'false'
  'true'
])
@description('Optional. Specifies the balance of similar node groups for the auto-scaler of the AKS cluster.')
param autoScalerProfileBalanceSimilarNodeGroups string = 'false'

@allowed([
  'least-waste'
  'most-pods'
  'priority'
  'random'
])
@description('Optional. Specifies the expand strategy for the auto-scaler of the AKS cluster.')
param autoScalerProfileExpander string = 'random'

@description('Optional. Specifies the maximum empty bulk delete for the auto-scaler of the AKS cluster.')
param autoScalerProfileMaxEmptyBulkDelete string = '10'

@description('Optional. Specifies the maximum node provisioning time for the auto-scaler of the AKS cluster. Values must be an integer followed by an "m". No unit of time other than minutes (m) is supported.')
param autoScalerProfileMaxNodeProvisionTime string = '15m'

@description('Optional. Specifies the mximum total unready percentage for the auto-scaler of the AKS cluster. The maximum is 100 and the minimum is 0.')
param autoScalerProfileMaxTotalUnreadyPercentage string = '45'

@description('Optional. For scenarios like burst/batch scale where you do not want CA to act before the kubernetes scheduler could schedule all the pods, you can tell CA to ignore unscheduled pods before they are a certain age. Values must be an integer followed by a unit ("s" for seconds, "m" for minutes, "h" for hours, etc).')
param autoScalerProfileNewPodScaleUpDelay string = '0s'

@description('Optional. Specifies the ok total unready count for the auto-scaler of the AKS cluster.')
param autoScalerProfileOkTotalUnreadyCount string = '3'

@allowed([
  'false'
  'true'
])
@description('Optional. Specifies if nodes with local storage should be skipped for the auto-scaler of the AKS cluster.')
param autoScalerProfileSkipNodesWithLocalStorage string = 'true'

@allowed([
  'false'
  'true'
])
@description('Optional. Specifies if nodes with system pods should be skipped for the auto-scaler of the AKS cluster.')
param autoScalerProfileSkipNodesWithSystemPods string = 'true'

@description('Optional. Running in Kubenet is disabled by default due to the security related nature of AAD Pod Identity and the risks of IP spoofing.')
param podIdentityProfileAllowNetworkPluginKubenet bool = false

@description('Optional. Whether the pod identity addon is enabled.')
param podIdentityProfileEnable bool = false

@description('Optional. The pod identities to use in the cluster.')
param podIdentityProfileUserAssignedIdentities array = []

@description('Optional. The pod identity exceptions to allow.')
param podIdentityProfileUserAssignedIdentityExceptions array = []

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Specifies whether the OMS agent is enabled.')
param omsAgentEnabled bool = true

@description('Optional. Resource ID of the monitoring log analytics workspace.')
param monitoringWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'kube-apiserver'
  'kube-audit'
  'kube-controller-manager'
  'kube-scheduler'
  'cluster-autoscaler'
])
param logsToEnable array = [
  'kube-apiserver'
  'kube-audit'
  'kube-controller-manager'
  'kube-scheduler'
  'cluster-autoscaler'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param metricsToEnable array = [
  'AllMetrics'
]

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsMetrics = [for metric in metricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var identityType = systemAssignedIdentity ? 'SystemAssigned' : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

var aksClusterLinuxProfile = {
  adminUsername: aksClusterAdminUsername
  ssh: {
    publicKeys: [
      {
        keyData: aksClusterSshPublicKey
      }
    ]
  }
}

var lbProfile = {
  managedOutboundIPs: {
    count: managedOutboundIPCount
  }
  effectiveOutboundIPs: []
}

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource managedCluster 'Microsoft.ContainerService/managedClusters@2021-10-01' = {
  name: name
  location: location
  tags: (empty(tags) ? null : tags)
  identity: identity
  properties: {
    kubernetesVersion: (empty(aksClusterKubernetesVersion) ? null : aksClusterKubernetesVersion)
    dnsPrefix: aksClusterDnsPrefix
    agentPoolProfiles: primaryAgentPoolProfile
    sku: {
      name: 'Basic'
      tier: aksClusterSkuTier
    }
    linuxProfile: (empty(aksClusterSshPublicKey) ? null : aksClusterLinuxProfile)
    servicePrincipalProfile: (empty(aksServicePrincipalProfile) ? null : aksServicePrincipalProfile)
    addonProfiles: {
      httpApplicationRouting: {
        enabled: httpApplicationRoutingEnabled
      }
      omsagent: {
        enabled: omsAgentEnabled && !empty(monitoringWorkspaceId)
        config: {
          logAnalyticsWorkspaceResourceID: !empty(monitoringWorkspaceId) ? any(monitoringWorkspaceId) : null
        }
      }
      aciConnectorLinux: {
        enabled: aciConnectorLinuxEnabled
      }
      azurepolicy: {
        enabled: azurePolicyEnabled
        config: {
          version: azurePolicyVersion
        }
      }
      kubeDashboard: {
        enabled: kubeDashboardEnabled
      }
      azureKeyvaultSecretsProvider: {
        enabled: enableKeyvaultSecretsProvider
        config: {
          enableSecretRotation: enableSecretRotation
        }
      }
    }
    enableRBAC: aadProfileEnableAzureRBAC
    disableLocalAccounts: disableLocalAccounts
    nodeResourceGroup: nodeResourceGroup
    networkProfile: {
      networkPlugin: !empty(aksClusterNetworkPlugin) ? any(aksClusterNetworkPlugin) : null
      networkPolicy: !empty(aksClusterNetworkPolicy) ? any(aksClusterNetworkPolicy) : null
      podCidr: !empty(aksClusterPodCidr) ? aksClusterPodCidr : null
      serviceCidr: !empty(aksClusterServiceCidr) ? aksClusterServiceCidr : null
      dnsServiceIP: !empty(aksClusterDnsServiceIP) ? aksClusterDnsServiceIP : null
      dockerBridgeCidr: !empty(aksClusterDockerBridgeCidr) ? aksClusterDockerBridgeCidr : null
      outboundType: aksClusterOutboundType
      loadBalancerSku: aksClusterLoadBalancerSku
      loadBalancerProfile: managedOutboundIPCount != 0 ? lbProfile : null
    }
    aadProfile: {
      clientAppID: aadProfileClientAppID
      serverAppID: aadProfileServerAppID
      serverAppSecret: aadProfileServerAppSecret
      managed: aadProfileManaged
      enableAzureRBAC: aadProfileEnableAzureRBAC
      adminGroupObjectIDs: aadProfileAdminGroupObjectIDs
      tenantID: aadProfileTenantId
    }
    autoScalerProfile: {
      'balance-similar-node-groups': autoScalerProfileBalanceSimilarNodeGroups
      'expander': autoScalerProfileExpander
      'max-empty-bulk-delete': autoScalerProfileMaxEmptyBulkDelete
      'max-graceful-termination-sec': autoScalerProfileMaxGracefulTerminationSec
      'max-node-provision-time': autoScalerProfileMaxNodeProvisionTime
      'max-total-unready-percentage': autoScalerProfileMaxTotalUnreadyPercentage
      'new-pod-scale-up-delay': autoScalerProfileNewPodScaleUpDelay
      'ok-total-unready-count': autoScalerProfileOkTotalUnreadyCount
      'scale-down-delay-after-add': autoScalerProfileScaleDownDelayAfterAdd
      'scale-down-delay-after-delete': autoScalerProfileScaleDownDelayAfterDelete
      'scale-down-delay-after-failure': autoScalerProfileScaleDownDelayAfterFailure
      'scale-down-unneeded-time': autoScalerProfileScaleDownUnneededTime
      'scale-down-unready-time': autoScalerProfileScaleDownUnreadyTime
      'scale-down-utilization-threshold': autoScalerProfileUtilizationThreshold
      'scan-interval': autoScalerProfileScanInterval
      'skip-nodes-with-local-storage': autoScalerProfileSkipNodesWithLocalStorage
      'skip-nodes-with-system-pods': autoScalerProfileSkipNodesWithSystemPods
    }
    apiServerAccessProfile: {
      authorizedIPRanges: authorizedIPRanges
      disableRunCommand: disableRunCommand
      enablePrivateCluster: enablePrivateCluster
      enablePrivateClusterPublicFQDN: enablePrivateClusterPublicFQDN
      privateDNSZone: usePrivateDNSZone ? 'system' : ''
    }
    podIdentityProfile: {
      allowNetworkPluginKubenet: podIdentityProfileAllowNetworkPluginKubenet
      enabled: podIdentityProfileEnable
      userAssignedIdentities: podIdentityProfileUserAssignedIdentities
      userAssignedIdentityExceptions: podIdentityProfileUserAssignedIdentityExceptions
    }
  }
}

module managedCluster_agentPools 'agentPools/deploy.bicep' = [for (agentPool, index) in agentPools: {
  name: '${uniqueString(deployment().name, location)}-ManagedCluster-AgentPool-${index}'
  params: {
    managedClusterName: managedCluster.name
    name: agentPool.name
    availabilityZones: contains(agentPool, 'availabilityZones') ? agentPool.availabilityZones : []
    count: contains(agentPool, 'count') ? agentPool.count : 1
    sourceResourceId: contains(agentPool, 'sourceResourceId') ? agentPool.sourceResourceId : ''
    enableAutoScaling: contains(agentPool, 'enableAutoScaling') ? agentPool.enableAutoScaling : false
    enableEncryptionAtHost: contains(agentPool, 'enableEncryptionAtHost') ? agentPool.enableEncryptionAtHost : false
    enableFIPS: contains(agentPool, 'enableFIPS') ? agentPool.enableFIPS : false
    enableNodePublicIP: contains(agentPool, 'enableNodePublicIP') ? agentPool.enableNodePublicIP : false
    enableUltraSSD: contains(agentPool, 'enableUltraSSD') ? agentPool.enableUltraSSD : false
    gpuInstanceProfile: contains(agentPool, 'gpuInstanceProfile') ? agentPool.gpuInstanceProfile : ''
    kubeletDiskType: contains(agentPool, 'kubeletDiskType') ? agentPool.kubeletDiskType : ''
    maxCount: contains(agentPool, 'maxCount') ? agentPool.maxCount : -1
    maxPods: contains(agentPool, 'maxPods') ? agentPool.maxPods : -1
    minCount: contains(agentPool, 'minCount') ? agentPool.minCount : -1
    mode: contains(agentPool, 'mode') ? agentPool.mode : ''
    nodeLabels: contains(agentPool, 'nodeLabels') ? agentPool.nodeLabels : {}
    nodePublicIpPrefixId: contains(agentPool, 'nodePublicIpPrefixId') ? agentPool.nodePublicIpPrefixId : ''
    nodeTaints: contains(agentPool, 'nodeTaints') ? agentPool.nodeTaints : []
    orchestratorVersion: contains(agentPool, 'orchestratorVersion') ? agentPool.orchestratorVersion : ''
    osDiskSizeGB: contains(agentPool, 'osDiskSizeGB') ? agentPool.osDiskSizeGB : -1
    osDiskType: contains(agentPool, 'osDiskType') ? agentPool.osDiskType : ''
    osSku: contains(agentPool, 'osSku') ? agentPool.osSku : ''
    osType: contains(agentPool, 'osType') ? agentPool.osType : 'Linux'
    podSubnetId: contains(agentPool, 'podSubnetId') ? agentPool.podSubnetId : ''
    proximityPlacementGroupId: contains(agentPool, 'proximityPlacementGroupId') ? agentPool.proximityPlacementGroupId : ''
    scaleDownMode: contains(agentPool, 'scaleDownMode') ? agentPool.scaleDownMode : 'Delete'
    scaleSetEvictionPolicy: contains(agentPool, 'scaleSetEvictionPolicy') ? agentPool.scaleSetEvictionPolicy : 'Delete'
    scaleSetPriority: contains(agentPool, 'scaleSetPriority') ? agentPool.scaleSetPriority : ''
    spotMaxPrice: contains(agentPool, 'spotMaxPrice') ? agentPool.spotMaxPrice : -1
    tags: contains(agentPool, 'tags') ? agentPool.tags : {}
    type: contains(agentPool, 'type') ? agentPool.type : ''
    maxSurge: contains(agentPool, 'maxSurge') ? agentPool.maxSurge : ''
    vmSize: contains(agentPool, 'vmSize') ? agentPool.vmSize : 'Standard_D2s_v3'
    vnetSubnetId: contains(agentPool, 'vnetSubnetId') ? agentPool.vnetSubnetId : ''
    workloadRuntime: contains(agentPool, 'workloadRuntime') ? agentPool.workloadRuntime : ''
  }
}]

resource managedCluster_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${managedCluster.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: managedCluster
}

resource managedCluster_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: '${managedCluster.name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: managedCluster
}

module managedCluster_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-ManagedCluster-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: managedCluster.id
  }
}]

@description('The resource ID of the managed cluster')
output resourceId string = managedCluster.id

@description('The resource group the managed cluster was deployed into')
output resourceGroupName string = resourceGroup().name

@description('The name of the managed cluster')
output name string = managedCluster.name

@description('The control plane FQDN of the managed cluster')
output controlPlaneFQDN string = enablePrivateCluster ? managedCluster.properties.privateFQDN : managedCluster.properties.fqdn

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(managedCluster.identity, 'principalId') ? managedCluster.identity.principalId : ''

@description('The Object ID of the AKS identity.')
output kubeletidentityObjectId string = contains(managedCluster.properties, 'identityProfile') ? contains(managedCluster.properties.identityProfile, 'kubeletidentity') ? managedCluster.properties.identityProfile.kubeletidentity.objectId : '' : ''

@description('The Object ID of the OMS agent identity.')
output omsagentIdentityObjectId string = contains(managedCluster.properties, 'addonProfiles') ? contains(managedCluster.properties.addonProfiles, 'omsagent') ? contains(managedCluster.properties.addonProfiles.omsagent, 'identity') ? managedCluster.properties.addonProfiles.omsagent.identity.objectId : '' : '' : ''
