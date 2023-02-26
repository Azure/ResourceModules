@description('Required. Name of the Container App.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. Container image tag.')
param containerImage string

@description('Required. Custom container name.')
param containerName string

@description('Optional. Bool indicating if app exposes an external http endpoint, default true.')
param ingressExternal bool = false

@allowed([
  'auto'
  'http'
  'http2'
  'tcp'
])
@description('Optional. Ingress transport protocol, default auto.')
param ingressTransport string = 'auto'

@description('Optional. Bool indicating if HTTP connections to is allowed. If set to false HTTP connections are automatically redirected to HTTPS connections.')
param ingressAllowInsecure bool = false

@description('Optional. Target Port in containers for traffic from ingress, default 80.')
param ingressTargetPort int = 6379

@description('Optional. Container environment variables.')
param containersEnv array = []

@description('Required. Container App resources.')
param containerResources object

@description('Optional. Minimum number of container replicas.')
param scaleMinReplicas int = 0

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

@description('Optional. The set of user assigned identities associated with the resource, the userAssignedIdentities dictionary keys will be ARM resource ids and The dictionary values can be empty objects ({}) in requests.')
param userAssignedIdentities object = {}

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute.')
param roleAssignments array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID), default false.')
param enableDefaultTelemetry bool = false

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

@description('Optional. Client certificate mode for mTLS authentication. Ignore indicates server drops client certificate on forwarding. Accept indicates server forwards client certificate but does not require a client certificate. Require indicates server requires a client certificate.')
@allowed([
  'accept'
  'ignore'
  'require'
])
param clientCertificateMode string = 'ignore'

@description('Optinal. Custom domain bindings for Container Apps hostnames.')
param customDomainsName string = ''

@description('Optinal. Custom domain Resource Id of the Certificate to be bound to this hostname.')
param customDomainsCertificateId string = ''

@description('Optinal. Custom Domain binding type.')
@allowed([
  'Disabled'
  'SniEnabled'
])
param customDomainsBindingType string = 'Disabled'

@description('Optional. Exposed Port in containers for TCP traffic from ingress.')
param exposedPort int = 0

@description('Optional. Traffic weights for apps revisions.')
param traffic array = []

@description('Optional. Cors policy to allow credentials or not.')
param corsPolicyAllowCredentials bool = false

@description('Optional. Cors policy to allowed HTTP headers.')
param corsPolicyAllowedHeaders array = []

@description('Optional. Cors policy to allowed HTTP methods.')
param corsPolicyAllowedMethods array = []

@description('Optional. Cors policy to allowed orgins.')
param corsPolicyAllowedOrigins array = []

@description('Optional. Cors policy to expose HTTP headers.')
param corsPolicyExposeHeaders array = []

@description('Optional. Cors policy to max time client can cache the result.')
param corsPolicyMaxAge int = 0

@description('Optional. Allow or Deny rules to determine for incoming IP. Note: Rules can only consist of ALL Allow or ALL Deny.')
@allowed([
  'Allow'
  'Deny'
])
param ipSecurityRestrictionsAction string = 'Allow'

@description('Optional. Describe the IP restriction rule that is being sent to the container-app. This is an optional field.')
param ipSecurityRestrictionsDescription string = ''

@description('Optional. Cidr notation to match incoming IP address.')
param ipSecurityRestrictionsIpAddressRange string = ''

@description('Optional. Name for the IP restriction rule.')
param ipSecurityRestrictionsName string = ''

resource containerApps 'Microsoft.App/containerApps@2022-06-01-preview' = {
  name: name
  tags: tags
  location: location
  identity: identity
  properties: {
    environmentId: environmentId
    configuration: {
      activeRevisionsMode: activeRevisionsMode
      secrets: []
      registries: !empty(registries) ? registries : null
      ingress: {
        allowInsecure: ingressAllowInsecure
        clientCertificateMode: clientCertificateMode
        corsPolicy: {
          allowCredentials: corsPolicyAllowCredentials
          allowedHeaders: corsPolicyAllowedHeaders
          allowedMethods: corsPolicyAllowedMethods
          allowedOrigins: corsPolicyAllowedOrigins
          exposeHeaders: corsPolicyExposeHeaders
          maxAge: corsPolicyMaxAge
        }
        customDomains: [
          {
            name: customDomainsName
            certificateId: customDomainsCertificateId
            bindingType: customDomainsBindingType
          }
        ]
        exposedPort: exposedPort
        external: ingressExternal
        ipSecurityRestrictions: [
          {
            action: ipSecurityRestrictionsAction
            description: ipSecurityRestrictionsDescription
            ipAddressRange: ipSecurityRestrictionsIpAddressRange
            name: ipSecurityRestrictionsName
          }
        ]
        targetPort: ingressTargetPort
        traffic: traffic
        transport: ingressTransport
      }
    }
    template: {
      containers: [
        {
          name: containerName
          image: containerImage
          resources: containerResources
          env: containersEnv
        }
      ]
      scale: {
        minReplicas: scaleMinReplicas
      }
    }
  }
}

resource containerAppsLock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${containerApps.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: containerApps
}

module containerApps_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-containerApps-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: containerApps.id
  }
}]

@description('The resource ID of the Container Apps.')
output resourceId string = containerApps.id

@description('The name of the resource group the Container Apps was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Container Apps name.')
output name string = containerApps.name

@description('The location the resource was deployed into.')
output location string = containerApps.location
