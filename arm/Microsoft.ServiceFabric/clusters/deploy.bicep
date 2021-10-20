// This file can only be deployed at a resource group scope.
targetScope = 'resourceGroup'

// Service Fabric cluster resource and lock params
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

@description('Optional. Object containing Azure active directory client application id, cluster application id and tenant id.')
param azureActiveDirectory object = {}

@description('Optional. Describes the certificate details like thumbprint of the primary certificate, thumbprint of the secondary certificate and the local certificate store location')
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

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it\'s fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Array of Service Fabric cluster applications.')
param serviceFabricClusterApplications array = []

// Var section
var azureActiveDirectory_var = {
  clientApplication: (!empty(azureActiveDirectory) ? azureActiveDirectory.clientApplication : json('null'))
  clusterApplication: (!empty(azureActiveDirectory) ? azureActiveDirectory.clusterApplication : json('null'))
  tenantId: (!empty(azureActiveDirectory) ? azureActiveDirectory.tenantId : json('null'))
}

var certificate_var = {
  thumbprint: (!empty(certificate) ? certificate.thumbprint : json('null'))
  thumbprintSecondary: (!empty(certificate) ? certificate.thumbprintSecondary : json('null'))
  x509StoreName: (!empty(certificate) ? certificate.x509StoreName : json('null'))
}

var certificateCommonNamesList_var = [for index in range(0, (!empty(certificateCommonNames) ? length(certificateCommonNames.commonNames) : 0)): {
  commonNames: certificateCommonNames.commonNames[index]
}]

var certificateCommonNames_var = {
  commonNames: (!empty(certificateCommonNames) ? certificateCommonNamesList_var : json('null'))
  x509StoreName: (!empty(certificateCommonNames) ? certificateCommonNames.x509StoreName : json('null'))
}

var clientCertificateCommonNames_var = [for index in range(0, (!empty(clientCertificateCommonNames) ? length(clientCertificateCommonNames) : 0)): {
  certificateCommonName: (!empty(clientCertificateCommonNames) ? '${clientCertificateCommonNames[index].certificateCommonName}' : json('null'))
  certificateIssuerThumbprint: (!empty(clientCertificateCommonNames) ? '${clientCertificateCommonNames[index].certificateIssuerThumbprint}' : json('null'))
  isAdmin: (!empty(clientCertificateCommonNames) ? '${clientCertificateCommonNames[index].isAdmin}' : json('null'))
}]

var clientCertificateThumbprints_var = [for index in range(0, (!empty(clientCertificateThumbprints) ? length(clientCertificateThumbprints) : 0)): {
  certificateThumbprint: (!empty(clientCertificateThumbprints) ? '${clientCertificateThumbprints[index].certificateThumbprint}' : json('null'))
  isAdmin: (!empty(clientCertificateThumbprints) ? '${clientCertificateThumbprints[index].isAdmin}' : json('null'))
}]

var diagnosticsStorageAccountConfig_var = {
  blobEndpoint: (!empty(diagnosticsStorageAccountConfig) ? diagnosticsStorageAccountConfig.blobEndpoint : json('null'))
  protectedAccountKeyName: (!empty(diagnosticsStorageAccountConfig) ? diagnosticsStorageAccountConfig.protectedAccountKeyName : json('null'))
  protectedAccountKeyName2: (!empty(diagnosticsStorageAccountConfig) ? diagnosticsStorageAccountConfig.protectedAccountKeyName2 : json('null'))
  queueEndpoint: (!empty(diagnosticsStorageAccountConfig) ? diagnosticsStorageAccountConfig.queueEndpoint : json('null'))
  storageAccountName: (!empty(diagnosticsStorageAccountConfig) ? diagnosticsStorageAccountConfig.storageAccountName : json('null'))
  tableEndpoint: (!empty(diagnosticsStorageAccountConfig) ? diagnosticsStorageAccountConfig.tableEndpoint : json('null'))
}

var fabricSettings_var = [for index in range(0, (!empty(fabricSettings) ? length(fabricSettings) : 0)): {
  name: (!empty(fabricSettings) ? fabricSettings[index].name : json('null'))
  parameters: (!empty(fabricSettings) ? fabricSettings[index].parameters : json('null'))
}]

var nodeTypes_var = [for index in range(0, (!empty(nodeTypes) ? length(nodeTypes) : 0)): {
  applicationPorts: {
    endPort: (!empty(nodeTypes) ? nodeTypes[index].applicationPorts.endPort : json('null'))
    startPort: (!empty(nodeTypes) ? nodeTypes[index].applicationPorts.startPort : json('null'))
  }
  capacities: (!empty(nodeTypes) ? nodeTypes[index].capacities : json('null'))
  clientConnectionEndpointPort: (!empty(nodeTypes) ? nodeTypes[index].clientConnectionEndpointPort : json('null'))
  durabilityLevel: '${(!empty(nodeTypes) ? nodeTypes[index].durabilityLevel : json('null'))}'
  ephemeralPorts: {
    endPort: (!empty(nodeTypes) ? nodeTypes[index].ephemeralPorts.endPort : json('null'))
    startPort: (!empty(nodeTypes) ? nodeTypes[index].ephemeralPorts.startPort : json('null'))
  }
  httpGatewayEndpointPort: (!empty(nodeTypes) ? nodeTypes[index].httpGatewayEndpointPort : json('null'))
  isPrimary: (!empty(nodeTypes) ? nodeTypes[index].isPrimary : json('null'))
  isStateless: (!empty(nodeTypes) ? nodeTypes[index].isStateless : json('null'))
  multipleAvailabilityZones: (!empty(nodeTypes) ? nodeTypes[index].multipleAvailabilityZones : json('null'))
  name: '${(!empty(nodeTypes) ? nodeTypes[index].name : json('null'))}'
  placementProperties: (!empty(nodeTypes) ? nodeTypes[index].placementProperties : json('null'))
  reverseProxyEndpointPort: (!empty(nodeTypes) ? nodeTypes[index].reverseProxyEndpointPort : json('null'))
  vmInstanceCount: (!empty(nodeTypes) ? nodeTypes[index].vmInstanceCount : json('null'))
}]

var notifications_var = [for index in range(0, (!empty(notifications) ? length(notifications) : 0)): {
  isEnabled: (!empty(notifications) ? notifications[index].isEnabled : json('null'))
  notificationCategory: (!empty(notifications) ? notifications[index].notificationCategory : json('null'))
  notificationLevel: (!empty(notifications) ? notifications[index].notificationLevel : json('null'))
  notificationTargets: (!empty(notifications) ? notifications[index].notificationTargets : json('null'))
}]

var reverseProxyCertificate_var = {
  thumbprint: (!empty(reverseProxyCertificate) ? reverseProxyCertificate.thumbprint : json('null'))
  thumbprintSecondary: (!empty(reverseProxyCertificate) ? reverseProxyCertificate.thumbprintSecondary : json('null'))
  x509StoreName: (!empty(reverseProxyCertificate) ? reverseProxyCertificate.x509StoreName : json('null'))
}

var reverseProxyCertificateCommonNamesList_var = [for index in range(0, (!empty(reverseProxyCertificateCommonNames) ? length(reverseProxyCertificateCommonNames.commonNames) : 0)): {
  commonNames: reverseProxyCertificateCommonNames.commonNames[index]
}]

var reverseProxyCertificateCommonNames_var = {
  commonNames: (!empty(reverseProxyCertificateCommonNames) ? reverseProxyCertificateCommonNamesList_var : json('null'))
  x509StoreName: (!empty(reverseProxyCertificateCommonNames) ? reverseProxyCertificateCommonNames.x509StoreName : json('null'))
}

var upgradeDescription_var = {
  deltaHealthPolicy: {
    applicationDeltaHealthPolicies: (!empty(upgradeDescription) ? upgradeDescription.applicationDeltaHealthPolicies : json('null'))
    maxPercentDeltaUnhealthyApplications: (!empty(upgradeDescription) ? upgradeDescription.maxPercentDeltaUnhealthyApplications : json('null'))
    maxPercentDeltaUnhealthyNodes: (!empty(upgradeDescription) ? upgradeDescription.maxPercentDeltaUnhealthyNodes : json('null'))
    maxPercentUpgradeDomainDeltaUnhealthyNodes: (!empty(upgradeDescription) ? upgradeDescription.maxPercentUpgradeDomainDeltaUnhealthyNodes : json('null'))
  }
  forceRestart: '${(!empty(upgradeDescription) ? upgradeDescription.forceRestart : json('null'))}'
  healthCheckRetryTimeout: '${(!empty(upgradeDescription) ? upgradeDescription.healthCheckRetryTimeout : json('null'))}'
  healthCheckStableDuration: '${(!empty(upgradeDescription) ? upgradeDescription.healthCheckStableDuration : json('null'))}'
  healthCheckWaitDuration: '${(!empty(upgradeDescription) ? upgradeDescription.healthCheckWaitDuration : json('null'))}'
  healthPolicy: {
    applicationHealthPolicies: (!empty(upgradeDescription) ? upgradeDescription.healthPolicy.applicationHealthPolicies : json('null'))
    maxPercentUnhealthyApplications: (!empty(upgradeDescription) ? upgradeDescription.healthPolicy.maxPercentUnhealthyApplications : json('null'))
    maxPercentUnhealthyNodes: (!empty(upgradeDescription) ? upgradeDescription.healthPolicy.maxPercentUnhealthyNodes : json('null'))
    upgradeDomainTimeout: '${(!empty(upgradeDescription) ? upgradeDescription.upgradeDomainTimeout : json('null'))}'
    upgradeReplicaSetCheckTimeout: '${(!empty(upgradeDescription) ? upgradeDescription.upgradeReplicaSetCheckTimeout : json('null'))}'
    upgradeTimeout: '${(!empty(upgradeDescription) ? upgradeDescription.upgradeTimeout : json('null'))}'
  }
}

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

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

    azureActiveDirectory: (!empty(azureActiveDirectory) ? azureActiveDirectory_var : json('null'))
    certificate: (!empty(certificate) ? certificate_var : json('null'))
    certificateCommonNames: (!empty(certificateCommonNames) ? certificateCommonNames_var : json('null'))
    clientCertificateCommonNames: (!empty(clientCertificateCommonNames) ? clientCertificateCommonNames_var : json('null'))
    clientCertificateThumbprints: (!empty(clientCertificateThumbprints) ? clientCertificateThumbprints_var : json('null'))
    clusterCodeVersion: '${(!empty(clusterCodeVersion) ? clusterCodeVersion : json('null'))}'
    diagnosticsStorageAccountConfig: (!empty(diagnosticsStorageAccountConfig) ? diagnosticsStorageAccountConfig_var : json('null'))
    eventStoreServiceEnabled: eventStoreServiceEnabled
    fabricSettings: (!empty(fabricSettings) ? fabricSettings_var : json('null'))
    infrastructureServiceManager: infrastructureServiceManager
    managementEndpoint: '${(!empty(managementEndpoint) ? managementEndpoint : json('null'))}'
    nodeTypes: nodeTypes_var
    notifications: (!empty(notifications) ? notifications_var : json('null'))
    reliabilityLevel: reliabilityLevel
    reverseProxyCertificate: (!empty(reverseProxyCertificate) ? reverseProxyCertificate_var : json('null'))
    reverseProxyCertificateCommonNames: (!empty(reverseProxyCertificateCommonNames) ? reverseProxyCertificateCommonNames_var : json('null'))
    sfZonalUpgradeMode: (!empty(sfZonalUpgradeMode) ? sfZonalUpgradeMode : json('null'))
    upgradeDescription: (!empty(upgradeDescription) ? upgradeDescription_var : json('null'))
    upgradeMode: (!empty(upgradeMode) ? upgradeMode : json('null'))
    upgradePauseEndTimestampUtc: (!empty(upgradePauseEndTimestampUtc) ? upgradePauseEndTimestampUtc : json('null'))
    upgradePauseStartTimestampUtc: (!empty(upgradePauseStartTimestampUtc) ? upgradePauseStartTimestampUtc : json('null'))
    upgradeWave: (!empty(upgradeWave) ? upgradeWave : json('null'))
    vmImage: (!empty(vmImage) ? vmImage : json('null'))
    vmssZonalUpgradeMode: (!empty(vmssZonalUpgradeMode) ? vmssZonalUpgradeMode : json('null'))
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

// Service Fabric cluster RBAC assignment
module serviceFabricCluster_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-ServiceFabricCluster-Rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: serviceFabricCluster.name
  }
}]

// Service Fabric cluster applications
resource serviceFabricClusterApplication 'Microsoft.ServiceFabric/clusters/applications@2021-06-01' = [for (application, index) in serviceFabricClusterApplications: if (!empty(serviceFabricClusterApplications)) {
  name: application[index].name
  location: location
  tags: tags
  identity: (!empty(application[index].identity) ? application[index] : json('null'))
  properties: {
    managedIdentities: (!empty(application[index].managedIdentities) ? application[index].managedIdentities : json('null'))
    maximumNodes: (!empty(application[index].maximumNodes) ? application[index].maximumNodes : null)
    metrics: (!empty(application[index].metrics) ? application[index].metrics : json('null'))
    minimumNodes: (!empty(application[index].minimumNodes) ? application[index].minimumNodes : null)
    parameters: (!empty(application[index].parameters) ? application[index].parameters : json('null'))
    removeApplicationCapacity: (!empty(application[index].removeApplicationCapacity) ? application[index].removeApplicationCapacity : null)
    typeName: (!empty(application[index].typeName) ? application[index].typeName : null)
    typeVersion: (!empty(application[index].typeVersion) ? application[index].typeVersion : null)
    upgradePolicy: (!empty(application[index].upgradePolicy) ? application[index].upgradePolicy : json('null'))
  }
}]

// Outputs section
output serviceFabricClusterName string = serviceFabricCluster.name
output serviceFabricClusterId string = serviceFabricCluster.id
output serviceFabricClusterProperties object = serviceFabricCluster.properties
