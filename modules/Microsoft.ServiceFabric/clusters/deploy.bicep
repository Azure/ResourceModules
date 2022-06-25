@description('Required. Name of the Service Fabric cluster.')
param name string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

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

@description('Optional. The settings to enable AAD authentication on the cluster.')
param azureActiveDirectory object = {}

@description('Optional. Describes the certificate details like thumbprint of the primary certificate, thumbprint of the secondary certificate and the local certificate store location.')
param certificate object = {}

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
param managementEndpoint string

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
param reliabilityLevel string

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

@description('Optional. The VM image VMSS has been configured with. Generic names such as Windows or Linux can be used.')
param vmImage string = ''

@allowed([
  'Hierarchical'
  'Parallel'
])
@description('Optional. This property defines the upgrade mode for the virtual machine scale set, it is mandatory if a node type with multiple Availability Zones is added.')
param vmssZonalUpgradeMode string = 'Hierarchical'

@description('Optional. Boolean to pause automatic runtime version upgrades to the cluster.')
param waveUpgradePaused bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Array of Service Fabric cluster application types.')
param applicationTypes array = []

var enableReferencedModulesTelemetry = false

var clientCertificateCommonNames_var = [for clientCertificateCommonName in clientCertificateCommonNames: {
  certificateCommonName: contains(clientCertificateCommonName, 'certificateCommonName') ? clientCertificateCommonName.certificateCommonName : null
  certificateIssuerThumbprint: contains(clientCertificateCommonName, 'certificateIssuerThumbprint') ? clientCertificateCommonName.certificateIssuerThumbprint : null
  isAdmin: contains(clientCertificateCommonName, 'isAdmin') ? clientCertificateCommonName.isAdmin : false
}]

var clientCertificateThumbprints_var = [for clientCertificateThumbprint in clientCertificateThumbprints: {
  certificateThumbprint: contains(clientCertificateThumbprint, 'certificateThumbprint') ? clientCertificateThumbprint.certificateThumbprint : null
  isAdmin: contains(clientCertificateThumbprint, 'isAdmin') ? clientCertificateThumbprint.isAdmin : false
}]

var fabricSettings_var = [for fabricSetting in fabricSettings: {
  name: contains(fabricSetting, 'name') ? fabricSetting.name : null
  parameters: contains(fabricSetting, 'parameters') ? fabricSetting.parameters : null
}]

var nodeTypes_var = [for nodeType in nodeTypes: {
  applicationPorts: contains(nodeType, 'applicationPorts') ? {
    endPort: contains(nodeType.applicationPorts, 'endPort') ? nodeType.applicationPorts.endPort : null
    startPort: contains(nodeType.applicationPorts, 'startPort') ? nodeType.applicationPorts.startPort : null
  } : null
  capacities: contains(nodeType, 'capacities') ? nodeType.capacities : null
  clientConnectionEndpointPort: contains(nodeType, 'clientConnectionEndpointPort') ? nodeType.clientConnectionEndpointPort : null
  durabilityLevel: contains(nodeType, 'durabilityLevel') ? nodeType.durabilityLevel : null
  ephemeralPorts: contains(nodeType, 'ephemeralPorts') ? {
    endPort: contains(nodeType.ephemeralPorts, 'endPort') ? nodeType.ephemeralPorts.endPort : null
    startPort: contains(nodeType.ephemeralPorts, 'startPort') ? nodeType.ephemeralPorts.startPort : null
  } : null
  httpGatewayEndpointPort: contains(nodeType, 'httpGatewayEndpointPort') ? nodeType.httpGatewayEndpointPort : null
  isPrimary: contains(nodeType, 'isPrimary') ? nodeType.isPrimary : null
  isStateless: contains(nodeType, 'isStateless') ? nodeType.isStateless : null
  multipleAvailabilityZones: contains(nodeType, 'multipleAvailabilityZones') ? nodeType.multipleAvailabilityZones : null
  name: contains(nodeType, 'name') ? nodeType.name : 'Node00'
  placementProperties: contains(nodeType, 'placementProperties') ? nodeType.placementProperties : null
  reverseProxyEndpointPort: contains(nodeType, 'reverseProxyEndpointPort') ? nodeType.reverseProxyEndpointPort : null
  vmInstanceCount: contains(nodeType, 'vmInstanceCount') ? nodeType.vmInstanceCount : 1
}]

var notifications_var = [for notification in notifications: {
  isEnabled: contains(notification, 'isEnabled') ? notification.isEnabled : false
  notificationCategory: contains(notification, 'notificationCategory') ? notification.notificationCategory : 'WaveProgress'
  notificationLevel: contains(notification, 'notificationLevel') ? notification.notificationLevel : 'All'
  notificationTargets: contains(notification, 'notificationTargets') ? notification.notificationTargets : []
}]

var upgradeDescription_var = union({
    deltaHealthPolicy: {
      applicationDeltaHealthPolicies: contains(upgradeDescription, 'applicationDeltaHealthPolicies') ? upgradeDescription.applicationDeltaHealthPolicies : {}
      maxPercentDeltaUnhealthyApplications: contains(upgradeDescription, 'maxPercentDeltaUnhealthyApplications') ? upgradeDescription.maxPercentDeltaUnhealthyApplications : 0
      maxPercentDeltaUnhealthyNodes: contains(upgradeDescription, 'maxPercentDeltaUnhealthyNodes') ? upgradeDescription.maxPercentDeltaUnhealthyNodes : 0
      maxPercentUpgradeDomainDeltaUnhealthyNodes: contains(upgradeDescription, 'maxPercentUpgradeDomainDeltaUnhealthyNodes') ? upgradeDescription.maxPercentUpgradeDomainDeltaUnhealthyNodes : 0
    }
    forceRestart: contains(upgradeDescription, 'forceRestart') ? upgradeDescription.forceRestart : false
    healthCheckRetryTimeout: contains(upgradeDescription, 'healthCheckRetryTimeout') ? upgradeDescription.healthCheckRetryTimeout : '00:45:00'
    healthCheckStableDuration: contains(upgradeDescription, 'healthCheckStableDuration') ? upgradeDescription.healthCheckStableDuration : '00:01:00'
    healthCheckWaitDuration: contains(upgradeDescription, 'healthCheckWaitDuration') ? upgradeDescription.healthCheckWaitDuration : '00:00:30'
    upgradeDomainTimeout: contains(upgradeDescription, 'upgradeDomainTimeout') ? upgradeDescription.upgradeDomainTimeout : '02:00:00'
    upgradeReplicaSetCheckTimeout: contains(upgradeDescription, 'upgradeReplicaSetCheckTimeout') ? upgradeDescription.upgradeReplicaSetCheckTimeout : '1.00:00:00'
    upgradeTimeout: contains(upgradeDescription, 'upgradeTimeout') ? upgradeDescription.upgradeTimeout : '02:00:00'
  }, contains(upgradeDescription, 'healthPolicy') ? {
    healthPolicy: {
      applicationHealthPolicies: contains(upgradeDescription.healthPolicy, 'applicationHealthPolicies') ? upgradeDescription.healthPolicy.applicationHealthPolicies : {}
      maxPercentUnhealthyApplications: contains(upgradeDescription.healthPolicy, 'maxPercentUnhealthyApplications') ? upgradeDescription.healthPolicy.maxPercentUnhealthyApplications : 0
      maxPercentUnhealthyNodes: contains(upgradeDescription.healthPolicy, 'maxPercentUnhealthyNodes') ? upgradeDescription.healthPolicy.maxPercentUnhealthyNodes : 0
    }
  } : {})

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

// Service Fabric cluster resource
resource serviceFabricCluster 'Microsoft.ServiceFabric/clusters@2021-06-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addOnFeatures: addOnFeatures
    applicationTypeVersionsCleanupPolicy: {
      maxUnusedVersionsToKeep: maxUnusedVersionsToKeep
    }
    azureActiveDirectory: !empty(azureActiveDirectory) ? {
      clientApplication: contains(azureActiveDirectory, 'clientApplication') ? azureActiveDirectory.clientApplication : null
      clusterApplication: contains(azureActiveDirectory, 'clusterApplication') ? azureActiveDirectory.clusterApplication : null
      tenantId: contains(azureActiveDirectory, 'tenantId') ? azureActiveDirectory.tenantId : null
    } : null
    certificate: !empty(certificate) ? {
      thumbprint: contains(certificate, 'thumbprint') ? certificate.thumbprint : null
      thumbprintSecondary: contains(certificate, 'thumbprintSecondary') ? certificate.thumbprintSecondary : null
      x509StoreName: contains(certificate, 'x509StoreName') ? certificate.x509StoreName : null
    } : null
    certificateCommonNames: !empty(certificateCommonNames) ? {
      commonNames: contains(certificateCommonNames, 'commonNames') ? certificateCommonNames.commonNames : null
      x509StoreName: contains(certificateCommonNames, 'certificateCommonNamesx509StoreName') ? certificateCommonNames.certificateCommonNamesx509StoreName : null
    } : null
    clientCertificateCommonNames: !empty(clientCertificateCommonNames) ? clientCertificateCommonNames_var : null
    clientCertificateThumbprints: !empty(clientCertificateThumbprints) ? clientCertificateThumbprints_var : null
    clusterCodeVersion: !empty(clusterCodeVersion) ? clusterCodeVersion : null
    diagnosticsStorageAccountConfig: !empty(diagnosticsStorageAccountConfig) ? {
      blobEndpoint: contains(diagnosticsStorageAccountConfig, 'blobEndpoint') ? diagnosticsStorageAccountConfig.blobEndpoint : null
      protectedAccountKeyName: contains(diagnosticsStorageAccountConfig, 'protectedAccountKeyName') ? diagnosticsStorageAccountConfig.protectedAccountKeyName : null
      protectedAccountKeyName2: contains(diagnosticsStorageAccountConfig, 'protectedAccountKeyName2') ? diagnosticsStorageAccountConfig.protectedAccountKeyName2 : null
      queueEndpoint: contains(diagnosticsStorageAccountConfig, 'queueEndpoint') ? diagnosticsStorageAccountConfig.queueEndpoint : null
      storageAccountName: contains(diagnosticsStorageAccountConfig, 'storageAccountName') ? diagnosticsStorageAccountConfig.storageAccountName : null
      tableEndpoint: contains(diagnosticsStorageAccountConfig, 'tableEndpoint') ? diagnosticsStorageAccountConfig.tableEndpoint : null
    } : null
    eventStoreServiceEnabled: eventStoreServiceEnabled
    fabricSettings: !empty(fabricSettings) ? fabricSettings_var : null
    infrastructureServiceManager: infrastructureServiceManager
    managementEndpoint: managementEndpoint
    nodeTypes: !empty(nodeTypes) ? nodeTypes_var : []
    notifications: !empty(notifications) ? notifications_var : null
    reliabilityLevel: !empty(reliabilityLevel) ? reliabilityLevel : 'None'
    reverseProxyCertificate: !empty(reverseProxyCertificate) ? {
      thumbprint: contains(reverseProxyCertificate, 'thumbprint') ? reverseProxyCertificate.thumbprint : null
      thumbprintSecondary: contains(reverseProxyCertificate, 'thumbprintSecondary') ? reverseProxyCertificate.thumbprintSecondary : null
      x509StoreName: contains(reverseProxyCertificate, 'x509StoreName') ? reverseProxyCertificate.x509StoreName : null
    } : null
    reverseProxyCertificateCommonNames: !empty(reverseProxyCertificateCommonNames) ? {
      commonNames: contains(reverseProxyCertificateCommonNames, 'commonNames') ? reverseProxyCertificateCommonNames.commonNames : null
      x509StoreName: contains(reverseProxyCertificateCommonNames, 'x509StoreName') ? reverseProxyCertificateCommonNames.x509StoreName : null
    } : null
    sfZonalUpgradeMode: !empty(sfZonalUpgradeMode) ? sfZonalUpgradeMode : null
    upgradeDescription: !empty(upgradeDescription) ? upgradeDescription_var : null
    upgradeMode: !empty(upgradeMode) ? upgradeMode : null
    upgradePauseEndTimestampUtc: !empty(upgradePauseEndTimestampUtc) ? upgradePauseEndTimestampUtc : null
    upgradePauseStartTimestampUtc: !empty(upgradePauseStartTimestampUtc) ? upgradePauseStartTimestampUtc : null
    upgradeWave: !empty(upgradeWave) ? upgradeWave : null
    vmImage: !empty(vmImage) ? vmImage : null
    vmssZonalUpgradeMode: !empty(vmssZonalUpgradeMode) ? vmssZonalUpgradeMode : null
    waveUpgradePaused: waveUpgradePaused
  }
}

// Service Fabric cluster resource lock
resource serviceFabricCluster_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${serviceFabricCluster.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: serviceFabricCluster
}

// Service Fabric cluster RBAC assignment
module serviceFabricCluster_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-ServiceFabric-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: serviceFabricCluster.id
  }
}]

// Service Fabric cluster application types
module serviceFabricCluster_applicationTypes 'applicationTypes/deploy.bicep' = [for applicationType in applicationTypes: {
  name: '${uniqueString(deployment().name, location)}-SFC-${applicationType.name}'
  params: {
    name: applicationType.name
    serviceFabricClusterName: serviceFabricCluster.name
    tags: contains(applicationType, 'tags') ? applicationType.tags : {}
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

@description('The Service Fabric Cluster name.')
output name string = serviceFabricCluster.name

@description('The Service Fabric Cluster resource group.')
output resourceGroupName string = resourceGroup().name

@description('The Service Fabric Cluster resource ID.')
output resourceId string = serviceFabricCluster.id

@description('The Service Fabric Cluster endpoint.')
output endpoint string = serviceFabricCluster.properties.clusterEndpoint

@description('The location the resource was deployed into.')
output location string = serviceFabricCluster.location
