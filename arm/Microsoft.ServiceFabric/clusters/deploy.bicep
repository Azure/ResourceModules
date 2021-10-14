// This file can only be deployed at a resource group scope.
targetScope = 'resourceGroup'

@description('Required. Name of the Serivce Fabric cluster.')
param serviceFabricClusterName string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Switch to lock storage from deletion.')
param lockForDeletion bool = false

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@allowed([
  'BackupRestoreService'
  'DnsService'
  'RepairManager'
  'ResourceMonitorService'
])
@description('Optional. The list of add-on features to enable in the cluster.')
param addOnFeatures array = []

@description('Required. Number of unused versions per application type to keep.')
param maxUnusedVersionsToKeep int = 3

@description('Optional. Azure active directory client application id.')
param clientApplication string = ''

@description('Optional. Azure active directory cluster application id.')
param clusterApplication string = ''

@description('Optional. Azure active directory tenant id.')
param tenantId string = ''

@description('Required. Thumbprint of the primary certificate.')
param thumbprint string = ''

@description('Optional. Thumbprint of the secondary certificate.')
param thumbprintSecondary string = ''

@allowed([
  'AddressBook'
  'AuthRoot'
  'CertificateAuthority'
  'Disallowed'
  'My'
  'Root'
  'TrustedPeople'
  'TrustedPublisher'
])
@description('Optional.The local certificate store location for cluster certificate.')
param clusterCertificatex509StoreName string = 'Root'

@description('Optional. Describes a list of server certificates referenced by common name that are used to secure the cluster.')
param certificateCommonNames object = {}

@description('Optional. The list of client certificates referenced by common name that are allowed to manage the cluster.')
param clientCertificateCommonNames array = []

@description('Optional. The list of client certificates referenced by thumbprint that are allowed to manage the cluster.')
param clientCertificateThumbprints array = []

@description('Optional. The Service Fabric runtime version of the cluster. This property can only by set the user when upgradeMode is set to "Manual". To get list of available Service Fabric versions for new clusters use ClusterVersion API. To get the list of available version for existing clusters use availableClusterVersions.')
param clusterCodeVersion string = ''

@description('Optional. The storage account information for storing Service Fabric diagnostic logs.')
param diagnosticsStorageAccountConfig object = {}

@description('Optional. Indicates if the event store service is enabled.')
param eventStoreServiceEnabled bool = false

@description('Optional. The list of custom fabric settings to configure the cluster.')
param fabricSettings array = []

@description('Optional. Indicates if infrastructure service manager is enabled.')
param infrastructureServiceManager bool = false

@description('Required. The http management endpoint of the cluster.')
param managementEndpoint string = ''

@description('Required. The list of node types in the cluster.')
param nodeTypes array = []

@description('Optional. Indicates a list of notification channels for cluster events.')
param notifications array = []

@allowed([
  'Bronze'
  'Gold'
  'None'
  'Platinum'
  'Silver'
])
@description('Optional. The reliability level sets the replica set size of system services. Learn about ReliabilityLevel (https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-capacity). - None - Run the System services with a target replica set count of 1. This should only be used for test clusters. - Bronze - Run the System services with a target replica set count of 3. This should only be used for test clusters. - Silver - Run the System services with a target replica set count of 5. - Gold - Run the System services with a target replica set count of 7. - Platinum - Run the System services with a target replica set count of 9.')
param reliabilityLevel string = 'None'

@description('Optional. Describes the certificate details.')
param reverseProxyCertificate object = {}

@description('Optional. Describes a list of server certificates referenced by common name that are used to secure the cluster.')
param reverseProxyCertificateCommonNames object = {}

@allowed([
  'Hierarchical'
  'Parallel'
])
@description('Optional. This property controls the logical grouping of VMs in upgrade domains (UDs). This property cannot be modified if a node type with multiple Availability Zones is already present in the cluster.')
param sfZonalUpgradeMode string = 'Hierarchical'

@description('Optional. Describes the policy used when upgrading the cluster.')
param upgradeDescription object = {}

@allowed([
  'Automatic'
  'Manual'
])
@description('Optional. The upgrade mode of the cluster when new Service Fabric runtime version is available.')
param upgradeMode string = 'Automatic'

@description('Optional. Indicates the end date and time to pause automatic runtime version upgrades on the cluster for an specific period of time on the cluster (UTC).')
param upgradePauseEndTimestampUtc string = ''

@description('Optional. Indicates the start date and time to pause automatic runtime version upgrades on the cluster for an specific period of time on the cluster (UTC).')
param upgradePauseStartTimestampUtc string = ''

@allowed([
  'Wave0'
  'Wave1'
  'Wave2'
])
@description('Optional. Indicates when new cluster runtime version upgrades will be applied after they are released. By default is Wave0.')
param upgradeWave string = 'Wave0'

@description('Optional. The VM image VMSS has been configured with. Generic names such as Windows or Linux can be used')
param vmImage string = ''

@allowed([
  'Hierarchical'
  'Parallel'
])
@description('Optional. This property defines the upgrade mode for the virtual machine scale set, it is mandatory if a node type with multiple Availability Zones is added.')
param vmssZonalUpgradeMode string = 'Hierarchical'

@description('Optional. Boolean to pause automatic runtime version upgrades to the cluster.')
param waveUpgradePaused bool = false

// Var section
var builtInRoleNames = {}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

// Service Fabric cluster resource
resource serviceFabricCluster 'Microsoft.ServiceFabric/clusters@2021-06-01' = {
  name: serviceFabricClusterName
  location: location
  tags: tags
  properties: {
    addOnFeatures: addOnFeatures

    applicationTypeVersionsCleanupPolicy: {
      maxUnusedVersionsToKeep: maxUnusedVersionsToKeep
    }

    azureActiveDirectory: {
      clientApplication: clientApplication
      clusterApplication: clusterApplication
      tenantId: tenantId
    }

    certificate: {
      thumbprint: thumbprint
      thumbprintSecondary: thumbprintSecondary
      x509StoreName: clusterCertificatex509StoreName
    }

    certificateCommonNames: certificateCommonNames
    clientCertificateCommonNames: clientCertificateCommonNames
    clientCertificateThumbprints: clientCertificateThumbprints
    clusterCodeVersion: clusterCodeVersion
    diagnosticsStorageAccountConfig: diagnosticsStorageAccountConfig
    eventStoreServiceEnabled: eventStoreServiceEnabled
    fabricSettings: fabricSettings
    infrastructureServiceManager: infrastructureServiceManager
    managementEndpoint: managementEndpoint
    nodeTypes: nodeTypes
    notifications: notifications
    reliabilityLevel: reliabilityLevel
    reverseProxyCertificate: reverseProxyCertificate
    reverseProxyCertificateCommonNames: reverseProxyCertificateCommonNames
    sfZonalUpgradeMode: sfZonalUpgradeMode
    upgradeDescription: upgradeDescription
    upgradeMode: upgradeMode
    upgradePauseEndTimestampUtc: upgradePauseEndTimestampUtc
    upgradePauseStartTimestampUtc: upgradePauseStartTimestampUtc
    upgradeWave: upgradeWave
    vmImage: vmImage
    vmssZonalUpgradeMode: vmssZonalUpgradeMode
    waveUpgradePaused: waveUpgradePaused
  }
}

// Service Fabric cluster resource lock
resource serviceFabricCluster_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${serviceFabricCluster.name}-doNotDelete'
  properties: {
    level: 'CanNotDelete'
    notes: 'Do not delete!'
  }
  scope: serviceFabricCluster
}

// Outputs section
output serviceFabricClusterName string = serviceFabricCluster.name
output serviceFabricClusterId string = serviceFabricCluster.id
output serviceFabricClusterProperties object = serviceFabricCluster.properties
