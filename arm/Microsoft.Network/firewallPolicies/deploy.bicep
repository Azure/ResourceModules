@description('Required. Name of the Firewall Policy.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the Firewall policy resource.')
param tags object = {}

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Rule collection groups.')
param ruleCollectionGroups array = []

@description('Optional. Rule groups.')
param ruleGroups array = []

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2021-03-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    basePolicy: {
      id: 'string'
    }
    dnsSettings: {
      enableProxy: bool
      requireProxyForNetworkRules: bool
      servers: [ 'string' ]
    }
    explicitProxySettings: {
      enableExplicitProxy: bool
      httpPort: int
      httpsPort: int
      pacFile: 'string'
      pacFilePort: int
    }
    insights: {
      isEnabled: bool
      logAnalyticsResources: {
        defaultWorkspaceId: {
          id: 'string'
        }
        workspaces: [
          {
            region: 'string'
            workspaceId: {
              id: 'string'
            }
          }
        ]
      }
      retentionDays: int
    }
    intrusionDetection: {
      configuration: {
        bypassTrafficSettings: [
          {
            description: 'string'
            destinationAddresses: [ 'string' ]
            destinationIpGroups: [ 'string' ]
            destinationPorts: [ 'string' ]
            name: 'string'
            protocol: 'string'
            sourceAddresses: [ 'string' ]
            sourceIpGroups: [ 'string' ]
          }
        ]
        signatureOverrides: [
          {
            id: 'string'
            mode: 'string'
          }
        ]
      }
      mode: 'string'
    }
    sku: {
      tier: 'string'
    }
    snat: {
      privateRanges: [ 'string' ]
    }
    sql: {
      allowSqlRedirect: bool
    }
    threatIntelMode: 'string'
    threatIntelWhitelist: {
      fqdns: [ 'string' ]
      ipAddresses: [ 'string' ]
    }
    transportSecurity: {
      certificateAuthority: {
        keyVaultSecretId: 'string'
        name: 'string'
      }
    }
  }
}

module ruleCollectionGroups_resource 'ruleCollectionGroups/deploy.bicep' = [for (ruleCollectionGroup, index) in ruleCollectionGroups: {
  name: '${uniqueString(deployment().name, location)}-ruleCollectionGroup-${index}'
  params: {
    firewallPolicyName: firewallPolicy.name
    name: ruleCollectionGroup.name
    priority: ruleCollectionGroup.priority
    ruleCollections: ruleCollectionGroup.ruleCollections
  }
  dependsOn: [
    firewallPolicy
  ]
}]

module ruleGroups_resource 'ruleGroups/deploy.bicep' = [for (ruleGroup, index) in ruleGroups: {
  name: '${uniqueString(deployment().name, location)}-ruleGroup-${index}'
  params: {
    firewallPolicyName: firewallPolicy.name
    name: ruleGroup.name
    priority: ruleGroup.priority
    rules: ruleGroup.rules
  }
  dependsOn: [
    firewallPolicy
  ]
}]
