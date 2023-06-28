@description('Required. Name of the Container App.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Bool indicating if app exposes an external http endpoint.')
param ingressExternal bool = true

@allowed([
  'auto'
  'http'
  'http2'
  'tcp'
])
@description('Optional. Ingress transport protocol.')
param ingressTransport string = 'auto'

@description('Optional. Bool indicating if HTTP connections to is allowed. If set to false HTTP connections are automatically redirected to HTTPS connections.')
param ingressAllowInsecure bool = true

@description('Optional. Target Port in containers for traffic from ingress.')
param ingressTargetPort int = 80

@description('Optional. Maximum number of container replicas. Defaults to 10 if not set.')
param scaleMaxReplicas int = 1

@description('Optional. Minimum number of container replicas.')
param scaleMinReplicas int = 0

@description('Optional. Scaling rules.')
param scaleRules array = []

@allowed([
  'Multiple'
  'Single'
])
@description('Optional. ActiveRevisionsMode controls how active revisions are handled for the Container app.')
param activeRevisionsMode string = 'Single'

@description('Required. Resource ID of environment.')
param environmentId string

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Collection of private container registry credentials for containers used by the Container app.')
param registries array = []

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The set of user assigned identities associated with the resource, the userAssignedIdentities dictionary keys will be ARM resource IDs and The dictionary values can be empty objects ({}) in requests.')
param userAssignedIdentities object = {}

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute.')
param roleAssignments array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Custom domain bindings for Container App hostnames.')
param customDomains array = []

@description('Optional. Exposed Port in containers for TCP traffic from ingress.')
param exposedPort int = 0

@description('Optional. Rules to restrict incoming IP address.')
param ipSecurityRestrictions array = []

@description('Optional. Associates a traffic label with a revision. Label name should be consist of lower case alphanumeric characters or dashes.')
param trafficLabel string = 'label-1'

@description('Optional. Indicates that the traffic weight belongs to a latest stable revision.')
param trafficLatestRevision bool = true

@description('Optional. Name of a revision.')
param trafficRevisionName string = ''

@description('Optional. Traffic weight assigned to a revision.')
param trafficWeight int = 100

@description('Optional. Dapr configuration for the Container App.')
param dapr object = {}

@description('Optional. Max inactive revisions a Container App can have.')
param maxInactiveRevisions int = 0

@description('Required. List of container definitions for the Container App.')
param containers array

@description('Optional. List of specialized containers that run before app containers.')
param initContainersTemplate array = []

@description('Optional. The secrets of the Container App.')
@secure()
param secrets object = {}

@description('Optional. User friendly suffix that is appended to the revision name.')
param revisionSuffix string = ''

@description('Optional. List of volume definitions for the Container App.')
param volumes array = []

@description('Optional. Workload profile type to pin for container app execution.')
param workloadProfileType string = ''

var secretList = !empty(secrets) ? secrets.secureList : []

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

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

resource containerApp 'Microsoft.App/containerApps@2022-10-01' = {
  name: name
  tags: tags
  location: location
  identity: identity
  properties: {
    environmentId: environmentId
    configuration: {
      activeRevisionsMode: activeRevisionsMode
      dapr: !empty(dapr) ? dapr : null
      ingress: {
        allowInsecure: ingressAllowInsecure
        customDomains: !empty(customDomains) ? customDomains : null
        exposedPort: exposedPort
        external: ingressExternal
        ipSecurityRestrictions: !empty(ipSecurityRestrictions) ? ipSecurityRestrictions : null
        targetPort: ingressTargetPort
        traffic: [
          {
            label: trafficLabel
            latestRevision: trafficLatestRevision
            revisionName: trafficRevisionName
            weight: trafficWeight
          }
        ]
        transport: ingressTransport
      }
      maxInactiveRevisions: maxInactiveRevisions
      registries: !empty(registries) ? registries : null
      secrets: secretList
    }
    template: {
      containers: containers
      initContainers: !empty(initContainersTemplate) ? initContainersTemplate : null
      revisionSuffix: revisionSuffix
      scale: {
        maxReplicas: scaleMaxReplicas
        minReplicas: scaleMinReplicas
        rules: !empty(scaleRules) ? scaleRules : null
      }
      volumes: !empty(volumes) ? volumes : null
    }
    workloadProfileType: workloadProfileType
  }
}

resource containerApp_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${containerApp.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: containerApp
}

module containerApp_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-containerApp-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: containerApp.id
  }
}]

@description('The resource ID of the Container App.')
output resourceId string = containerApp.id

@description('The name of the resource group the Container App was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Container App.')
output name string = containerApp.name

@description('The location the resource was deployed into.')
output location string = containerApp.location
