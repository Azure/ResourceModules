targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.network.networkmanagers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nnmcom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resourceGroupResources 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    virtualNetworkHubName: 'dep-<<namePrefix>>-vnetHub-${serviceShort}'
    virtualNetworkSpoke1Name: 'dep-<<namePrefix>>-vnetSpoke1-${serviceShort}'
    virtualNetworkSpoke2Name: 'dep-<<namePrefix>>-vnetSpoke2-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '<<namePrefix>>${serviceShort}001'
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    networkManagerScopeAccesses: [
      'Connectivity'
      'SecurityAdmin'
    ]
    networkManagerScopes: {
      subscriptions: [
        subscription().id
      ]
    }
    networkGroups: [
      {
        name: 'network-group-spokes'
        description: 'network-group-spokes description'
        staticMembers: [
          {
            name: 'virtualNetworkSpoke1'
            resourceId: resourceGroupResources.outputs.virtualNetworkSpoke1Id
          }
          {
            name: 'virtualNetworkSpoke2'
            resourceId: resourceGroupResources.outputs.virtualNetworkSpoke2Id
          }
        ]
      }
    ]
    connectivityConfigurations: [
      {
        name: 'hubSpokeConnectivity'
        description: 'hubSpokeConnectivity description'
        connectivityTopology: 'HubAndSpoke'
        hubs: [
          { //TODO: test if we can use multiple hubs
            resourceId: resourceGroupResources.outputs.virtualNetworkHubId
            resourceType: 'Microsoft.Network/virtualNetworks'
          }
        ]
        deleteExistingPeering: 'True'
        isGlobal: 'True'
        appliesToGroups: [
          {
            networkGroupId: concat(resourceGroup.id, '/providers/Microsoft.Network/networkManagers/,<<namePrefix>>${serviceShort}001,/networkGroups/network-group-spokes')
            useHubGateway: 'False'
            groupConnectivity: 'None'
            isGlobal: 'False'
          }
        ]
      }
      {
        name: 'MeshConnectivity'
        description: 'MeshConnectivity description'
        connectivityTopology: 'Mesh'
        deleteExistingPeering: 'True'
        isGlobal: 'True'
        appliesToGroups: [
          {
            networkGroupId: concat(resourceGroup.id, '/providers/Microsoft.Network/networkManagers/,<<namePrefix>>${serviceShort}001,/networkGroups/network-group-spokes')
            useHubGateway: 'False'
            groupConnectivity: 'None'
            isGlobal: 'False'
          }
        ]
      }
    ]
    scopeConnections: [
      {
        name: 'scope-connection-test'
        description: 'description of the scope connection'
        resourceId: '/subscriptions/<<subscriptionId>>'
        tenantid: '<<tenantId>>'
      }
    ]
    securityAdminConfigurations: [
      {
        name: 'test-security-admin-config'
        description: 'description of the security admin config'
        applyOnNetworkIntentPolicyBasedServices: [
          'AllowRulesOnly'
        ]
        ruleCollections: [
          {
            name: 'test-rule-collection-1'
            description: 'test-rule-collection-description'
            appliesToGroups: [
              {
                networkGroupId: concat(resourceGroup.id, '/providers/Microsoft.Network/networkManagers/,<<namePrefix>>${serviceShort}001,/networkGroups/network-group-spokes')
              }
            ]
            rules: [
              {
                name: 'test-inbound-allow-rule-1'
                description: 'test-inbound-allow-rule-1-description'
                access: 'Allow'
                direction: 'Inbound'
                priority: 150
                protocol: 'Tcp'
              }
              {
                name: 'test-outbound-deny-rule-2'
                description: 'test-outbound-deny-rule-2-description'
                access: 'Deny'
                direction: 'Outbound'
                priority: 200
                protocol: 'Tcp'
                sourcePortRanges: [
                  '80'
                  '442-445'
                ]
                sourcesAddressPrefix: 'AppService.WestEurope'
                sourcesAddressPrefixType: 'ServiceTag'
              }
            ]
          }
          {
            name: 'test-rule-collection-2'
            description: 'test-rule-collection-description'
            appliesToGroups: [
              {
                networkGroupId: concat(resourceGroup.id, '/providers/Microsoft.Network/networkManagers/,<<namePrefix>>${serviceShort}001,/networkGroups/network-group-spokes')
              }
            ]
            rules: [
              {
                name: 'test-inbound-allow-rule-3'
                description: 'test-inbound-allow-rule-3-description'
                access: 'Allow'
                direction: 'Inbound'
                destinationPortRanges: [
                  '80'
                  '442-445'
                ]
                destinationsAddressPrefix: '192.168.20.20'
                destinationsAddressPrefixType: 'IPPrefix'
                priority: 250
                protocol: 'Tcp'
              }
            ]
          }
        ]
      }
    ]
  }
}
