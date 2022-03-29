@description('Required. The name of the Flux Configuration')
param name string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. The name of the AKS cluster that should be configured.')
param clusterName string

@description('Optional. Flag to note if this extension participates in auto upgrade of minor version, or not.')
param autoUpgradeMinorVersion bool = true

@description('Optional. Configuration settings that are sensitive, as name-value pairs for configuring this extension.')
param configurationProtectedSettings object = {}

@description('Optional. Configuration settings, as name-value pairs for configuring this extension.')
param configurationSettings object = {}

@description('Required. Type of the Extension, of which this resource is an instance of. It must be one of the Extension Types registered with Microsoft.KubernetesConfiguration by the Extension publisher.')
param extensionType string

@description('Optional. ReleaseTrain this extension participates in for auto-upgrade (e.g. Stable, Preview, etc.) - only if autoUpgradeMinorVersion is "true".')
param releaseTrain string = 'Stable'

@description('Optional. Namespace where the extension Release must be placed, for a Cluster scoped extension. If this namespace does not exist, it will be created')
param releaseNamespace string = ''

@description('Optional. Namespace where the extension will be created for an Namespace scoped extension. If this namespace does not exist, it will be created')
param targetNamespace string = ''

@description('Optional. Version of the extension for this extension, if it is "pinned" to a specific version. autoUpgradeMinorVersion must be "false".')
param version string = ''

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : {}

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource managedCluster 'Microsoft.ContainerService/managedClusters@2021-10-01' existing = {
  name: clusterName
}

resource extension 'Microsoft.KubernetesConfiguration/extensions@2022-03-01' = {
  name: name
  scope: managedCluster
  identity: identity
  properties: {
    autoUpgradeMinorVersion: autoUpgradeMinorVersion
    configurationProtectedSettings: !empty(configurationProtectedSettings) ? configurationProtectedSettings : {}
    configurationSettings: !empty(configurationSettings) ? configurationSettings : {}
    extensionType: extensionType
    releaseTrain: !empty(releaseTrain) ? releaseTrain : null
    scope: {
      cluster: empty(releaseNamespace) ? null : {
        releaseNamespace: releaseNamespace
      }
      namespace: empty(targetNamespace) ? null : {
        targetNamespace: targetNamespace
      }
    }
    version: !empty(version) ? version : null
  }
}

@description('The name of the extension')
output name string = extension.name

@description('The resource ID of the extension')
output resourceId string = extension.id

@description('The name of the resource group the extension was deployed into')
output resourceGroupName string = resourceGroup().name
